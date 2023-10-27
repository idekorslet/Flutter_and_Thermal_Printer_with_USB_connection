import 'package:flutter/material.dart';
import 'package:print_invoice_with_usb_connection/printer_services/printer_service.dart';
import '../../custom_widgets/popup_message.dart';

class PrinterSettingScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const PrinterSettingScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<PrinterSettingScreen> createState() => _PrinterSettingScreenState();
}

class _PrinterSettingScreenState extends State<PrinterSettingScreen> {
  TextEditingController printerNameCtrl = TextEditingController();
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncInit();
    });
  }

  _asyncInit() async {
    PrinterService.init();
    await PrinterService.scan();
  }

  @override
  void dispose() {
    printerNameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return PrinterService.isPrinterConnected
    //     ? InvoiceBuilder(invoice: Invoice.fromMap(widget.data))
    return Column(
      children: [
        Container(
            width: double.infinity,
            height: 130,
            padding: const EdgeInsets.only(left: 10, right: 10),
            margin: const EdgeInsets.only(top: 40),
            decoration: const BoxDecoration(
              // border: Border.all(color: Colors.blue)
            ),
            child: StreamBuilder(
                  stream: PrinterService.currentUsbStringStatusStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    // final isPrinterConnected = PrinterService.printerStatus == PrinterStatus.connected;
                    isScanning = PrinterService.printerStatus == PrinterStatus.scanning;
                    // log('[printer_page] usb printer status / isScanning: $isScanning');
                    // log(snapshot.data.toString());

                    if (snapshot.hasData && snapshot.data != null && snapshot.data != PrinterStatus.notFound && isScanning == false) {
                      printerNameCtrl.text = PrinterService.printerName;
                    }
                    else {
                      printerNameCtrl.text = ' ';
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: Theme(
                                  data: ThemeData(
                                    disabledColor: Colors.black,
                                  ),
                                  child: TextField(
                                    enabled: false,
                                    controller: printerNameCtrl,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        labelText: 'Printer Name',
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.grey
                                          ),
                                        ),

                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10))
                                        ),
                                        contentPadding: EdgeInsets.all(10)
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 20,),

                            /// ******************** Scan Button ******************* ///
                            FilledButton.tonal(
                                onPressed: () async {
                                  // log('[printer_page] PrinterService.printerStatus: ${PrinterService.printerStatus}');
                                  // if (PrinterService.printerStatus == PrinterStatus.notConnected || PrinterService.printerStatus == PrinterStatus.notFound) {
                                  if ([PrinterStatus.notConnected, PrinterStatus.notFound].contains(PrinterService.printerStatus)) {
                                    await PrinterService.scan();
                                  }
                                  else if (PrinterService.printerStatus == PrinterStatus.connected) {
                                    PopUpMessage.showPopup(
                                        context: context,
                                        keepBarrier: false,
                                        title: 'Printer terkoneksi',
                                        content: 'Printer masih terkoneksi, putuskan koneksi terlebih dahulu sebelum scan'
                                    );
                                  }

                                  return;
                                },
                                child: const Text('    Scan    ')
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text('Status: '),
                            Text(PrinterService.printerStatus,
                                style: TextStyle(
                                  color: PrinterService.isPrinterConnected ? Colors.green : Colors.black,
                                  fontWeight: PrinterService.isPrinterConnected ? FontWeight.bold : FontWeight.normal,
                                )
                            ),
                          ],
                        ),
                        // const SizedBox(height: 10,),

                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: InkWell(
                                  onTap: () async {
                                    if (PrinterService.isPrinterConnected) {
                                      await PrinterService.disConnect();
                                    }
                                    else {
                                      await PrinterService.connect();
                                    }
                                  },
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.only(right: 15),
                                    title: const Text('Connect to Printer'),
                                    trailing: Switch(
                                      value: PrinterService.isPrinterConnected,
                                      onChanged: (newValue) async {
                                        if (PrinterService.isPrinterConnected) {
                                          await PrinterService.disConnect();
                                        }
                                        else {
                                          await PrinterService.connect();
                                        }

                                        return;
                                      },

                                    ),
                                  ),
                                ),
                              ),
                            ),

                            FilledButton.tonal(
                                style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(color: PrinterService.isPrinterConnected ? Colors.black : Colors.grey.shade300)
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                      PrinterService.isPrinterConnected ? Theme.of(context).colorScheme.secondaryContainer : Colors.grey.shade300
                                  ),
                                ),
                                onPressed: () async {
                                  if (PrinterService.isPrinterConnected && PrinterService.printerStatus != PrinterStatus.printing) {
                                    await PrinterService.testPrint();
                                  }
                                  return;
                                },
                                child: const Text('Test Print')
                            ),
                          ],
                        )
                      ],
                    );
                  }
              )
          ),
      ],
    );
  }
}
