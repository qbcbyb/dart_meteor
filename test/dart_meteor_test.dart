import 'dart:async';

import 'package:dart_meteor/dart_meteor.dart';
import 'package:test/test.dart';

void main() {
  group('MeteorClient', () {
    MeteorClient meteor;

    setUp(() async {
      meteor = MeteorClient.connect(url: 'ws://localhost:3000');
      await Future.delayed(Duration(seconds: 2));
    });

    tearDown(() {
      meteor.disconnect();
    });

    test('meteor.isClient()', () {
      expect(meteor.isClient(), isTrue);
    });

    test('meteor.isServer()', () {
      expect(meteor.isServer(), isFalse);
    });

    test('meteor.isCordova()', () {
      expect(meteor.isCordova(), isFalse);
    });

    test('meteor.loginWithPassword(), correct username & password', () async {
      var loginResult = await meteor.loginWithPassword('user1', 'password1');
      expect(loginResult.userId, isNotNull);
      expect(loginResult.userId.length, greaterThan(0));
    });

    test('meteor.loginWithPassword(), wrong username & password', () async {
      try {
        await meteor.loginWithPassword('user1x', 'password1x');
      } catch (err) {
        expect(err, isA<MeteorError>());
      }
    });

    test('meteor.user()', () async {
      String userId;
      var completer = Completer();
      meteor.user().listen((user) {
        print(user);
        expect(user['_id'], equals(userId));
        expect(user['username'], equals('user1'));
        expect(user['profile']['name'], equals('John'));
        expect(user['profile']['surname'], equals('Doe'));
        completer.complete(user);
      });

      var loginResult = await meteor.loginWithPassword('user1', 'password1');
      expect(loginResult.userId, isNotNull);
      expect(loginResult.userId.length, greaterThan(0));
      userId = loginResult.userId;

      expect(completer.future, completes);
    });

    test('meteor.userId()', () async {
      var loginResult = await meteor.loginWithPassword('user1', 'password1');
      expect(loginResult.userId, isNotNull);
      expect(loginResult.userId.length, greaterThan(0));
      var _userId = loginResult.userId;

      var completer = Completer();
      meteor.userId().listen((userId) {
        expect(userId, equals(_userId));
        completer.complete(userId);
      });

      expect(completer.future, completes);
    });

    test('call sum', () async {
      var result = await meteor.call('sum', [1, 2]);
      expect(result, 3);
    });

    test('call auth sum', () async {
      try {
        await meteor.call('authSum', [1, 2]);
      } catch (err) {
        expect(err, isNotNull);
        expect(err, isA<MeteorError>());
      }
    });
  });
}
