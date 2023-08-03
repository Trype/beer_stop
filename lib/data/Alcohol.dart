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
  final double rating;
  final String? description;

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
    required this.volume,
    required this.rating,
    required this.description
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
      volume: json['volume'].toDouble(),
      rating: json['rating'] != null ? json['rating'].toDouble() : 0.0,
      description: json['description']
    );
  }

  Map<String, dynamic> toJson() => {
    "permanent_id": permanentId,
    "title": title,
    "brand": brand,
    "thumbnail_url": thumbnailUrl,
    "image_url": imageUrl,
    "category": category,
    "subcategory": subcategory,
    "alcohol_content": alcoholContent,
    "price": price,
    "price_index": priceIndex,
    "country": country,
    "volume": volume,
    "rating": rating,
    "description": description,
  };

  @override
  String toString() {
    return title;
  }
}