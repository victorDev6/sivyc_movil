import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sivyc/screens/detalle_notificacion.dart';

Widget designNotificacion(BuildContext context, data, _homeState) {
   return data!.length > 0
       ? ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
               return designNotifi(data[index], context, _homeState);
            }
         )
       : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Image.asset('assets/empty.png', width: 250,),
               const Padding(
                 padding: EdgeInsets.all(12.0),
                 child: Text('No se encontraron notificaciones!', style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
               )
            ],
   );
}

Widget designNotifi(data1, BuildContext context, homeState) {
   var data = jsonDecode(data1['data']);
   return Card(
      elevation: 2,
      color: data1['read_movil'] != true ? Colors.lightBlue[50] : Colors.white,
      child: ListTile(
         title: Text(data['titulo'], textAlign: TextAlign.justify,),
         subtitle: Padding(
           padding: const EdgeInsets.only(top: 5),
           child: Text(data['supre_memo']),
         ),
         onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) => DetalleNotificacion(data1))).then((value) => {
               homeState.actualizar(data1['id'])
            });
         },
      ),
   );
}