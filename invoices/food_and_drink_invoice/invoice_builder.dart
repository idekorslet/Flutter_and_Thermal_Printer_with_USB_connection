import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:print_invoice_with_usb_connection/invoices/food_and_drink_invoice/invoice_model.dart';
import '../../constants.dart';
import '../invoice_widget.dart';

// ignore: must_be_immutable
class InvoiceBuilder extends StatelessWidget {
  InvoiceBuilder({
    Key? key,
    // required this.screenWidth,
    required this.invoice,
    // this.isNewTransaction=false,
    this.printInvoice=false
  }) : super(key: key);
  final bool printInvoice;
  final Invoice? invoice;

  double screenWidth = Constants.invoiceScreenWidth;
  late bool customWidth = printInvoice; /// digunakan untuk mengatur posisi spasi paling kanan karakter ketika diprint, apakah tercetak sebagian atau normal

  @override
  Widget build(BuildContext context) {
    // final scrWidth = MediaQuery.of(context).size.width;
    // final scrHeight = MediaQuery.of(context).size.height;
    // Orientation currentOrientation = MediaQuery.of(context).orientation;
    //
    // final screenLength = currentOrientation == Orientation.portrait ? scrWidth : scrHeight;

    return printInvoice ? buildInvoice() : SingleChildScrollView(child: buildInvoice());
  }

  Widget buildInvoice() {
    final reducedSize = customWidth ? 55 : 0;  /// dikurangi sebanyak-n supaya karakter paling kanan tidak terputus .nilai ini bisa saja berbeda, silahkan uji coba sampai dapat nilai yang pas (atur semakin tinggi jika teks paling kanan terpotong). dan pastikan posisi kertas terpasang rata
    double? fontSize = printInvoice ? 18 : 16;

    if (invoice != null) {
      Widget? imageHeader;

      if (invoice!.imageLogo!.isNotEmpty) {
        final bytes = const Base64Decoder().convert(invoice!.imageLogo!);
        imageHeader = Image.memory(bytes, fit: BoxFit.scaleDown, alignment: Alignment.bottomCenter,);
      }

      int itemNo = 0;

      return Column(
        children: [
          /// ********************************* invoice header ******************************** ///
          Container(
            // decoration: BoxDecoration(
            // border: Border.all(color: Colors.red)
            // ),
              padding: const EdgeInsets.only(bottom: 10),
              height: 160,
              width: 160,
              child: imageHeader
          ),

          InvoiceWidget.buildItems(title: invoice!.header1!, value: '', fontSize: fontSize, centerPos: true, screenWidth: screenWidth),
          InvoiceWidget.buildItems(title: invoice!.header2!, value: '', fontSize: fontSize, centerPos: true, screenWidth: screenWidth),
          InvoiceWidget.buildItems(title: invoice!.header3!, value: '', fontSize: fontSize, centerPos: true, screenWidth: screenWidth),
          InvoiceWidget.buildItems(title: invoice!.header4!, value: '', fontSize: fontSize, centerPos: true, screenWidth: screenWidth),
          InvoiceWidget.buildItems(title: invoice!.header5!, value: '', fontSize: fontSize, centerPos: true, screenWidth: screenWidth),
          InvoiceWidget.buildDottedLine(reducedWidth: reducedSize, screenWidth: screenWidth),

          /// ********************************* invoice items ******************************** ///
          if (invoice!.items!.isNotEmpty)
            ...[
              InvoiceWidget.buildItems(title: 'Date', value: invoice!.trxDate!, reducedWidth: reducedSize, fontSize: fontSize, screenWidth: screenWidth),
              InvoiceWidget.buildItems(title: 'Transaction ID', value: invoice!.trxID!, reducedWidth: reducedSize, fontSize: fontSize, screenWidth: screenWidth),
              InvoiceWidget.buildItems(title: 'Cashier Name', value: invoice!.cashierName!, reducedWidth: reducedSize, fontSize: fontSize, screenWidth: screenWidth),
              InvoiceWidget.buildDottedLine(reducedWidth: reducedSize, screenWidth: screenWidth),

              /// *************************** part nama item, quantity, price, tax ****************************** ///

              ...invoice!.items!.map((e) {
                itemNo++;

                return Container(
                  decoration: const BoxDecoration(
                    // border: Border.all(color: Colors.red)
                  ),
                  child: Column(
                    children: [
                      InvoiceWidget.buildItems(title: '$itemNo.${e.itemName} x${e.qty}', value: e.itemPrice, reducedWidth: reducedSize, fontSize: fontSize, screenWidth: screenWidth),
                      e.discountName == ''
                          ? const SizedBox()
                          : InvoiceWidget.buildItems(title: '      ${e.discountName}', value: e.discountAmount, reducedWidth: reducedSize, fontSize: 14, screenWidth: screenWidth),
                    ],
                  ),
                );
              }
              ).toList(),

              InvoiceWidget.buildDottedLine(reducedWidth: reducedSize, screenWidth: screenWidth),

              /// ************************ end of part nama item, quantity, price, tax ************************** ///

              InvoiceWidget.buildItems(title: 'SubTotal', value: invoice!.subTotal!, reducedWidth: reducedSize, fontSize: 20, screenWidth: screenWidth),
              InvoiceWidget.buildItems(title: 'Total Discount', value: invoice!.discountTotal!, reducedWidth: reducedSize, fontSize: 20, screenWidth: screenWidth),
              InvoiceWidget.buildItems(title: 'Total Tax', value: invoice!.taxTotal!, reducedWidth: reducedSize, fontSize: 20, screenWidth: screenWidth),

              InvoiceWidget.buildDottedLine(reducedWidth: reducedSize, screenWidth: screenWidth),
              InvoiceWidget.buildItems(title: 'Total', value: invoice!.total!, reducedWidth: reducedSize, fontSize: 20, isBold: true, screenWidth: screenWidth),
              InvoiceWidget.buildDottedLine(reducedWidth: reducedSize, screenWidth: screenWidth),
              InvoiceWidget.buildItems(title: 'Pay amount', value: invoice!.payAmount!, reducedWidth: reducedSize, fontSize: fontSize, screenWidth: screenWidth),
              InvoiceWidget.buildItems(title: 'Payment type', value: invoice!.paymentType!, reducedWidth: reducedSize, fontSize: fontSize, screenWidth: screenWidth),
              InvoiceWidget.buildItems(title: 'Change', value: invoice!.change!, reducedWidth: reducedSize, fontSize: fontSize, screenWidth: screenWidth),
            ],

          /// ********************************* invoice footer ******************************** ///
          InvoiceWidget.buildDottedLine(reducedWidth: reducedSize, screenWidth: screenWidth),
          InvoiceWidget.buildItems(title: 'Closed Bill', value: '', fontSize: 20, centerPos: true, screenWidth: screenWidth),
          InvoiceWidget.buildDottedLineWithCurrentDateTime(reducedWidth: reducedSize, fontSize: 18, screenWidth: screenWidth),
          InvoiceWidget.buildItems(title: invoice!.footer1!, value: '', fontSize: fontSize, centerPos: true, screenWidth: screenWidth),
          InvoiceWidget.buildItems(title: invoice!.footer2!, value: '', fontSize: fontSize, centerPos: true, screenWidth: screenWidth),
        ],
      );
    }

    return const Center(child: Text('Data not available'));
  }

}