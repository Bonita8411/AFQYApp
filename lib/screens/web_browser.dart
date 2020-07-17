import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebBrowser extends StatelessWidget {
  final String url;

  WebBrowser(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Ticket'),
        backgroundColor: Colors.red[900],
      ),
      body: Container(
          child: WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
          )),
    );
  }
}
