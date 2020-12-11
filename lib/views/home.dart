import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/Helper/Data.dart';
import 'package:newsapp/Helper/News.dart';
import 'package:newsapp/models/CategoryModel.dart';
import 'package:newsapp/models/MayaAPIModel.dart';
import 'package:newsapp/models/articleModel.dart';
import 'package:newsapp/views/article_view.dart';
import 'package:newsapp/views/category_news.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

//variableGlobal
stt.SpeechToText _speech;
bool _isListening = false;
String _text = '';
final FlutterTts tts = FlutterTts();

class _HomeState extends State<Home> {
  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> articles = new List<ArticleModel>();
  String countryMaya = 'in';
  String categoryMaya = 'general';

  bool _loading = true;

  void _speak(String reply) async {
    await tts.setLanguage("en-US");
    await tts.setPitch(1);
    await tts.speak(reply);
  }

  void _listen() async {
    if (!_isListening) {
      bool availble = await _speech.initialize(
        onStatus: (val) {
          print('onStatus: $val');
          if (val != 'listening') {
            setState(() {
              _isListening = false;
            });
          }
        },
        onError: (val) {
          print('onError: $val');
          setState(() {
            _isListening = false;
          });
        },
      );
      if (availble) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(onResult: (val) {
          setState(() async {
            _text = val.recognizedWords;
            print(_text);
            await responseByMaya(_text);
            _loading = true;
            getMNews(countryMaya, categoryMaya);
          });
        });
      } else {
        setState(() {
          _isListening = false;
        });
        _speech.stop();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories = getCategoryModel();
    getNews();
    _speech = stt.SpeechToText();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews(countryMaya, categoryMaya);
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  getMNews(String country, String category) async {
    MayaAskedNews newsClass = MayaAskedNews();
    await newsClass.getMayaNews(country, category);
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  responseByMaya(String sentence) async {
    GetMayaResponse resp = GetMayaResponse();
    List mayaResp = await resp.getResponse(sentence);
    countryMaya = mayaResp[0];
    categoryMaya = mayaResp[1];
    if (countryMaya == null) {
      countryMaya = 'in';
    } else if (countryMaya == 'call') {
      countryMaya = 'in';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Colors.red,
        endRadius: 35.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          onPressed: () {
            _listen();
          },
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Techicious",
                style: TextStyle(
                  color: Colors.blue,
                )),
            Text(
              "News",
              style: TextStyle(color: Colors.red),
            ),
            Text(
              countryMaya,
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
      body: _loading
          ? Center(
              child: Container(
              child: CircularProgressIndicator(),
            ))
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    //Categories
                    Container(
                      height: 70,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            imageUrl: categories[index].imageUrl,
                            categoryName: categories[index].categoryName,
                          );
                        },
                      ),
                    ),

                    //Blogs
                    Container(
                      padding: EdgeInsets.only(top: 16),
                      child: ListView.builder(
                        itemCount: articles.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Card(
                              margin: EdgeInsets.only(bottom: 16),
                              elevation: 5.0,
                              child: BlogTile(
                                  imageUrl: articles[index].urlToImage,
                                  title: articles[index].title,
                                  description: articles[index].description,
                                  url: articles[index].url));
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final imageUrl, categoryName;
  CategoryTile({this.imageUrl, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _isListening = false;
        Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    category_news(
                      category: categoryName,
                    ),
                transitionDuration: Duration(seconds: 0)));
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        child: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 120,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 120,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.black26,
              ),
              child: Text(
                categoryName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  final String imageUrl, title, description, url;
  BlogTile({this.imageUrl, this.title, @required this.url, this.description});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        _isListening = false;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => article_view(
              blogUrl: url,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                )),
            SizedBox(
              height: 8,
            ),
            Text(title,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87)),
            SizedBox(
              height: 8,
            ),
            Text(description, style: TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
