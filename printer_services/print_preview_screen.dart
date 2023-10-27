import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../invoices/food_and_drink_invoice/invoice_builder.dart';
import '../invoices/invoice_generator.dart';
import '../invoices/food_and_drink_invoice/invoice_model.dart';

// ignore: must_be_immutable
class PrintPreviewScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  bool showGeneratedInvoice;
  BuildContext mainContext;

  PrintPreviewScreen({Key? key,
    required this.data,
    this.showGeneratedInvoice=false,
    required this.mainContext
  }) : super(key: key);

  ValueNotifier<Uint8List?> invoiceImage = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          /// invoice widget preview
          InvoiceBuilder(invoice: Invoice.fromMap(data)),

          const SizedBox(height: 20,),

          /// Generate invoice button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await InvoiceGenerator.generateInvoice(
                      context: mainContext,
                      dataToPrint: data
                  );

                  invoiceImage.value = InvoiceGenerator.generatedInvoiceImage;
                },
                child: const Text('View Generated Invoice'),
              ),

              /// Print invoice button
              ElevatedButton(
                onPressed: () async {
                  await InvoiceGenerator.createInvoiceAndPrint(
                      context: mainContext,
                      data: data
                  );
                },
                child: const Text('Print Invoice'),
              ),
            ],
          ),

          ValueListenableBuilder(
              valueListenable: invoiceImage,
              builder: (BuildContext ctx, Uint8List? img, Widget? widget) {
                if (img == null) return const Center(child: Text('No generated invoice available'),);

                return Image.memory(img);
              }
            )
        ],
      ),
    );
  }
}
