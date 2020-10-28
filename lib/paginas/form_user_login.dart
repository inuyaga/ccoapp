import 'dart:convert';
import 'package:ccoapp/widgets/mostrarAlerta.dart';
import 'package:http/http.dart' as http;
import 'package:ccoapp/conexionesString.dart';
import 'package:ccoapp/constantes/coloresapp.dart';
import 'package:ccoapp/paginas/registrar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormLoginUser extends StatefulWidget {
  // final VoidCallback refrescarParent;
  final ValueChanged<bool> refrescarParent;
  FormLoginUser(this.refrescarParent);
  @override
  _FormLoginUserState createState() => _FormLoginUserState();
}

class _FormLoginUserState extends State<FormLoginUser> {
  final _formKey = GlobalKey<FormState>();
  String usuario;
  String password;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [ColoresApp.primario, ColoresApp.primarioAcent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
        ),
        Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 50, right: 50, top: 50, bottom: 100),
              child: Container(
                padding: EdgeInsets.all(20),
                // height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Inicio de Sesion",
                          style: TextStyle(
                              color: Color(0xff374ABE),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          onSaved: (val) => setState(() => usuario = val),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Usuario',
                          ),
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
                          height: 15,
                        ),
                        TextFormField(
                          onSaved: (val) => setState(() => password = val),
                          obscureText: true,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: 'Contraseña',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Escriba su contraseña';
                            } else {
                              _formKey.currentState.save();
                              return null;
                            }
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 50.0,
                          child: RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                var response = await http
                                    .post(InternetString.loginUrl, body: {
                                  'username': usuario,
                                  'password': password
                                });

                                print(response.statusCode);
                                if (response.statusCode == 200) {
                                  Map<String, dynamic> responseJson =
                                      json.decode(response.body);
                                  SharedPreferences preferencias =
                                      await SharedPreferences.getInstance();
                                  preferencias.setString(
                                      'token', responseJson['token']);
                                  preferencias.setString('usuario',
                                      json.encode(responseJson['usuario']));
                                  this.widget.refrescarParent(true);
                                } else if (response.statusCode == 403) {                                  
                                  mostraAlerta(
                                    context: context,
                                    cuerpo: ListBody(
                                      children: [
                                        Text("Usuario o contraseñas incorrectos o no existentes!.")
                                      ],
                                    ),
                                    titulo: 'Error al iniciar'
                                  );
                                }
                              }
                            },
                            shape: StadiumBorder(),
                            padding: EdgeInsets.all(0.0),
                            child: Ink(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xff374ABE),
                                      Color(0xff64B6FF)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 300.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Iniciar",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RegitrarseViewPage(),
                                    ));
                              },
                              child: Text(
                                "Registrase",
                                style: TextStyle(
                                    color: Colors.blue,
                                    // fontStyle: FontStyle.italic,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            // GestureDetector(
                            //   onTap: () {
                            //     print("Hola");
                            //   },
                            //   child: Text(
                            //     "¡Olvide mi contraseña!",
                            //     style: TextStyle(
                            //         color: Colors.blue,
                            //         // fontStyle: FontStyle.italic,
                            //         decoration: TextDecoration.underline),
                            //   ),
                            // ),
                          ],
                        )
                      ],
                    )),
              ),
            ),
          ),
        )
      ],
    );
  }
}



