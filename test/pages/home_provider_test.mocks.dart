// Mocks generated by Mockito 5.3.2 from annotations
// in dicoding_flutter_fundamental/test/pages/home_provider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dicoding_flutter_fundamental/model/restaurant.dart' as _i5;
import 'package:dicoding_flutter_fundamental/model/restaurant_detail.dart'
    as _i2;
import 'package:dicoding_flutter_fundamental/service/restaurant_service.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeRestaurantDetail_0 extends _i1.SmartFake
    implements _i2.RestaurantDetail {
  _FakeRestaurantDetail_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [RestaurantService].
///
/// See the documentation for Mockito's code generation for more information.
class MockRestaurantService extends _i1.Mock implements _i3.RestaurantService {
  @override
  _i4.Future<List<_i5.Restaurant>> fetchAllRestaurant() => (super.noSuchMethod(
        Invocation.method(
          #fetchAllRestaurant,
          [],
        ),
        returnValue: _i4.Future<List<_i5.Restaurant>>.value(<_i5.Restaurant>[]),
        returnValueForMissingStub:
            _i4.Future<List<_i5.Restaurant>>.value(<_i5.Restaurant>[]),
      ) as _i4.Future<List<_i5.Restaurant>>);
  @override
  _i4.Future<List<_i5.Restaurant>> findRestaurant(String? query) =>
      (super.noSuchMethod(
        Invocation.method(
          #findRestaurant,
          [query],
        ),
        returnValue: _i4.Future<List<_i5.Restaurant>>.value(<_i5.Restaurant>[]),
        returnValueForMissingStub:
            _i4.Future<List<_i5.Restaurant>>.value(<_i5.Restaurant>[]),
      ) as _i4.Future<List<_i5.Restaurant>>);
  @override
  _i4.Future<_i2.RestaurantDetail> fetchRestaurantDetail(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchRestaurantDetail,
          [id],
        ),
        returnValue:
            _i4.Future<_i2.RestaurantDetail>.value(_FakeRestaurantDetail_0(
          this,
          Invocation.method(
            #fetchRestaurantDetail,
            [id],
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.RestaurantDetail>.value(_FakeRestaurantDetail_0(
          this,
          Invocation.method(
            #fetchRestaurantDetail,
            [id],
          ),
        )),
      ) as _i4.Future<_i2.RestaurantDetail>);
}
