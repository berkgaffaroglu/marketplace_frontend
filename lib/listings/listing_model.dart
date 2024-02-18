class Listing {
  final int id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory Listing.fromJson(Map<String, dynamic> json) {
    final imageUrl = json['images'].isEmpty ? '' : json['images'][0]['image'];
    print(imageUrl);
    return Listing(
        id: json['id'] is String ? int.parse(json['id']) : json['id'],
        title: json['title'],
        description: json['description'],
        price: json['price'].toDouble(),
        imageUrl: imageUrl);
  }
}
