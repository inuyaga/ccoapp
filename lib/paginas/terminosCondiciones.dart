import 'package:flutter/material.dart';

class TerminosCondicionesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                "Condiciones de Compra",
                style: styleTitulo(),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                """•	Los precios se encuentran en pesos mexicanos e incluyen I.V.A.\n\n•	Las imágenes, características, especificaciones y precios son ilustrativos y pueden variar o cambiar sin previo aviso.\n\n•	Los precios publicados en la página pueden variar en tienda física.\n\n•	Todos los productos que se ofrecen se encuentran sujetos a disponibilidad y hasta agotar existencias.
                    """,
                style: styleCuerpo(),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Inventarios y precios",
                style: styleTitulo(),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Cambios en los inventarios y precios\nLa disponibilidad de los productos, precios, marcas y modelos pueden variar.\n  Todos los precios ya incluyen el Impuesto al Valor Agregado, el precio señalado en la Oferta de Venta no es negociable, y será debidamente respetado al “Usuario”.",
                style: styleCuerpo(),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Cancelar una orden en línea',
                style: styleTitulo(),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Para cancelar tu orden es necesario que te comuniques al WhatsApp 993 590 2904 y sigas las instrucciones que se le proporcionen.\nUna vez que su pedido este en tránsito no será posible cancelar.\nCabe la posibilidad que su orden ya se haya procesado y no se pueda cancelar, en estos casos deberá proceder con la política de devoluciones.',
                style: styleCuerpo(),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Contáctanos',
                style: styleTitulo(),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Para preguntas, dudas o comentarios sobre el estado de tu orden o la disponibilidad de un artículo, contáctanos al 9933136180 ó al WhatsApp 993 590 2904',
                style: styleCuerpo(),
              ),
                  ],
                ),
              ),
              
            ],
          ),
        
      ),
    );
  }
}

TextStyle styleTitulo() {
  return TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      fontFamily: 'KG');
}

TextStyle styleCuerpo() {
  return TextStyle(
      fontSize: 15,
      // fontWeight: FontWeight.bold
      fontFamily: 'KG');
}
