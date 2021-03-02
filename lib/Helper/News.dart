import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newsapp/models/articleModel.dart';
import 'package:http/http.dart' as http;

class News {
  List<ArticleModel> news = [];
  Future<List> getNews(country, category) async {
    var response;
    String url =
        'http://api-maya.herokuapp.com/news?country=$country&category=$category';
    print(url);
    try {
      response = await http.get(url);
    } catch (e) {
      print('Error in HTTP ' + e);
    }
    var jsonData = jsonDecode(response.body);
    var CNews = jsonData['country'];
    var CaNews = jsonData['category'];
    var listC = [CNews, CaNews];
    if (jsonData['status'] == 'OK') {
      jsonData['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            author: element['author'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            description: element['description'],
            content: element['content'],
            source: element['source'],
          );
          news.add(articleModel);
        }
      });
    }
    return listC;
  }
}

class CategoryNews {
  List<ArticleModel> news = [];
  Future<void> getCategoryNews(String category) async {
    String url =
        'http://newsapi.org/v2/top-headlines?country=in&category=$category&apiKey=f623a55d481c4466b5e85ea7b71ab8b6';

    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            author: element['author'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            description: element['description'],
            content: element['content'],
          );
          news.add(articleModel);
          print(news);
        }
      });
    }
  }
}

class MayaAskedNewsC {
  List<ArticleModel> news = [];
  Future<void> getMayaNews(String country) async {
    String url =
        'http://newsapi.org/v2/top-headlines?country=$country&apiKey=f623a55d481c4466b5e85ea7b71ab8b6';
    print(url);
    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            author: element['author'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            description: element['description'],
            content: element['content'],
          );
          news.add(articleModel);
          print(news);
        }
      });
    }
  }
}

class MayaAskedNews {
  List<ArticleModel> news = [];
  Future<void> getMayaNews(String country, String category) async {
    String url =
        'http://newsapi.org/v2/top-headlines?country=in&apiKey=f623a55d481c4466b5e85ea7b71ab8b6';
    if (category != null && country != null) {
      url =
          'http://newsapi.org/v2/top-headlines?country=$country&category=$category&apiKey=f623a55d481c4466b5e85ea7b71ab8b6';
      print(url);
    } else if (country != null && category == null) {
      url =
          'http://newsapi.org/v2/top-headlines?country=$country&apiKey=f623a55d481c4466b5e85ea7b71ab8b6';
      print(url);
    } else if (country == null && category == null) {
      url =
          'http://newsapi.org/v2/top-headlines?country=in&apiKey=f623a55d481c4466b5e85ea7b71ab8b6';
      print(url);
    } else if (category != null) {
      url =
          'http://newsapi.org/v2/top-headlines?country=in&category=$category&apiKey=f623a55d481c4466b5e85ea7b71ab8b6';
      print(url);
    }
    // else {
    //   url =
    //       'http://newsapi.org/v2/top-headlines?country=in&apiKey=f623a55d481c4466b5e85ea7b71ab8b6';
    //   print(url);
    // }
    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);

    if (jsonData['status'] == 'ok') {
      jsonData['articles'].forEach((element) {
        if (element['urlToImage'] != null && element['description'] != null) {
          ArticleModel articleModel = ArticleModel(
            title: element['title'],
            author: element['author'],
            url: element['url'],
            urlToImage: element['urlToImage'],
            description: element['description'],
            content: element['content'],
          );
          news.add(articleModel);
          print(news);
        }
      });
    }
  }
}

class GetMayaResponse {
  Future<List> getResponse(String sentence) async {
    String url = 'https://api-maya.herokuapp.com/api?Query=$sentence';
    var res = await http.get(url);
    var jsonData = jsonDecode(res.body);
    String Country = jsonData['country'];
    String Category = jsonData['category'];
    var RespList = new List(2);
    RespList[0] = Country;
    RespList[1] = Category;
    return RespList;
  }
}

class Source<String> {
  String id;
  String name;

  Source({this.id, this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(name: json["name"] as String);
  }
}
