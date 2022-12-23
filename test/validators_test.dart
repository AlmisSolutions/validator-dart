import 'package:validator_dart/extensions/list_extensions.dart';
import 'package:validator_dart/src/validators/is_alpha.dart';
import 'package:validator_dart/src/validators/is_alphanumeric.dart';
import 'package:validator_dart/src/validators/is_byte_length.dart';
import 'package:validator_dart/src/validators/is_email.dart';
import 'package:validator_dart/src/validators/is_fqdn.dart';
import 'package:validator_dart/src/validators/is_mac_address.dart';
import 'package:validator_dart/src/validators/is_url.dart';
import 'package:validator_dart/validator_dart.dart';
import 'package:test/test.dart';

void validatorTest(Map<String, dynamic> options) {
  List<dynamic> args = (options['args'] as List? ?? []).map((e) => e).toList();

  args.insert(0, null);

  if (options['error'] != null) {
    options['error'].forEach((error) {
      args[0] = error;
      try {
        callMethod(options['validator'], args);
        String warning =
            'validator.${options['validator']}(${args.join(', ')}) passed but should error';
        throw Exception(warning);
      } on Exception catch (err) {
        if (err.toString().contains('passed but should error')) {
          rethrow;
        }
      }
    });
  }
  if (options['valid'] != null) {
    options['valid'].forEach((valid) {
      args[0] = valid;
      if (callMethod(options['validator'], args) != true) {
        String warning =
            'validator.${options['validator']}(${args.join(', ')}) failed but should have passed';
        throw Exception(warning);
      }
    });
  }
  if (options['invalid'] != null) {
    options['invalid'].forEach((invalid) {
      args[0] = invalid;
      if (callMethod(options['validator'], args) != false) {
        String warning =
            'validator.${options['validator']}(${args.join(', ')}) passed but should have failed';
        throw Exception(warning);
      }
    });
  }
}

dynamic callMethod(option, List args) {
  if (option == 'isEmail') {
    return Validator.isEmail(args.get(0), options: args.get(1));
  } else if (option == 'isURL') {
    return Validator.isURL(args.get(0), options: args.get(1));
  } else if (option == 'isMACAddress') {
    return Validator.isMACAddress(args.get(0), options: args.get(1));
  } else if (option == 'isIP') {
    return Validator.isIP(args.get(0), version: args.get(1));
  } else if (option == 'isIPRange') {
    return Validator.isIPRange(args.get(0), version: args.get(1));
  } else if (option == 'isFQDN') {
    return Validator.isFQDN(args.get(0), options: args.get(1));
  } else if (option == 'isAlpha') {
    return Validator.isAlpha(args.get(0),
        locale: args.get(1), options: args.get(2));
  } else if (option == 'isAlphanumeric') {
    return Validator.isAlphanumeric(args.get(0),
        locale: args.get(1), options: args.get(2));
  } else if (option == 'isByteLength') {
    return Validator.isByteLength(args.get(0), options: args.get(1));
  } else if (option == 'isUppercase') {
    return Validator.isUppercase(args.get(0));
  }

  return null;
}

String repeat(String str, int count) {
  String result = '';
  for (; count > 0; count--) {
    result += str;
  }
  return result;
}

