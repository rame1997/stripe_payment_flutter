import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_payment/stripe_payment.dart';

import '../models/payment_card.dart';
import '../stripe/stripe_service.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({Key? key}) : super(key: key);

  @override
  _CardsScreenState createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  List<PaymentCard> paymentCards = [
    PaymentCard(
      cardNumber: '4242424242424242',
      expiryDate: '04/24',
      cardHolderName: 'Client 1',
      cvvCode: '424',
    ),
    PaymentCard(
      cardNumber: '4000000000009995',
      expiryDate: '03/25',
      cardHolderName: 'Client 2',
      cvvCode: '234',
    ),
    PaymentCard(
      cardNumber: '3400000000009995',
      expiryDate: '03/25',
      cardHolderName: 'Client 2',
      cvvCode: '234',
    ),   PaymentCard(
      cardNumber: '5500000000009995',
      expiryDate: '03/25',
      cardHolderName: 'Client 2',
      cvvCode: '234',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cards')),
      body: ListView.builder(
        itemCount: paymentCards.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () async => await payViaCard(paymentCard: paymentCards[index]),
            child: CreditCardWidget(
              cardNumber: paymentCards[index].cardNumber,
              expiryDate: paymentCards[index].expiryDate,
              cardHolderName: paymentCards[index].cardHolderName,
              cvvCode: paymentCards[index].cvvCode,
              showBackView: paymentCards[index].showBackView,
              onCreditCardWidgetChange: (p0) {},
            ),
          );
        },
      ),
    );
  }

  Future<void> payViaCard({required PaymentCard paymentCard}) async {
    var response = await StripeService.payViaCard(
        amount: '1000',
        currency: 'usd',
        creditCard: getCreditCard(paymentCard));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        backgroundColor: response.success ? Colors.green : Colors.red,
        duration: Duration(seconds: 2),
      ),
    ).closed.then((value) {
      if(response.success) Navigator.pop(context);
    });
  }

  CreditCard getCreditCard(PaymentCard paymentCard) {
    CreditCard creditCard = CreditCard();
    creditCard.number = paymentCard.cardNumber;
    creditCard.cvc = paymentCard.cvvCode;
    creditCard.name = paymentCard.cardHolderName;
    creditCard.expMonth = int.parse(
        paymentCard.expiryDate.split('/')[0]); //04/24 => [04,24] => index 0,1
    creditCard.expYear = int.parse(paymentCard.expiryDate.split('/')[1]);
    return creditCard;
  }
}
