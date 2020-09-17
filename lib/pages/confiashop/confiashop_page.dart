import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ConfiashopPage extends StatefulWidget {
  @override
  _ConfiashopPageState createState() => _ConfiashopPageState();
}

class _ConfiashopPageState extends State<ConfiashopPage> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WebView(
            initialUrl: 'https://www.google.com',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('https://www.youtube.com/')) {
                print('blocking navigation to $request}');
                Navigator.pop(context);
                return NavigationDecision.prevent;
              }
              print('allowing navigation to $request');
              return NavigationDecision.navigate;
            },
            //javascriptChannels: Set.from([
            //  JavascriptChannel(
            //      name: 'event',
            //      onMessageReceived: (JavascriptMessage message) {
            //        print('1. $message');
            //      }
            //    ),
            //    JavascriptChannel(
            //      name: 'window',
            //      onMessageReceived: (JavascriptMessage message) {
            //        print('2. $message');
            //      }
            //    ),
            //    JavascriptChannel(
            //      name: 'Print',
            //      onMessageReceived: (JavascriptMessage message) {
            //        print('3. $message');
            //      }
            //    )
            //]),
            //onPageStarted: (String url) {
            //  print('Page started loading: $url');
            //},
            //onPageFinished: (String url) {
            //  print('Page finished loading: $url');
            //},
            //gestureNavigationEnabled: true,
          ),
        bottomNavigationBar: _bottomBar()
      
    );
  }

  Widget _bottomBar(){
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Colors.grey[300]),
        )
      ),
      child: GestureDetector(
        onTap: ()=>Navigator.pop(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              child: Icon(
                Icons.arrow_back_ios, 
                color: Colors.blue    
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 15.0),
              child: Text(
                'Regresar'.toUpperCase(), 
                style:  TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)
              )
            )
          ],
        ),
      ),
    );
  }

}