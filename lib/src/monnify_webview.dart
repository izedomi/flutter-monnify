import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import '../flutter_monnify.dart';

class MonnifyWebview extends StatefulWidget {
  ///Transaction payload
  final Map<String, dynamic> payload;

  ///display toast to user based on the various state
  final bool displayToast;

  /// Customize how toast is displayed
  final ToastConfig? toast;

  /// Customize look of the appbar
  final AppBarConfig? appBar;

  const MonnifyWebview(this.payload,
      {Key? key, this.displayToast = true, this.toast, this.appBar})
      : super(key: key);
  @override
  State<MonnifyWebview> createState() => _MonnifyWebviewState();
}

class _MonnifyWebviewState extends State<MonnifyWebview>
    with WidgetsBindingObserver {
  late WebViewPlusController _controller;
  double loadProgress = 0;
  String url = "https://monnify-web-asset.vercel.app";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appBar?.title ?? "Monnify",
          style: TextStyle(color: widget.appBar?.titleColor),
        ),
        elevation: 0,
        backgroundColor: widget.appBar?.backgroundColor,
        leading: widget.appBar?.leadingIcon ??
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.chevron_left,
                // color: baseBlack,
              ),
            ),
        actions: [
          IconButton(
            onPressed: () {
              _controller.loadUrl(url);
            },
            icon: const Icon(Icons.refresh
                // color: baseBlack,
                ),
          ),
        ],
      ),
      body: SafeArea(
        child: SizedBox(
            width: deviceWidth(context),
            height: deviceHeight(context),
            child: Column(
              children: [
                loadProgress < 1.0
                    ? Expanded(
                        flex: loadProgress < 1.0 ? 10 : 0,
                        child: _loadingView())
                    : Container(),
                Expanded(flex: 1, child: _mainView()),
              ],
            )),
      ),
    );
  }

  Widget _loadingView() {
    return Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.symmetric(vertical: 36),
        child: const Center(child: CircularProgressIndicator.adaptive()));
  }

  Widget _mainView() {
    return WebViewPlus(
      initialUrl: url,
      onWebViewCreated: (WebViewPlusController controller) {
        _controller = controller;
        controller.loadUrl(url);
      },
      onPageFinished: (String url) async {
        await _controller.webViewController
            .runJavascript('showpaymentModal(${json.encode(widget.payload)})');
      },
      onProgress: (int progress) {
        setState(() {
          loadProgress = progress / 100;
        });
      },
      debuggingEnabled: true,
      javascriptMode: JavascriptMode.unrestricted,
      javascriptChannels: <JavascriptChannel>{
        _monnifySDKJavascriptChannel(),
      },
    );
  }

  JavascriptChannel _monnifySDKJavascriptChannel() {
    return JavascriptChannel(
        name: 'monnifyFlutterClient',
        onMessageReceived: (JavascriptMessage message) {
          Map<String, dynamic> response = json.decode(message.message);
          if (kDebugMode) {
            print(response["message"]);
            print(response["data"]);
            print(response.toString());
            print("========");
          }
          returnTransactionStatus(response);
        });
  }

  returnTransactionStatus(Map<String, dynamic> response) {
    String toastMessage = response["message"] ?? "";

    //returns to the calling screen if "returnToCaller" is true
    if (response.containsKey("data") &&
        response.containsKey("returnToCaller") &&
        response["returnToCaller"]) {
      late TransactionResponse transactionResponse;

      Map<String, dynamic> responseData = response["data"];

      //transaction was cancelled
      if (responseData.containsKey("paymentStatus")) {
        toastMessage = responseData["paymentStatus"];

        transactionResponse = TransactionResponse(
            status: responseData["paymentStatus"],
            message: responseData["responseMessage"],
            amount: responseData["authorizedAmount"],
            rawData: responseData);
      }
      if (responseData.containsKey("status")) {
        toastMessage = responseData["message"] ?? "";
        if (responseData.containsKey("payload")) {
          transactionResponse = TransactionResponse(
              status: responseData["status"],
              message: responseData["message"] ?? responseData["status"],
              amount: responseData["payload"]["amount"],
              transactionReference: responseData["payload"]
                  ["transactionReference"],
              paymentReference: responseData["payload"]["paymentReference"],
              currency: responseData["payload"]["currency"],
              rawData: responseData);
        } else {
          transactionResponse = TransactionResponse(
              status: responseData["status"],
              message: responseData["message"] ?? responseData["status"],
              amount: responseData["authorizedAmount"],
              transactionReference: responseData["transactionReference"],
              paymentReference: responseData["paymentReference"],
              rawData: responseData);
        }
      }
      //show toast message
      if (widget.displayToast) {
        showToast(toastMessage);
      }

      //return transaction response
      if (Navigator.canPop(context)) {
        Navigator.pop(context, transactionResponse);
      }
    } else {
      if (widget.displayToast) {
        showToast(toastMessage);
      }
    }
  }

  showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: widget.toast?.length ?? Toast.LENGTH_LONG,
        gravity: widget.toast?.position ?? ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: widget.toast?.backgroundColor ?? Colors.grey,
        textColor: widget.toast?.color ?? Colors.black,
        fontSize: widget.toast?.fontSize ?? 16.0);
  }
}
