class Invoice {
  final String? imageLogo;
  final String? imageUrl;
  final String? header1;
  final String? header2;
  final String? header3;
  final String? header4;
  final String? header5;

  final String? trxDate;
  final String? trxID;
  final String? cashierName;

  final List<InvoiceItem>? items;

  final String? subTotal;
  final String? discountTotal;
  final String? taxTotal;
  final String? total;
  final String? paymentType;
  final String? payAmount;
  final String? change;

  final String? footer1;
  final String? footer2;

  Invoice({
    this.imageLogo,
    this.imageUrl,
    this.header1,
    this.header2,
    this.header3,
    this.header4,
    this.header5,
    this.trxDate,
    this.trxID,
    this.cashierName,
    this.items,
    this.subTotal,
    this.discountTotal,
    this.taxTotal,
    this.total,
    this.paymentType,
    this.payAmount,
    this.change,
    this.footer1,
    this.footer2
  });

  factory Invoice.fromMap(Map<String, dynamic> data) {
    List<InvoiceItem> trxItems = [];

    if (data["transactionData"]["items"] != null) {
      for (final trxItem in data["transactionData"]["items"] as List) {
        trxItems.add(InvoiceItem.fromMap(trxItem));
      }
    }

    return Invoice(
      imageLogo: data["imageLogo"],
      imageUrl: data["imageUrl"],
      header1: data["headerData"]["header1"],
      header2: data["headerData"]["header2"],
      header3: data["headerData"]["header3"],
      header4: data["headerData"]["header4"],
      header5: data["headerData"]["header5"],

      trxDate: data["transactionData"]["date"],
      trxID: data["transactionData"]["trxID"],
      cashierName: data["transactionData"]["cashierName"],

      items: trxItems,

      subTotal: data["transactionData"]["subTotal"],
      discountTotal: data["transactionData"]["discountTotal"],
      taxTotal: data["transactionData"]["taxTotal"],
      total: data["transactionData"]["total"],
      paymentType: data["transactionData"]["paymentType"],
      payAmount: data["transactionData"]["payAmount"],
      change: data["transactionData"]["change"],

      footer1: data["footerData"]["footer1"],
      footer2: data["footerData"]["footer2"],
    );
  }
}

class InvoiceItem {
  late String itemName;
  late String itemPrice;
  late String qty;
  late String discountName;
  late String discountAmount;

  InvoiceItem.fromMap(Map<String, dynamic> data) {
    itemName = data["itemName"];
    itemPrice = data["itemPrice"];
    qty = data["qty"];
    discountName = data["discountName"];
    discountAmount = data["discountAmount"];
  }
}