import 'dart:convert';

class Article {
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;

  Article(this.author, this.title, this.description, this.url, this.urlToImage);

  @override
  String toString() {
    return 'Article(author: $author, title: $title, description: $description, url: $url, urlToImage: $urlToImage)';
  }

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
    };
  }

  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      map['author'] ?? '',
      map['title'] ?? '',
      map['description'] ?? '',
      map['url'] ?? '',
      map['urlToImage'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Article.fromJson(String source) =>
      Article.fromMap(json.decode(source));
}
