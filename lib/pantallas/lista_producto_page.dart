import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constantes.dart';
import 'package:eli_market/data/database_helper.dart';
import 'package:eli_market/models/categoria.dart';
import 'package:eli_market/models/producto.dart';
import 'package:eli_market/pantallas/menu_page.dart';
import 'package:eli_market/pantallas/registro_producto_page.dart';
import 'package:eli_market/pantallas/modificacion_producto_page.dart';
import 'package:eli_market/pantallas/detalle_producto_page.dart';

class ListaProductoPage extends StatefulWidget {
  //final String miProducto;
  final Categoria oCategoria;
  ListaProductoPage({this.oCategoria});

  @override
  _ListaProductoPageState createState() =>
      _ListaProductoPageState(this.oCategoria);
}

class _ListaProductoPageState extends State<ListaProductoPage> {
  Widget cusBusquedaBar;

  SvgPicture cusIconBusqueda = SvgPicture.asset(
    "assets/icons/search.svg",
    color: kTextoLigthColor,
  );
  SvgPicture cusIconBusquedaCancel = SvgPicture.asset(
    "assets/icons/cancel-close.svg",
    color: kTextoLigthColor,
  );

  _ListaProductoPageState(Categoria _oCategoria) {
    cusBusquedaBar = Text(_oCategoria.descCategoria,
        style: GoogleFonts.berkshireSwash(
          color: kTextoLigthColor,
        ));
  }
  bool _esBusqueda = false;

  List todosProductos = [];
  List itemsProducto = [];
  TextEditingController _textoBusqueda = TextEditingController();

  @override
  void initState() {
    super.initState();
    DataBaseHelper.db
        .obtieneProductoPorIdCategoria(widget.oCategoria.idCategoria)
        .then((data) {
      setState(() {
        todosProductos = data;
        itemsProducto = todosProductos;
      });
    });
  }

