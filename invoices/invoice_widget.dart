import 'package:flutter/material.dart';
import '../constants.dart';
import '../formatter.dart';

class InvoiceWidget {
  static Widget buildItems({required double screenWidth, required String title, required String value, int reducedWidth=0, double? fontSize, bool isBold=false, bool centerPos=false}) {
    const divider = Constants.invoiceItemDivider;
    const multiplier = Constants.invoiceItemMultiplier; // nilai multiplier ini disesuaikan aja (tergantung font size), silahkan sesuaikan nilai divider & multiplier

    int rowCount = (value.length / divider).ceil();
    num totalRow = rowCount > 0 ? rowCount : 1;
    totalRow *= multiplier;
    // print('value length: ${value.length} / row count: $rowCount / height size: $totalRow');

    return Container(
      height: double.parse(totalRow.toString()),
      width: screenWidth - reducedWidth,
      // margin: EdgeInsets.zero,
      decoration: const BoxDecoration(
        // border: Border.all(color: Colors.red)
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisAlignment: centerPos ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
        children: [
          Text(
              title,
              style: TextStyle(fontSize: fontSize, color: Colors.black, fontWeight: isBold ? FontWeight.bold : null)
          ),
          SizedBox(width: centerPos ? 0 : (title.length >= 14 ? 20 : 50)),
          centerPos
            ? Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(fontSize: fontSize, color: Colors.black, fontWeight: isBold ? FontWeight.bold : null)
            )
            : Expanded(
              child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: fontSize, color: Colors.black, fontWeight: isBold ? FontWeight.bold : null)
              )
            )
        ],
      ),
    );
  }

  static Widget buildDottedLineWithCurrentDateTime({required double screenWidth, int reducedWidth=0, double? fontSize}) {
    final currentDate = Formatter.formatDate(dateString: DateTime.now().toString());

    return SizedBox(
      width: screenWidth - reducedWidth,
      // decoration: BoxDecoration(border: Border.all(color: Colors.green)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              SizedBox(
                // margin: const EdgeInsets.only(top: 20),
                // width: screenWidth - reducedWidth,
                  height: 28,
                  // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('<', style: TextStyle(fontSize: 18),),
                      ...List.generate(screenWidth~/10, (index) {
                        return Expanded(
                            child: Container(
                              color: index % 2 == 0 ? Colors.transparent : Colors.black,
                              height: 2,
                            )
                        );
                      }),
                      const Text('>', style: TextStyle(fontSize: 18),),
                    ],
                  )
              ),
              Center(
                child: Container(
                    alignment: Alignment.center,
                    height: 28,
                    width: 220,
                    // width: currentDate.length * 8.5,
                    color: Colors.white,
                    child: Text(currentDate, style: const TextStyle(fontSize: 18),)
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  static Widget buildFooterLine({required double leftPos, double? width, required String text, enablePadding=false}) {
    return Positioned(
      left: leftPos,
      child: Container(
          color: Colors.white,
          padding: enablePadding ? const EdgeInsets.only(left: 10, right: 10) : null,
          width: width,
          // height: 14,
          child: Center(child: Text(text, style: const TextStyle(fontSize: 18)),)
      ),
    );
  }

  static Widget buildDottedLine({required double screenWidth, int reducedWidth=0, double topMargin=4}) {
    return Container(
        margin: EdgeInsets.only(bottom: 4, top: topMargin, left: 0),
        width: screenWidth - reducedWidth,
        // height: 10,
        child: Row(
          children: [
            ...List.generate(screenWidth~/10, (index) {
              return Expanded(
                  child: Container(
                    color: index % 2 == 0 ? Colors.transparent : Colors.black,
                    height: 2,
                  )
              );
            }),
          ],
        )
    );
  }

  static Widget buildHorizontalLine({required double screenWidth, int reducedWidth=0}) {
    return Container(
      // height: 20,
      margin: const EdgeInsets.only(top: 4, bottom: 4),
      width: screenWidth - reducedWidth,
      child: Row(
        children: [
          Expanded(
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black)
                ),
              )
          ),
        ],
      ),
    );
  }
}