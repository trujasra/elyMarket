import 'package:eli_market/constantes.dart';
import 'package:flutter/material.dart';

import 'package:eli_market/pantallas/bienvenida_page.dart';
import 'package:eli_market/pantallas/menu_page.dart';
import 'package:eli_market/pantallas/creditos_page.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // bloquea la orientacion de la pantalla solo a Vertical.
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    // Para cambiar el estilo del AppBar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: kIconoInactivo,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ely Market App',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(bodyColor: kPrimaryColor),
        appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
        ),
      ),

      routes: {
        '/': (context) => BienvenidaPage(),
        '/Menu': (context) => MenuPage(),
        '/Creditos': (context) => CreditosPage(),
      },
      initialRoute: "/",
      // home: BienvenidaPage(),
    );
  }
}
