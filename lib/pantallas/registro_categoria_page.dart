import 'dart:io';

//import 'package:eli_market/models/par_tipo_categoria.dart';
import 'package:eli_market/pantallas/menu_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:eli_market/constantes.dart';
import 'package:eli_market/data/database_helper.dart';
import 'package:eli_market/models/categoria.dart';

//import 'lista_categoria_page.dart';

class RegistroCategoriaPage extends StatefulWidget {
  @override
  _RegistroCategoriaPageState createState() => _RegistroCategoriaPageState();
}

class _RegistroCategoriaPageState extends State<RegistroCategoriaPage> {
  // LLaves par alos formularios
  //final _formKeyTipoCategoria = GlobalKey<FormState>();
  final _formKeyCategoria = GlobalKey<FormState>();

  // Estilos
  TextStyle textStyle = TextStyle(color: kTextoDarkColor);
  OutlineInputBorder inputBorderTexto = OutlineInputBorder(
      borderSide: new BorderSide(
        color: kTextoColor,
      ),
      borderRadius: BorderRadius.circular(6.0));

  TextEditingController descripcionController = TextEditingController();
  TextEditingController observacionController = TextEditingController();
  TextEditingController descTipoCategoriaController = TextEditingController();

  String vIdTipoCategoria;
  //List<DropdownMenuItem<String>> lista;

