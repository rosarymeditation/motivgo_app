class MessageBlockResult {
  final bool isBlocked;
  final String? reason;

  MessageBlockResult({required this.isBlocked, this.reason});
}

class SensitiveContentFilter {
  static final Map<String, RegExp> _patterns = {
    'Phone Number': RegExp(
        r'(?<!\d)(?:\+?(\d{1,4}))?[-.\s]?(\(?\d{1,4}\)?)[-.\s]?\d{1,4}[-.\s]?\d{1,9}(?!\d)'),
    'Email Address':
        RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b'),
    'URL': RegExp(r'\b((https?:\/\/)|(www\.))[\w\-]+\.[\w\-]+([\/\w\.-]*)*\b'),
    'Domain': RegExp(r'\b[a-zA-Z0-9\-]+\.(com|net|org|edu|gov|info|biz)\b'),
    'IP Address': RegExp(r'\b(?:\d{1,3}\.){3}\d{1,3}\b'),
    'Social Handle': RegExp(r'@[\w_]{2,20}'),
    'Messaging Link':
        RegExp(r'\b(t\.me|wa\.me|telegram\.me|chat\.whatsapp|joinchat)\b'),
  };

  static final Map<String, String> _numberWords = {
    'zero': '0',
    'one': '1',
    'two': '2',
    'three': '3',
    'four': '4',
    'five': '5',
    'six': '6',
    'seven': '7',
    'eight': '8',
    'nine': '9',
    'ten': '10',
    'eleven': '11',
    'twelve': '12',
    'thirteen': '13',
    'fourteen': '14',
    'fifteen': '15',
    'sixteen': '16',
    'seventeen': '17',
    'eighteen': '18',
    'nineteen': '19',
    'twenty': '20',
    'oh': '0',
    'o': '0',
    'double': '', // handled specially
  };

  static List<String> findViolations(
    String message, {
    required bool isPremium,
    required bool hasBothMessaged,
  }) {
    final violations = <String>[];

    for (var entry in _patterns.entries) {
      final type = entry.key;
      final pattern = entry.value;

      if (type == 'Phone Number' && isPremium && hasBothMessaged) {
        continue;
      }

      if (pattern.hasMatch(message)) {
        violations.add(type);
      }
    }

    final digitized = convertWordsToDigits(message);
    final phonePattern = _patterns['Phone Number']!;
    if (phonePattern.hasMatch(digitized)) {
      if (!(isPremium && hasBothMessaged)) {
        violations.add('Spelled-out Phone Number');
      }
    }

    return violations.toSet().toList(); // unique list
  }

  static bool containsSensitiveContent(
    String message, {
    required bool isPremium,
    required bool hasBothMessaged,
  }) {
    return findViolations(
      message,
      isPremium: isPremium,
      hasBothMessaged: hasBothMessaged,
    ).isNotEmpty;
  }

  static String sanitize(
    String message, {
    required bool isPremium,
    required bool hasBothMessaged,
  }) {
    String cleaned = message;

    for (var entry in _patterns.entries) {
      if (entry.key == 'Phone Number' && isPremium && hasBothMessaged) {
        continue;
      }
      cleaned = cleaned.replaceAll(entry.value, '[removed]');
    }

    if (!(isPremium && hasBothMessaged)) {
      cleaned = cleaned.replaceAllMapped(
        RegExp(r'\b(' + _numberWords.keys.join('|') + r')\b',
            caseSensitive: false),
        (match) => '[removed]',
      );
    }

    return cleaned;
  }

  static String convertWordsToDigits(String input) {
    final words = input.toLowerCase().split(RegExp(r'[\s\-_,.]+'));
    final buffer = StringBuffer();

    for (int i = 0; i < words.length; i++) {
      final word = words[i];

      if (word == 'double' && i + 1 < words.length) {
        final next = _numberWords[words[i + 1]];
        if (next != null) {
          buffer.write('$next$next');
          i++; // skip next word
          continue;
        }
      }

      final digit = _numberWords[word];
      if (digit != null) {
        buffer.write(digit);
      }
    }

    return buffer.toString();
  }

  /// Main helper for validation with message
  static MessageBlockResult checkMessageBlocked(
    String message, {
    required bool isPremium,
    required bool hasBothMessaged,
  }) {
    final violations = findViolations(
      message,
      isPremium: isPremium,
      hasBothMessaged: hasBothMessaged,
    );

    if (violations.isEmpty) {
      return MessageBlockResult(isBlocked: false);
    }

    final isPhoneViolation = violations
        .any((v) => v == 'Phone Number' || v == 'Spelled-out Phone Number');

    if (isPhoneViolation) {
      if (!isPremium) {
        return MessageBlockResult(
          isBlocked: true,
          reason:
              "🔒 Sharing phone numbers is a premium feature. Upgrade to premium to unlock this option.",
        );
      } else if (!hasBothMessaged) {
        return MessageBlockResult(
          isBlocked: true,
          reason:
              "⚠️ You're a premium member, but you can only share your phone number after the other user has responded. Try sending a message first and wait for a reply.",
        );
      }
    }

    return MessageBlockResult(
      isBlocked: true,
      reason: "❌ Message blocked. Contains: ${violations.join(', ')}.",
    );
  }
}
