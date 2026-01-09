import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final WebViewController _controller;
  late final WebViewController _controller1;
  late final WebViewController _controller2;

  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            print("Page Start Loading: $url");
          },
          onPageFinished: (url) {
            print("Page finished loading $url");
          },
          onNavigationRequest: (request) {
            if (request.url.startsWith("https://flutter.dev/")) {
              return NavigationDecision.navigate;
            }
            print("Blocked Navagation to :${request.url}");
            return NavigationDecision.prevent;
          },
        ),
      ); 

    //..loadRequest(Uri.parse("https://flutter.dev/"));
    _controller.loadRequest(Uri.parse("https://flutter.dev/"));
    _controller.loadFlutterAsset('assets/index.html');
    _controller1 = WebViewController()..loadFlutterAsset('assets/index.html');
    _controller2 = WebViewController()..loadHtmlString("<html><head><title>Local Asset</title></head><body><h1>Hello from assets/index.html</h1><p>This is loaded inside WebView.</p></body></html>");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WebView Flutter"),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () async {
              if (await _controller1.canGoBack()) {
                _controller1.goBack();
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () async {
              if (await _controller1.canGoForward()) {
                _controller1.goForward();
              }
            },
          ),
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => _controller1.reload()),
        ],
      ),
      body: 
       Column(
        children: [
          Expanded(child: WebViewWidget(controller: _controller1)),
          const Divider(thickness: 2, height: 1),
          Expanded(child: WebViewWidget(controller: _controller2)),
        ]
       ),
    );
  }
}