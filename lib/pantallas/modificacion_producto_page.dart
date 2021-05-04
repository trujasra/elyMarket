import 'dart:io';

import 'package:eli_market/models/producto_bitacora.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:eli_market/data/database_helper.dart';
import 'package:eli_market/pantallas/lista_producto_page.dart';
import '../constantes.dart';
import 'package:eli_market/models/producto.dart';
import 'package:eli_market/models/categoria.dart';

class ModificacionProductoPage extends StatefulWidget {
  final Categoria oCategoria;
  final Producto oProducto;
  ModificacionProductoPage(
      {@required this.oCategoria, @required this.oProducto, Key key})
      : super(key: key);

  @override
  _ModificacionProductoPageState createState() =>
      _ModificacionProductoPageState();
}

class _ModificacionProductoPageState extends State<ModificacionProductoPage> {
  // LLaves par alos formularios
  final _formKeyProducto = GlobalKey<FormState>();

  // Estilos
  TextStyle textStyle = TextStyle(color: kTextoDarkColor);
  OutlineInputBorder inputBorderTexto = OutlineInputBorder(
      borderSide: new BorderSide(
        color: kTextoColor,
      ),
      borderRadius: BorderRadius.circular(6.0));

  TextEditingController nombreProductoController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController observacionController = TextEditingController();
  TextEditingController lugarCompraController = TextEditingController();

