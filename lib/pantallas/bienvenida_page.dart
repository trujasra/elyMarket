import 'package:flutter/material.dart';

import 'package:eli_market/constantes.dart';

class BienvenidaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size tamanio = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/imagenes/fondo_bienvenida.jpg"),
                  fit: BoxFit.fill,
                ),
              ),
              child: null,
            ),
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: tamanio.height * 0.60,
                    width: tamanio.width,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 130.0, top: 20.0),
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/Menu');
                          },
                          child: Text(cBotonIngreso),
                          style: ElevatedButton.styleFrom(
                              elevation: 5.0,
                              primary: kAcentColor,
                              padding: EdgeInsets.symmetric(horizontal: 30.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0))),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/Creditos');
                          },
                          child: Text(cBotonCreditos),
                          style: ElevatedButton.styleFrom(
                              elevation: 5.0,
                              primary: kAcentColor,
                              padding: EdgeInsets.symmetric(horizontal: 30.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0))),
                        ),
                        SizedBox(
                          height: 60.0,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 130.0),
                          child: Text(
                            cVersionApp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
