import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newsapp/models/articleModel.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class article_view extends StatefulWidget {
  final String blogUrl;
  article_view({this.blogUrl});

  @override
  _article_viewState createState() => _article_viewState();
}

class _article_viewState extends State<article_view> {
  final _key = UniqueKey();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Techicious", style: TextStyle(color: Colors.blue)),
              Text(
                "News",
                style: TextStyle(color: Colors.red),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 115),
            child: Text(
              "Article",
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          )
        ]),
        actions: [
          Opacity(
            opacity: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.save),
            ),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: WebView(
          key: _key,
          initialUrl: widget.blogUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
      ),
    );
  }
}
