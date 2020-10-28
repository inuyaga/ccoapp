import 'dart:convert';
import 'dart:ui';
import 'package:ccoapp/constantes/coloresapp.dart';
import 'package:ccoapp/objetos.dart';
import 'package:ccoapp/paginas/form_user_login.dart';
import 'package:ccoapp/paginas/info_user.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UsuarioViewPage extends StatefulWidget {
  @override
  _UsuarioViewPageState createState() => _UsuarioViewPageState();
}

class _UsuarioViewPageState extends State<UsuarioViewPage> {
  String token;
  Widget pageInitial;

  actualizarView(bool verdad) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: obtenerScreen(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (!snap.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(ColoresApp.secundario),
              ),
            );
          }
          return snap.data;
        });
  }

  Future<Widget> obtenerScreen() async {
    SharedPreferences preferencias = await SharedPreferences.getInstance();
    // preferencias.clear();
    token = preferencias.getString("token") ?? "";
    if (token == "") {
      pageInitial = FormLoginUser(this.actualizarView);
    } else {
      Usuario user =
          Usuario.fromJson(json.decode(preferencias.getString("usuario")));
      pageInitial = InfoUserView(user, preferencias, actualizarView);
    }
    return pageInitial;
  }
}





// TextStyle stiloNombre = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);


