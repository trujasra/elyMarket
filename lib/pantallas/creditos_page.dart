import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:eli_market/widgets/creditos_componente.dart';
import '../constantes.dart';

class CreditosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 0,
        leading: IconButton(
          icon: SvgPicture.asset("assets/icons/back.svg",
              color: kTextoLigthColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Creditos",
          style: TextStyle(color: kTextoLigthColor),
        ),
      ),
      body: CreditosComponente(),
    );
  }
}
