import 'package:flutter/material.dart';
// import 'package:fluttervalidarformulariofh/src/bloc/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Container(),
      floatingActionButton: _crearBoton(context),
    );
  }


  _crearBoton(BuildContext context) {

    return FloatingActionButton(
      backgroundColor: Color.fromRGBO(169, 80, 162, 1.0),
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, 'producto'),
    );

  }
}