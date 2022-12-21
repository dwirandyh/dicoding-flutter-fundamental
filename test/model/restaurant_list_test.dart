import 'package:dicoding_flutter_fundamental/model/restaurant.dart';
import 'package:dicoding_flutter_fundamental/model/restaurant_list.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('should be able to parse from raw json', () {
    String rawJson = """
    {
      "error": false,
      "message": "success",
      "count": 20,
      "restaurants": [{
        "id": "rqdv5juczeskfw1e867",
        "name": "Melting Pot",
        "description": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.",
        "pictureId": "14",
        "city": "Medan",
        "rating": 4.2
      }]
    }
    """;

    final restaurantList = RestaurantList.fromRawJson(rawJson);
    expect(restaurantList.restaurants.length, 1);
  });

  test('should be able to convert object into json', () {
    final restaurantList = RestaurantList(restaurants: [Restaurant(id: "1", name: "name", description: "description", pictureId: "pictureId", city: "city", rating: 1)]);
    const expectedOutput = """{"restaurants":[{"id":"1","name":"name","description":"description","pictureId":"pictureId","city":"city","rating":0}]}""";

    final json = restaurantList.toRawJson();

    expect(json, expectedOutput);
  });
}