// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:validator_dart/extensions/list_extensions.dart';
import 'package:validator_dart/validator_dart.dart';
import 'package:test/test.dart';

void validatorTest(options) {
  List<dynamic> args = (options['args'] as List? ?? []).map((e) => e).toList();

  args.insert(0, null);

  options['expect'].keys.forEach((dynamic input) {
    args[0] = input.toString();
    dynamic result = callMethod(options['sanitizer'], args);
    dynamic expected = options['expect'][input];

    // identical is used for double.nan values
    if (result != expected && !identical(result, expected)) {
      String warning =
          'validator.${options['sanitizer']}(${args.join(', ')}) returned "${result}" but should have returned "${expected}"';
      throw Exception(warning);
    }
  });
}

dynamic callMethod(option, List args) {
  if (option == 'toBoolean') {
    return Validator.toBoolean(str: args.get(0), strict: args.get(1));
  } else if (option == 'ltrim') {
    return Validator.ltrim(str: args.get(0), chars: args.get(1));
  } else if (option == 'rtrim') {
    return Validator.rtrim(str: args.get(0), chars: args.get(1));
  } else if (option == 'trim') {
    return Validator.trim(str: args.get(0), chars: args.get(1));
  } else if (option == 'toInt') {
    return Validator.toInt(str: args.get(0), radix: args.get(1));
  } else if (option == 'toFloat') {
    return Validator.toFloat(str: args.get(0));
  } else if (option == 'escape') {
    return Validator.escape(str: args.get(0));
  }

  return null;
}

void main() {
  group('Sanitizers', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('should sanitize boolean strings', () {
      validatorTest({
        'sanitizer': 'toBoolean',
        'expect': {
          0: false,
          '': false,
          1: true,
          true: true,
          'True': true,
          'TRUE': true,
          'foobar': true,
          '   ': true,
          false: false,
          'False': false,
          'FALSE': false,
        },
      });
      validatorTest({
        'sanitizer': 'toBoolean',
        'args': [true], // strict
        'expect': {
          0: false,
          '': false,
          1: true,
          true: true,
          'True': true,
          'TRUE': true,
          'foobar': false,
          '   ': false,
          false: false,
          'False': false,
          'FALSE': false,
        },
      });
    });

    test('should trim whitespace', () {
      validatorTest({
        'sanitizer': 'trim',
        'expect': {
          '  \r\n\tfoo  \r\n\t   ': 'foo',
          '      \r': '',
        },
      });

      validatorTest({
        'sanitizer': 'ltrim',
        'expect': {
          '  \r\n\tfoo  \r\n\t   ': 'foo  \r\n\t   ',
          '   \t  \n': '',
        },
      });

      validatorTest({
        'sanitizer': 'rtrim',
        'expect': {
          '  \r\n\tfoo  \r\n\t   ': '  \r\n\tfoo',
          ' \r\n  \t': '',
        },
      });
    });

    test('should trim custom characters', () {
      validatorTest({
        'sanitizer': 'trim',
        'args': ['01'],
        'expect': {'010100201000': '2'},
      });

      validatorTest({
        'sanitizer': 'ltrim',
        'args': ['01'],
        'expect': {'010100201000': '201000'},
      });

      validatorTest({
        'sanitizer': 'ltrim',
        'args': ['\\S'],
        'expect': {'\\S01010020100001': '01010020100001'},
      });

      validatorTest({
        'sanitizer': 'rtrim',
        'args': ['01'],
        'expect': {'010100201000': '0101002'},
      });

      validatorTest({
        'sanitizer': 'rtrim',
        'args': ['\\S'],
        'expect': {'01010020100001\\S': '01010020100001'},
      });
    });

    test('should convert strings to integers', () {
      validatorTest({
        'sanitizer': 'toInt',
        'expect': {
          3: 3,
          ' 3 ': 3,
          2.4: 2,
          // cannot return NaN like in JS version because NaN is double
          'foo': null,
        },
      });

      validatorTest({
        'sanitizer': 'toInt',
        'args': [16],
        'expect': {'ff': 255},
      });
    });

    test('should convert strings to floats', () {
      validatorTest({
        'sanitizer': 'toFloat',
        'expect': {
          2: 2,
          '2.': 2,
          '-2.5': -2.5,
          '.5': 0.5,
          '2020-01-06T14:31:00.135Z': double.nan,
          'foo': double.nan,
        },
      });
    });

    test('should escape HTML', () {
      validatorTest({
        'sanitizer': 'escape',
        'expect': {
          '<script> alert("xss&fun"); </script>':
              '&lt;script&gt; alert(&quot;xss&amp;fun&quot;); &lt;&#x2F;script&gt;',
          "<script> alert('xss&fun'); </script>":
              '&lt;script&gt; alert(&#x27;xss&amp;fun&#x27;); &lt;&#x2F;script&gt;',
          'Backtick: `': 'Backtick: &#96;',
          'Backslash: \\': 'Backslash: &#x5C;',
        },
      });
    });
  });
}
