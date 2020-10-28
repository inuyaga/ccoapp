import 'dart:convert';

import 'dart:ui';
import 'package:ccoapp/conexionesString.dart';
import 'package:ccoapp/constantes/coloresapp.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:status_alert/status_alert.dart';

class RegitrarseViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [ColoresApp.primario, ColoresApp.primarioAcent],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight)),
          ),
          Positioned(
            top: 100,
            child: Text(
              "Registro",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.height * 0.4,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(30)),
              child: FormRegistrer(),
            ),
          )
        ],
      ),
    );
  }
}

class FormRegistrer extends StatefulWidget {
  @override
  _FormRegistrerState createState() => _FormRegistrerState();
}

class _FormRegistrerState extends State<FormRegistrer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String usuario;
  String password;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 50,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                children: [
                  TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(hintText: 'Usuario'),
                    onSaved: (val) => setState(() => usuario = val),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Escriba su usuario';
                      } else {
                        _formKey.currentState.save();
                        return null;
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(hintText: 'Contraseña'),
                    obscureText: true,
                    onSaved: (val) => setState(() => password = val),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Escriba una contraseña';
                      } else {
                        _formKey.currentState.save();
                        return null;
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 10,
              child: Container(
                height: 50,
                width: 200,
                child: RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      var response = await http.post(InternetString.registrar,
                          body: {'username': usuario, 'password': password});
                      print(response.statusCode);
                      if (response.statusCode == 201) {
                        Map<String, dynamic> responseJson =
                            json.decode(response.body);
                        
                        Navigator.pop(context);
                        StatusAlert.show(
                          context,
                          duration: Duration(seconds: 4),
                          title: '${responseJson['username']}',
                          subtitle: 'Ahora inicie sesion con sus credenciales',
                          configuration: IconConfiguration(icon: Icons.done),
                          subtitleOptions: StatusAlertTextConfiguration(
                          softWrap: true, maxLines: 10)
                        );
                      } else if (response.statusCode == 400) {
                        Map<String, dynamic> responseJson = json.decode(response.body);
                        _showMyDialog(context, responseJson);
                      } else {
                        print("mal");
                      }
                    }
                  },
                  shape: StadiumBorder(),
                  padding: EdgeInsets.all(0.0),
                  child: Ink(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Registrarme",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ))
        ],
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
