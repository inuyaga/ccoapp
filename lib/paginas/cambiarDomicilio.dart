import 'dart:convert';
import 'dart:io';
import 'package:ccoapp/conexionesString.dart';
import 'package:ccoapp/constantes/coloresapp.dart';
import 'package:flutter/material.dart';
import 'package:ccoapp/objetos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CambiarDomicilioView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getDomiciliosUser(),
          builder: (BuildContext context, AsyncSnapshot snap) {
            if (!snap.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(ColoresApp.secundario),
                ),
              );
            } else {
              return BuildListDomicilios(snap.data);
            }
          }),
    );
  }

  Future<List<Domicilio>> getDomiciliosUser() async {
    List<Domicilio> domicilios = [];
    SharedPreferences preferencias = await SharedPreferences.getInstance();
    String token = preferencias.getString("token") ?? "";
    final response = await http.get(InternetString.domiciliosUser, headers: {
      HttpHeaders.authorizationHeader: 'Token $token',
    });

    if (response.statusCode == 200) {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      for (var item in responseJson) {
        Domicilio domicilio = Domicilio.fromJson(item);
        domicilios.add(domicilio);
      }
    }

    return domicilios;
  }
}

class BuildListDomicilios extends StatefulWidget {
  final List<Domicilio> domicilios;

  BuildListDomicilios(this.domicilios);

  @override
  _BuildListDomiciliosState createState() => _BuildListDomiciliosState();
}

class _BuildListDomiciliosState extends State<BuildListDomicilios> {
  Domicilio domicilioSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 90,
          child: ListView.builder(
              itemCount: widget.domicilios.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text("${widget.domicilios[index].descripcionlarga}"),
                  leading: Radio(
                      value: widget.domicilios[index],
                      groupValue: domicilioSelected,
                      onChanged: (Domicilio dom) {
                        setState(() {
                          domicilioSelected = dom;
                        });
                      }),
                );
              }),
        ),
        Expanded(
          flex: 10,
          child: Center(
              child: SizedBox(
                  width: 250,
                  child: FlatButton(
                      color: Colors.amber,
                      onPressed: () async {
                        SharedPreferences preferencias = await SharedPreferences.getInstance();
                        String token = preferencias.getString("token") ?? "";
                        final response = await http.put(InternetString.updateDomicilio+"${domicilioSelected.id}/", headers: {
                          HttpHeaders.authorizationHeader: 'Token $token',
                        }, body: {
                          'dom_activo':'true'
                        });

                        if (response.statusCode == 200) {                          
                        Navigator.of(context).pop(domicilioSelected);
                        }
                      },
                      child: Text("Guardar")))),
        )
      ],
    );
  }
}


