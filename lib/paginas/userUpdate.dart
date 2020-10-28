
import 'dart:convert';
import 'dart:io';

import 'package:ccoapp/conexionesString.dart';
import 'package:ccoapp/constantes/coloresapp.dart';
import 'package:ccoapp/objetos.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class UsuarioUpdateView extends StatefulWidget {
  final SharedPreferences preferencias;
  final Usuario user;
  UsuarioUpdateView({this.preferencias, this.user});
  @override
  _UsuarioUpdateViewState createState() => _UsuarioUpdateViewState();
}

class _UsuarioUpdateViewState extends State<UsuarioUpdateView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String nombre;

  String apellidos;

  String email;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Scaffold(
          appBar: AppBar(
      title: Text("Editar Usuario"),
      centerTitle: true,
          ),
          body: Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(30),
            child: TextFormField(
              initialValue: this.widget.user.firstname,
              onSaved: (val) => setState(() => nombre = val),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Escriba su nombre';
                } else {
                  _formKey.currentState.save();
                  return null;
                }
              },
              decoration: InputDecoration(hintText: 'Nombre', labelText: 'Nombre'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: TextFormField(
              initialValue: this.widget.user.lastname,
              onSaved: (val) => setState(() => apellidos = val),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Escriba sus apellidos';
                } else {
                  _formKey.currentState.save();
                  return null;
                }
              },
              decoration: InputDecoration(hintText: 'Apellidos', labelText: 'Apellidos'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: TextFormField(
              initialValue: this.widget.user.email,
              keyboardType: TextInputType.emailAddress,
              onSaved: (val) => setState(() => email = val),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Escriba su email';
                } else {
                  _formKey.currentState.save();
                  return null;
                }
              },
              decoration: InputDecoration(hintText: 'Email', labelText: 'Email'),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(30),
              child: FlatButton(
                  color: ColoresApp.primario,
                  onPressed: () async {
                    String token = this.widget.preferencias.getString("token");
                    if (_formKey.currentState.validate()) {
                      var response = await http.put(
                        InternetString.infouserUpdate+"${this.widget.user.id}/",
                        headers: {HttpHeaders.authorizationHeader: 'Token $token',},
                        body: {
                          'first_name': nombre, 
                          'last_name': apellidos,
                          'email': email,
                          });
                          if (response.statusCode == 200) {
                            Navigator.of(context).pop(true);
                          }if (response.statusCode == 400) {
                            Map<String, dynamic> responseJson = json.decode(utf8.decode(response.bodyBytes));
                            _showMyDialog(context ,responseJson);
                          } else {
                          }

                          print(response.statusCode);
                          print(response.body);
                    }
                  },
                  child: Text("Guardar"))), 
        ],
      ),
          ),
        ),
    );
  }
}




Future<void> _showMyDialog(
    BuildContext context, Map<String, dynamic> responseJson) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Mensaje de validacion'),
        content: Container(
          width: 90,
          height: 300,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: responseJson.length,
              itemBuilder: (BuildContext context, int index) {
                return RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text: '${responseJson.keys.elementAt(index)}\n'
                              .toUpperCase(),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: '${responseJson.values.elementAt(index)}'),
                    ],
                  ),
                );
              }),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}