  File _imagenProducto, _imagenProductoBitacora;
  final _imagenPicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    setState(() {
      nombreProductoController.text = widget.oProducto.descProducto;
      observacionController.text = widget.oProducto.observacion;
      precioController.text = widget.oProducto.precio.toString();
      lugarCompraController.text = widget.oProducto.lugarCompra;

      _imagenProducto = widget.oProducto.imagen == null
          ? null
          : File(widget.oProducto.imagen);

      _imagenProductoBitacora = widget.oProducto.imagen == null
          ? null
          : File(widget.oProducto.imagen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _retornarListaProducto(context);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () =>
                _retornarListaProducto(context), //Navigator.pop(context),
            icon: SvgPicture.asset("assets/icons/back.svg",
                color: kTextoLigthColor),
          ),
          title: Text(widget.oCategoria.descCategoria,
              style: GoogleFonts.berkshireSwash(
                color: kTextoLigthColor,
              )),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: kIconoInactivo.withAlpha(40),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0))),
              width: MediaQuery.of(context).size.width,
              height: 110.0, //90.0,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.0, left: 8.0),
                      child: Text(
                        "MODIFICACIÓN REGISTRO",
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Para la modificacón de los datos del producto debe de llenar todos los campos solicitados y cargar la imagen.",
                        style: GoogleFonts.montserratAlternates(
                            color: kTextoDarkColor, fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: _disenioProducto(context)),
          ],
        ),
      ),
    );
  }

  Widget _disenioProducto(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKeyProducto,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
              ),
              child: TextFormField(
                validator: (valor) {
                  if (valor.isEmpty) {
                    return 'Ingrese el nombre del producto';
                  }
                  return null;
                },
                maxLength: 40,
                textCapitalization: TextCapitalization.sentences,
                controller: nombreProductoController,
                decoration: InputDecoration(
                  labelText: 'Nombre producto',
                  labelStyle: textStyle,
                  enabledBorder: inputBorderTexto,
                  focusedBorder: inputBorderTexto,
                  errorBorder: inputBorderTexto,
                  focusedErrorBorder: inputBorderTexto,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
              child: TextFormField(
                validator: (valor) {
                  if (valor.isEmpty) {
                    return "Ingrese descripción/observación";
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
                controller: observacionController,
                decoration: InputDecoration(
                  labelText: 'Descripción/Observación',
                  labelStyle: textStyle,
                  enabledBorder: inputBorderTexto,
                  focusedBorder: inputBorderTexto,
                  errorBorder: inputBorderTexto,
                  focusedErrorBorder: inputBorderTexto,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: TextFormField(
                validator: (valor) {
                  if (valor.isEmpty) {
                    return 'Ingrese el precio del producto';
                  }
                  return null;
                },
                // maxLength: 40,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                controller: precioController,
                decoration: InputDecoration(
                  labelText: 'Precio producto',
                  labelStyle: textStyle,
                  enabledBorder: inputBorderTexto,
                  focusedBorder: inputBorderTexto,
                  errorBorder: inputBorderTexto,
                  focusedErrorBorder: inputBorderTexto,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
              child: TextFormField(
                // validator: (valor) {
                //   if (valor.isEmpty) {
                //     return "Ingrese el lugar/dirección de compra";
                //   }
                //   return null;
                // },
                textCapitalization: TextCapitalization.sentences,
                maxLines: 2,
                controller: lugarCompraController,
                decoration: InputDecoration(
                  labelText: 'Lugar/Dirección de compra',
                  labelStyle: textStyle,
                  enabledBorder: inputBorderTexto,
                  focusedBorder: inputBorderTexto,
                  errorBorder: inputBorderTexto,
                  focusedErrorBorder: inputBorderTexto,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    foregroundColor: Colors.red,
                    backgroundImage: _imagenProducto != null
                        ? FileImage(File(_imagenProducto.path))
                        : AssetImage("assets/imagenes/producto_ninguno.png"),
                  ),
                  SizedBox(
                    width: 25.0,
                  ),
                  ElevatedButton.icon(
                    label: Text("Cargar imagen"),
                    icon: SvgPicture.asset(
                      "assets/icons/upload-file.svg",
                      color: kTextoLigthColor,
                      height: 25.0,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (builder) => seleccionArchivo(context));
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        elevation: 5.0,
                        primary: kIconoInactivoLigth,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  )
                ],
              ),
            ),
            actualizaProducto(context),
          ],
        ),
      ),
    );
  }

  void _retornarListaProducto(BuildContext context) {
    //Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListaProductoPage(
                  oCategoria: widget.oCategoria,
                )));
  }

  Widget actualizaProducto(BuildContext context) {
    return Container(
      margin: new EdgeInsets.only(top: 40.0),
      width: MediaQuery.of(context).size.width * 0.90,
      child: ElevatedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          // verifica si la informacion esta validada.
          if (_formKeyProducto.currentState.validate()) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return WillPopScope(
                    onWillPop: () async => true,
                    child: AlertDialog(
                      title: Text("Información"),
                      content:
                          Text("Desea modificar la información del producto?"),
                      actions: [
                        OutlinedButton(
                          onPressed: () {
                            // Envia para modificar
                            modificarRegistroProducto(context);
                          },
                          child: Text(
                            'SI',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.green[50],
                              side: BorderSide(
                                color: Colors.green,
                              )),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'CANCELAR',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.red[50],
                              side: BorderSide(color: Colors.redAccent)),
                        ),
                      ],
                    ),
                  );
                });
          }
        },
        child: Text("MODIFICAR"),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            elevation: 5.0,
            primary: kAcentColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))),
      ),
    );
  }

  Widget seleccionArchivo(BuildContext context) {
    return Container(
      height: 110.0,
      width: MediaQuery.of(context).size.width,
      color: kPrimaryLigthColor,
      child: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          Text(
            "Elige como cargar la imagen: ",
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () {
                  // Seleccion de Camara
                  getImagenArchivo(ImageSource.camera);
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.camera_alt,
                  color: kPrimaryDarkColor,
                ),
                label: Text(
                  "Tomar foto",
                  style: TextStyle(color: kPrimaryDarkColor),
                ),
                style: OutlinedButton.styleFrom(
                    backgroundColor: kAcentColor.withAlpha(80),
                    side: BorderSide(
                      color: kAcentColor,
                    )),
              ),
              SizedBox(
                width: 30.0,
              ),
              OutlinedButton.icon(
                onPressed: () {
                  // Seleccion de Galeria
                  getImagenArchivo(ImageSource.gallery);
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.image,
                  color: kPrimaryDarkColor,
                ),
                label: Text(
                  "Galeria",
                  style: TextStyle(color: kPrimaryDarkColor),
                ),
                style: OutlinedButton.styleFrom(
                    backgroundColor: kAcentColor.withAlpha(80),
                    side: BorderSide(
                      color: kAcentColor,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void getImagenArchivo(ImageSource imageSource) async {
    // PickedFile imageArchivo = await _imagenPicker.getImage(source: imageSource);
    PickedFile imageArchivo = await _imagenPicker.getImage(
        source: imageSource, maxHeight: 800.0, maxWidth: 800.0);
    // Verifica que no sea nulo
    if (imageArchivo == null) return;
    File tmpArchivo = File(imageArchivo.path);
    final appDir = await getApplicationDocumentsDirectory();
    final nombreArchivo = basename(imageArchivo.path);
    tmpArchivo = await tmpArchivo.copy('${appDir.path}/$nombreArchivo');
    // actualiza el valor de imagen
    setState(() {
      _imagenProducto = tmpArchivo;
    });
  }

// Metodo para modificar la informacion del producto
  void modificarRegistroProducto(BuildContext context) {
    // Guarda los datos del producto en bitcora
    ProductoBitacora productoBitacora = new ProductoBitacora();
    productoBitacora.idProducto = widget.oProducto.idProducto;
    productoBitacora.idCategoria = widget.oProducto.idCategoria;
    productoBitacora.descProducto = widget.oProducto.descProducto;
    productoBitacora.precio = widget.oProducto.precio;
    productoBitacora.observacion = widget.oProducto.observacion;
    productoBitacora.lugarCompra = widget.oProducto.lugarCompra;

    productoBitacora.imagen =
        _imagenProductoBitacora != null ? _imagenProductoBitacora.path : null;

    productoBitacora.usuarioRegistroProd =
        widget.oProducto.usuarioModificacion == null
            ? widget.oProducto.usuarioRegistro
            : widget.oProducto.usuarioModificacion;
    productoBitacora.fechaRegistroProd =
        widget.oProducto.fechaModificacion == null
            ? widget.oProducto.fechaRegistro
            : widget.oProducto.fechaModificacion;

    // Envia para modificar la informacion.
    DataBaseHelper.db.registraProductoBitacora(productoBitacora);

    // Carga los datos nuevos para actualizar
    Producto producto = new Producto();
    producto.idProducto = widget.oProducto.idProducto;
    producto.idCategoria = widget.oProducto.idCategoria;
    producto.descProducto = nombreProductoController.text.trim();
    producto.precio = double.parse(precioController.text);
    producto.observacion = observacionController.text.trim();
    producto.lugarCompra = lugarCompraController.text.trim();

    producto.imagen = _imagenProducto != null ? _imagenProducto.path : null;
    producto.estadoRegistro = widget.oProducto.estadoRegistro;
    producto.usuarioRegistro = widget.oProducto.usuarioRegistro;
    producto.fechaRegistro = widget.oProducto.fechaRegistro;

    // Envia para modificar la informacion.
    DataBaseHelper.db.actualizaProducto(producto);
    // Envia un mensaje
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: kColorTarjeta,
      content: Text(
        'Se modifico la información correctamente.',
        style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
      ),
    ));

    // Navigator.pop(context);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ListaProductoPage(oCategoria: widget.oCategoria)));
  }
}
