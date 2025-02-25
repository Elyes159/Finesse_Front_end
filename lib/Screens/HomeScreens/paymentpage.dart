import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;
  final String successUrl;
  final String failUrl;

  const PaymentWebView({
    required this.paymentUrl,
    required this.successUrl,
    required this.failUrl,
  });

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  late String _currentUrl;

  @override
  void initState() {
    super.initState();
    _initializeWebView(); // Appeler la méthode d'initialisation ici
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _currentUrl = url; // Suivre l'URL actuelle
            });

            if (url.startsWith(widget.successUrl)) {
              Navigator.pop(context, true); // Paiement réussi
            } else if (url.startsWith(widget.failUrl)) {
              Navigator.pop(context, false); // Paiement échoué
            }
          },
          onWebResourceError: (WebResourceError error) {
            print("Web resource error: ${error.description}");
            // Vous pourriez afficher un message d'erreur ou naviguer vers une page d'erreur
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paiement"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () async {
            _currentUrl = await _controller.currentUrl() ?? "";
            print(_currentUrl);

            if (_currentUrl.contains("success_finesse")) {
              Navigator.pop(context, true); // Retourner true si l'URL contient "success_finesse"
            } else {
              Navigator.pop(context, false); // Sinon retourner false
            }
          },
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
