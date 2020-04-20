import 'dart:convert';
import 'dart:io';
import 'package:fluttervalidarformulariofh/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'package:fluttervalidarformulariofh/src/models/producto_model.dart';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';

class ProductosProvider {

  final _url = 'https://flutter-varios-839da.firebaseio.com';
  final _urlapi = 'https://api.imgbb.com/1/upload?key=6139cd1471ff93beafe9e4034cc3c39a';
  final _prefs = new PreferenciasUsuario();

  
  
  Future<bool>crearProducto(ProductoModel producto) async {

    final url = '$_url/productos.json?auth=${_prefs.token}';

    print('Product model to json: $producto');

    final resp =  await http.post(url, body: productoModelToJson(producto));

    final decodeData = json.decode(resp.body);

    print(decodeData);

    return true;

  }
  
  
  Future<bool>editarProducto(ProductoModel producto) async {

    final url = '$_url/productos/${producto.id}.json?auth=${_prefs.token}';

    final resp =  await http.put(url, body: productoModelToJson(producto));

    final decodeData = json.decode(resp.body);

    print(decodeData);

    return true;

  }

  Future<List<ProductoModel>> cargarProductos() async {

    final url = '$_url/productos.json?auth=${_prefs.token}';
    final resp = await http.get(url);

    final Map<String, dynamic> decodeData = json.decode(resp.body);

    final List<ProductoModel> productos = new List();

    if(decodeData == null) return [];

    
    // Validación para la sesión del token
    if(decodeData['error'] != null) return [];


    decodeData.forEach((id, prod) {

      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;

      productos.add(prodTemp);

    });

    return productos;

  }


  // Eliminar un registro en firebase
  Future<int> borrarProducto(String id) async {

    final url = '$_url/productos/$id.json?auth=${_prefs.token}';
    final resp = await http.delete(url);

    print(json.decode(resp.body));

    return 1;

  }


  Future<String> subirImagen(File imagen) async {

    final url = Uri.parse('$_urlapi');
    final mimeType = mime(imagen.path).split('/'); // imagen/jpg
    print(imagen.path);
    print(mimeType);

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath(
      'image',
      imagen.path,
      contentType: MediaType(mimeType[0], mimeType[1])
    );

    // Se pueden adjuntar multiples archivos
    // imageUploadRequest.files.add(file);
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    
    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    // print('respuesta correcta: ${resp.body}');

    final respData = json.decode(resp.body);
    // print('Respuesta Data: $respData');

    return '${respData['data']['url']}';

  }

}