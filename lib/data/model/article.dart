// import 'dart:convert';

class ArticlesResult {
 final String status;
 final int totalResults;
 final List<Article> articles;

 ArticlesResult({
   required this.status,
   required this.totalResults,
   required this.articles,
 });
 
 factory ArticlesResult.fromJson(Map<String, dynamic> json) => ArticlesResult(
       status: json["status"],
       totalResults: json["totalResults"],
       articles: List<Article>.from((json["articles"] as List)
           .map((x) => Article.fromJson(x))
           .where((article) =>
              article.author != null &&
              article.urlToImage != null &&
              article.publishedAt != null &&
              article.content != null)),
     );
}

class Article {
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;

  Article({
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> article) => Article(
        author: article['author'],
        title: article['title'],
        description: article['description'],
        url: article['url'],
        urlToImage: article['urlToImage'],
        publishedAt: DateTime.parse(article['publishedAt']),
        content: article['content'],
      );

  // static List<Article> parseArticles(String? json) {
  //   if (json == null) {
  //     return [];
  //   }

  //   final List parsed = jsonDecode(json);
  //   return parsed.map((json) => Article.fromJson(json)).toList();
  // }
}
