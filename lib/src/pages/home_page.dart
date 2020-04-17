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

          final productos = snapshot.data;
          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (BuildContext context, int i) => _crearItem(context, productos[i])
          );

        }else {

          return Center(child: CircularProgressIndicator());

        }

      },
    );

  }


  Widget _crearItem(BuildContext context , ProductoModel producto) {

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direccion) {

        productosProvider.borrarProducto(producto.id);

      },
      child: Card(
        child: Column(
          children: <Widget>[

            (producto.fotoUrl == null)
              ? Image(image: AssetImage('assets/404.jpg'))
              : FadeInImage(
                image: NetworkImage(producto.fotoUrl),
                placeholder: AssetImage('assets/load.gif'),
                height: 300.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

              ListTile(
                title: Text('${producto.titulo} - ${producto.valor}'),
                subtitle: Text('${producto.id}'),
                onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto),
              ),

          ],
        ),
      )
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