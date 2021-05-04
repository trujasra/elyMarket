import 'dart:io';

import 'package:eli_market/models/producto_bitacora.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:eli_market/data/database_helper.dart';
import 'package:eli_market/pantallas/lista_producto_page.dart';
import 'package:eli_market/models/categoria.dart';
import 'package:eli_market/models/producto.dart';
import 'package:eli_market/constantes.dart';

class DetalleProductoPage extends StatelessWidget {
  final Producto oProducto;
  final Categoria oCategoria;
  DetalleProductoPage(
      {@required this.oCategoria, @required this.oProducto, Key key})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _retornarListaProducto(context);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () =>
                _retornarListaProducto(context), //Navigator.pop(context),
            icon: SvgPicture.asset("assets/icons/back.svg",
                color: kTextoLigthColor),
          ),
          title: Text("Más detalles del producto",
              style: GoogleFonts.berkshireSwash(
                color: kTextoLigthColor,
              )),
        ),
        body: _disenioDetalle(context),
      ),
    );
  }

  void _retornarListaProducto(BuildContext context) {
    //Navigator.of(context).pop();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListaProductoPage(
                  oCategoria: oCategoria,
                )));
  }

  Widget _disenioDetalle(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.40, //180,
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.1), BlendMode.dstATop),
            image: oProducto.imagen == null || oProducto.imagen.isEmpty
                ? AssetImage(
                    "assets/imagenes/producto_ninguno.png",
                  )
                : oProducto.imagen.contains('assets/im')
                    ? AssetImage(
                        oProducto.imagen,
                      )
                    : FileImage(
                        File(oProducto.imagen),
                      ),
          )),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  oProducto.descProducto,
                                  style: GoogleFonts.montserratAlternates(
                                    color: kPrimaryLigthColor,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Divider(
                                color: kColorTarjetaOtro,
                                height: 2.0,
                                thickness: 1,
                              ),
                              Text(
                                oProducto.observacion,
                                style: GoogleFonts.montserratAlternates(
                                    color: kTextoLigthColor, fontSize: 16.0),
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                oProducto.lugarCompra != null &&
                                        oProducto.lugarCompra != ""
                                    ? "Lugar : ${oProducto.lugarCompra}"
                                    : "",
                                style: GoogleFonts.montserratAlternates(
                                    color: kColorTarjetaOtro, fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await showDialog(
                                    context: context,
                                    builder: (_) => _mostrarImagen(
                                        context, oProducto.imagen));
                              },
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                    color: kColorTarjeta,
                                    borderRadius: BorderRadius.circular(30),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      // colorFilter: new ColorFilter.mode(
                                      //     Colors.black.withOpacity(0.1),
                                      //     BlendMode.dstATop),
                                      image: oProducto.imagen == null ||
                                              oProducto.imagen.isEmpty
                                          ? AssetImage(
                                              "assets/imagenes/producto_ninguno.png",
                                            )
                                          : oProducto.imagen
                                                  .contains('assets/im')
                                              ? AssetImage(
                                                  oProducto.imagen,
                                                )
                                              : FileImage(
                                                  File(oProducto.imagen),
                                                ),
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Bs. ${oProducto.precio}",
                              style: TextStyle(
                                fontSize: 21.0,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              oProducto.fechaModificacion == null
                                  ? "${oProducto.fechaRegistro}"
                                  : "${oProducto.fechaModificacion}",
                              style: TextStyle(
                                  fontSize: 12.0, color: kPrimaryLigthColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 20.0),
          child: Text(
            "Historial del producto",
            style: TextStyle(color: kPrimaryLigthColor),
          ),
        ),
        Expanded(
            child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0))),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
            child: Column(
              children: [
                FutureBuilder(
                    future: DataBaseHelper.db
                        .obtieneProductoBitacoraPorIdProducto(
                            oProducto.idProducto),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<ProductoBitacora>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return _listaProductoBitacora(snapshot.data, context);
                      }
                    }),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _listaProductoBitacora(
      List<ProductoBitacora> listaProductoBitacora, BuildContext context) {
    return listaProductoBitacora.length > 0
        ? Expanded(
            child: ListView.builder(
                itemCount: listaProductoBitacora.length,
                itemBuilder: (BuildContext context, int i) {
                  ProductoBitacora oProductoBitacora = listaProductoBitacora[i];
                  // print(snapshot.data);
                  return itemProductoBitacora(context, oProductoBitacora);
                }))
        : Container(
            padding: EdgeInsets.all(20.0),
            width: MediaQuery.of(context).size.width,
            child: Text(
              "No existe registros",
              style: TextStyle(color: kPrimaryColor),
            ));
  }

  Widget itemProductoBitacora(
      BuildContext context, ProductoBitacora oProductoBitacora) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding:
            EdgeInsets.only(top: 12.0, bottom: 12.0, left: 10.0, right: 10.0),
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
                GestureDetector(
                  onTap: () async {
                    await showDialog(
                        context: context,
                        builder: (_) =>
                            _mostrarImagen(context, oProductoBitacora.imagen));
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 36.0,
                    child: ClipOval(
                      // borderRadius: BorderRadius.circular(36.0),
                      child: oProductoBitacora.imagen == null ||
                              oProductoBitacora.imagen.isEmpty
                          ? Image.asset(
                              "assets/imagenes/producto_ninguno.png",
                              width: 100.0,
                            )
                          : oProductoBitacora.imagen.contains('assets/im')
                              ? Image.asset(
                                  oProductoBitacora.imagen,
                                  width: 100.0,
                                )
                              : Image.file(
                                  File(oProductoBitacora.imagen),
                                  width: 100.0,
                                  height: 100.0,
                                  fit: BoxFit.cover,
                                ),
                    ),
                    // backgroundImage: AssetImage(oProductoBitacora.imagen),
                    // width: 100.0,
                  ),
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
                        oProductoBitacora.descProducto,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: kTextoColor,
                            height: 1.5),
                      ),
                      Text(
                        oProductoBitacora.observacion,
                        // overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15, color: kTextoDarkColor, height: 1.5),
                      ),
                      Text(
                        oProductoBitacora.lugarCompra != null &&
                                oProductoBitacora.lugarCompra != ""
                            ? "Lugar : ${oProductoBitacora.lugarCompra}"
                            : "",
                        // overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14, color: kIconoInactivo, height: 1.5),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Precio: ",
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12,
                                color: kPrimaryDarkColor,
                                fontWeight: FontWeight.bold,
                                height: 1.5),
                          ),
                          Text(
                            " Bs. ${oProductoBitacora.precio}",
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 20,
                                color: kTextoDarkColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${oProductoBitacora.fechaRegistroProd}",
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
          ],
        ),
      ),
    );
  }

  Widget _mostrarImagen(BuildContext context, String imagen) {
    return Dialog(
      child: Container(
        height: 300,
        // height: MediaQuery.of(context).size.height * 0.70,
        decoration: BoxDecoration(
            color: kColorTarjeta,
            image: DecorationImage(
                image: imagen == null || imagen.isEmpty
                    ? AssetImage(
                        "assets/imagenes/producto_ninguno.png",
                      )
                    : imagen.contains('assets/im')
                        ? AssetImage(
                            imagen,
                          )
                        : FileImage(
                            File(imagen),
                          ),

                //ExactAssetImage('assets/imagenes/producto_ninguno.png'),
                fit: BoxFit.contain)),
      ),
    );
  }
}
