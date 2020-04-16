import 'package:flutter/material.dart';
import 'package:fluttervalidarformulariofh/src/models/producto_model.dart';
import 'package:fluttervalidarformulariofh/src/providers/produtos_provider.dart';
import 'package:fluttervalidarformulariofh/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {

  // Flutter sabra que es un formulario y que tiene las propiedades para hacer las validaciones
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {

  final formKey = GlobalKey<FormState>();

  ProductoModel producto = new ProductoModel();
  final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {

    // Se toma el argumento en caso de que venga
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if(prodData != null) {
      producto = prodData;
    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearBoton(),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _crearDisponible() {

    return SwitchListTile(
      value: producto.disponible,
      title: Text('Disponible'),
      onChanged: (value) => setState(() {

        producto.disponible = value;
        
      }),
    );

  }

  Widget _crearNombre() {

    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      onSaved: (value) => producto.titulo = value,
      validator: (value) {

        return (value.length < 3) ? 'Ingrese el nombre del producto' : null;

      },
    );
    
  }

  Widget _crearPrecio() {

    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio',
      ),
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (value) {

        return (utils.isNumeric(value)) ? null : 'Solo números';

      },
    );

  }

  Widget _crearBoton() {

    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Color.fromRGBO(169, 80, 162, 1.0),
      textColor: Colors.white,
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      onPressed: _submit,
    );

  }

  void _submit() {

    if(!formKey.currentState.validate()) return;

    // ejecuta todos los metodo save que esten dentro del formulario
    formKey.currentState.save();

    print('Todo OK...');

    print(producto.titulo);
    print(producto.valor);
    print(producto.disponible);

    if(producto.id == null) {
      productosProvider.crearProducto(producto);
    }else {
      productosProvider.editarProducto(producto);
    }


  }
}