class Alcohol {
  final int permanentId;
  final String title;
  final String? brand;
  final String? thumbnailUrl;
  final String? imageUrl;

  const Alcohol({
    required this.permanentId,
    required this.title,
    required this.brand,
    required this.thumbnailUrl,
    required this.imageUrl
  });

  factory Alcohol.fromJson(Map<String, dynamic> json) {
    return Alcohol(
        permanentId: json['permanent_id'],
        title: json['title'],
        brand: json['brand'],
        thumbnailUrl: json['thumbnail_url'],
        imageUrl: json['image_url']
    );
  }

  @override
  String toString() {
    return title;
  }
}