  void filtroBusqueda(String consulta) {
    var filtroBusquedaList = todosProductos;
    // Verifica si existe datos para buscar
    if (consulta.isNotEmpty) {
      var filtroBusquedaData = [];

      Producto producto;
      filtroBusquedaList.forEach((element) {
        producto = element;
        // verifica si existe el nombre del producto
        if (producto.descProducto
                .toLowerCase()
                .contains(consulta.toLowerCase()) ||
            producto.observacion
                .toLowerCase()
                .contains(consulta.toLowerCase())) {
          // Adiciona a la lsta de filtro.
          filtroBusquedaData.add(element);
        }
      });
      setState(() {
        // limpia la lista de items del producto filtro
        itemsProducto = [];
        // Adiciona la lista filtrada.
        itemsProducto.addAll(filtroBusquedaData);
      });
      return;
    } else {
      setState(() {
        itemsProducto = [];
        itemsProducto = todosProductos;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _retornaMenu(context);
        // Retorna un futuro para volver atras
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () => _retornaMenu(context),
            icon: SvgPicture.asset("assets/icons/back.svg",
                color: kTextoLigthColor),
          ),
          actions: [
            _esBusqueda
                ? IconButton(
                    icon: cusIconBusquedaCancel,
                    onPressed: () {
                      setState(() {
                        _textoBusqueda.text = "";
                        filtroBusqueda("");
                        this._esBusqueda = false;
                      });
                    })
                : IconButton(
                    icon: cusIconBusqueda,
                    onPressed: () {
                      setState(() {
                        this._esBusqueda = true;
                      });
                    }),
            IconButton(
                icon: SvgPicture.asset("assets/icons/shopping-cart-1.svg",
                    color: kTextoLigthColor),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistroProductoPage(
                                oCategoria: widget.oCategoria,
                              )));
                }),
          ],
          title: !_esBusqueda
              ? cusBusquedaBar
              : TextField(
                  onChanged: (value) {
                    setState(() {
                      filtroBusqueda(value);
                    });
                  },
                  controller: _textoBusqueda,
                  style: TextStyle(color: Colors.white),
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: "Ingrese texto a buscar",
                      hintStyle: TextStyle(color: kTextoLigthColor),
                      focusedBorder: new UnderlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white))),
                ),
          // title: Text(widget.oCategoria.descCategoria,
          //     style: GoogleFonts.berkshireSwash(
          //       color: kTextoLigthColor,
          //     )),
        ),
        body: _listaProductos(),
        // body: FutureBuilder(
        //   future: DataBaseHelper.db
        //       .obtieneProductoPorIdCategoria(widget.oCategoria.idCategoria),
        //   builder:
        //       (BuildContext context, AsyncSnapshot<List<Producto>> snapshot) {
        //     // Verifica si esta esperando la data
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(child: CircularProgressIndicator());
        //     } else {
        //       // retorna un lista de item.
        //       return _listaProductos(snapshot.data);
        //     }
        //   },
        // ),
      ),
    );
  }

  void _retornaMenu(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MenuPage())); //Navigator.pop(context),
  }

  Widget _listaProductos() {
    return itemsProducto.length > 0
        ? ListView.builder(
            itemCount: itemsProducto.length,
            itemBuilder: (BuildContext context, int i) {
              Producto oProducto = itemsProducto[i];
              // print(snapshot.data);
              return itemProducto(context, oProducto);
            })
        : Container(
            padding: EdgeInsets.all(20.0),
            child: Text(
                "No existen productos \nPara adicionar haga clik en el carrito(+)"),
          );
  }
  // Widget _listaProductos(List<Producto> listProducto) {
  //   return listProducto.length > 0
  //       ? ListView.builder(
  //           itemCount: listProducto.length,
  //           itemBuilder: (BuildContext context, int i) {
  //             Producto oProducto = listProducto[i];
  //             // print(snapshot.data);
  //             return itemProducto(context, oProducto);
  //           })
  //       : Container(
  //           padding: EdgeInsets.all(20.0),
  //           child: Text(
  //               "No existen productos \nPara adicionar haga clik en el carrito(+)"),
  //         );
  // }

  Widget itemProducto(BuildContext context, Producto oProducto) {
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
                  radius: 36.0,
                  child: ClipOval(
                    // borderRadius: BorderRadius.circular(36.0),
                    child: oProducto.imagen == null || oProducto.imagen.isEmpty
                        ? Image.asset(
                            "assets/imagenes/producto_ninguno.png",
                            width: 100.0,
                          )
                        : oProducto.imagen.contains('assets/im')
                            ? Image.asset(
                                oProducto.imagen,
                                width: 100.0,
                              )
                            : Image.file(
                                File(oProducto.imagen),
                                width: 100.0,
                                height: 100.0,
                                fit: BoxFit.cover,
                              ),
                  ),
                  // backgroundImage: AssetImage(oProducto.imagen),
                  // width: 100.0,
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
                        oProducto.descProducto,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: kTextoColor,
                            height: 1.5),
                      ),
                      Text(
                        oProducto.observacion,
                        // overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 15, color: kTextoDarkColor, height: 1.5),
                      ),
                      Text(
                        oProducto.lugarCompra != null &&
                                oProducto.lugarCompra != ""
                            ? "Lugar : ${oProducto.lugarCompra}"
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
                            " Bs. ${oProducto.precio}",
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 20,
                                color: kTextoDarkColor,
                                fontWeight: FontWeight.bold),
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _botonDetalle(context, Icons.delete, "Eliminar",
                    Colors.redAccent, oProducto),
                _botonDetalle(
                    context, Icons.edit, "Modificar", Colors.green, oProducto),
                _botonDetalle(context, Icons.search, "Ver detalle",
                    kPrimaryDarkColor, oProducto),
              ],
            )
          ],
        ),
      ),
    );
  }

  _botonDetalle(BuildContext context, IconData icono, String titulo,
      Color pColor, Producto pProducto) {
    return ElevatedButton.icon(
      onPressed: () {
        switch (titulo) {
          case "Eliminar":
            _modalEliminarProducto(context, pProducto);
            break;
          case "Modificar":
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ModificacionProductoPage(
                          oCategoria: widget.oCategoria,
                          oProducto: pProducto,
                        )));
            break;
          case "Ver detalle":
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetalleProductoPage(
                          oCategoria: widget.oCategoria,
                          oProducto: pProducto,
                        )));
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

  Future<void> _modalEliminarProducto(
      BuildContext context, Producto producto) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Información"),
            content: Text(
                "Desea eliminar ${producto.descProducto.toUpperCase()} de la lista?"),
            actions: [
              OutlinedButton(
                onPressed: () {
                  // Envia para eliminar
                  eliminarRegistroProducto(context, producto);
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

  void eliminarRegistroProducto(BuildContext context, Producto producto) {
    // Se envia para eliminar el producto
    DataBaseHelper.db.eliminaProducto(producto.idProducto);
    // Envia un mensaje
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: kColorTarjeta,
      content: Text(
        'Se elimino ${producto.descProducto.toUpperCase()} correctamente.',
        style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold),
      ),
    ));

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                ListaProductoPage(oCategoria: widget.oCategoria)));
  }
}

class DbHelper {}
