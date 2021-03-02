import 'package:flutter/material.dart';
import 'package:newsapp/views/article_view.dart';
import 'package:newsapp/views/home.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Techicious News",
        debugShowCheckedModeBanner: false,
        builder: (BuildContext context, Widget widget) {
          ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
            return buildError(context, errorDetails);
          };

          return widget;
        },
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: Home());
  }
}

//Error Handler Widget
Widget buildError(BuildContext context, FlutterErrorDetails error) {
  return Scaffold(
    body: Center(
      child: Column(
        children: [
          SizedBox(
            width: 300,
            child: SvgPicture.asset(
              'assets/Error.svg',
            ),
          ),
          Text(
            'We are very Sorry, but there is an Error.\nWe have got the reports an  we are working in and out to Fix this issue.\nPlease Restart the App',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.blueGrey),
          ),
        ],
      ),
    ),
  );
}