void main() {
  test('should validate email addresses', () {
    validatorTest({
      'validator': 'isEmail',
      'valid': [
        'foo@bar.com',
        'x@x.au',
        'foo@bar.com.au',
        'foo+bar@bar.com',
        'hans.m端ller@test.com',
        'hans@m端ller.com',
        'test|123@m端ller.com',
        'test123+ext@gmail.com',
        'some.name.midd.leNa.me.and.locality+extension@GoogleMail.com',
        '"foobar"@example.com',
        '"  foo  m端ller "@example.com',
        '"foo\\@bar"@example.com',
        '${repeat('a', 64)}@${repeat('a', 63)}.com',
        '${repeat('a', 64)}@${repeat('a', 63)}.com',
        '${repeat('a', 31)}@gmail.com',
        'test@gmail.com',
        'test.1@gmail.com',
        'test@1337.com',
      ],
      'invalid': [
        'invalidemail@',
        'invalid.com',
        '@invalid.com',
        'foo@bar.com.',
        'somename@ｇｍａｉｌ.com',
        'foo@bar.co.uk.',
        'z@co.c',
        'ｇｍａｉｌｇｍａｉｌｇｍａｉｌｇｍａｉｌｇｍａｉｌ@gmail.com',
        '${repeat('a', 64)}@${repeat('a', 251)}.com',
        '${repeat('a', 65)}@${repeat('a', 250)}.com',
        '${repeat('a', 64)}@${repeat('a', 64)}.com',
        '${repeat('a', 64)}@${repeat('a', 63)}.${repeat('a', 63)}.${repeat('a', 63)}.${repeat('a', 58)}.com',
        'test1@invalid.co m',
        'test2@invalid.co m',
        'test3@invalid.co m',
        'test4@invalid.co m',
        'test5@invalid.co m',
        'test6@invalid.co m',
        'test7@invalid.co m',
        'test8@invalid.co m',
        'test9@invalid.co m',
        'test10@invalid.co m',
        'test11@invalid.co m',
        'test12@invalid.co　m',
        'test13@invalid.co　m',
        'multiple..dots@stillinvalid.com',
        'test123+invalid! sub_address@gmail.com',
        'gmail...ignores...dots...@gmail.com',
        'ends.with.dot.@gmail.com',
        'multiple..dots@gmail.com',
        'wrong()[]",:;<>@@gmail.com',
        '"wrong()[]",:;<>@@gmail.com',
        'username@domain.com�',
        'username@domain.com©',
      ],
    });
  });

  test('should validate email addresses with domain specific validation', () {
    validatorTest({
      'validator': 'isEmail',
      'args': [
        EmailOptions(
          domainSpecificValidation: true,
        )
      ],
      'valid': [
        'foobar@gmail.com',
        'foo.bar@gmail.com',
        'foo.bar@googlemail.com',
        '${repeat('a', 30)}@gmail.com',
      ],
      'invalid': [
        '${repeat('a', 31)}@gmail.com',
        'test@gmail.com',
        'test.1@gmail.com',
        '.foobar@gmail.com',
      ],
    });
  });

  test('should validate email addresses without UTF8 characters in local part',
      () {
    validatorTest({
      'validator': 'isEmail',
      'args': [
        EmailOptions(
          allowUtf8LocalPart: false,
        )
      ],
      'valid': [
        'foo@bar.com',
        'x@x.au',
        'foo@bar.com.au',
        'foo+bar@bar.com',
        'hans@m端ller.com',
        'test|123@m端ller.com',
        'test123+ext@gmail.com',
        'some.name.midd.leNa.me+extension@GoogleMail.com',
        '"foobar"@example.com',
        '"foo\\@bar"@example.com',
        '"  foo  bar  "@example.com',
      ],
      'invalid': [
        'invalidemail@',
        'invalid.com',
        '@invalid.com',
        'foo@bar.com.',
        'foo@bar.co.uk.',
        'somename@ｇｍａｉｌ.com',
        'hans.m端ller@test.com',
        'z@co.c',
        'tüst@invalid.com',
      ],
    });
  });

  test('should validate email addresses with display names', () {
    validatorTest({
      'validator': 'isEmail',
      'args': [
        EmailOptions(
          allowDisplayName: true,
        )
      ],
      'valid': [
        'foo@bar.com',
        'x@x.au',
        'foo@bar.com.au',
        'foo+bar@bar.com',
        'hans.m端ller@test.com',
        'hans@m端ller.com',
        'test|123@m端ller.com',
        'test123+ext@gmail.com',
        'some.name.midd.leNa.me+extension@GoogleMail.com',
        'Some Name <foo@bar.com>',
        'Some Name <x@x.au>',
        'Some Name <foo@bar.com.au>',
        'Some Name <foo+bar@bar.com>',
        'Some Name <hans.m端ller@test.com>',
        'Some Name <hans@m端ller.com>',
        'Some Name <test|123@m端ller.com>',
        'Some Name <test123+ext@gmail.com>',
        '\'Foo Bar, Esq\'<foo@bar.com>',
        'Some Name <some.name.midd.leNa.me+extension@GoogleMail.com>',
        'Some Middle Name <some.name.midd.leNa.me+extension@GoogleMail.com>',
        'Name <some.name.midd.leNa.me+extension@GoogleMail.com>',
        'Name<some.name.midd.leNa.me+extension@GoogleMail.com>',
        'Some Name <foo@gmail.com>',
        'Name🍓With🍑Emoji🚴‍♀️🏆<test@aftership.com>',
        '🍇🍗🍑<only_emoji@aftership.com>',
        '"<displayNameInBrackets>"<jh@gmail.com>',
        '"\\"quotes\\""<jh@gmail.com>',
        '"name;"<jh@gmail.com>',
        '"name;" <jh@gmail.com>',
      ],
      'invalid': [
        'invalidemail@',
        'invalid.com',
        '@invalid.com',
        'foo@bar.com.',
        'foo@bar.co.uk.',
        'Some Name <invalidemail@>',
        'Some Name <invalid.com>',
        'Some Name <@invalid.com>',
        'Some Name <foo@bar.com.>',
        'Some Name <foo@bar.co.uk.>',
        'Some Name foo@bar.co.uk.>',
        'Some Name <foo@bar.co.uk.',
        'Some Name < foo@bar.co.uk >',
        'Name foo@bar.co.uk',
        'Some Name <some..name@gmail.com>',
        'Some Name<emoji_in_address🍈@aftership.com>',
        'invisibleCharacter\u001F<jh@gmail.com>',
        '<displayNameInBrackets><jh@gmail.com>',
        '\\"quotes\\"<jh@gmail.com>',
        '""quotes""<jh@gmail.com>',
        'name;<jh@gmail.com>',
        '    <jh@gmail.com>',
        '"    "<jh@gmail.com>',
      ],
    });
  });

  test('should validate email addresses with required display names', () {
    validatorTest({
      'validator': 'isEmail',
      'args': [
        EmailOptions(
          requireDisplayName: true,
        )
      ],
      'valid': [
        'Some Name <foo@bar.com>',
        'Some Name <x@x.au>',
        'Some Name <foo@bar.com.au>',
        'Some Name <foo+bar@bar.com>',
        'Some Name <hans.m端ller@test.com>',
        'Some Name <hans@m端ller.com>',
        'Some Name <test|123@m端ller.com>',
        'Some Name <test123+ext@gmail.com>',
        'Some Name <some.name.midd.leNa.me+extension@GoogleMail.com>',
        'Some Middle Name <some.name.midd.leNa.me+extension@GoogleMail.com>',
        'Name <some.name.midd.leNa.me+extension@GoogleMail.com>',
        'Name<some.name.midd.leNa.me+extension@GoogleMail.com>',
      ],
      'invalid': [
        'some.name.midd.leNa.me+extension@GoogleMail.com',
        'foo@bar.com',
        'x@x.au',
        'foo@bar.com.au',
        'foo+bar@bar.com',
        'hans.m端ller@test.com',
        'hans@m端ller.com',
        'test|123@m端ller.com',
        'test123+ext@gmail.com',
        'invalidemail@',
        'invalid.com',
        '@invalid.com',
        'foo@bar.com.',
        'foo@bar.co.uk.',
        'Some Name <invalidemail@>',
        'Some Name <invalid.com>',
        'Some Name <@invalid.com>',
        'Some Name <foo@bar.com.>',
        'Some Name <foo@bar.co.uk.>',
        'Some Name foo@bar.co.uk.>',
        'Some Name <foo@bar.co.uk.',
        'Some Name < foo@bar.co.uk >',
        'Name foo@bar.co.uk',
      ],
    });
  });

  test('should validate email addresses with allowed IPs', () {
    validatorTest({
      'validator': 'isEmail',
      'args': [
        EmailOptions(
          allowIpDomain: true,
        )
      ],
      'valid': [
        'email@[123.123.123.123]',
        'email@255.255.255.255',
      ],
      'invalid': [
        'email@0.0.0.256',
        'email@26.0.0.256',
        'email@[266.266.266.266]',
      ],
    });
  });

  test('should not validate email addresses with blacklisted chars in the name',
      () {
    validatorTest({
      'validator': 'isEmail',
      'args': [
        EmailOptions(
          blacklistedChars: 'abc',
        )
      ],
      'valid': [
        'emil@gmail.com',
      ],
      'invalid': [
        'email@gmail.com',
      ],
    });
  });

  test('should validate really long emails if ignore_max_length is set', () {
    validatorTest({
      'validator': 'isEmail',
      'args': [
        EmailOptions(
          ignoreMaxLength: false,
        )
      ],
      'valid': [],
      'invalid': [
        'Deleted-user-id-19430-Team-5051deleted-user-id-19430-team-5051XXXXXX@example.com',
      ],
    });

    validatorTest({
      'validator': 'isEmail',
      'args': [
        EmailOptions(
          ignoreMaxLength: true,
        )
      ],
      'valid': [
        'Deleted-user-id-19430-Team-5051deleted-user-id-19430-team-5051XXXXXX@example.com',
      ],
      'invalid': [],
    });
  });

  test('should not validate email addresses with denylisted domains', () {
    validatorTest({
      'validator': 'isEmail',
      'args': [
        EmailOptions(
          hostBlacklist: ['gmail.com', 'foo.bar.com'],
        )
      ],
      'valid': [
        'email@foo.gmail.com',
      ],
      'invalid': [
        'foo+bar@gmail.com',
        'email@foo.bar.com',
      ],
    });
  });

  test('should validate only email addresses with whitelisted domains', () {
    validatorTest({
      'validator': 'isEmail',
      'args': [
        EmailOptions(
          hostWhitelist: ['gmail.com', 'foo.bar.com'],
        )
      ],
      'valid': [
        'email@gmail.com',
        'test@foo.bar.com',
      ],
      'invalid': [
        'foo+bar@test.com',
        'email@foo.com',
        'email@bar.com',
      ],
    });
  });

  test('should validate URLs', () {
    validatorTest({
      'validator': 'isURL',
      'valid': [
        'foobar.com',
        'www.foobar.com',
        'foobar.com/',
        'valid.au',
        'http://www.foobar.com/',
        'HTTP://WWW.FOOBAR.COM/',
        'https://www.foobar.com/',
        'HTTPS://WWW.FOOBAR.COM/',
        'http://www.foobar.com:23/',
        'http://www.foobar.com:65535/',
        'http://www.foobar.com:5/',
        'https://www.foobar.com/',
        'ftp://www.foobar.com/',
        'http://www.foobar.com/~foobar',
        'http://user:pass@www.foobar.com/',
        'http://user:@www.foobar.com/',
        'http://:pass@www.foobar.com/',
        'http://user@www.foobar.com',
        'http://127.0.0.1/',
        'http://10.0.0.0/',
        'http://189.123.14.13/',
        'http://duckduckgo.com/?q=%2F',
        'http://foobar.com/t\$-_.+!*\'(),',
        'http://foobar.com/?foo=bar#baz=qux',
        'http://foobar.com?foo=bar',
        'http://foobar.com#baz=qux',
        'http://www.xn--froschgrn-x9a.net/',
        'http://xn--froschgrn-x9a.com/',
        'http://foo--bar.com',
        'http://høyfjellet.no',
        'http://xn--j1aac5a4g.xn--j1amh',
        'http://xn------eddceddeftq7bvv7c4ke4c.xn--p1ai',
        'http://кулік.укр',
        'test.com?ref=http://test2.com',
        'http://[FEDC:BA98:7654:3210:FEDC:BA98:7654:3210]:80/index.html',
        'http://[1080:0:0:0:8:800:200C:417A]/index.html',
        'http://[3ffe:2a00:100:7031::1]',
        'http://[1080::8:800:200C:417A]/foo',
        'http://[::192.9.5.5]/ipng',
        'http://[::FFFF:129.144.52.38]:80/index.html',
        'http://[2010:836B:4179::836B:4179]',
        'http://example.com/example.json#/foo/bar',
        'http://1337.com',
      ],
      'invalid': [
        'http://localhost:3000/',
        '//foobar.com',
        'xyz://foobar.com',
        'invalid/',
        'invalid.x',
        'invalid.',
        '.com',
        'http://com/',
        'http://300.0.0.1/',
        'mailto:foo@bar.com',
        'rtmp://foobar.com',
        'http://www.xn--.com/',
        'http://xn--.com/',
        'http://www.foobar.com:0/',
        'http://www.foobar.com:70000/',
        'http://www.foobar.com:99999/',
        'http://www.-foobar.com/',
        'http://www.foobar-.com/',
        'http://foobar/# lol',
        'http://foobar/? lol',
        'http://foobar/ lol/',
        'http://lol @foobar.com/',
        'http://lol:lol @foobar.com/',
        'http://lol:lol:lol@foobar.com/',
        'http://lol: @foobar.com/',
        'http://www.foo_bar.com/',
        'http://www.foobar.com/\t',
        'http://@foobar.com',
        'http://:@foobar.com',
        'http://\n@www.foobar.com/',
        '',
        'http://foobar.com/${List.filled(2083, 'f').join()}',
        'http://*.foo.com',
        '*.foo.com',
        '!.foo.com',
        'http://example.com.',
        'http://localhost:61500this is an invalid url!!!!',
        '////foobar.com',
        'http:////foobar.com',
        'https://example.com/foo/<script>alert(\'XSS\')</script>/',
      ],
    });
  });

  test('should validate URLs with custom protocols', () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          protocols: ['rtmp'],
        )
      ],
      'valid': [
        'rtmp://foobar.com',
      ],
      'invalid': [
        'http://foobar.com',
      ],
    });
  });

  test('should validate file URLs without a host', () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          protocols: ['file'],
          requireHost: false,
          requireTld: false,
        )
      ],
      'valid': [
        'file://localhost/foo.txt',
        'file:///foo.txt',
        'file:///',
      ],
      'invalid': [
        'http://foobar.com',
        'file://',
      ],
    });
  });

  test('should validate postgres URLs without a host', () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          protocols: ['postgres'],
          requireHost: false,
        )
      ],
      'valid': [
        'postgres://user:pw@/test',
      ],
      'invalid': [
        'http://foobar.com',
        'postgres://',
      ],
    });
  });

  test('should validate URLs with any protocol', () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          requireValidProtocol: false,
        )
      ],
      'valid': [
        'rtmp://foobar.com',
        'http://foobar.com',
        'test://foobar.com',
      ],
      'invalid': [
        'mailto:test@example.com',
      ],
    });
  });

  test('should validate URLs with underscores', () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          allowUnderscores: true,
        )
      ],
      'valid': [
        'http://foo_bar.com',
        'http://pr.example_com.294.example.com/',
        'http://foo__bar.com',
        'http://_.example.com',
      ],
      'invalid': [],
    });
  });

  test('should validate URLs that do not have a TLD', () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          requireTld: false,
        )
      ],
      'valid': [
        'http://foobar.com/',
        'http://foobar/',
        'http://localhost/',
        'foobar/',
        'foobar',
      ],
      'invalid': [],
    });
  });

  test('should validate URLs with a trailing dot option', () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          allowTrailingDot: true,
          requireTld: false,
        )
      ],
      'valid': [
        'http://example.com.',
        'foobar.',
      ],
    });
  });

  test('should validate URLs with column and no port', () {
    validatorTest({
      'validator': 'isURL',
      'valid': [
        'http://example.com:',
        'ftp://example.com:',
      ],
      'invalid': [
        'https://example.com:abc',
      ],
    });
  });

  test('should validate sftp protocol URL containing column and no port', () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(protocols: ['sftp'])
      ],
      'valid': [
        'sftp://user:pass@terminal.aws.test.nl:/incoming/things.csv',
      ],
    });
  });

  test('should validate protocol relative URLs', () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          allowProtocolRelativeUrls: true,
        )
      ],
      'valid': [
        '//foobar.com',
        'http://foobar.com',
        'foobar.com',
      ],
      'invalid': [
        '://foobar.com',
        '/foobar.com',
        '////foobar.com',
        'http:////foobar.com',
      ],
    });
  });

  test('should not validate URLs with fragments when allow fragments is false',
      () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          allowFragments: false,
        )
      ],
      'valid': [
        'http://foobar.com',
        'foobar.com',
      ],
      'invalid': [
        'http://foobar.com#part',
        'foobar.com#part',
      ],
    });
  });

  test(
      'should not validate URLs with query components when allow query components is false',
      () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          allowQueryComponents: false,
        )
      ],
      'valid': [
        'http://foobar.com',
        'foobar.com',
      ],
      'invalid': [
        'http://foobar.com?foo=bar',
        'http://foobar.com?foo=bar&bar=foo',
        'foobar.com?foo=bar',
        'foobar.com?foo=bar&bar=foo',
      ],
    });
  });

  test(
      'should not validate protocol relative URLs when require protocol is true',
      () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          allowProtocolRelativeUrls: true,
          requireProtocol: true,
        )
      ],
      'valid': [
        'http://foobar.com',
      ],
      'invalid': [
        '//foobar.com',
        '://foobar.com',
        '/foobar.com',
        'foobar.com',
      ],
    });
  });

  test('should let users specify whether URLs require a protocol', () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          requireProtocol: true,
        )
      ],
      'valid': [
        'http://foobar.com/',
      ],
      'invalid': [
        'http://localhost/',
        'foobar.com',
        'foobar',
      ],
    });
  });

  test('should let users specify a host whitelist', () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          hostWhitelist: ['foo.com', 'bar.com'],
        )
      ],
      'valid': [
        'http://bar.com/',
        'http://foo.com/',
      ],
      'invalid': [
        'http://foobar.com',
        'http://foo.bar.com/',
        'http://qux.com',
      ],
    });
  });

  test('should allow regular expressions in the host whitelist', () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          hostWhitelist: ['bar.com', 'foo.com', RegExp(r'\.foo\.com$')],
        )
      ],
      'valid': [
        'http://bar.com/',
        'http://foo.com/',
        'http://images.foo.com/',
        'http://cdn.foo.com/',
        'http://a.b.c.foo.com/',
      ],
      'invalid': [
        'http://foobar.com',
        'http://foo.bar.com/',
        'http://qux.com',
      ],
    });
  });

  test('should let users specify a host blacklist', () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          hostBlacklist: ['foo.com', 'bar.com'],
        )
      ],
      'valid': [
        'http://foobar.com',
        'http://foo.bar.com/',
        'http://qux.com',
      ],
      'invalid': [
        'http://bar.com/',
        'http://foo.com/',
      ],
    });
  });

  test('should allow regular expressions in the host blacklist', () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          hostBlacklist: ['foo.com', 'bar.com', RegExp(r'\.foo\.com$')],
        )
      ],
      'valid': [
        'http://foobar.com',
        'http://foo.bar.com/',
        'http://qux.com',
      ],
      'invalid': [
        'http://bar.com/',
        'http://foo.com/',
        'http://images.foo.com/',
        'http://cdn.foo.com/',
        'http://a.b.c.foo.com/',
      ],
    });
  });

  test('should allow rejecting urls containing authentication information', () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          disallowAuth: true,
        )
      ],
      'valid': [
        'doe.com',
      ],
      'invalid': [
        'john@doe.com',
        'john:john@doe.com',
      ],
    });
  });

  test('should accept urls containing authentication information', () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          disallowAuth: false,
        )
      ],
      'valid': [
        'user@example.com',
        'user:@example.com',
        'user:password@example.com',
      ],
      'invalid': [
        'user:user:password@example.com',
        '@example.com',
        ':@example.com',
        ':example.com',
      ],
    });
  });

  test('should allow user to skip URL length validation', () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          validateLength: false,
        )
      ],
      'valid': [
        'http://foobar.com/f',
        'http://foobar.com/${List.filled(2083, 'f').join()}',
      ],
      'invalid': [],
    });
  });

  test('should validate URLs with port present', () {
    validatorTest({
      'validator': 'isURL',
      'args': [
        UrlOptions(
          requirePort: true,
        )
      ],
      'valid': [
        'http://user:pass@www.foobar.com:1',
        'http://user:@www.foobar.com:65535',
        'http://127.0.0.1:23',
        'http://10.0.0.0:256',
        'http://189.123.14.13:256',
        'http://duckduckgo.com:65535?q=%2F',
      ],
      'invalid': [
        'http://user:pass@www.foobar.com/',
        'http://user:@www.foobar.com/',
        'http://127.0.0.1/',
        'http://10.0.0.0/',
        'http://189.123.14.13/',
        'http://duckduckgo.com/?q=%2F',
      ],
    });
  });

  test('should validate MAC addresses', () {
    validatorTest({
      'validator': 'isMACAddress',
      'valid': [
        'ab:ab:ab:ab:ab:ab',
        'FF:FF:FF:FF:FF:FF',
        '01:02:03:04:05:ab',
        '01:AB:03:04:05:06',
        'A9 C5 D4 9F EB D3',
        '01 02 03 04 05 ab',
        '01-02-03-04-05-ab',
        '0102.0304.05ab',
        'ab:ab:ab:ab:ab:ab:ab:ab',
        'FF:FF:FF:FF:FF:FF:FF:FF',
        '01:02:03:04:05:06:07:ab',
        '01:AB:03:04:05:06:07:08',
        'A9 C5 D4 9F EB D3 B6 65',
        '01 02 03 04 05 06 07 ab',
        '01-02-03-04-05-06-07-ab',
        '0102.0304.0506.07ab',
      ],
      'invalid': [
        'abc',
        '01:02:03:04:05',
        '01:02:03:04:05:z0',
        '01:02:03:04::ab',
        '1:2:3:4:5:6',
        'AB:CD:EF:GH:01:02',
        'A9C5 D4 9F EB D3',
        '01-02 03:04 05 ab',
        '0102.03:04.05ab',
        '900f/dffs/sdea',
        '01:02:03:04:05:06:07',
        '01:02:03:04:05:06:07:z0',
        '01:02:03:04:05:06::ab',
        '1:2:3:4:5:6:7:8',
        'AB:CD:EF:GH:01:02:03:04',
        'A9C5 D4 9F EB D3 B6 65',
        '01-02 03:04 05 06 07 ab',
        '0102.03:04.0506.07ab',
        '900f/dffs/sdea/54gh',
      ],
    });

    validatorTest({
      'validator': 'isMACAddress',
      'args': [
        MACAddressOptions(
          eui: '48',
        )
      ],
      'valid': [
        'ab:ab:ab:ab:ab:ab',
        'FF:FF:FF:FF:FF:FF',
        '01:02:03:04:05:ab',
        '01:AB:03:04:05:06',
        'A9 C5 D4 9F EB D3',
        '01 02 03 04 05 ab',
        '01-02-03-04-05-ab',
        '0102.0304.05ab',
      ],
      'invalid': [
        'ab:ab:ab:ab:ab:ab:ab:ab',
        'FF:FF:FF:FF:FF:FF:FF:FF',
        '01:02:03:04:05:06:07:ab',
        '01:AB:03:04:05:06:07:08',
        'A9 C5 D4 9F EB D3 B6 65',
        '01 02 03 04 05 06 07 ab',
        '01-02-03-04-05-06-07-ab',
        '0102.0304.0506.07ab',
      ],
    });
    validatorTest({
      'validator': 'isMACAddress',
      'args': [MACAddressOptions(eui: '64')],
      'valid': [
        'ab:ab:ab:ab:ab:ab:ab:ab',
        'FF:FF:FF:FF:FF:FF:FF:FF',
        '01:02:03:04:05:06:07:ab',
        '01:AB:03:04:05:06:07:08',
        'A9 C5 D4 9F EB D3 B6 65',
        '01 02 03 04 05 06 07 ab',
        '01-02-03-04-05-06-07-ab',
        '0102.0304.0506.07ab',
      ],
      'invalid': [
        'ab:ab:ab:ab:ab:ab',
        'FF:FF:FF:FF:FF:FF',
        '01:02:03:04:05:ab',
        '01:AB:03:04:05:06',
        'A9 C5 D4 9F EB D3',
        '01 02 03 04 05 ab',
        '01-02-03-04-05-ab',
        '0102.0304.05ab',
      ],
    });
  });

  test('should validate MAC addresses without separator', () {
    validatorTest({
      'validator': 'isMACAddress',
      'args': [
        MACAddressOptions(
          noSeparators: true,
        )
      ],
      'valid': [
        'abababababab',
        'FFFFFFFFFFFF',
        '0102030405ab',
        '01AB03040506',
        'abababababababab',
        'FFFFFFFFFFFFFFFF',
        '01020304050607ab',
        '01AB030405060708',
      ],
      'invalid': [
        'abc',
        '01:02:03:04:05',
        '01:02:03:04::ab',
        '1:2:3:4:5:6',
        'AB:CD:EF:GH:01:02',
        'ab:ab:ab:ab:ab:ab',
        'FF:FF:FF:FF:FF:FF',
        '01:02:03:04:05:ab',
        '01:AB:03:04:05:06',
        '0102030405',
        '01020304ab',
        '123456',
        'ABCDEFGH0102',
        '01:02:03:04:05:06:07',
        '01:02:03:04:05:06::ab',
        '1:2:3:4:5:6:7:8',
        'AB:CD:EF:GH:01:02:03:04',
        'ab:ab:ab:ab:ab:ab:ab:ab',
        'FF:FF:FF:FF:FF:FF:FF:FF',
        '01:02:03:04:05:06:07:ab',
        '01:AB:03:04:05:06:07:08',
        '01020304050607',
        '010203040506ab',
        '12345678',
        'ABCDEFGH01020304',
      ],
    });

    validatorTest({
      'validator': 'isMACAddress',
      'args': [
        MACAddressOptions(
          noSeparators: true,
          eui: '48',
        )
      ],
      'valid': [
        'abababababab',
        'FFFFFFFFFFFF',
        '0102030405ab',
        '01AB03040506',
      ],
      'invalid': [
        'abababababababab',
        'FFFFFFFFFFFFFFFF',
        '01020304050607ab',
        '01AB030405060708',
      ],
    });

    validatorTest({
      'validator': 'isMACAddress',
      'args': [
        MACAddressOptions(
          noSeparators: true,
          eui: '64',
        )
      ],
      'valid': [
        'abababababababab',
        'FFFFFFFFFFFFFFFF',
        '01020304050607ab',
        '01AB030405060708',
      ],
      'invalid': [
        'abababababab',
        'FFFFFFFFFFFF',
        '0102030405ab',
        '01AB03040506',
      ],
    });
  });

  test('should validate IP addresses', () {
    validatorTest({
      'validator': 'isIP',
      'valid': [
        '127.0.0.1',
        '0.0.0.0',
        '255.255.255.255',
        '1.2.3.4',
        '::1',
        '2001:db8:0000:1:1:1:1:1',
        '2001:db8:3:4::192.0.2.33',
        '2001:41d0:2:a141::1',
        '::ffff:127.0.0.1',
        '::0000',
        '0000::',
        '1::',
        '1111:1:1:1:1:1:1:1',
        'fe80::a6db:30ff:fe98:e946',
        '::',
        '::8',
        '::ffff:127.0.0.1',
        '::ffff:255.255.255.255',
        '::ffff:0:255.255.255.255',
        '::2:3:4:5:6:7:8',
        '::255.255.255.255',
        '0:0:0:0:0:ffff:127.0.0.1',
        '1:2:3:4:5:6:7::',
        '1:2:3:4:5:6::8',
        '1::7:8',
        '1:2:3:4:5::7:8',
        '1:2:3:4:5::8',
        '1::6:7:8',
        '1:2:3:4::6:7:8',
        '1:2:3:4::8',
        '1::5:6:7:8',
        '1:2:3::5:6:7:8',
        '1:2:3::8',
        '1::4:5:6:7:8',
        '1:2::4:5:6:7:8',
        '1:2::8',
        '1::3:4:5:6:7:8',
        '1::8',
        'fe80::7:8%eth0',
        'fe80::7:8%1',
        '64:ff9b::192.0.2.33',
        '0:0:0:0:0:0:10.0.0.1',
      ],
      'invalid': [
        'abc',
        '256.0.0.0',
        '0.0.0.256',
        '26.0.0.256',
        '0200.200.200.200',
        '200.0200.200.200',
        '200.200.0200.200',
        '200.200.200.0200',
        '::banana',
        'banana::',
        '::1banana',
        '::1::',
        '1:',
        ':1',
        ':1:1:1::2',
        '1:1:1:1:1:1:1:1:1:1:1:1:1:1:1:1',
        '::11111',
        '11111:1:1:1:1:1:1:1',
        '2001:db8:0000:1:1:1:1::1',
        '0:0:0:0:0:0:ffff:127.0.0.1',
        '0:0:0:0:ffff:127.0.0.1',
      ],
    });

    validatorTest({
      'validator': 'isIP',
      'args': [4],
      'valid': [
        '127.0.0.1',
        '0.0.0.0',
        '255.255.255.255',
        '1.2.3.4',
        '255.0.0.1',
        '0.0.1.1',
      ],
      'invalid': [
        '::1',
        '2001:db8:0000:1:1:1:1:1',
        '::ffff:127.0.0.1',
        '137.132.10.01',
        '0.256.0.256',
        '255.256.255.256',
      ],
    });

    validatorTest({
      'validator': 'isIP',
      'args': [6],
      'valid': [
        '::1',
        '2001:db8:0000:1:1:1:1:1',
        '::ffff:127.0.0.1',
        'fe80::1234%1',
        'ff08::9abc%10',
        'ff08::9abc%interface10',
        'ff02::5678%pvc1.3',
      ],
      'invalid': [
        '127.0.0.1',
        '0.0.0.0',
        '255.255.255.255',
        '1.2.3.4',
        '::ffff:287.0.0.1',
        '%',
        'fe80::1234%',
        'fe80::1234%1%3%4',
        'fe80%fe80%',
      ],
    });

    validatorTest({
      'validator': 'isIP',
      'args': [10],
      'valid': [],
      'invalid': [
        '127.0.0.1',
        '0.0.0.0',
        '255.255.255.255',
        '1.2.3.4',
        '::1',
        '2001:db8:0000:1:1:1:1:1',
      ],
    });
  });

  test('should validate isIPRange', () {
    validatorTest({
      'validator': 'isIPRange',
      'valid': [
        '127.0.0.1/24',
        '0.0.0.0/0',
        '255.255.255.0/32',
        '::/0',
        '::/128',
        '2001::/128',
        '2001:800::/128',
        '::ffff:127.0.0.1/128',
      ],
      'invalid': [
        'abc',
        '127.200.230.1/35',
        '127.200.230.1/-1',
        '1.1.1.1/011',
        '1.1.1/24.1',
        '1.1.1.1/01',
        '1.1.1.1/1.1',
        '1.1.1.1/1.',
        '1.1.1.1/1/1',
        '1.1.1.1',
        '::1',
        '::1/164',
        '2001::/240',
        '2001::/-1',
        '2001::/001',
        '2001::/24.1',
        '2001:db8:0000:1:1:1:1:1',
        '::ffff:127.0.0.1',
      ],
    });

    validatorTest({
      'validator': 'isIPRange',
      'args': [4],
      'valid': [
        '127.0.0.1/1',
        '0.0.0.0/1',
        '255.255.255.255/1',
        '1.2.3.4/1',
        '255.0.0.1/1',
        '0.0.1.1/1',
      ],
      'invalid': [
        'abc',
        '::1',
        '2001:db8:0000:1:1:1:1:1',
        '::ffff:127.0.0.1',
        '137.132.10.01',
        '0.256.0.256',
        '255.256.255.256',
      ],
    });
    validatorTest({
      'validator': 'isIPRange',
      'args': [6],
      'valid': [
        '::1/1',
        '2001:db8:0000:1:1:1:1:1/1',
        '::ffff:127.0.0.1/1',
      ],
      'invalid': [
        'abc',
        '127.0.0.1',
        '0.0.0.0',
        '255.255.255.255',
        '1.2.3.4',
        '::ffff:287.0.0.1',
        '::ffff:287.0.0.1/254',
        '%',
        'fe80::1234%',
        'fe80::1234%1%3%4',
        'fe80%fe80%',
      ],
    });

    validatorTest({
      'validator': 'isIPRange',
      'args': [10],
      'valid': [],
      'invalid': [
        'abc',
        '127.0.0.1/1',
        '0.0.0.0/1',
        '255.255.255.255/1',
        '1.2.3.4/1',
        '::1/1',
        '2001:db8:0000:1:1:1:1:1/1',
      ],
    });
  });

  test('should validate FQDN', () {
    validatorTest({
      'validator': 'isFQDN',
      'valid': [
        'domain.com',
        'dom.plato',
        'a.domain.co',
        'foo--bar.com',
        'xn--froschgrn-x9a.com',
        'rebecca.blackfriday',
        '1337.com',
      ],
      'invalid': [
        'abc',
        '256.0.0.0',
        '_.com',
        '*.some.com',
        's!ome.com',
        'domain.com/',
        '/more.com',
        'domain.com�',
        'domain.co\u00A0m',
        'domain.co\u1680m',
        'domain.co\u2006m',
        'domain.co\u2028m',
        'domain.co\u2029m',
        'domain.co\u202Fm',
        'domain.co\u205Fm',
        'domain.co\u3000m',
        'domain.com\uDC00',
        'domain.co\uEFFFm',
        'domain.co\uFDDAm',
        'domain.co\uFFF4m',
        'domain.com©',
        'example.0',
        '192.168.0.9999',
        '192.168.0',
      ],
    });
  });

  test('should validate FQDN with trailing dot option', () {
    validatorTest({
      'validator': 'isFQDN',
      'args': [
        FqdnOptions(
          allowTrailingDot: true,
        )
      ],
      'valid': [
        'example.com.',
      ],
    });
  });

  test('should invalidate FQDN when not require_tld', () {
    validatorTest({
      'validator': 'isFQDN',
      'args': [
        FqdnOptions(
          requireTld: true,
        )
      ],
      'invalid': [
        'example.0',
        '192.168.0',
        '192.168.0.9999',
      ],
    });
  });

  test('should validate FQDN when not require_tld but allow_numeric_tld', () {
    validatorTest({
      'validator': 'isFQDN',
      'args': [
        FqdnOptions(
          allowNumericTld: true,
          requireTld: false,
        )
      ],
      'valid': [
        'example.0',
        '192.168.0',
        '192.168.0.9999',
      ],
    });
  });

  test('should validate FQDN with wildcard option', () {
    validatorTest({
      'validator': 'isFQDN',
      'args': [
        FqdnOptions(
          allowWildcard: true,
        )
      ],
      'valid': [
        '*.example.com',
        '*.shop.example.com',
      ],
    });
  });

  test(
      'should validate FQDN with required allow_trailing_dot, allow_underscores and allow_numeric_tld options',
      () {
    validatorTest({
      'validator': 'isFQDN',
      'args': [
        FqdnOptions(
          allowTrailingDot: true,
          allowUnderscores: true,
          allowNumericTld: true,
        ),
      ],
      'valid': [
        'abc.efg.g1h.',
        'as1s.sad3s.ssa2d.',
      ],
    });
  });

  test('should validate alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'valid': [
        'abc',
        'ABC',
        'FoObar',
      ],
      'invalid': [
        'abc1',
        '  foo  ',
        '',
        'ÄBC',
        'FÜübar',
        'Jön',
        'Heiß',
      ],
    });
  });

  test('should validate alpha string with ignored characters', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['en-US', AlphaOptions(ignore: '- /')], // ignore [space-/]
      'valid': [
        'en-US',
        'this is a valid alpha string',
        'us/usa',
      ],
      'invalid': [
        '1. this is not a valid alpha string',
        'this\$is also not a valid.alpha string',
        'this is also not a valid alpha string.',
      ],
    });

    validatorTest({
      'validator': 'isAlpha',
      'args': [
        'en-US',
        AlphaOptions(ignore: RegExp(r'[\s/-]'))
      ], // ignore [space -]
      'valid': [
        'en-US',
        'this is a valid alpha string',
      ],
      'invalid': [
        '1. this is not a valid alpha string',
        'this\$is also not a valid.alpha string',
        'this is also not a valid alpha string.',
      ],
    });

    validatorTest({
      'validator': 'isAlpha',
      'args': ['en-US', AlphaOptions(ignore: 1234)], // invalid ignore matcher
      'error': [
        'alpha',
      ],
    });
  });

  test('should validate Azerbaijani alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['az-AZ'],
      'valid': [
        'Azərbaycan',
        'Bakı',
        'üöğıəçş',
        'sizAzərbaycanlaşdırılmışlardansınızmı',
        'dahaBirDüzgünString',
        'abcçdeəfgğhxıijkqlmnoöprsştuüvyz',
      ],
      'invalid': [
        'rəqəm1',
        '  foo  ',
        '',
        'ab(cd)',
        'simvol@',
        'wəkil',
      ],
    });
  });

  test('should validate bulgarian alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['bg-BG'],
      'valid': [
        'абв',
        'АБВ',
        'жаба',
        'яГоДа',
      ],
      'invalid': [
        'abc1',
        '  foo  ',
        '',
        'ЁЧПС',
        '_аз_обичам_обувки_',
        'ехо!',
      ],
    });
  });

  test('should validate Bengali alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['bn-BD'],
      'valid': [
        'অয়াওর',
        'ফগফদ্রত',
        'ফদ্ম্যতভ',
        'বেরেওভচনভন',
        'আমারবাসগা',
      ],
      'invalid': [
        'দাস২৩৪',
        '  দ্গফহ্নভ  ',
        '',
        '(গফদ)',
      ],
    });
  });

  test('should validate czech alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['cs-CZ'],
      'valid': [
        'žluťoučký',
        'KŮŇ',
        'Pěl',
        'Ďábelské',
        'ódy',
      ],
      'invalid': [
        'ábc1',
        '  fůj  ',
        '',
      ],
    });
  });

  test('should validate slovak alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['sk-SK'],
      'valid': [
        'môj',
        'ľúbím',
        'mäkčeň',
        'stĹp',
        'vŕba',
        'ňorimberk',
        'ťava',
        'žanéta',
        'Ďábelské',
        'ódy',
      ],
      'invalid': [
        '1moj',
        '你好世界',
        '  Привет мир  ',
        'مرحبا العا ',
      ],
    });
  });

  test('should validate danish alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['da-DK'],
      'valid': [
        'aøå',
        'Ære',
        'Øre',
        'Åre',
      ],
      'invalid': [
        'äbc123',
        'ÄBC11',
        '',
      ],
    });
  });

  test('should validate dutch alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['nl-NL'],
      'valid': [
        'Kán',
        'één',
        'vóór',
        'nú',
        'héél',
      ],
      'invalid': [
        'äca ',
        'abcß',
        'Øre',
      ],
    });
  });

  test('should validate german alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['de-DE'],
      'valid': [
        'äbc',
        'ÄBC',
        'FöÖbär',
        'Heiß',
      ],
      'invalid': [
        'äbc1',
        '  föö  ',
        '',
      ],
    });
  });

  test('should validate hungarian alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['hu-HU'],
      'valid': [
        'árvíztűrőtükörfúrógép',
        'ÁRVÍZTŰRŐTÜKÖRFÚRÓGÉP',
      ],
      'invalid': [
        'äbc1',
        '  fäö  ',
        'Heiß',
        '',
      ],
    });
  });

  test('should validate portuguese alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['pt-PT'],
      'valid': [
        'palíndromo',
        'órgão',
        'qwértyúão',
        'àäãcëüïÄÏÜ',
      ],
      'invalid': [
        '12abc',
        'Heiß',
        'Øre',
        'æøå',
        '',
      ],
    });
  });

  test('should validate italian alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['it-IT'],
      'valid': [
        'àéèìîóòù',
        'correnti',
        'DEFINIZIONE',
        'compilazione',
        'metró',
        'pèsca',
        'PÉSCA',
        'genî',
      ],
      'invalid': [
        'äbc123',
        'ÄBC11',
        'æøå',
        '',
      ],
    });
  });

  test('should validate Japanese alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['ja-JP'],
      'valid': [
        'あいうえお',
        'がぎぐげご',
        'ぁぃぅぇぉ',
        'アイウエオ',
        'ァィゥェ',
        'ｱｲｳｴｵ',
        '吾輩は猫である',
        '臥薪嘗胆',
        '新世紀エヴァンゲリオン',
        '天国と地獄',
        '七人の侍',
        'シン・ウルトラマン',
      ],
      'invalid': [
        'あいう123',
        'abcあいう',
        '１９８４',
      ],
    });
  });

  test('should validate Vietnamese alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['vi-VN'],
      'valid': [
        'thiến',
        'nghiêng',
        'xin',
        'chào',
        'thế',
        'giới',
      ],
      'invalid': [
        'thầy3',
        'Ba gà',
        '',
      ],
    });
  });

  test('should validate arabic alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['ar'],
      'valid': [
        'أبت',
        'اَبِتَثّجً',
      ],
      'invalid': [
        '١٢٣أبت',
        '١٢٣',
        'abc1',
        '  foo  ',
        '',
        'ÄBC',
        'FÜübar',
        'Jön',
        'Heiß',
      ],
    });
  });

  test('should validate farsi alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['fa-IR'],
      'valid': [
        'پدر',
        'مادر',
        'برادر',
        'خواهر',
      ],
      'invalid': [
        'فارسی۱۲۳',
        '۱۶۴',
        'abc1',
        '  foo  ',
        '',
        'ÄBC',
        'FÜübar',
        'Jön',
        'Heiß',
      ],
    });
  });

  test('should validate finnish alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['fi-FI'],
      'valid': [
        'äiti',
        'Öljy',
        'Åke',
        'testÖ',
      ],
      'invalid': [
        'AİıÖöÇçŞşĞğÜüZ',
        'äöå123',
        '',
      ],
    });
  });

  test('should validate kurdish alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['ku-IQ'],
      'valid': [
        'ئؤڤگێ',
        'کوردستان',
      ],
      'invalid': [
        'ئؤڤگێ١٢٣',
        '١٢٣',
        'abc1',
        '  foo  ',
        '',
        'ÄBC',
        'FÜübar',
        'Jön',
        'Heiß',
      ],
    });
  });

  test('should validate norwegian alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['nb-NO'],
      'valid': [
        'aøå',
        'Ære',
        'Øre',
        'Åre',
      ],
      'invalid': [
        'äbc123',
        'ÄBC11',
        '',
      ],
    });
  });

  test('should validate polish alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['pl-PL'],
      'valid': [
        'kreską',
        'zamknięte',
        'zwykłe',
        'kropką',
        'przyjęły',
        'święty',
        'Pozwól',
      ],
      'invalid': [
        '12řiď ',
        'blé!!',
        'föö!2!',
      ],
    });
  });

  test('should validate serbian cyrillic alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['sr-RS'],
      'valid': [
        'ШћжЂљЕ',
        'ЧПСТЋЏ',
      ],
      'invalid': [
        'řiď ',
        'blé33!!',
        'föö!!',
      ],
    });
  });

  test('should validate serbian latin alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['sr-RS@latin'],
      'valid': [
        'ŠAabčšđćž',
        'ŠATROĆčđš',
      ],
      'invalid': [
        '12řiď ',
        'blé!!',
        'föö!2!',
      ],
    });
  });

  test('should validate spanish alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['es-ES'],
      'valid': [
        'ábcó',
        'ÁBCÓ',
        'dormís',
        'volvés',
        'español',
      ],
      'invalid': [
        'äca ',
        'abcß',
        'föö!!',
      ],
    });
  });

  test('should validate swedish alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['sv-SE'],
      'valid': [
        'religiös',
        'stjäla',
        'västgöte',
        'Åre',
      ],
      'invalid': [
        'AİıÖöÇçŞşĞğÜüZ',
        'religiös23',
        '',
      ],
    });
  });

  test('should validate defined arabic locales alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['ar-SY'],
      'valid': [
        'أبت',
        'اَبِتَثّجً',
      ],
      'invalid': [
        '١٢٣أبت',
        '١٢٣',
        'abc1',
        '  foo  ',
        '',
        'ÄBC',
        'FÜübar',
        'Jön',
        'Heiß',
      ],
    });
  });

  test('should validate turkish alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['tr-TR'],
      'valid': [
        'AİıÖöÇçŞşĞğÜüZ',
      ],
      'invalid': [
        '0AİıÖöÇçŞşĞğÜüZ1',
        '  AİıÖöÇçŞşĞğÜüZ  ',
        'abc1',
        '  foo  ',
        '',
        'ÄBC',
        'Heiß',
      ],
    });
  });

  test('should validate urkrainian alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['uk-UA'],
      'valid': [
        'АБВГҐДЕЄЖЗИIЇЙКЛМНОПРСТУФХЦШЩЬЮЯ',
      ],
      'invalid': [
        '0AİıÖöÇçŞşĞğÜüZ1',
        '  AİıÖöÇçŞşĞğÜüZ  ',
        'abc1',
        '  foo  ',
        '',
        'ÄBC',
        'Heiß',
        'ЫыЪъЭэ',
      ],
    });
  });

  test('should validate greek alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['el-GR'],
      'valid': [
        'αβγδεζηθικλμνξοπρςστυφχψω',
        'ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ',
        'άέήίΰϊϋόύώ',
        'ΆΈΉΊΪΫΎΏ',
      ],
      'invalid': [
        '0AİıÖöÇçŞşĞğÜüZ1',
        '  AİıÖöÇçŞşĞğÜüZ  ',
        'ÄBC',
        'Heiß',
        'ЫыЪъЭэ',
        '120',
        'jαckγ',
      ],
    });
  });

  test('should validate Hebrew alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['he'],
      'valid': [
        'בדיקה',
        'שלום',
      ],
      'invalid': [
        'בדיקה123',
        '  foo  ',
        'abc1',
        '',
      ],
    });
  });

  test('should validate Hindi alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['hi-IN'],
      'valid': [
        'अतअपनाअपनीअपनेअभीअंदरआदिआपइत्यादिइनइनकाइन्हींइन्हेंइन्होंइसइसकाइसकीइसकेइसमेंइसीइसेउनउनकाउनकीउनकेउनकोउन्हींउन्हेंउन्होंउसउसकेउसीउसेएकएवंएसऐसेऔरकईकरकरताकरतेकरनाकरनेकरेंकहतेकहाकाकाफ़ीकिकितनाकिन्हेंकिन्होंकियाकिरकिसकिसीकिसेकीकुछकुलकेकोकोईकौनकौनसागयाघरजबजहाँजाजितनाजिनजिन्हेंजिन्होंजिसजिसेजीधरजैसाजैसेजोतकतबतरहतिनतिन्हेंतिन्होंतिसतिसेतोथाथीथेदबारादियादुसरादूसरेदोद्वाराननकेनहींनानिहायतनीचेनेपरपहलेपूरापेफिरबनीबहीबहुतबादबालाबिलकुलभीभीतरमगरमानोमेमेंयदियहयहाँयहीयायिहयेरखेंरहारहेऱ्वासालिएलियेलेकिनववग़ैरहवर्गवहवहाँवहींवालेवुहवेवोसकतासकतेसबसेसभीसाथसाबुतसाभसारासेसोसंगहीहुआहुईहुएहैहैंहोहोताहोतीहोतेहोनाहोने',
        'इन्हें',
      ],
      'invalid': [
        'अत०२३४५६७८९',
        'अत 12',
        ' अत ',
        'abc1',
        'abc',
        '',
      ],
    });
  });

  test('should validate persian alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['fa-IR'],
      'valid': [
        'تست',
        'عزیزم',
        'ح',
      ],
      'invalid': [
        'تست 1',
        '  عزیزم  ',
        '',
      ],
    });
  });

  test('should validate Thai alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['th-TH'],
      'valid': [
        'สวัสดี',
        'ยินดีต้อนรับ เทสเคส',
      ],
      'invalid': [
        'สวัสดีHi',
        '123 ยินดีต้อนรับ',
        'ยินดีต้อนรับ-๑๒๓',
      ],
    });
  });

  test('should validate Korea alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['ko-KR'],
      'valid': [
        'ㄱ',
        'ㅑ',
        'ㄱㄴㄷㅏㅕ',
        '세종대왕',
        '나랏말싸미듕귁에달아문자와로서르사맛디아니할쎄',
      ],
      'invalid': [
        'abc',
        '123',
        '흥선대원군 문호개방',
        '1592년임진왜란',
        '대한민국!',
      ],
    });
  });

  test('should validate Sinhala alpha strings', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['si-LK'],
      'valid': [
        'චතුර',
        'කචටදබ',
        'ඎඏදාෛපසුගො',
      ],
      'invalid': [
        'ஆஐअतක',
        'කචට 12',
        ' ඎ ',
        'abc1',
        'abc',
        '',
      ],
    });
  });

  test('should error on invalid locale', () {
    validatorTest({
      'validator': 'isAlpha',
      'args': ['is-NOT'],
      'error': [
        'abc',
        'ABC',
      ],
    });
  });

  test('should validate alphanumeric string with ignored characters', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': [
        'en-US',
        AlphanumericOptions(ignore: '@_- ')
      ], // ignore [@ space _ -]
      'valid': [
        'Hello@123',
        'this is a valid alphaNumeric string',
        'En-US @ alpha_numeric',
      ],
      'invalid': [
        'In*Valid',
        'hello\$123',
        '{invalid}',
      ],
    });

    validatorTest({
      'validator': 'isAlphanumeric',
      'args': [
        'en-US',
        AlphanumericOptions(ignore: RegExp(r'[\s/-]'))
      ], // ignore [space -]
      'valid': [
        'en-US',
        'this is a valid alphaNumeric string',
      ],
      'invalid': [
        'INVALID\$ AlphaNum Str',
        'hello@123',
        'abc*123',
      ],
    });

    validatorTest({
      'validator': 'isAlphanumeric',
      'args': [
        'en-US',
        AlphanumericOptions(ignore: 1234)
      ], // invalid ignore matcher (ignore should be instance of a String or RegExp)
      'error': [
        'alpha',
      ],
    });
  });

  test('should validate defined english aliases', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['en-GB'],
      'valid': [
        'abc123',
        'ABC11',
      ],
      'invalid': [
        'abc ',
        'foo!!',
        'ÄBC',
        'FÜübar',
        'Jön',
      ],
    });
  });

  test('should validate Azerbaijani alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['az-AZ'],
      'valid': [
        'Azərbaycan',
        'Bakı',
        'abc1',
        'abcç2',
        '3kərə4kərə',
      ],
      'invalid': [
        '  foo1  ',
        '',
        'ab(cd)',
        'simvol@',
        'wəkil',
      ],
    });
  });

  test('should validate bulgarian alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['bg-BG'],
      'valid': [
        'абв1',
        '4АБ5В6',
        'жаба',
        'яГоДа2',
        'йЮя',
        '123',
      ],
      'invalid': [
        ' ',
        '789  ',
        'hello000',
      ],
    });
  });

  test('should validate Bengali alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['bn-BD'],
      'valid': [
        'দ্গজ্ঞহ্রত্য১২৩',
        'দ্গগফ৮৯০',
        'চব৩৬৫ভবচ',
        '১২৩৪',
        '৩৪২৩৪দফজ্ঞদফ',
      ],
      'invalid': [
        ' ',
        '১২৩  ',
        'hel৩২0',
      ],
    });
  });

  test('should validate czech alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['cs-CZ'],
      'valid': [
        'řiť123',
        'KŮŇ11',
      ],
      'invalid': [
        'řiď ',
        'blé!!',
      ],
    });
  });

  test('should validate slovak alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['sk-SK'],
      'valid': [
        '1môj',
        '2ľúbím',
        '3mäkčeň',
        '4stĹp',
        '5vŕba',
        '6ňorimberk',
        '7ťava',
        '8žanéta',
        '9Ďábelské',
        '10ódy',
      ],
      'invalid': [
        '1moj!',
        '你好世界',
        '  Привет мир  ',
      ],
    });
  });

  test('should validate danish alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['da-DK'],
      'valid': [
        'ÆØÅ123',
        'Ære321',
        '321Øre',
        '123Åre',
      ],
      'invalid': [
        'äbc123',
        'ÄBC11',
        '',
      ],
    });
  });

  test('should validate dutch alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['nl-NL'],
      'valid': [
        'Kán123',
        'één354',
        'v4óór',
        'nú234',
        'hé54él',
      ],
      'invalid': [
        '1äca ',
        'ab3cß',
        'Øre',
      ],
    });
  });

  test('should validate finnish alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['fi-FI'],
      'valid': [
        'äiti124',
        'ÖLJY1234',
        '123Åke',
        '451åå23',
      ],
      'invalid': [
        'AİıÖöÇçŞşĞğÜüZ',
        'foo!!',
        '',
      ],
    });
  });

  test('should validate german alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['de-DE'],
      'valid': [
        'äbc123',
        'ÄBC11',
      ],
      'invalid': [
        'äca ',
        'föö!!',
      ],
    });
  });

  test('should validate hungarian alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['hu-HU'],
      'valid': [
        '0árvíztűrőtükörfúrógép123',
        '0ÁRVÍZTŰRŐTÜKÖRFÚRÓGÉP123',
      ],
      'invalid': [
        '1időúr!',
        'äbc1',
        '  fäö  ',
        'Heiß!',
        '',
      ],
    });
  });

  test('should validate portuguese alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['pt-PT'],
      'valid': [
        'palíndromo',
        '2órgão',
        'qwértyúão9',
        'àäãcë4üïÄÏÜ',
      ],
      'invalid': [
        '!abc',
        'Heiß',
        'Øre',
        'æøå',
        '',
      ],
    });
  });

  test('should validate italian alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['it-IT'],
      'valid': [
        '123àéèìîóòù',
        '123correnti',
        'DEFINIZIONE321',
        'compil123azione',
        'met23ró',
        'pès56ca',
        'PÉS45CA',
        'gen45î',
      ],
      'invalid': [
        'äbc123',
        'ÄBC11',
        'æøå',
        '',
      ],
    });
  });

  test('should validate spanish alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['es-ES'],
      'valid': [
        'ábcó123',
        'ÁBCÓ11',
      ],
      'invalid': [
        'äca ',
        'abcß',
        'föö!!',
      ],
    });
  });

  test('should validate Vietnamese alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['vi-VN'],
      'valid': [
        'Thầy3',
        '3Gà',
      ],
      'invalid': [
        'toang!',
        'Cậu Vàng',
      ],
    });
  });

  test('should validate arabic alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['ar'],
      'valid': [
        'أبت123',
        'أبتَُِ١٢٣',
      ],
      'invalid': [
        'äca ',
        'abcß',
        'föö!!',
      ],
    });
  });

  test('should validate Hindi alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['hi-IN'],
      'valid': [
        'अतअपनाअपनीअपनेअभीअंदरआदिआपइत्यादिइनइनकाइन्हींइन्हेंइन्होंइसइसकाइसकीइसकेइसमेंइसीइसेउनउनकाउनकीउनकेउनकोउन्हींउन्हेंउन्होंउसउसकेउसीउसेएकएवंएसऐसेऔरकईकरकरताकरतेकरनाकरनेकरेंकहतेकहाकाकाफ़ीकिकितनाकिन्हेंकिन्होंकियाकिरकिसकिसीकिसेकीकुछकुलकेकोकोईकौनकौनसागयाघरजबजहाँजाजितनाजिनजिन्हेंजिन्होंजिसजिसेजीधरजैसाजैसेजोतकतबतरहतिनतिन्हेंतिन्होंतिसतिसेतोथाथीथेदबारादियादुसरादूसरेदोद्वाराननकेनहींनानिहायतनीचेनेपरपहलेपूरापेफिरबनीबहीबहुतबादबालाबिलकुलभीभीतरमगरमानोमेमेंयदियहयहाँयहीयायिहयेरखेंरहारहेऱ्वासालिएलियेलेकिनववग़ैरहवर्गवहवहाँवहींवालेवुहवेवोसकतासकतेसबसेसभीसाथसाबुतसाभसारासेसोसंगहीहुआहुईहुएहैहैंहोहोताहोतीहोतेहोनाहोने०२३४५६७८९',
        'इन्हें४५६७८९',
      ],
      'invalid': [
        'अत ०२३४५६७८९',
        ' ३४५६७८९',
        '12 ',
        ' अत ',
        'abc1',
        'abc',
        '',
      ],
    });
  });

  test('should validate farsi alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['fa-IR'],
      'valid': [
        'پارسی۱۲۳',
        '۱۴۵۶',
        'مژگان9',
      ],
      'invalid': [
        'äca ',
        'abcßة',
        'föö!!',
        '٤٥٦',
      ],
    });
  });

  test('should validate Japanese alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['ja-JP'],
      'valid': [
        'あいうえお123',
        '123がぎぐげご',
        'ぁぃぅぇぉ',
        'アイウエオ',
        'ァィゥェ',
        'ｱｲｳｴｵ',
        '２０世紀少年',
        '華氏４５１度',
      ],
      'invalid': [
        ' あいう123 ',
        'abcあいう',
        '生きろ!!',
      ],
    });
  });

  test('should validate kurdish alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['ku-IQ'],
      'valid': [
        'ئؤڤگێ١٢٣',
      ],
      'invalid': [
        'äca ',
        'abcß',
        'föö!!',
      ],
    });
  });

  test('should validate defined arabic aliases', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['ar-SY'],
      'valid': [
        'أبت123',
        'أبتَُِ١٢٣',
      ],
      'invalid': [
        'abc ',
        'foo!!',
        'ÄBC',
        'FÜübar',
        'Jön',
      ],
    });
  });

  test('should validate norwegian alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['nb-NO'],
      'valid': [
        'ÆØÅ123',
        'Ære321',
        '321Øre',
        '123Åre',
      ],
      'invalid': [
        'äbc123',
        'ÄBC11',
        '',
      ],
    });
  });

  test('should validate polish alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['pl-PL'],
      'valid': [
        'kre123ską',
        'zam21knięte',
        'zw23ykłe',
        '123',
        'prz23yjęły',
        'świ23ęty',
        'Poz1322wól',
      ],
      'invalid': [
        '12řiď ',
        'blé!!',
        'föö!2!',
      ],
    });
  });

  test('should validate serbian cyrillic alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['sr-RS'],
      'valid': [
        'ШћжЂљЕ123',
        'ЧПСТ132ЋЏ',
      ],
      'invalid': [
        'řiď ',
        'blé!!',
        'föö!!',
      ],
    });
  });

  test('should validate serbian latin alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['sr-RS@latin'],
      'valid': [
        'ŠAabčšđćž123',
        'ŠATRO11Ćčđš',
      ],
      'invalid': [
        'řiď ',
        'blé!!',
        'föö!!',
      ],
    });
  });

  test('should validate swedish alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['sv-SE'],
      'valid': [
        'religiös13',
        'st23jäla',
        'västgöte123',
        '123Åre',
      ],
      'invalid': [
        'AİıÖöÇçŞşĞğÜüZ',
        'foo!!',
        '',
      ],
    });
  });

  test('should validate turkish alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['tr-TR'],
      'valid': [
        'AİıÖöÇçŞşĞğÜüZ123',
      ],
      'invalid': [
        'AİıÖöÇçŞşĞğÜüZ ',
        'foo!!',
        'ÄBC',
      ],
    });
  });

  test('should validate urkrainian alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['uk-UA'],
      'valid': [
        'АБВГҐДЕЄЖЗИIЇЙКЛМНОПРСТУФХЦШЩЬЮЯ123',
      ],
      'invalid': [
        'éeoc ',
        'foo!!',
        'ÄBC',
        'ЫыЪъЭэ',
      ],
    });
  });

  test('should validate greek alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['el-GR'],
      'valid': [
        'αβγδεζηθικλμνξοπρςστυφχψω',
        'ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩ',
        '20θ',
        '1234568960',
      ],
      'invalid': [
        '0AİıÖöÇçŞşĞğÜüZ1',
        '  AİıÖöÇçŞşĞğÜüZ  ',
        'ÄBC',
        'Heiß',
        'ЫыЪъЭэ',
        'jαckγ',
      ],
    });
  });

  test('should validate Hebrew alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['he'],
      'valid': [
        'אבג123',
        'שלום11',
      ],
      'invalid': [
        'אבג ',
        'לא!!',
        'abc',
        '  foo  ',
      ],
    });
  });

  test('should validate Thai alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['th-TH'],
      'valid': [
        'สวัสดี ๑๒๓',
        'ยินดีต้อนรับทั้ง ๒ คน',
      ],
      'invalid': [
        '1.สวัสดี',
        'ยินดีต้อนรับทั้ง 2 คน',
      ],
    });
  });

  test('should validate Korea alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['ko-KR'],
      'valid': [
        '2002',
        '훈민정음',
        '1446년훈민정음반포',
      ],
      'invalid': [
        '2022!',
        '2019 코로나시작',
        '1.로렘입숨',
      ],
    });
  });

  test('should validate Sinhala alphanumeric strings', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['si-LK'],
      'valid': [
        'චතුර',
        'කචට12',
        'ඎඏදාෛපසුගො2',
        '1234',
      ],
      'invalid': [
        'ஆஐअतක',
        'කචට 12',
        ' ඎ ',
        'a1234',
        'abc',
        '',
      ],
    });
  });

  test('should error on invalid locale', () {
    validatorTest({
      'validator': 'isAlphanumeric',
      'args': ['is-NOT'],
      'error': [
        '1234568960',
        'abc123',
      ],
    });
  });

  test('should validate strings by byte length (deprecated api)', () {
    validatorTest({
      'validator': 'isByteLength',
      'args': [ByteLengthOptions(min: 2)],
      'valid': ['abc', 'de', 'abcd', 'ｇｍａｉｌ'],
      'invalid': ['', 'a'],
    });
    validatorTest({
      'validator': 'isByteLength',
      'args': [ByteLengthOptions(min: 2, max: 3)],
      'valid': ['abc', 'de', 'ｇ'],
      'invalid': ['', 'a', 'abcd', 'ｇｍ'],
    });
    validatorTest({
      'validator': 'isByteLength',
      'args': [ByteLengthOptions(min: 0, max: 0)],
      'valid': [''],
      'invalid': ['ｇ', 'a'],
    });
  });

  test('should validate uppercase strings', () {
    validatorTest({
      'validator': 'isUppercase',
      'valid': [
        'ABC',
        'ABC123',
        'ALL CAPS IS FUN.',
        '   .',
      ],
      'invalid': [
        'fooBar',
        '123abc',
      ],
    });
  });
}