  File _imagenCategoria;
  final _imagenPicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    //lista = [];
    // Metodo para obtener los datos para el combo Tipo categoria
    // DataBaseHelper.db.obtieneTipoCategoria().then((listaMap) {
    //   listaMap.map((map) {
    //     return obtieneDropDownWiget(map);
    //   }).forEach((element) {
    //     lista.add(element);
    //   });
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _retornaMenu(context);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white, //kPrimaryColor
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
              height: 75.0, //90.0,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Para el registro de una nueva categoria debe de llenar todos los campos solicitados y cargar la imagen.",
                        style: GoogleFonts.montserratAlternates(
                            color: kTextoDarkColor, fontSize: 14.0), //
                      ),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 9.0, left: 18.0, right: 18.0),
                    //   child: Text(
                    //     "* Si no existe en la lista el tipo categoria, debe de hacer click en (+ TIPO CAT) para agregar uno nuevo.",
                    //     style: GoogleFonts.montserratAlternates(
                    //         color: kTextoColor, fontSize: 12.0),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKeyCategoria,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Expanded(
                      //       child: Padding(
                      //         padding: EdgeInsets.only(
                      //           left: 20.0,
                      //           right: 2.0,
                      //           top: 20.0,
                      //         ),
                      //         child: DropdownButtonFormField(
                      //           validator: (valor) {
                      //             if (valor == null) {
                      //               return "Seleccione tipo categoria";
                      //             }
                      //             return null;
                      //           },
                      //           decoration: new InputDecoration(
                      //             labelText: "Tipo categoria",
                      //             // hintText: 'Ingrese tipo categoria',
                      //             labelStyle: textStyle,
                      //             enabledBorder: inputBorderTexto,
                      //             focusedBorder: inputBorderTexto,
                      //             errorBorder: inputBorderTexto,
                      //             focusedErrorBorder: inputBorderTexto,
                      //           ),
                      //           isExpanded: true,
                      //           // itemHeight: 50.0,
                      //           style: textStyle,
                      //           value: vIdTipoCategoria,
                      //           items: lista,
                      //           onChanged: (valor) {
                      //             FocusScope.of(context)
                      //                 .requestFocus(new FocusNode());
                      //             // print(valor);
                      //             setState(() {
                      //               vIdTipoCategoria = valor;
                      //             });
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      //     registrarNuevoTipoCategoria(context),
                      //   ],
                      // ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 20.0,
                          right: 20.0,
                          top: 20.0,
                        ),
                        child: TextFormField(
                          validator: (valor) {
                            if (valor.isEmpty) {
                              return 'Ingrese el nombre de la categoria';
                            }
                            return null;
                          },
                          textCapitalization: TextCapitalization.sentences,
                          maxLength: 40,
                          controller: descripcionController,
                          decoration: InputDecoration(
                            labelText: 'Nombre categoria',
                            // hintText: 'Ingrese la categoria',
                            labelStyle: textStyle,
                            enabledBorder: inputBorderTexto,
                            focusedBorder: inputBorderTexto,
                            errorBorder: inputBorderTexto,
                            focusedErrorBorder: inputBorderTexto,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 7.0),
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
                            // hintText: 'Ingrese la observación',
                            labelStyle: textStyle,
                            enabledBorder: inputBorderTexto,
                            focusedBorder: inputBorderTexto,
                            errorBorder: inputBorderTexto,
                            focusedErrorBorder: inputBorderTexto,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              foregroundColor: Colors.red,
                              backgroundImage: _imagenCategoria != null
                                  ? FileImage(File(_imagenCategoria.path))
                                  : AssetImage(
                                      "assets/imagenes/categoria_ninguno.png"),
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
                                    builder: (builder) =>
                                        seleccionArchivo(context));

                                // Seleccion de Galeria
                                //getImagenArchivo(ImageSource.gallery);
                                //
                                // Seleccion de Camara
                                //getImagenArchivo(ImageSource.camera);
                              },
                              style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 15.0),
                                  elevation: 5.0,
                                  primary: kIconoInactivoLigth,
                                  // padding: EdgeInsets.symmetric(horizontal: 30.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            )
                          ],
                        ),
                      ),

                      registrarNuevaCategoria(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _retornaMenu(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MenuPage()));
  }
  // DropdownMenuItem<String> obtieneDropDownWiget(
  //     ParTipoCategoria tipoCategoria) {
  //   return DropdownMenuItem<String>(
  //     value: tipoCategoria.idTipoCategoria.toString(),
  //     child: Text(tipoCategoria.tipoCategoria),
  //   );
  // }

  Widget registrarNuevaCategoria(BuildContext context) {
    return Container(
      margin: new EdgeInsets.only(top: 40.0),
      width: MediaQuery.of(context).size.width * 0.90,
      child: ElevatedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          // verifica si la informacion esta validada.
          if (_formKeyCategoria.currentState.validate()) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Información"),
                    content: Text("Desea registrar la nueva categoria?"),
                    actions: [
                      OutlinedButton(
                        onPressed: () {
                          // Envia para guardar
                          guardarRegistroCategoria(context);
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
                  );
                });
          }
        },
        child: Text("REGISTRAR"),
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            elevation: 5.0,
            primary: kAcentColor,
            // padding: EdgeInsets.symmetric(horizontal: 30.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))),
      ),
    );
  }

  // Widget registrarNuevoTipoCategoria(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.only(right: 20.0, left: 2.0, top: 1.0),
  //     child: ElevatedButton.icon(
  //       icon: SvgPicture.asset(
  //         "assets/icons/shopping-basket.svg",
  //         color: kTextoLigthColor,
  //         height: 25.0,
  //       ),
  //       onPressed: () {
  //         showDialog(
  //             context: context,
  //             builder: (context) {
  //               return Dialog(
  //                 shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(15.0)),
  //                 child: Form(
  //                   key: _formKeyTipoCategoria,
  //                   child: Container(
  //                     height: 250.0,
  //                     child: Column(
  //                       children: [
  //                         Container(
  //                           padding: EdgeInsets.all(18.0),
  //                           height: 60.0,
  //                           width: MediaQuery.of(context).size.width,
  //                           decoration: BoxDecoration(
  //                               color: kPrimaryColor,
  //                               borderRadius: BorderRadius.only(
  //                                   topLeft: Radius.circular(15.0),
  //                                   topRight: Radius.circular(15.0))),
  //                           child: Text(
  //                             "Registrar Tipo de Categoria",
  //                             style: GoogleFonts.berkshireSwash(
  //                                 color: kTextoLigthColor, fontSize: 18.0),
  //                           ),
  //                         ),
  //                         Padding(
  //                           padding: EdgeInsets.symmetric(
  //                               horizontal: 20.0, vertical: 20.0),
  //                           child: TextFormField(
  //                             validator: (valor) {
  //                               if (valor.isEmpty) {
  //                                 return 'Ingrese el tipo de categoria';
  //                               }
  //                               return null;
  //                             },
  //                             maxLength: 25,
  //                             controller: descTipoCategoriaController,
  //                             decoration: InputDecoration(
  //                               labelText: 'Tipo de Categoria',
  //                               // hintText: 'Ingrese tipo categoria',
  //                               labelStyle: textStyle,
  //                               enabledBorder: inputBorderTexto,
  //                               focusedBorder: inputBorderTexto,
  //                               errorBorder: inputBorderTexto,
  //                               focusedErrorBorder: inputBorderTexto,
  //                             ),
  //                           ),
  //                         ),
  //                         Container(
  //                           width: MediaQuery.of(context).size.width * 0.70,
  //                           child: ElevatedButton(
  //                             onPressed: () {
  //                               // Verifica si todo esta validadado
  //                               if (_formKeyTipoCategoria.currentState
  //                                   .validate()) {
  //                                 // Aca se gurda la informacion
  //                               }
  //                             },
  //                             child: Text("REGISTRAR"),
  //                             style: ElevatedButton.styleFrom(
  //                                 primary: kAcentColor,
  //                                 padding: EdgeInsets.symmetric(vertical: 15.0),
  //                                 elevation: 5.0,
  //                                 shape: RoundedRectangleBorder(
  //                                     borderRadius:
  //                                         BorderRadius.circular(10.0))),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             });
  //       },
  //       label: Text("+ TIPO CAT."),
  //       style: ElevatedButton.styleFrom(
  //           padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
  //           elevation: 5.0,
  //           primary: kAcentColor,
  //           // padding: EdgeInsets.symmetric(horizontal: 30.0),
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(10.0))),
  //     ),
  //   );
  // }

  Widget seleccionArchivo(BuildContext context) {
    return Container(
      height: 110.0,
      width: MediaQuery.of(context).size.width,
      // margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
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
      _imagenCategoria = tmpArchivo;
    });
  }

  // Metodo para gurdar la informacion de la categoria
  void guardarRegistroCategoria(BuildContext context) {
    Categoria categoria = new Categoria();
    categoria.descCategoria = descripcionController.text.trim();
    // categoria.parTipoCategoria = int.parse(vIdTipoCategoria);
    categoria.parTipoCategoria = 7; // Otros;
    categoria.observacion = observacionController.text.trim();
    // categoria.imagen = "assets/imagenes/abarrotes.png";
    categoria.imagen = _imagenCategoria != null ? _imagenCategoria.path : null;

    // Envia para registrar la informacion.
    DataBaseHelper.db.registraCategoria(categoria);
    // Envia un mensaje
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: kColorTarjeta,
      content: Text(
        'Se registro correctamente.',
        style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
      ),
    ));

    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => MenuPage()));
  }
}
