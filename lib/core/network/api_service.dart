import 'dart:convert';
import 'package:http/http.dart' as http;
import '../features/product/product_model.dart';


//<--- fetch multiple products ---->
Future<List<Product>> fetchProductsByIds(List<String> ids) async {
  final query = ids.map((id) => 'id=$id').join('&');


  final response = await http.get(
    Uri.parse('https://api.restful-api.dev/objects?$query'),
  );

  final List list = json.decode(response.body);
  return list.map((e) => Product.fromJson(e)).toList();
}
 //<---- fetch single product ---->

Future<Product> fetchProductById(String id) async {
  final response = await http.get(
    Uri.parse("https://api.restful-api.dev/objects/$id"),
  );

  if (response.statusCode == 200) {
    return Product.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to load product");
  }
}

//<---- fetch all products ----->

Future<List<Product>> fetchAllProducts() async {
  final response = await fetchProductsByIds([
    'ff8081819782e69e019bc67597d65d9b',
    'ff8081819782e69e019bc67cade95dcb',
    'ff8081819782e69e019bc67eeeae5dd5',
    'ff8081819782e69e019bda13575e0eb1',
    'ff8081819782e69e019bda1465e30eb6',
    'ff8081819782e69e019bda0ca7f50e93',
    'ff8081819782e69e019bda11d7e50ea8',
    'ff8081819782e69e019bda1699ec0ebd',
    'ff8081819782e69e019bda1766b70ec0',
    'ff8081819782e69e019bda1a3c150ed3',
    'ff8081819782e69e019bda0b8f8d0e90',
    'ff8081819782e69e019bda1b78210ed8',
    'ff8081819782e69e019bda1c256a0edc',
    'ff8081819782e69e019bda1d78bd0ee7',
    'ff8081819782e69e019bda1e457a0ee8',
    'f8081819782e69e019bda1f76c00eeb',
    'ff8081819782e69e019bda1ffa8e0eee',
    'ff8081819782e69e019bda21c7150ef3',
    'ff8081819782e69e019bda225dc30ef4',
    'ff8081819782e69e019bda236ff30efa',
    'ff8081819782e69e019bda240dc60efd',
    'ff8081819782e69e019bda257f8f0f00',
    'ff8081819782e69e019bda2616e80f01',
  ]);
  return response;
}
