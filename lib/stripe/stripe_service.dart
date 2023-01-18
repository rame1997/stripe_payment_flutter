import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_payment/stripe_payment.dart';
import 'package:stripe_payment_ndc/stripe/stripe_helper.dart';
import '../models/stripe_transaction_response.dart';

class StripeService with StripeHelper {
  static const String _apiBase = "https://api.stripe.com/v1";
  static const String _paymentApiUrl = "$_apiBase/payment_intents";

  static init() {
    StripePayment.setOptions(StripeOptions(
      publishableKey: StripeHelper.publishableKey,
      merchantId: "test",
      androidPayMode: "test",
    ));
    // StripePayment.setOptions(StripeOptions(
    //     publishableKey:"public live key",
    //     merchantId: 'merchant.thegreatestmarkeplace', //merchantId
    //     androidPayMode: 'production'));
  }

  static Future<StripeTransactionResponse> payViaCard({
    required String amount,
    required String currency,
    CreditCard? creditCard,
  }) async {
    try {
      var paymentIntent = await StripeService.createPaymentIntent(amount: amount, currency: currency);

      var paymentMethod = creditCard != null
          ? await StripePayment.createPaymentMethod(PaymentMethodRequest(card: creditCard))
          : await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());

      var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
        clientSecret: paymentIntent['client_secret'],
        paymentMethodId: paymentMethod.id,
      ));

      if (response.status == 'succeeded') {
        return StripeTransactionResponse(message: "Transaction successful", success: true);
      } else {
        return StripeTransactionResponse(message: "Transaction failed", success: false);
      }
    } on PlatformException catch (platformException) {
      return getPlatformExceptionError(platformException: platformException);
    } catch (error) {
      return StripeTransactionResponse(message: 'Transaction failed', success: false);
    }
  }

  static getPlatformExceptionError(
      {required PlatformException platformException}) {
    if (platformException.code == 'cancelled') {
      return StripeTransactionResponse(message: platformException.message ?? 'Transaction Cancelled',success: false,);
    }
  }

  static Future<Map<String, dynamic>> createPaymentIntent({
    required String amount,
    required String currency,
  }) async {
    var url = Uri.parse(_paymentApiUrl);
    var response = await http.post(
      url,
      body: {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card',
      },
      headers: StripeHelper.headers,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return {};
  }
}
