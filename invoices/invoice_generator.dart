import 'dart:typed_data';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import '../printer_services/printer_service.dart';
import 'food_and_drink_invoice/invoice_builder.dart';
import 'food_and_drink_invoice/invoice_model.dart';

class InvoiceGenerator {
  static Uint8List? generatedInvoiceImage;
  static final ScreenshotController _screenshotController = ScreenshotController();

  static Future<void> createInvoiceAndPrint({
    required Map<String, dynamic> data,
    required BuildContext context,
  }) async {
    await generateInvoice(context: context, dataToPrint: data);

    if (PrinterService.isPrinterConnected) {
      log('[invoice_generator] Printing invoice');
      await PrinterService.printInvoiceFromImage(imageData: generatedInvoiceImage);
    }
  }

  static Future<void> generateInvoice({
    required BuildContext context,
    required Map<String, dynamic> dataToPrint,
  }) async {
    log('[invoice_generator] Generating invoice');
    generatedInvoiceImage = null;

    if (context.mounted) {
      await _screenshotController.captureFromLongWidget(
        InheritedTheme.captureAll(
          context,
          Material(
            color: Colors.white,
            child: InvoiceBuilder(
              printInvoice: true,
              // screenWidth: screenLength,
              invoice: Invoice.fromMap(dataToPrint),
            ),
          ),
        ),
        delay: const Duration(milliseconds: 100),
        context: context,
      )
      .then((capturedImage) async {
        generatedInvoiceImage = capturedImage;
      })
      .whenComplete(() {
        if (generatedInvoiceImage != null) {
          log('[invoice_generator] invoice generated');
        }
      })
      .catchError((onError) {
        log('[invoice_generator] Failed to generate invoice: $onError');
        //
        // Fluttertoast.showToast(
        //     msg: "Failed to generate invoice",
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     // backgroundColor: Colors.red,
        //     // textColor: Colors.white,
        //     fontSize: 16.0
        // );

      });
    }
  }
}