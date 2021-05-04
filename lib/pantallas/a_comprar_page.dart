import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:eli_market/data/database_helper.dart';
import 'package:eli_market/pantallas/menu_page.dart';
import 'package:eli_market/models/producto_a_comprar.dart';
import 'package:eli_market/constantes.dart';

class AComprarPage extends StatefulWidget {
  @override
  _AComprarPageState createState() => _AComprarPageState();
}

class _AComprarPageState extends State<AComprarPage> {
  // LLaves par alos formularios
  final _formKeyProductoAComprar = GlobalKey<FormState>();

  // Estilos
  TextStyle textStyle = TextStyle(color: kTextoDarkColor);
  OutlineInputBorder inputBorderTexto = OutlineInputBorder(
      borderSide: new BorderSide(
        color: kTextoColor,
      ),
      borderRadius: BorderRadius.circular(6.0));

  TextEditingController descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _retornaMenu(context);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: kColorTarjeta.withAlpha(100),
              child: Form(
                key: _formKeyProductoAComprar,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Ingrese el producto que desea comprar",
                        style: GoogleFonts.montserratAlternates(
                            color: kTextoDarkColor, fontSize: 14.0), //
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 7.0),
                      child: TextFormField(
                        validator: (valor) {
                          if (valor.isEmpty) {
                            return "Ingrese descripción producto a comprar";
                          }
                          return null;
                        },
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 3,
                        controller: descripcionController,
                        decoration: InputDecoration(
                          labelText: 'Descripción producto',
                          labelStyle: textStyle,
                          enabledBorder: inputBorderTexto,
                          focusedBorder: inputBorderTexto,
                          errorBorder: inputBorderTexto,
                          focusedErrorBorder: inputBorderTexto,
                        ),
                      ),
                    ),
                    registrarNuevoProductoComprar(context),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Divider(
              color: kColorTarjetaOtro,
              height: 2.0,
              thickness: 1,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 10.0,
                left: 10.0,
                right: 10.0,
              ),
              child: Text("Lista de productos a comparar"),
            ),
            listaProductos(context),
          ],
        ),
      ),
    );
  }

  void _retornaMenu(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MenuPage()));
  }

  Widget registrarNuevoProductoComprar(BuildContext context) {
    return Container(
      margin: new EdgeInsets.only(top: 5.0),
      width: MediaQuery.of(context).size.width * 0.90,
      child: ElevatedButton(
        onPressed: () {
          FocusScope.of(context).unfocus();
          // verifica si la informacion esta validada.
          if (_formKeyProductoAComprar.currentState.validate()) {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Información"),
                    content:
                        Text("Desea registrar el nuevo producto a comprar?"),
                    actions: [
                      OutlinedButton(
                        onPressed: () {
                          // Envia para guardar
                          guardarRegistroAComprar(context);
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

  // Metodo para gurdar la informacion de la producto a compra
  void guardarRegistroAComprar(BuildContext context) {
    ProductoAComprar productoAComprar = new ProductoAComprar();
    productoAComprar.observacion = descripcionController.text.trim();

    // Envia para registrar la informacion.
    DataBaseHelper.db.registraProductoAComparar(productoAComprar);
    // Envia un mensaje
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: kColorTarjeta,
      content: Text(
        'Se registro correctamente.',
        style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
      ),
    ));

    setState(() {
      descripcionController.text = "";
      listaProductos(context);
    });
    Navigator.of(context).pop();

    // Navigator.push(context,
    //     MaterialPageRoute(builder: (BuildContext context) => AComprarPage()));
  }

  Widget listaProductos(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: DataBaseHelper.db.obtieneProductoAComparar(),
        // initialData: InitialData,
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductoAComprar>> snapshot) {
          //print(snapshot.connectionState);
          // Verifica si esta esperando la data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            // retorna un lista de item.
            return _listaProductosAComprar(snapshot.data);
          }
        },
      ),
    );
  }

  Widget _listaProductosAComprar(List<ProductoAComprar> listProductoAComprar) {
    return listProductoAComprar.length > 0
        ? ListView.builder(
            itemCount: listProductoAComprar.length,
            itemBuilder: (BuildContext context, int i) {
              ProductoAComprar oProductoAComprar = listProductoAComprar[i];
              // print(snapshot.data);
              return itemProductoAComprar(context, oProductoAComprar);
            })
        : Container(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "No existen productos a comparar",
              style: TextStyle(color: kTextoDarkColor),
            ),
          );
  }

  Widget itemProductoAComprar(
      BuildContext context, ProductoAComprar oProductoAComprar) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding:
            EdgeInsets.only(top: 12.0, bottom: 0.0, left: 10.0, right: 10.0),
        decoration: BoxDecoration(
          color: kColorTarjeta,
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20.0,
                  child: ClipOval(
                      child: SvgPicture.asset(
                    "assets/icons/shopping-cart-1.svg",
                    color: kTextoLigthColor,
                    width: 25.0,
                  )),
                ),
                SizedBox(
                  width: 8.0,
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        oProductoAComprar.observacion,
                        style: TextStyle(
                            fontSize: 14, color: kIconoInactivo, height: 1.5),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${oProductoAComprar.fechaRegistro}",
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12,
                                color: kTextoDarkColor,
                                height: 1.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            // SizedBox(
            //   height: 5.0,
            // ),
            Divider(
              color: kColorTarjetaOtro,
              height: 2.0,
              thickness: 1,
            ),
            // SizedBox(
            //   height: 5.0,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _botonDetalle(context, Icons.delete, "Eliminar",
                    Colors.redAccent, oProductoAComprar),
              ],
            )
          ],
        ),
      ),
    );
  }

  _botonDetalle(BuildContext context, IconData icono, String titulo,
      Color pColor, ProductoAComprar pProductoAComprar) {
    return ElevatedButton.icon(
      onPressed: () {
        switch (titulo) {
          case "Eliminar":
            _modalEliminarProductoAComprar(context, pProductoAComprar);
            break;
          default:
        }
      },
      icon: Icon(
        icono,
        size: 14.0,
        color: Colors.white,
      ),
      label: Text(
        titulo,
        style: TextStyle(fontSize: 11.0, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
          primary: pColor.withAlpha(200),
          minimumSize: Size(90.0, 25.0),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0))),
    );
  }

  Future<void> _modalEliminarProductoAComprar(
      BuildContext context, ProductoAComprar productoAComprar) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Información"),
            content: Text(
                "Desea eliminar ${productoAComprar.observacion} de la lista?"),
            actions: [
              OutlinedButton(
                onPressed: () {
                  // Envia para eliminar
                  eliminarRegistroProductoAComprar(context, productoAComprar);
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

  //Metodo para eliminar la informacion del producto a comprar
  void eliminarRegistroProductoAComprar(
      BuildContext context, ProductoAComprar productoAComprar) {
    // Se envia para eliminar el producto a comprar
    DataBaseHelper.db
        .eliminaProductoAComparar(productoAComprar.idProductoAComprar);
    // Envia un mensaje
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: kColorTarjeta,
      content: Text(
        'Se elimino ${productoAComprar.observacion} correctamente.',
        style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
      ),
    ));

    setState(() {
      descripcionController.text = "";
      listaProductos(context);
    });
    Navigator.of(context).pop();

    // Navigator.push(context,
    //     MaterialPageRoute(builder: (BuildContext context) => AComprarPage()));
  }
}
