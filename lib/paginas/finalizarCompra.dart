import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:ccoapp/objetos.dart';
import 'package:ccoapp/paginas/home.dart';
import 'package:ccoapp/paginas/terminosCondiciones.dart';
import 'package:http/http.dart' as http;
import 'package:ccoapp/conexionesString.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:ccoapp/constantes/coloresapp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final oCcy = new NumberFormat("#,##0.00", "en_US");

class FinalizarCompraView extends StatefulWidget {
  final double totalpedido;
  final Domicilio domicilio;

  FinalizarCompraView({@required this.totalpedido, @required this.domicilio});

  @override
  _FinalizarCompraViewState createState() => _FinalizarCompraViewState();
}

class _FinalizarCompraViewState extends State<FinalizarCompraView> {
  double costoEnvio = 160.0;
  bool loading = false;

  void startloading() {
    setState(() {
      loading = true;
    });
  }

  void stoploading() {
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [ColoresApp.primario, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total Compra:",
                      style: getStylo(),
                    ),
                    Text(
                      r'$' + "${oCcy.format(widget.totalpedido)}",
                      style: getStylo(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Costo de Envio:",
                      style: getStylo(),
                    ),
                    Text(
                      r'$' + "${oCcy.format(costoEnvio)}",
                      style: getStylo(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total pedido:",
                      style: getStylo(),
                    ),
                    Text(
                      r'$' + "${oCcy.format(widget.totalpedido + costoEnvio)}",
                      style: getStylo(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                child: Text(
                  "Terminos y Condiciones",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.blue[900],
                      fontSize: 16),
                ),
                onTap: () {

                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TerminosCondicionesView()));
                  // Navigator.of(context).push(PageRouteBuilder(
                  //   opaque: false,
                  //   pageBuilder: (BuildContext context, _,__)=>TerminosCondicionesView()));
                  
                },
              ),
              SizedBox(
                height: 15,
              ),
              loading == false
                  ? FlatButton(
                      shape: StadiumBorder(),
                      color: Colors.amber,
                      onPressed: () async {
                        startloading();
                        // await Future.delayed(Duration(seconds: 8));
                        SharedPreferences preferencias =
                            await SharedPreferences.getInstance();
                        String token = preferencias.getString("token") ?? "";
                        try {
                          var response = await http
                              .post(InternetString.endCompra, headers: {
                            HttpHeaders.authorizationHeader: 'Token $token',
                          }, body: {
                            'IDomicilio': "${this.widget.domicilio.id}"
                          });

                          if (response.statusCode == 201) {
                            Map<String, dynamic> responseJson =
                                json.decode(utf8.decode(response.bodyBytes));
                            mostraAlerta(
                                context: context,
                                titulo: 'Pedido Finalizado',
                                cuerpo: ListBody(
                                  children: [
                                    Text("Pedido N° ${responseJson['idCompraWeb']}"),
                                    Text("COMPUCOPIAS"),
                                    Text("BBVA"),
                                    Text("BANCOMER"),
                                    Text("CUENTA"),
                                    Text("0134715950"),
                                    Text("CLABE"),
                                    Text("012790001347159500"),
                                    Text("Enviar captura al Email computel@live.com.mx"),
                                  ],
                                ));
                          }
                        } on SocketException {
                          print("Sin internet");
                        } on HttpException {
                          print("Servicio es unaviable");
                        } catch (e) {
                          print(e);
                        } finally {
                          stoploading();
                        }
                      },
                      child: Text("Finalizar pedido"))
                  : SizedBox(
                      height: 100,
                      width: 100,
                      child: LoadingIndicator(
                          indicatorType: Indicator.values[12],
                          color: Colors.amber),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle getStylo() {
  return TextStyle(
      color: Colors.white,
      fontSize: 25,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontFamily: 'KG');
}

Future<void> mostraAlerta({
  BuildContext context,
  String titulo,
  ListBody cuerpo,
}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(titulo),
        content: SingleChildScrollView(
          child: cuerpo,
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomeView()),
                  (route) => false);
            },
          ),
        ],
      );
    },
  );
}


