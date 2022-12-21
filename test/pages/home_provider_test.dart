import 'package:dicoding_flutter_fundamental/model/restaurant.dart';
import 'package:dicoding_flutter_fundamental/pages/home/home_provider.dart';
import 'package:dicoding_flutter_fundamental/service/restaurant_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateNiceMocks([MockSpec<RestaurantService>()])
import 'home_provider_test.mocks.dart';

void main() {
  late MockRestaurantService restaurantServiceMock;
  late HomeProvider provider;

  setUp(() {
    restaurantServiceMock = MockRestaurantService();
    provider = HomeProvider(restaurantService: restaurantServiceMock);
  });

  group('load all data', () {
    test('should be able to load data success', () async {
      List<Restaurant> restaurants = [];
      restaurants.add(Restaurant(id: "1", name: "dummy", description: "dummy", pictureId: "dummy", city: "dummy", rating: 2));

      when(restaurantServiceMock.fetchAllRestaurant()).thenAnswer((_) async => restaurants);

      await provider.loadData();

      expect(provider.state, ResultState.success);
      expect(provider.restaurants, restaurants);
      verify(restaurantServiceMock.fetchAllRestaurant());
    });

    test('should change state to error', () async {
      when(restaurantServiceMock.fetchAllRestaurant()).thenThrow(Exception("Gagal mengambil data restaurant"));

      await provider.loadData();

      expect(provider.state, ResultState.error);
      verify(restaurantServiceMock.fetchAllRestaurant());
    });
  });

  group('find restaurant', () {
    test('should be able to find restaurant', () async {
      List<Restaurant> restaurants = [];
      restaurants.add(Restaurant(id: "1", name: "dummy", description: "dummy", pictureId: "dummy", city: "dummy", rating: 2));

      when(restaurantServiceMock.findRestaurant(any)).thenAnswer((_) async => restaurants);

      await provider.findData("1");

      expect(provider.state, ResultState.success);
      expect(provider.restaurants, restaurants);
      verify(restaurantServiceMock.findRestaurant("1"));
    });

    test('should change state to error', () async {
      when(restaurantServiceMock.findRestaurant(any)).thenThrow(Exception("Gagal mengambil data restaurant"));

      await provider.findData("1");

      expect(provider.state, ResultState.error);
      verify(restaurantServiceMock.findRestaurant("1"));
    });

    test('should change state to error', () async {
      when(restaurantServiceMock.findRestaurant(any)).thenAnswer((realInvocation) async => []);

      await provider.findData("1");

      expect(provider.state, ResultState.empty);
      expect(provider.restaurants.length, 0);
      verify(restaurantServiceMock.findRestaurant("1"));
    });
  });

}