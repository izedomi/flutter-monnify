## Flutter Monnify Package
A Flutter package for making payments via Monnify Payment Gateway. Android and iOS supported.

## Getting Started
To use this package, add `flutter_monnify` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).


## How to use

``` dart
import 'package:flutter_monnify/flutter_paystack.dart';

TransactionResponse? response = await Monnify().checkout(
      context, monnifyPayload(),
      appBar: AppBarConfig(
          titleColor: Colors.white, backgroundColor: Colors.red),
      toast: ToastConfig(
          color: Colors.black, backgroundColor: Colors.red));

  //call the backend to verify transaction status before providing value
```

No other configuration required&mdash;the plugin works out of the box.

## Example
``` dart
import 'package:flutter/material.dart';
import 'package:flutter_monnify/flutter_monnify.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Monnify',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PayWithMonnify(),
    );
  }
}

class PayWithMonnify extends StatefulWidget {
  const PayWithMonnify({super.key});

  @override
  State<PayWithMonnify> createState() => _PayWithMonnifyState();
}

class _PayWithMonnifyState extends State<PayWithMonnify> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SizedBox(
      width: width,
      height: height,
      child: Center(
        child: TextButton(
          child: const Text("Pay With Monnify SDK"),
          onPressed: () async {
            TransactionResponse? response = await Monnify().checkout(
                context, monnifyPayload(),
                appBar: AppBarConfig(
                    titleColor: Colors.white, backgroundColor: Colors.red),
                toast: ToastConfig(
                    color: Colors.black, backgroundColor: Colors.red));

            //call the backend to verify transaction status before providing value
          },
        ),
      ),
    ));
  }

  Map<String, dynamic> monnifyPayload() {
    return {
      "amount": 100,
      "currency": "NGN",
      "reference": DateTime.now().toIso8601String(),
      "customerFullName": "Emmanuel Izedomi",
      "customerEmail": "kingemmanuel4life@gmail.com",
      "apiKey": "MK_TEST_595UN92CCV",
      "contractCode": "8628159341",
      "paymentDescription": "Lahray World",
      "metadata": {"name": "Damilare", "age": 45},
      // "incomeSplitConfig": [
      //   {
      //     "subAccountCode": "MFY_SUB_342113621921",
      //     "feePercentage": 50,
      //     "splitAmount": 1900,
      //     "feeBearer": true
      //   },
      //   {
      //     "subAccountCode": "MFY_SUB_342113621922",
      //     "feePercentage": 50,
      //     "splitAmount": 2100,
      //     "feeBearer": true
      //   }
      // ],
      "paymentMethod": ["CARD", "ACCOUNT_TRANSFER", "USSD", "PHONE_NUMBER"],
    };
  }
}

```

The Monnify.checkout() returns a TransactionResponse with the following fields:

``` dart
  String? status;
  String? message;
  String? transactionReference;
  String? paymentReference;
  int? amount;
  String? currency;
  dynamic rawData;

```

The transaction is successful if `response.status` is `SUCCEESSFUL`. It is recommended to verify with the transaction status with the backend before providing balue

## Contributing, Issues and Bug Reports

The project is open to public contribution. Please feel very free to contribute.
Experienced an issue or want to report a bug? Please, [report it here](https://github.com/izedomi/flutter-monnify/issues). Remember to be as descriptive as possible.


## Need More Information?

For further info about Monnify's SDKs, including transaction status types, see the documentations for the [web](https://teamapt.atlassian.net/wiki/spaces/MON/pages/212008793/Monnify+Web+SDK) [Android](https://teamapt.atlassian.net/wiki/spaces/MON/pages/213909311/Monnify+Android+SDK) and [iOS](https://teamapt.atlassian.net/wiki/spaces/MON/pages/213909672/Monnify+iOS+SDK)




