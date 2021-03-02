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
  bool _isLoading = true;
  final _key = UniqueKey();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
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
          ),
          _isLoading
              ? Padding(
                  padding: const EdgeInsets.only(top: 2.0, left: 115),
                  child: SizedBox(width: 50, child: LinearProgressIndicator()),
                )
              : Container(height: 0, width: 0),
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
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: WebView(
            key: _key,
            initialUrl: widget.blogUrl,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                _isLoading = false;
              });
            },
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
          ),
        ),
        _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(),
      ]),
    );
  }
}
