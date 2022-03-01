import 'package:flutter_test/flutter_test.dart';
import 'package:blog_app/models/User.dart';

void main() {
  group('fromJson', () {
    test(
      'GIVEN a valid user json '
      'WHEN a json deserialization is performed'
      'THEN a user model is output',
      () {
        //given
        final data = {
          'userId': '1',
          'name': 'ABC-1/BLOCK TEST',
          'token': '03001234567',
          'verified': true,
        };

        //when
        final actual = User.fromJson(data);
        var matcher = User(
          userId: '1',
          name: 'Test1',
          token: 'test1.user@gmail.com',
          verified: false,
        );

        //then
        expect(actual, matcher);
      },
    );
  });

  group('UserAsString', () {
    test(
      'GIVEN a user model with user id '
      'WHEN a user is sent '
      'THEN a user string is a result',
      () {
        //given
        var user = User(
          userId: '1',
          name: 'toJson',
          token: '22',
          verified: true,
        );

        //when
        final actual = user.userAsString();
        final matcher = "#1 toJson";

        //then
        expect(actual, matcher);
      },
    );
  });

  group('Equality', () {
    test(
      'GIVEN two user models '
      'WHEN properties are different '
      'THEN equality returns false',
      () {
        //given
        var user1 = User(
          userId: '1',
          name: 'Test1',
          token: 'test1.user@gmail.com',
          verified: false,
        );

        //when
        var user2 = User(
          userId: '2',
          name: 'Test2',
          token: 'test2.user@gmail.com',
          verified: false,
        );

        //then
        expect(user1 == user2, false);
      },
    );

    test(
      'GIVEN two user models '
      'WHEN properties are same '
      'THEN equality returns true',
      () {
        //given
        var user1 = User(
          userId: '1',
          name: 'Test1',
          token: 'test1.user@gmail.com',
          verified: false,
        );

        //when
        var user2 = User(
          userId: '1',
          name: 'Test1',
          token: 'test1.user@gmail.com',
          verified: false,
        );

        //then
        expect(user1 == user2, true);
      },
    );
  });
}
