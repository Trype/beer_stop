class Alcohol {
  final int permanentId;
  final String title;
  final String? brand;
  final String? thumbnailUrl;
  final String? imageUrl;
  final String category;
  final String? subcategory;
  final double price;
  final double volume;
  final double priceIndex;
  final double alcoholContent;
  final String? country;

  const Alcohol({
    required this.permanentId,
    required this.title,
    required this.brand,
    required this.thumbnailUrl,
    required this.imageUrl,
    required this.category,
    required this.alcoholContent,
    required this.price,
    required this.priceIndex,
    required this.country,
    required this.subcategory,
    required this.volume
  });

  factory Alcohol.fromJson(Map<String, dynamic> json) {
    return Alcohol(
        permanentId: json['permanent_id'],
        title: json['title'],
        brand: json['brand'],
        thumbnailUrl: json['thumbnail_url'],
        imageUrl: json['image_url'],
        category: json['category'],
      subcategory: json['subcategory'],
      alcoholContent: json['alcohol_content'].toDouble(),
      price: json['price'].toDouble(),
      priceIndex: json['price_index'].toDouble(),
      country: json['country'],
      volume: json['volume'].toDouble()
    );
  }

  @override
  String toString() {
    return title;
  }
}