import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/data/api/api_service.dart';
// import 'package:news_app/ui/article_detail_page.dart';
import 'package:news_app/data/model/article.dart';
import 'package:news_app/widgets/card_article.dart';
import 'package:news_app/widgets/platform_widget.dart';

class ArticleListPage extends StatefulWidget {
  const ArticleListPage({super.key});

  @override
  State<ArticleListPage> createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {
  late Future<ArticlesResult> _article;

  @override
  void initState() {
    super.initState();
    _article = ApiService().topHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  // Android
  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
      ),
      body: _buildList(context),
    );
  }

  // iOS
  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('News App'),
        transitionBetweenRoutes: false,
      ),
      child: _buildList(context),
    );
  }

  Widget _buildList(BuildContext context) {
    return FutureBuilder(
        // future:
        //     DefaultAssetBundle.of(context).loadString('assets/articles.json'),
        future: _article,
        builder: (context, snapshot) {
          var state = snapshot.connectionState;
          if (state != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData) {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.articles.length,
                itemBuilder: (context, index) {
                  var article = snapshot.data?.articles[index];
                  return CardArticle(article: article!);
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Material(
                  child: Text(snapshot.error.toString()),
                ),
              );
            } else {
              return const Material(
                child: Text(''),
              );
            }
          }
          // final List<Article> articles = Article.parseArticles(snapshot.data);
          // return ListView.builder(
          //     itemCount: articles.length,
          //     itemBuilder: (context, index) {
          //       return _buildArticleItem(context, articles[index]);
          //     });
        });
  }
}

//   Widget _buildArticleItem(BuildContext context, Article article) {
//     return Material(
//       child: ListTile(
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         leading: Hero(
//           tag: article.urlToImage,
//           child: Image.network(
//             article.urlToImage,
//             width: 100,
//             errorBuilder: (ctx, error, _) =>
//                 const Center(child: Icon(Icons.error)),
//           ),
//         ),
//         title: Text(article.title),
//         subtitle: Text(article.author),
//         onTap: () {
//           Navigator.pushNamed(context, ArticleDetailPage.routeName,
//               arguments: article);
//         },
//       ),
//     );
//   }
// }