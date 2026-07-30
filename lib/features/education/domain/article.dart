class Article {
  final String id;
  final String title;
  final String subtitle;
  final String content;
  final String imageUrl;
  final String category;
  final String readTime;
  final String publishDate;
  final String author;
  final bool isFeatured;

  const Article({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.imageUrl,
    required this.category,
    required this.readTime,
    required this.publishDate,
    required this.author,
    this.isFeatured = false,
  });
}
