class Products {
  final String id,
      productName,
      productCode,
      image,
      unitPrice,
      totalPrice,
      quantity,
      createdDate;

  Products(this.id, this.productName, this.productCode, this.image,
      this.unitPrice, this.totalPrice, this.quantity, this.createdDate);

  factory Products.toJson(Map<String, dynamic>json){
    return Products(
      json['_id'],
      json['ProductName'],
      json['ProductCode'],
      json['Img'],
      json['UnitPrice'],
      json['Qty'],
      json['TotalPrice'],
      json['CreatedDate'],
    );
  }
}
