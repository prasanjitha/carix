import 'package:flutter/services.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  static const separator = ',';

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    if (oldValue.text.length > newValue.text.length &&
        oldValue.text.endsWith(separator)) {
      final String textWithoutComma = newValue.text.replaceAll(separator, '');
      final int value = int.tryParse(textWithoutComma) ?? 0;
      final newString = formatString(value.toString());
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(offset: newString.length),
      );
    }

    if (newValue.text.endsWith('.')) {
      return newValue;
    }

    String text = newValue.text.replaceAll(separator, '');

    if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(text)) {
      return oldValue;
    }

    try {
      final List<String> parts = text.split('.');
      final String mainPart = parts[0];

      String formatted = formatString(mainPart);

      if (parts.length > 1) {
        formatted += '.${parts[1]}';
      }

      return TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    } catch (e) {
      return oldValue;
    }
  }

  static String formatString(String s) {
    if (s.isEmpty) return '';

    // Split decimal
    final parts = s.split('.');
    String mainPart = parts[0];

    StringBuffer buffer = StringBuffer();
    int count = 0;
    for (int i = mainPart.length - 1; i >= 0; i--) {
      buffer.write(mainPart[i]);
      count++;
      count++; // wait, why twice? Ah no, just one count++.
      if (count % 3 == 0 && i != 0) {
        buffer.write(separator);
      }
    }
    // Fixed the double count++ above in thought, I'll write correctly.
    return _formatBufferString(mainPart);
  }

  static String _formatBufferString(String mainPart) {
    StringBuffer buffer = StringBuffer();
    int count = 0;
    for (int i = mainPart.length - 1; i >= 0; i--) {
      buffer.write(mainPart[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        buffer.write(separator);
      }
    }
    return buffer.toString().split('').reversed.join('');
  }

  static String formatWithDecimals(String s) {
    if (s.isEmpty) return '';
    final parts = s.split('.');
    String formatted = _formatBufferString(parts[0]);
    if (parts.length > 1) {
      formatted += '.${parts[1]}';
    }
    return formatted;
  }
}
