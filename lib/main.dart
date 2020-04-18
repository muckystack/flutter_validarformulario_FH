import 'package:flutter/material.dart';
import 'package:fluttervalidarformulariofh/src/bloc/provider.dart';
import 'package:fluttervalidarformulariofh/src/pages/home_page.dart';
import 'package:fluttervalidarformulariofh/src/pages/login_page.dart';
import 'package:fluttervalidarformulariofh/src/pages/producto_page.dart';
import 'package:fluttervalidarformulariofh/src/pages/registro_page.dart';
import 'package:fluttervalidarformulariofh/src/preferencias_usuario/preferencias_usuario.dart';
 
void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());

}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final prefs = new PreferenciasUsuario();

    // if(prefs.token != '') Navigator.of(context).pushReplacementNamed('home');

    Theme(
      // Crea un tema único con "ThemeData"
      data: ThemeData(
        accentColor: Colors.yellow,
      ),
      child: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );

    Theme(
      // Encuentra y amplía el tema padre usando "copyWith". Por favor observa la siguiente 
      // sección para más información sobre `Theme.of`.
      data: Theme.of(context).copyWith(accentColor: Colors.yellow),
      child: FloatingActionButton(
        onPressed: null,
        child: Icon(Icons.add),
      ),
    );

    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: (prefs.token != '') ? 'home' : 'login',
        routes: {
          'login' : (BuildContext context) => LoginPage(),
          'registro' : (BuildContext context) => RegistroPage(),
          'home' : (BuildContext context) => HomePage(),
          'producto' : (BuildContext context) => ProductoPage(),
        },
        theme: ThemeData(
          // Define el Brightness y Colores por defecto
          // brightness: Brightness.dark,
          primaryColor: Color.fromRGBO(88, 72, 147, 1.0),
        )
      ),
    );
  }
}