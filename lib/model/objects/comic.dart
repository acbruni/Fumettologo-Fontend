class Comic {
  final int id;
  final String title;
  final String author;
  final String publisher;
  final String category;
  final double price;
  final int quantity;
  final String image;

  Comic({
    required this.id,
    required this.title,
    required this.author,
    required this.publisher,
    required this.category,
    required this.price,
    required this.quantity,
    required this.image,
  });

  factory Comic.fromJson(Map<String, dynamic> json) {
    return Comic(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      publisher: json['publisher'],
      category: json['category'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'publisher': publisher,
      'category': category,
      'price': price,
      'quantity': quantity,
      'image': image,
    };
  }
}