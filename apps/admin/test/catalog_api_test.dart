import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nooshora_admin/catalog_api.dart';

void main() {
  test('fetchProducts parses weighted and counted products', () async {
    final client = MockClient((request) async => http.Response(
          jsonEncode([
            {
              'id': '1',
              'title': 'پسته اکبری',
              'slug': 'akbari',
              'category': 'مغزیجات',
              'origin': 'رفسنجان',
              'unitType': 'Weight',
              'variants': [
                {
                  'sku': 'AK-250',
                  'quantity': 250,
                  'baseUnit': 'gram',
                  'displayLabel': '۲۵۰ گرم',
                  'price': 100000,
                  'availablePackages': 4,
                }
              ],
            }
          ]),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ));

    final products = await CatalogApiClient(client: client, baseUrl: 'https://api.test').fetchProducts();

    expect(products, hasLength(1));
    expect(products.single.isWeight, isTrue);
    expect(products.single.totalStock, 4);
  });

  test('createProduct surfaces Persian conflict message', () async {
    final client = MockClient((request) async => http.Response(
          utf8.decode(utf8.encode(jsonEncode({'message': 'SKU تکراری است.'}))),
          409,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ));

    final api = CatalogApiClient(client: client, baseUrl: 'https://api.test');
    final command = CreateProductCommand(
      title: 'کوکی',
      slug: 'cookie',
      category: 'سالم',
      origin: 'نوشورا',
      unitType: 'Count',
      variants: const [
        CreateVariantCommand(sku: 'CK-1', quantity: 1, displayLabel: '۱ عدد', price: 1000, availablePackages: 2),
      ],
    );

    expect(() => api.createProduct(command), throwsA(isA<CatalogApiException>().having((e) => e.message, 'message', 'SKU تکراری است.')));
  });
}
