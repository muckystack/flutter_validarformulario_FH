import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttervalidarformulariofh/src/models/producto_model.dart';

class ProductosProvider {

  final _url = 'https://flutter-varios-839da.firebaseio.com';

  
  
  Future<bool>crearProducto(ProductoModel producto) async {

    final url = '$_url/productos.json';

    print('Product model to json: $producto');

    final resp =  await http.post(url, body: productoModelToJson(producto));

    final decodeData = json.decode(resp.body);

    print(decodeData);

    return true;

  }
  
  
  Future<bool>editarProducto(ProductoModel producto) async {

    final url = '$_url/productos/${producto.id}.json';

    final resp =  await http.put(url, body: productoModelToJson(producto));

    final decodeData = json.decode(resp.body);

    print(decodeData);

    return true;

  }

  Future<List<ProductoModel>> cargarProductos() async {

    final url = '$_url/productos.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodeData = json.decode(resp.body);

    final List<ProductoModel> productos = new List();

    if(decodeData == null) return [];

    decodeData.forEach((id, prod) {

      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;

      productos.add(prodTemp);

    });

    return productos;

  }


  // Eliminar un registro en firebase
  Future<int> borrarProducto(String id) async {

    final url = '$_url/productos/$id.json';
    final resp = await http.delete(url);

    print(json.decode(resp.body));

    return 1;

  }

}