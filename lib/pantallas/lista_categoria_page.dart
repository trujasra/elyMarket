import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:eli_market/data/database_helper.dart';
import 'package:eli_market/models/categoria.dart';
import 'package:google_fonts/google_fonts.dart';
import 'lista_producto_page.dart';

import '../constantes.dart';

class ListaCategoriaPage extends StatelessWidget {
  final Random random = new Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            // height: MediaQuery.of(context).size.height * 0.10,
            height: 60.0,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                children: [
                  Text(
                    "Hola, Elizabeth",
                    style: GoogleFonts.pacifico(
                        color: kPrimaryLigthColor, fontSize: 20.0),
                  ),
                  Text(
                    "Debes de seleccionar una categoria.",
                    style: GoogleFonts.montserratAlternates(
                        color: kTextoLigthColor, fontSize: 12.0),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              // margin: EdgeInsets.only(top: 15.0),
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
                        future: DataBaseHelper.db.obtieneCategoria(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Categoria>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return _listaMenuCategoria(snapshot.data);
                          }
                        }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listaMenuCategoria(List<Categoria> listaCategoria) {
    return Expanded(
      child: Container(
        child: GridView.builder(
            itemCount: listaCategoria.length,
            padding: EdgeInsets.only(
                top: 5.0, right: kDefaultPaddin, left: kDefaultPaddin),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: kDefaultPaddin / 2,
                mainAxisSpacing: kDefaultPaddin / 2,
                childAspectRatio: 0.88),
            itemBuilder: (BuildContext context, int index) {
              Categoria oCategoria = listaCategoria[index];
              return detalleMenuN(context, oCategoria);
            }),
      ),
    );
  }

  Widget detalleMenuN(BuildContext context, Categoria pCategoria) {
    int colorR = random.nextInt(255);
    int colorG = random.nextInt(255);
    int colorB = random.nextInt(255);
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ListaProductoPage(
                    oCategoria: pCategoria,
                  ))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
              // height: 100,
              width: 160,
              decoration: BoxDecoration(
                color: Color.fromRGBO(colorR, colorG, colorB, 0.10),
                borderRadius: BorderRadius.circular(56),
              ),
              child: Column(
                children: [
                  Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(colorR, colorG, colorB, 0.3),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(27.0),
                            bottomLeft: Radius.circular(27.0)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        // child: Image.asset(pCategoria.imagen),
                        child: pCategoria.imagen == null ||
                                pCategoria.imagen.isEmpty
                            ? Image.asset(
                                "assets/imagenes/categoria_ninguno.png",
                                width: 100.0,
                              )
                            : pCategoria.imagen.contains('assets/im')
                                ? Image.asset(
                                    pCategoria.imagen,
                                    width: 100.0,
                                  )
                                : Image(
                                    image: FileImage(File(pCategoria.imagen)),
                                    width: 100.0,
                                  ),
                      )),
                  Padding(
                    padding: EdgeInsets.only(top: 5.0),
                    child: Text(pCategoria.descCategoria,
                        style: GoogleFonts.montserratAlternates(
                          color: kPrimaryDarkColor,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.center),
                  ),
                ],
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: kDefaultPaddin),
          //   child: Text(
          //     pCategoria.descCategoria,
          //     style: TextStyle(color: kPrimaryDarkColor),
          //   ),
          // )
        ],
      ),
    );
  }
}
