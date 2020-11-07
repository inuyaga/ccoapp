import 'package:flutter/material.dart';

showMaterialDialog(BuildContext context) {
  showAboutDialog(
      context: context, applicationVersion: '1.0', applicationLegalese: 
      """Condiciones de Compra
•	Los precios se encuentran en pesos mexicanos e incluyen I.V.A.
•	Las imágenes, características, especificaciones y precios son ilustrativos y pueden variar o cambiar sin previo aviso.
•	Los precios publicados en la página pueden variar en tienda física.
•	Todos los productos que se ofrecen se encuentran sujetos a disponibilidad y hasta agotar existencias.


Inventarios y precios
Cambios en los inventarios y precios
La disponibilidad de los productos, precios, marcas y modelos pueden variar.
Todos los precios ya incluyen el Impuesto al Valor Agregado, el precio señalado en la Oferta de Venta no es negociable, y será debidamente respetado al “Usuario”.


Cancelar una orden en línea
Para cancelar tu orden es necesario que te comuniques al WhatsApp 993 590 2904 y sigas las instrucciones que se le proporcionen.
Una vez que su pedido este en tránsito no será posible cancelar.
Cabe la posibilidad que su orden ya se haya procesado y no se pueda cancelar, en estos casos deberá proceder con la política de devoluciones.

Contáctanos
Para preguntas, dudas o comentarios sobre el estado de tu orden o la disponibilidad de un artículo, contáctanos al 9933136180 ó al WhatsApp 993 590 2904

       """,
       applicationName: "Compucopias App",
       
       );
}



showPageLicencia(BuildContext context){
  showLicensePage(
    context: context,
    applicationLegalese: """
Condiciones de Compra
•	Para procesar el pago es necesario hacer el deposito a la siguente cuenta BBVA Cuenta: 0134715950 Clave: 012790001347159500 Referencia es el numero de pedido.
•	Enviar captura de pago al siguente correo electronico computel@live.com.mx
•	Los precios se encuentran en pesos mexicanos e incluyen I.V.A.
•	Las imágenes, características, especificaciones y precios son ilustrativos y pueden variar o cambiar sin previo aviso.
•	Los precios publicados en la página pueden variar en tienda física.
•	Todos los productos que se ofrecen se encuentran sujetos a disponibilidad y hasta agotar existencias.
•	El costo de envio es de 160.0 pesos MXN.


Inventarios y precios
Cambios en los inventarios y precios
La disponibilidad de los productos, precios, marcas y modelos pueden variar.
Todos los precios ya incluyen el Impuesto al Valor Agregado, el precio señalado en la Oferta de Venta no es negociable, y será debidamente respetado al “Usuario”.


Cancelar una orden en línea
Para cancelar tu orden es necesario que te comuniques al WhatsApp 993 590 2904 y sigas las instrucciones que se le proporcionen.
Una vez que su pedido este en tránsito no será posible cancelar.
Cabe la posibilidad que su orden ya se haya procesado y no se pueda cancelar, en estos casos deberá proceder con la política de devoluciones.

Contáctanos
Para preguntas, dudas o comentarios sobre el estado de tu orden o la disponibilidad de un artículo, contáctanos al 9933136180 ó al WhatsApp 993 590 2904

       """,
       applicationName: 'Compucopias App',
       applicationVersion: '1.0',
       applicationIcon: Image(image: AssetImage('cco.png'), width: 120,)
  );
}