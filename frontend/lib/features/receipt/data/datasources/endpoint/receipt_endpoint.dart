class ReceiptEndpoint {
  ReceiptEndpoint._();

  /// `POST`: a receipt's OCR text to a draft. Rate-limited per user.
  static const parse = '/ai/parse-receipt';
}
