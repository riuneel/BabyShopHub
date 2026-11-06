class ProductData{
  const ProductData({
    required this.productId,
    required this.productName,
    required this.productBrand,
    required this.productCategory,
    required this.productPrice,
    required this.productStock,
    required this.productImage,
  });

  final int productId;
  final String productName;
  final String productBrand;
  final String productCategory;
  final double productPrice;
  final int productStock;
  final String productImage;

  // assigning the JSON value of products to the Dart product variables, using map
  // Map<String, dynamic> json accepts the JSON data as a Dart map.

  ProductData.fromJson(Map<String, dynamic> json)
     : productId = json['product_id'] as int,
       productName = json['product_name'] as String,
       productBrand = json['product_brand'] as String,
       productCategory = json['product_category'] as String,
       productPrice = (json['product_price'] as num).toDouble(),
       productStock = json['product_stock'] as int,
       productImage = json['product_image'] as String;

}