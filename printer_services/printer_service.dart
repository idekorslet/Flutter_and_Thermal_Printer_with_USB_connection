import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:image/image.dart';
import 'package:flutter/services.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';

class PrinterService {
  static late String printerName;
  static late Completer<PrinterDevice> _completer;
  static late PrinterDevice _printer;
  static USBStatus _currentUsbStatus = USBStatus.none;
  static StreamSubscription<USBStatus>? _subscriptionUsbStatus;
  static final _printerManager = PrinterManager.instance;

  static final StreamController<String> _currentUsbStatusStreamController = StreamController();
  static Stream<String> currentUsbStringStatusStream = _currentUsbStatusStreamController.stream.asBroadcastStream();
  static late StreamSubscription<String> _currentUsbStatusStringSubscription;
  static bool _isPrinterAvailable = false;
  static bool _isScanning = false;
  static bool _isDisconnecting = false;
  static bool _isPrinting = false;

  static String get printerStatus => _convertUsbStatusToString();
  static bool get isPrinterConnected => _currentUsbStatus == USBStatus.connected;

  static void init() {
    log('[PrinterService] init called');
    _currentUsbStatusStringSubscription = currentUsbStringStatusStream.listen((event) { });

    _currentUsbStatusStringSubscription.onData((data) {
      // log('[printer_service] on data _currentUsbStatusStringSubscription');
      // log(data);
    });
  }

  static void dispose() {
    _currentUsbStatusStringSubscription.cancel();
    _currentUsbStatusStreamController.close();
  }

  static String _convertUsbStatusToString() {
    final usbStatus = _currentUsbStatus == USBStatus.connecting
        ? PrinterStatus.connecting
        : _currentUsbStatus == USBStatus.connected ? PrinterStatus.connected : PrinterStatus.notConnected;

    if (_isScanning) {
      return PrinterStatus.scanning;
    }
    else if (_isPrinting) {
      return PrinterStatus.printing;
    }
    else if (_isDisconnecting) {
      return PrinterStatus.disconnecting;
    }
    else if (usbStatus == PrinterStatus.notConnected) {
      return _isPrinterAvailable ? PrinterStatus.notConnected : PrinterStatus.notFound;
    }

    return usbStatus;
  }

  static Future<void> scan() async {
    if (_isScanning == false) {
      _isScanning = true;
      _refreshPrinterStatus();

      var defaultPrinterType = PrinterType.usb;

      _subscriptionUsbStatus = _printerManager.stateUSB.listen((status) {
        log('[PrinterService] on listen');
      });

      _subscriptionUsbStatus?.onData((status) {
        log('[PrinterService] on data');
        log(' ----------------- status usb $status ------------------ ');
        _currentUsbStatus = status;
        _refreshPrinterStatus();
      });

      // _subscriptionUsbStatus?.onDone(() {
      //   log('[PrinterService] on done');
      //   _currentUsbStatus = USBStatus.none;
      // });

      /// *********** scan method ************* ///
      log('[printer_service] Searching for printers...');
      _completer = Completer<PrinterDevice>();

      _printerManager.discovery(type: defaultPrinterType).listen((printer) {
        log('printer os: ${printer.operatingSystem}');
        log('printer name: ${printer.name}');
        log('printer address: ${printer.address}');
        log('printer vendor id: ${printer.vendorId}');
        log('printer product id: ${printer.productId}');
        _completer.complete(printer);
      });

      try {
        printerName = '';
        _printer = await _completer.future.timeout(const Duration(seconds: 5))
          .whenComplete(() {
            log('[printer_service] scanning timer done');
            _isScanning = false;
          });

        printerName = _printer.name;
        _isPrinterAvailable = printerName.isNotEmpty;

        _refreshPrinterStatus();
      } on TimeoutException catch (e) {
        log('[printer_service@TimeoutException] Scan result: Printer not found\n$e');
        _isPrinterAvailable = false;
        _refreshPrinterStatus();
        return;
      }
    }
  }

  static Future<void> connect() async {
    if (printerStatus == PrinterStatus.notConnected) {
      // log('printer name: ${_printer.name} / current status usb: ${printerManager.currentStatusUSB.name}');

      try {
        await _printerManager.connect(
          type: PrinterType.usb,
          model: UsbPrinterInput(
            name: _printer.name,
            productId: _printer.productId,
            vendorId: _printer.vendorId
          )
        )
        .timeout(const Duration(seconds: 5))
        .whenComplete(() => log('connecting done'));

      } on TimeoutException catch (e) {
        log("[printer_service] Failed to connect with printer\n$e");
        return;
      }
    }
  }

  static Future<void> disConnect() async {

    if (printerStatus == PrinterStatus.connected) {
      log('Disconnecting printer');
      _isDisconnecting = true;
      _refreshPrinterStatus();

      try {
        await _printerManager.disconnect(type: PrinterType.usb,)
        .timeout(const Duration(seconds: 5))
        .whenComplete(() {
          log('[printer_service] disconnect task done');
          _currentUsbStatus = USBStatus.none;
          _isDisconnecting = false;
          _refreshPrinterStatus();
        });
      } on TimeoutException catch (e) {
        log("Failed to disConnect printer\n$e");
        return;
      }
    }
  }

  static Future<void> testPrint() async {
    // if (printerStatus == PrinterStatus.connected && _isPrinting == false) {
      _isPrinting = true;
      _refreshPrinterStatus();
      List<int> bytes = [];
      final generator = Generator(PaperSize.mm58, await CapabilityProfile.load());
      bytes += generator.text('Print test OK');
      bytes += generator.cut();

      await _print(data: bytes);
    // }
  }

  static void _refreshPrinterStatus() {
    _currentUsbStatusStreamController.sink.add(_convertUsbStatusToString());
  }

  static Future<bool> _print({required List<int> data}) async {
    bool isPrintOk = true;

    try {
      isPrintOk = await _printerManager
      .send(type: PrinterType.usb, bytes: data)
      .timeout(const Duration(seconds: 5))
      .whenComplete(() {
        _isPrinting = false;
        _refreshPrinterStatus();
      });
      log('[printer_service] Print test OK');
    } on TimeoutException catch (e) {
      isPrintOk = false;
      log('[printer_service] Failed to print data\n$e');
    }

    return isPrintOk;
  }

  static Future<void> printInvoiceFromImage({required Uint8List? imageData}) async {
    if (imageData == null) return;

    List<int> bytes = [];
    final generator = Generator(PaperSize.mm58, await CapabilityProfile.load());
    final image = decodePng(imageData)!;

    /// failed to show image in print result if using generator.image
    // bytes += generator.image(
    //   image,
      // align: PosAlign.center
    // );

    bytes += generator.imageRaster(image);
    bytes += generator.cut();

    await _print(data: bytes);
  }
}

class PrinterStatus {
  static const connecting = 'Connecting';
  static const disconnecting = 'Disconnecting';
  static const connected = 'Connected';
  static const notFound = 'Printer not found';
  static const notConnected = 'Not connected';
  static const scanning = 'Searching for printer';
  static const printing = 'Printing';
}
