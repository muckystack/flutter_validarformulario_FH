import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttervalidarformulariofh/src/models/producto_model.dart';
import 'package:fluttervalidarformulariofh/src/providers/produtos_provider.dart';
import 'package:fluttervalidarformulariofh/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {

  // Flutter sabra que es un formulario y que tiene las propiedades para hacer las validaciones
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {



  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ProductoModel producto = new ProductoModel();
  final productosProvider = new ProductosProvider();
  bool _guardando = false;

  File foto;



  @override
  Widget build(BuildContext context) {

    // Se toma el argumento en caso de que venga
    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if(prodData != null) {
      producto = prodData;
    }


    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
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
                _mostrarFoto(),
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
      onPressed: (_guardando) ? null : _submit,
    );

  }

  void _submit() async {

    if(!formKey.currentState.validate()) return;

    // ejecuta todos los metodo save que esten dentro del formulario
    formKey.currentState.save();
    
    setState(() {
      _guardando = true;
    });

    if(foto != null) {

      producto.fotoUrl = await productosProvider.subirImagen(foto);

    }
    

    print(producto.titulo);
    print(producto.valor);
    print(producto.disponible);

    if(producto.id == null) {
      productosProvider.crearProducto(producto);
    }else {
      productosProvider.editarProducto(producto);
    }

    mostrarSnackbar('Registro guardado');

    Navigator.pop(context);

    setState(() {
      // _guardando = true;
    });

  }

  void mostrarSnackbar(String mensaje) {

    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(seconds: 1500),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);

  }

  Widget _mostrarFoto() {

    if(producto.fotoUrl != null) {

      return FadeInImage(
        image: NetworkImage(producto.fotoUrl),
        placeholder: AssetImage('assets/load.gif'),
        height: 300.0,
        fit: BoxFit.contain
      );

    }else {

      return Image(
        image: AssetImage(foto?.path ?? 'assets/404.jpg'),
        height: 300.0,
        fit: BoxFit.cover,
      );

    }

  }


  _seleccionarFoto() async {

    _procesarImagen(ImageSource.gallery);

  }
  
  
  
  _tomarFoto() async {

    _procesarImagen(ImageSource.camera);

  }
  

  _procesarImagen(ImageSource origen) async {

    foto = await ImagePicker.pickImage(
      source: origen
    );

    if(foto != null) {

      producto.fotoUrl = null;

    }

    setState(() {});

  }

}