import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:ccoapp/constantes/coloresapp.dart';
import 'package:flutter/material.dart';
import 'package:ccoapp/objetos.dart';
import 'package:http/http.dart' as http;
import 'package:ccoapp/conexionesString.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DomicilioPageView extends StatefulWidget {
  final Domicilio domicilio;
  DomicilioPageView({this.domicilio});
  @override
  _DomicilioPageViewState createState() => _DomicilioPageViewState();
}

class _DomicilioPageViewState extends State<DomicilioPageView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String domnomap;
  String domcodigop;
  String domestado;
  String domdelegacion;
  String domcolonia;
  String domcalle;
  String domnumex;
  String domnuminterior;
  String domindicaciones;
  TipoDomicilio selectedDomicilio;
  String domtelefono;

  SharedPreferences preferencias;

  List<TipoDomicilio> tipouser = [
    TipoDomicilio(number: 1, texto: 'Trabajo'),
    TipoDomicilio(number: 2, texto: 'Casa'),
  ];

  Future<void> getPreferenciasShared() async {
    preferencias = await SharedPreferences.getInstance();
  }

  void getTipoDom() {
    if (this.widget.domicilio != null) {
      tipouser.forEach((element) {
        if (this.widget.domicilio.domtipo == element.number) {
          selectedDomicilio = element;
        }
      });
    }
  }

  @override
  initState() {
    super.initState();
    getPreferenciasShared();
    getTipoDom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.only(left: 40, right: 40, top: 15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                      initialValue: this.widget.domicilio != null
                          ? this.widget.domicilio.domnomap
                          : "",
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: 'Nombre y apellido',
                          labelText: 'Nombre y apellido'),
                      onSaved: (val) => setState(() => domnomap = val),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Campo requerido';
                        } else {
                          _formKey.currentState.save();
                          return null;
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    initialValue: this.widget.domicilio != null
                        ? "${this.widget.domicilio.domcodigop}"
                        : "",
                    onSaved: (val) => setState(() => domcodigop = val),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo requerido';
                      } else {
                        _formKey.currentState.save();
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Codigo postal', labelText: 'Codigo postal'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    initialValue: this.widget.domicilio != null
                        ? this.widget.domicilio.domestado
                        : "",
                    onSaved: (val) => setState(() => domestado = val),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo requerido';
                      } else {
                        _formKey.currentState.save();
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: 'Estado', labelText: 'Estado'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    initialValue: this.widget.domicilio != null
                        ? this.widget.domicilio.domdelegacion
                        : "",
                    onSaved: (val) => setState(() => domdelegacion = val),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo requerido';
                      } else {
                        _formKey.currentState.save();
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: 'Delegacion', labelText: 'Delegacion'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    initialValue: this.widget.domicilio != null
                        ? this.widget.domicilio.domcolonia
                        : "",
                    onSaved: (val) => setState(() => domcolonia = val),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo requerido';
                      } else {
                        _formKey.currentState.save();
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: 'Colonia / Asentamiento',
                        labelText: 'Colonia / Asentamiento'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    initialValue: this.widget.domicilio != null
                        ? this.widget.domicilio.domcalle
                        : "",
                    onSaved: (val) => setState(() => domcalle = val),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo requerido';
                      } else {
                        _formKey.currentState.save();
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    decoration:
                        InputDecoration(hintText: 'Calle', labelText: 'Calle'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    initialValue: this.widget.domicilio != null
                        ? "${this.widget.domicilio.domnumex}"
                        : "",
                    onSaved: (val) => setState(() => domnumex = val),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo requerido';
                      } else {
                        _formKey.currentState.save();
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'N° exterior', labelText: 'N° exterior'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    initialValue: this.widget.domicilio != null
                        ? "${this.widget.domicilio.domnuminterior}"
                        : "",
                    onSaved: (val) => setState(() => domnuminterior = val),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo requerido';
                      } else {
                        _formKey.currentState.save();
                        return null;
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'N° interior', labelText: 'N° interior'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    initialValue: this.widget.domicilio != null
                        ? this.widget.domicilio.domindicaciones
                        : "",
                    onSaved: (val) => setState(() => domindicaciones = val),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo requerido';
                      } else {
                        _formKey.currentState.save();
                        return null;
                      }
                    },
                    keyboardType: TextInputType.text,
                    maxLines: 5,
                    decoration: InputDecoration(
                        hintText:
                            'Indicaciones adicionales para entregar tus compras en esta dirección',
                        labelText:
                            'Indicaciones adicionales para entregar tus compras en esta dirección'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("¿Es tu trabajo o tu casa?"),
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: DropdownButton<TipoDomicilio>(
                      hint: Text("¿Es tu trabajo o tu casa?"),
                      isExpanded: true,
                      value: selectedDomicilio == null ? tipouser.first : selectedDomicilio,                    
                      items: tipouser.map((TipoDomicilio tipDomi) {
                        return DropdownMenuItem<TipoDomicilio>(
                            value: tipDomi, child: Text("${tipDomi.texto}"));
                      }).toList(),
                      onChanged: (TipoDomicilio value) {
                        setState(() {
                          selectedDomicilio = value;
                        });
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    initialValue: this.widget.domicilio != null
                        ? this.widget.domicilio.domtelefono
                        : "",
                    onSaved: (val) => setState(() => domtelefono = val),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo requerido';
                      } else {
                        _formKey.currentState.save();
                        return null;
                      }
                    },
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        hintText: 'Telefono de contacto',
                        labelText: 'Telefono de contacto'),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: this.widget.domicilio == null
                        ? FlatButton(
                            shape: StadiumBorder(),
                            color: Colors.amber,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                String token =
                                    preferencias.getString("token") ?? "";
                                var response = await http.post(
                                    InternetString.createDomicilio,
                                    headers: {
                                      HttpHeaders.authorizationHeader:
                                          'Token $token',
                                    },
                                    body: {
                                      'dom_nom_ap': domnomap,
                                      'dom_codigo_p': domcodigop,
                                      'dom_estado': domestado,
                                      'dom_delegacion': domdelegacion,
                                      'dom_colonia': domcolonia,
                                      'dom_calle': domcalle,
                                      'dom_num_ex': domnumex,
                                      'dom_num_interior': domnuminterior,
                                      'dom_indicaciones': domindicaciones,
                                      'dom_tipo': "${selectedDomicilio.number}",
                                      'dom_telefono': domtelefono,
                                      'dom_creador': '',
                                    });

                                if (response.statusCode == 201) {
                                  Navigator.of(context).pop(true);
                                } else if (response.statusCode == 400) {
                                  Map<String, dynamic> responseJson = json
                                      .decode(utf8.decode(response.bodyBytes));
                                  _showMyDialog(context, responseJson);
                                }
                              }
                            },
                            child: Text("Guardar"))
                        : FlatButton(
                            color: ColoresApp.primario,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                String token =
                                    preferencias.getString("token") ?? "";
                                var response = await http.put(
                                    InternetString.updateDomicilioView +
                                        "${this.widget.domicilio.id}/",
                                    headers: {
                                      HttpHeaders.authorizationHeader:
                                          'Token $token',
                                    },
                                    body: {
                                      'dom_nom_ap': domnomap,
                                      'dom_codigo_p': domcodigop,
                                      'dom_estado': domestado,
                                      'dom_delegacion': domdelegacion,
                                      'dom_colonia': domcolonia,
                                      'dom_calle': domcalle,
                                      'dom_num_ex': domnumex,
                                      'dom_num_interior': domnuminterior,
                                      'dom_indicaciones': domindicaciones,
                                      'dom_tipo': "${selectedDomicilio.number}",
                                      'dom_telefono': domtelefono,
                                      'dom_creador':
                                          "${this.widget.domicilio.domcreador}",
                                    });

                                if (response.statusCode == 200) {
                                  Navigator.of(context).pop(true);
                                } else if (response.statusCode == 400) {
                                  Map<String, dynamic> responseJson = json
                                      .decode(utf8.decode(response.bodyBytes));
                                  _showMyDialog(context, responseJson);
                                }
                              }
                            },
                            child: Text(
                              "Actualizar",
                              style: TextStyle(color: Colors.white),
                            ))),
              ],
            ),
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
