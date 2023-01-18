class PaymentCard {
  String cardNumber;
  String expiryDate;
  String cardHolderName;
  String cvvCode;
  bool showBackView;

  PaymentCard({
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
    this.showBackView = false,
  });
}
