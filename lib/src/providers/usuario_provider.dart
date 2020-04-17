import 'dart:convert';

import 'package:http/http.dart' as http;

class UsuarioProvider {

  final String _firebasetoken = 'AIzaSyBsT1K_Gzhsd-g5ouVS6eJMFZjxywTfiOE';

  Future nuevoUsuario(String email, String password) async {

    final authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebasetoken',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodeResp = json.decode(resp.body);

    print(decodeResp);

    if(decodeResp.containsKey('idToken')) {

      // TODO: Salvar el token en el storage
      return {'ok': true, 'token': decodeResp['idToken']};

    }else {

      return {'ok': false, 'mensaje': decodeResp['error']['message']};

    }

  }

}