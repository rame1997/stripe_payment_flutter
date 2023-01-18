import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../stripe/stripe_service.dart';

class OptionsScreen extends StatefulWidget {
  const OptionsScreen({Key? key}) : super(key: key);

  @override
  _OptionsScreenState createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stripe'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          ListTile(
            leading: const Icon(Icons.add_circle_outlined),
            title: const Text('New card'),
            subtitle: const Text('Pay with new card'),
            onTap: () async => await payViaNewCard(),
          ),
          ListTile(
            leading: const Icon(Icons.add_circle_outlined),
            title: const Text('Exists cards'),
            subtitle: const Text('Pay with exist card'),
            onTap: () => Navigator.pushNamed(context, '/cards_screen'),
          )
        ],
      ),
    );
  }

  Future<void> payViaNewCard() async {
    ProgressDialog progressDialog = ProgressDialog(context: context);
    // await progressDialog.show(max: 1, msg: 'Please wait...');
    var response = await StripeService.payViaCard(amount: '1000', currency: 'usd');
    // progressDialog.close();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        backgroundColor: response.success ? Colors.green : Colors.red,
        duration: const Duration(seconds: 1),
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }
}
