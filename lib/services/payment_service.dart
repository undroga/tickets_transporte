enum PaymentMethod { MPesa, Card, BankTransfer }

class PaymentResult {
  final bool success;
  final String message;
  final String? transactionId;

  PaymentResult({
    required this.success,
    required this.message,
    this.transactionId,
  });
}

class PaymentService {
  Future<PaymentResult> processPayment({
    required PaymentMethod method,
    required double amount,
    required String userId,
    Map<String, dynamic>? additionalData,
  }) async {
    // Simulando atraso da rede e processamento
    await Future.delayed(Duration(seconds: 3));

    // Simular resultado de pagamento com 90% de chance de sucesso
    bool isSuccessful = (DateTime.now().millisecondsSinceEpoch % 10) < 9;

    if (isSuccessful) {
      return PaymentResult(
        success: true,
        message: 'Pagamento processado com sucesso',
        transactionId: 'TRX-${DateTime.now().millisecondsSinceEpoch}',
      );
    } else {
      return PaymentResult(
        success: false,
        message:
            'Falha no processamento do pagamento. Por favor, tente novamente.',
      );
    }
  }

  String getPaymentMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.MPesa:
        return 'M-Pesa';
      case PaymentMethod.Card:
        return 'Cartão de Crédito/Débito';
      case PaymentMethod.BankTransfer:
        return 'Transferência Bancária';
      default:
        return 'Desconhecido';
    }
  }
}
