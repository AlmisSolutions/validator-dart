import 'package:validator_dart/src/validators/is_int.dart';

final validators = {
  'PL': (String str) {
    final weightOfDigits = {
      1: 1,
      2: 3,
      3: 7,
      4: 9,
      5: 1,
      6: 3,
      7: 7,
      8: 9,
      9: 1,
      10: 3,
      11: 0,
    };
    if (str.length == 11 &&
        $isInt(str, options: IntOptions(allowLeadingZeroes: true))) {
      final digits = str.split('');
      digits.removeLast();
      var sum = 0;
      digits.asMap().forEach((index, digit) =>
          sum += (int.parse(digit) * (weightOfDigits[index + 1]!)));
      final modulo = sum % 10;
      final lastDigit = int.parse(str[str.length - 1]);
      if ((modulo == 0 && lastDigit == 0) || lastDigit == 10 - modulo) {
        return true;
      }
    }
    return false;
  },
  'ES': (String str) {
    final dni = RegExp(r'^[0-9X-Z][0-9]{7}[TRWAGMYFPDXBNJZSQVHLCKE]$');

    final charsValue = {
      'X': 0,
      'Y': 1,
      'Z': 2,
    };

    final controlDigits = [
      'T',
      'R',
      'W',
      'A',
      'G',
      'M',
      'Y',
      'F',
      'P',
      'D',
      'X',
      'B',
      'N',
      'J',
      'Z',
      'S',
      'Q',
      'V',
      'H',
      'L',
      'C',
      'K',
      'E',
    ];

    // sanitize user input
    final sanitized = str.trim().toUpperCase();

    // validate the data structure
    if (!dni.hasMatch(sanitized)) {
      return false;
    }

    // validate the control digit
    final number = sanitized
        .substring(0, sanitized.length - 1)
        .replaceAllMapped(RegExp(r'[X,Y,Z]'),
            (match) => charsValue[match.group(0)!].toString());

    return sanitized.endsWith(controlDigits[int.parse(number) % 23]);
  },
  'FI': (String str) {
    // https://dvv.fi/en/personal-identity-code#:~:text=control%20character%20for%20a-,personal,-identity%20code%20calculated

    if (str.length != 11) {
      return false;
    }

    if (!str.contains(
        RegExp(r'^\d{6}[\-A\+]\d{3}[0-9ABCDEFHJKLMNPRSTUVWXY]{1}$'))) {
      return false;
    }

    final checkDigits = '0123456789ABCDEFHJKLMNPRSTUVWXY';

    final idAsNumber = (int.parse(str.substring(0, 6)) * 1000) +
        int.parse(str.substring(7, 10));
    final remainder = idAsNumber % 31;
    final checkDigit = checkDigits[remainder];

    return checkDigit == str.substring(10, 11);
  },
  'IN': (String str) {
    final dni = RegExp(r'^[1-9]\d{3}\s?\d{4}\s?\d{4}$');

    // multiplication table
    const d = [
      [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
      [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
      [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
      [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
      [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
      [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
      [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
      [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
      [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
      [9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
    ];

    // permutation table
    const p = [
      [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
      [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
      [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
      [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
      [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
      [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
      [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
      [7, 0, 4, 6, 9, 1, 3, 2, 5, 8],
    ];

    final sanitized = str.trim();

    if (!dni.hasMatch(sanitized)) {
      return false;
    }

    int c = 0;
    final invertedArray = sanitized
        .replaceAll(RegExp(r'\s'), '')
        .split('')
        .map(int.parse)
        .toList()
        .reversed
        .toList();

    invertedArray.asMap().forEach((i, val) {
      c = d[c][p[(i % 8)][val]];
    });

    return c == 0;
  },
  'IR': (String str) {
    if (!RegExp(r'^\d{10}$').hasMatch(str)) return false;
    str = ('0000$str').substring(str.length - 6);

    if (int.parse(str.substring(3, 9)) == 0) return false;

    final lastNumber = int.parse(str.substring(9, 10));
    int sum = 0;

    for (int i = 0; i < 9; i++) {
      sum += int.parse(str.substring(i, i + 1)) * (10 - i);
    }

    sum %= 11;

    return (sum < 2 && lastNumber == sum) ||
        (sum >= 2 && lastNumber == 11 - sum);
  },
  'IT': (String str) {
    if (str.length != 9) return false;
    if (str == 'CA00000AA') {
      // https://it.wikipedia.org/wiki/Carta_d%27identit%C3%A0_elettronica_italiana
      return false;
    }
    return str.contains(RegExp(r'C[A-Z]\d{5}[A-Z]{2}', caseSensitive: false));
  },
  'NO': (String str) {
    final sanitized = str.trim();
    if (int.tryParse(sanitized) == null) return false;
    if (sanitized.length != 11) return false;
    if (sanitized == '00000000000') return false;

    final f = sanitized.split('').map(int.parse).toList();
    int k1 = (11 -
            (((3 * f[0]) +
                    (7 * f[1]) +
                    (6 * f[2]) +
                    (1 * f[3]) +
                    (8 * f[4]) +
                    (9 * f[5]) +
                    (4 * f[6]) +
                    (5 * f[7]) +
                    (2 * f[8])) %
                11)) %
        11;
    int k2 = (11 -
            (((5 * f[0]) +
                    (4 * f[1]) +
                    (3 * f[2]) +
                    (2 * f[3]) +
                    (7 * f[4]) +
                    (6 * f[5]) +
                    (5 * f[6]) +
                    (4 * f[7]) +
                    (3 * f[8]) +
                    (2 * k1)) %
                11)) %
        11;

    if (k1 != f[9] || k2 != f[10]) return false;
    return true;
  },
  'TH': (String str) {
    if (!RegExp(r'^[1-8]\d{12}$').hasMatch(str)) return false;

    // validate check digit
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      sum += int.parse(str[i]) * (13 - i);
    }
    return str[12] == ((11 - (sum % 11)) % 10).toString();
  },
  'LK': (String str) {
    final oldNic = RegExp(r'^[1-9]\d{8}[vx]$', caseSensitive: false);
    final newNic = RegExp(r'^[1-9]\d{11}$', caseSensitive: false);

    return (str.length == 10 && oldNic.hasMatch(str)) ||
        (str.length == 12 && newNic.hasMatch(str));
  },
  'he-IL': (String str) {
    final dni = RegExp(r'^\d{9}$');

    // sanitize user input
    final sanitized = str.trim();

    // validate the data structure
    if (!dni.hasMatch(sanitized)) {
      return false;
    }

    final id = sanitized;

    int sum = 0, incNum;
    for (int i = 0; i < id.length; i++) {
      incNum = int.parse(id[i]) * ((i % 2) + 1); // Multiply number by 1 or 2
      sum += incNum > 9
          ? incNum - 9
          : incNum; // Sum the digits up and add to total
    }
    return sum % 10 == 0;
  },
  'ar-LY': (String str) {
    // Libya National Identity Number NIN is 12 digits, the first digit is either 1 or 2
    final nin = RegExp(r'^(1|2)\d{11}$');

    // sanitize user input
    final sanitized = str.trim();

    // validate the data structure
    if (!nin.hasMatch(sanitized)) {
      return false;
    }
    return true;
  },
  'ar-TN': (String str) {
    final dni = RegExp(r'^\d{8}$');

    final sanitized = str.trim();

    if (!dni.hasMatch(sanitized)) {
      return false;
    }
    return true;
  },
  'zh-CN': (String str) {
    const provincesAndCities = [
      '11', // 北京
      '12', // 天津
      '13', // 河北
      '14', // 山西
      '15', // 内蒙古
      '21', // 辽宁
      '22', // 吉林
      '23', // 黑龙江
      '31', // 上海
      '32', // 江苏
      '33', // 浙江
      '34', // 安徽
      '35', // 福建
      '36', // 江西
      '37', // 山东
      '41', // 河南
      '42', // 湖北
      '43', // 湖南
      '44', // 广东
      '45', // 广西
      '46', // 海南
      '50', // 重庆
      '51', // 四川
      '52', // 贵州
      '53', // 云南
      '54', // 西藏
      '61', // 陕西
      '62', // 甘肃
      '63', // 青海
      '64', // 宁夏
      '65', // 新疆
      '71', // 台湾
      '81', // 香港
      '82', // 澳门
      '91', // 国外
    ];

    const powers = [
      '7',
      '9',
      '10',
      '5',
      '8',
      '4',
      '2',
      '1',
      '6',
      '3',
      '7',
      '9',
      '10',
      '5',
      '8',
      '4',
      '2'
    ];

    const parityBit = ['1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2'];

    bool checkAddressCode(String addressCode) {
      return provincesAndCities.contains(addressCode);
    }

    bool checkBirthDayCode(String birDayCode) {
      final yyyy = int.parse(birDayCode.substring(0, 4));
      final mm = int.parse(birDayCode.substring(4, 6));
      final dd = int.parse(birDayCode.substring(6));
      final xdata = DateTime(yyyy, mm, dd);
      if (xdata.isAfter(DateTime.now())) {
        return false;
      } else if (xdata.year == yyyy && xdata.month == mm && xdata.day == dd) {
        return true;
      }
      return false;
    }

    String getParityBit(String idCardNo) {
      String id17 = idCardNo.substring(0, 17);

      int power = 0;
      for (int i = 0; i < 17; i++) {
        power += int.parse(id17[i]) * int.parse(powers[i]);
      }

      int mod = power % 11;
      return parityBit[mod];
    }

    bool checkParityBit(String idCardNo) =>
        getParityBit(idCardNo) == idCardNo[17].toUpperCase();

    bool check15IdCardNo(String idCardNo) {
      bool check = RegExp(
              r'^[1-9]\d{7}((0[1-9])|(1[0-2]))((0[1-9])|([1-2][0-9])|(3[0-1]))\d{3}$')
          .hasMatch(idCardNo);
      if (!check) return false;
      String addressCode = idCardNo.substring(0, 2);
      check = checkAddressCode(addressCode);
      if (!check) return false;
      String birDayCode = '19${idCardNo.substring(6, 12)}';
      check = checkBirthDayCode(birDayCode);
      if (!check) return false;
      return true;
    }

    bool check18IdCardNo(String idCardNo) {
      bool check = RegExp(
              r'^[1-9]\d{5}[1-9]\d{3}((0[1-9])|(1[0-2]))((0[1-9])|([1-2][0-9])|(3[0-1]))\d{3}(\d|x|X)$')
          .hasMatch(idCardNo);
      if (!check) return false;
      String addressCode = idCardNo.substring(0, 2);
      check = checkAddressCode(addressCode);
      if (!check) return false;
      String birDayCode = idCardNo.substring(6, 14);
      check = checkBirthDayCode(birDayCode);
      if (!check) return false;
      return checkParityBit(idCardNo);
    }

    bool checkIdCardNo(String str) {
      final check = RegExp(r'^\d{15}|(\d{17}(\d|x|X))$').hasMatch(str);
      if (!check) return false;
      if (str.length == 15) {
        return check15IdCardNo(str);
      }
      return check18IdCardNo(str);
    }

    return checkIdCardNo(str);
  },
  'zh-TW': (String str) {
    const alphabetCodes = {
      'A': 10,
      'B': 11,
      'C': 12,
      'D': 13,
      'E': 14,
      'F': 15,
      'G': 16,
      'H': 17,
      'I': 34,
      'J': 18,
      'K': 19,
      'L': 20,
      'M': 21,
      'N': 22,
      'O': 35,
      'P': 23,
      'Q': 24,
      'R': 25,
      'S': 26,
      'T': 27,
      'U': 28,
      'V': 29,
      'W': 32,
      'X': 30,
      'Y': 31,
      'Z': 33,
    };
    final sanitized = str.trim().toUpperCase();

    if (!RegExp(r'^[A-Z][0-9]{9}$').hasMatch(sanitized)) return false;

    int sum = 0;
    for (int i = 0; i < sanitized.length; i++) {
      final number = sanitized[i];
      if (i == 0) {
        final code = alphabetCodes[number];
        sum = ((code! % 10) * 9) + (code ~/ 10);
        continue;
      }

      if (i == 9) {
        return ((10 - (sum % 10)) - int.parse(number)) % 10 == 0;
      }

      sum += int.parse(number) * (9 - i);
    }

    return false;
  },
};

bool $isIdentityCard(String str, String locale) {
  if (validators.containsKey(locale)) {
    return validators[locale]?.call(str) ?? false;
  } else if (locale == 'any') {
    for (final key in validators.keys) {
      final validator = validators[key];
      if (validator?.call(str) ?? false) {
        return true;
      }
    }
    return false;
  }
  throw Exception('Invalid locale $locale');
}
