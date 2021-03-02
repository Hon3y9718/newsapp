import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/Helper/Data.dart';
import 'package:newsapp/Helper/News.dart';
import 'package:newsapp/models/CategoryModel.dart';
import 'package:newsapp/models/articleModel.dart';
import 'package:newsapp/views/home.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';
import 'article_view.dart';

class category_news extends StatefulWidget {
  final String category, country;
  category_news({this.category, this.country});

  @override
  _category_newsState createState() => _category_newsState();
}

class _category_newsState extends State<category_news> {
  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> articles = new List<ArticleModel>();
  bool _loading = false;
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';
  var countryMaya = 'in';
  var CNews = '';
  var categoryMaya = 'general';
  var _currentSelectedCountry = 'in';

  var list = {
    'USA': 'us',
    'India': 'in',
    'Greece': 'gr',
    'Argentina': 'ar',
    'Hong Kong': 'hk',
    'Australia': 'au',
    'Austria': 'at',
    'Belgium': 'be',
    'Hungary': 'hu',
    'Indonesia': 'id',
    'Bulgaria': 'bg',
    'Ireland': 'ie',
    'Canada': 'ca',
    'Israel': 'il',
    'China': 'cn',
    'Italy': 'it',
    'Colombia': 'co',
    'Japan': 'jp',
    'Cuba': 'cu',
    'Latvia': 'lv',
    'Czech Republic': 'cz',
    'Lithuania': 'lt',
    'Egypt': 'eg',
    'Malaysia': 'my',
    'Mexico': 'mx',
    'Germany': 'de',
    'Morocco': 'ma',
    'Slovenia': 'si',
    'Slovakia': 'sk',
    'Singapore': 'sg',
    'Serbia': 'rs',
    'Venuzuela': 've',
    'Saudi Arabia': 'sa',
    'United Kingdom': 'uk',
    'Ukraine': 'ua',
    'Russia': 'ru',
    'Romania': 'ro',
    'Portugal': 'pt',
    'UAE': 'ae',
    'Turkey': 'tr',
    'Poland': 'pl',
    'Thailand': 'th',
    'Taiwan': 'tw',
    'Philippines': 'ph',
    'Norway': 'no',
    'Switzerland': 'ch',
    'Sweden': 'se',
    'Nigeria': 'ng',
    'New Zealand': 'nz',
    'Netherland': 'nl',
    'South Africa': 'za',
    'South Korea': 'kr',
  };

  Future setCountry(country) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('country', country);
    var countryMaya = prefs.getString('country');
    countryMaya = await getCountry();
  }

  getCountry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var country = prefs.getString('country');
    return country;
  }

  Future<String> getCategory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var category = prefs.getString('category');
    return category;
  }

  //SetCategory
  Future setCategory(category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var categorytobeset = prefs.setString('category', category);
  }

  @override
  void initState() {
    super.initState();
    categories = getCategoryModel();
    getNews();
    _speech = stt.SpeechToText();
  }

  getNews() async {
    var country = await getCountry();
    News newsClass = News();
    var CoNews = await newsClass.getNews('null', widget.category);
    articles = newsClass.news;
    setState(() {
      _loading = false;
      CNews = CoNews[0];
      _currentSelectedCountry = CNews;
    });
  }

  getNewsonSelect() async {
    var country = await getCountry();
    News newsClass = News();
    var CoNews =
        await newsClass.getNews(_currentSelectedCountry, widget.category);
    articles = newsClass.news;
    setState(() {
      _loading = false;
      CNews = CoNews[0];
      _currentSelectedCountry = CNews;
    });
  }

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
            getNews();
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

  responseByMaya(String sentence) async {
    GetMayaResponse resp = GetMayaResponse();
    List mayaResp = await resp.getResponse(sentence);
    countryMaya = mayaResp[0];
    categoryMaya = mayaResp[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        automaticallyImplyLeading: false,
        title: GestureDetector(
          onTap: () {
            setState(() {
              Navigator.pop(
                  context,
                  PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          Home(),
                      transitionDuration: Duration(seconds: 0)));
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(widget.category.capitalize(),
                  style: TextStyle(color: Colors.blue)),
              Text(
                "News",
                style: TextStyle(color: Colors.red),
              ),
              Text(
                CNews,
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 5, right: 11.5, left: 0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                icon: Image.asset(
                  'icons/flags/png/$_currentSelectedCountry.png',
                  package: 'country_icons',
                  height: 25,
                  width: 25,
                ),
                items: list.entries.map((entries) {
                  return DropdownMenuItem(
                    value: entries.key,
                    child: Text(
                      entries.key,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  );
                }).toList(),
                onChanged: (String valueSelected) {
                  setState(() {
                    _currentSelectedCountry = list[valueSelected];
                    _loading = true;
                    setCountry(_currentSelectedCountry);
                    getNewsonSelect();
                  });
                },
              ),
            ),
          ),
        ],
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
                  children: [
                    //Category
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
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(widget.category.capitalize(),
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))
                      ],
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
                            elevation: 4.0,
                            child: BlogTile(
                                imageUrl: articles[index].urlToImage,
                                title: articles[index].title,
                                description: articles[index].description,
                                url: articles[index].url,
                                source: articles[index].source),
                          );
                        },
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8, top: 8),
                        child: Text(
                          '© Techicious™ 2020',
                          style: TextStyle(color: Colors.black),
                        ),
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
  final String imageUrl, title, description, url, source;
  BlogTile(
      {this.imageUrl,
      this.title,
      @required this.url,
      this.description,
      this.source});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => article_view(
                      blogUrl: url,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16, top: 16, right: 16, left: 16),
        child: Column(
          children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
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
            SizedBox(height: 5),
            Row(
              children: [
                Text(
                  source,
                  style: TextStyle(color: Colors.blue),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

//CapitalizeExtension
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
