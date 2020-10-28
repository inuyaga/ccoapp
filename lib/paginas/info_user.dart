import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:ccoapp/conexionesString.dart';
import 'package:ccoapp/constantes/coloresapp.dart';
import 'package:ccoapp/objetos.dart';
import 'package:ccoapp/paginas/domicilio.dart';
import 'package:ccoapp/paginas/userUpdate.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InfoUserView extends StatefulWidget {
  final ValueChanged<bool> refrescarParent;
  final Usuario user;
  final SharedPreferences preferencias;
  InfoUserView(this.user, this.preferencias, this.refrescarParent);

  @override
  _InfoUserViewState createState() => _InfoUserViewState();
}

class _InfoUserViewState extends State<InfoUserView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
            decoration: BoxDecoration(

                // gradient: LinearGradient(
                //   colors: [ColoresApp.primario, ColoresApp.primarioAcent]
                // )
                )),
        Positioned(
            bottom: 0,
            child: FutureBuilder(
                future: getUserInfo(this.widget.preferencias),
                builder: (BuildContext context, AsyncSnapshot snap) {
                  if (!snap.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            ColoresApp.secundario),
                      ),
                    );
                  } else {
                    return BuilderUser(snap.data, this.widget.refrescarParent);
                  }
                })),
        Positioned(
            bottom: 10,
            child: Column(
              children: [
                SizedBox(
                  width: 250,
                  child: FlatButton(
                      shape: StadiumBorder(),
                      color: ColoresApp.primario,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UsuarioUpdateView(
                                      preferencias: widget.preferencias,
                                      user: widget.user,
                                    ))).then((value) {
                          if (value != null) {
                            this.widget.refrescarParent(true);
                          }
                        });
                      },
                      child: Text(
                        "Editar información",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                SizedBox(
                  width: 250,
                  child: FlatButton(
                      shape: StadiumBorder(),
                      color: Colors.orange,
                      onPressed: () {
                        Future.delayed(const Duration(milliseconds: 1000), () {
                          widget.preferencias.clear();
                          exit(0);
                        });
                      },
                      child: Text(
                        "Cerrar Sesion",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ))
      ],
    );
  }
}

class BuilderUser extends StatefulWidget {
  final Usuario user;
  final ValueChanged<bool> refrescarParent;
  BuilderUser(this.user, this.refrescarParent);

  @override
  _BuilderUserState createState() => _BuilderUserState();
}

class _BuilderUserState extends State<BuilderUser> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.73,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            color: ColoresApp.secundario,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: -30,
                    child: Column(
                      children: [
                        ClipOval(
                          child: Image.network(
                            "https://www.nicepng.com/png/detail/136-1366211_group-of-10-guys-login-user-icon-png.png",
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              widget.user.username,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Icon(Icons.verified_user_sharp, color: Colors.blue),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${widget.user.firstname} ${widget.user.lastname}",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.4),
                              fontSize: 15),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.green,
                            ),
                            Text(
                              "${widget.user.email}",
                              style: TextStyle(color: Colors.green),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          "Domicilios",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                          color: Colors.green,
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => DomicilioPageView()))
                                .then((value) {
                              if (value != null) {
                                this.widget.refrescarParent(true);
                              }
                            });
                          }),
                    ],
                  ),
                  Container(
                    height: 230,
                    child: ListView.builder(
                        itemCount: widget.user.domicilio.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: Icon(Icons.location_city),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${widget.user.domicilio[index].descripcionlarga}",
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                DomicilioPageView(
                                                  domicilio: widget
                                                      .user.domicilio[index],
                                                )))
                                        .then((value) {
                                      if (value != null) {
                                        this.widget.refrescarParent(true);
                                      }
                                    });
                                  },
                                  child: Icon(Icons.edit),
                                )
                              ],
                            ),
                            subtitle: Text(
                                "${widget.user.domicilio[index].domcodigop}"),
                          );
                        }),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}


Future<Usuario> getUserInfo(SharedPreferences preferencias) async {
  SharedPreferences preferencias = await SharedPreferences.getInstance();
  String token = preferencias.getString("token");
  Usuario user; 
  final response = await http.get(InternetString.infouser, headers: {
    HttpHeaders.authorizationHeader: 'Token $token',
  });
  if (response.statusCode == 200) {
    var responseJson = json.decode(utf8.decode(response.bodyBytes));

    user = Usuario.fromJson(responseJson);
  }
    return user;
}