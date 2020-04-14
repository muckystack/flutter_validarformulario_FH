import 'package:flutter/material.dart';
import 'package:fluttervalidarformulariofh/src/models/producto_model.dart';
import 'package:fluttervalidarformulariofh/src/providers/produtos_provider.dart';
// import 'package:fluttervalidarformulariofh/src/bloc/provider.dart';

class HomePage extends StatelessWidget {

  final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {

    // final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
    );
  }


  Widget _crearListado() {

    return FutureBuilder(
      future: productosProvider.cargarProductos(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {

        if(snapshot.hasData) {

          return Container();

        }else {

          return Center(child: CircularProgressIndicator());

        }

      },
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