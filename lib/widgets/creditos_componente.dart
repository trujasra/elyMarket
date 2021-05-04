import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:eli_market/constantes.dart';

class CreditosComponente extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          //color: kPrimaryColor, // comentar esto
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/imagenes/fondo_creditos.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: null,
        ),
        Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Para mi amor Elizabeth Condori: ",
                style: GoogleFonts.pacifico(
                    color: kTextoLigthColor, fontSize: 20.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Ante todo dar gracias a Dios por el talento que nos dio y a ti amor gracias por inspirarme a realizar esta App, que te sea muy util en tus actividades.\n\nAmanecer, verte cada dia y saber que estas a mi lado es mi felicidad, te amo mucho mi princesa.\n\n atte,",
                style: GoogleFonts.montserratAlternates(
                    color: kTextoLigthColor, fontSize: 14.0),
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    "assets/imagenes/firma.png",
                    width: 180,
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              )
            ],
          ),
        ),
      ],
    );
  }
}
