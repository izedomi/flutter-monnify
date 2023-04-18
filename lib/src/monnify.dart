import 'package:flutter/material.dart';
import 'model/appbar_config.dart';
import 'model/toast_config.dart';
import 'model/transaction_response.dart';
import 'monnify_webview.dart';

class Monnify {
  Future<TransactionResponse?> checkout(
    BuildContext context,
    Map<String, dynamic> payload, {
    bool displayToast = true,
    ToastConfig? toast,
    AppBarConfig? appBar,
  }) async {
    TransactionResponse? transactionResponse = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MonnifyWebview(
                payload,
                toast: toast,
                appBar: appBar,
                displayToast: displayToast,
              )),
    );
    return transactionResponse;
  }
}
