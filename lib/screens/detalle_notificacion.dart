import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sivyc/http/http_handle.dart';

class DetalleNotificacion extends StatefulWidget {
  var data1;
  DetalleNotificacion(this.data1);

  @override
  _DetalleNotificacionState createState() => _DetalleNotificacionState();
}

class _DetalleNotificacionState extends State<DetalleNotificacion> {

  @override
  void initState() {
    actualizarRead();
    super.initState();
  }

  void actualizarRead() {
    if (widget.data1['read_movil'] != true) {
      HttpHandle().updateRead(widget.data1['id'], true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = jsonDecode(widget.data1['data']);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(data['supre_memo'], style: const TextStyle(fontSize: 15),),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, right: 10, left: 10),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10,),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Asunto:', style: TextStyle(color: Colors.grey))
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(data['titulo']),
                ),
                const SizedBox(height: 20,),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Número de memorandum:', style: TextStyle(color: Colors.grey))
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(data['supre_memo']),
                ),
                const SizedBox(height: 20,),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Unidad(es):', style: TextStyle(color: Colors.grey))
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(data['supre_unidad']),
                ),
                const SizedBox(height: 20,),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Fecha del movimiento:', style: TextStyle(color: Colors.grey))
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(widget.data1['created_at']),
                ),
                const SizedBox(height: 20,),
                const Align(
                    alignment: Alignment.topLeft,
                    child: Text('Para mas información visite en el sistema sivyc:', style: TextStyle(color: Colors.grey))
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(data['url']),
                ),
                const SizedBox(height: 15,)
              ],
            ),
          ),
        ),
      ),
    );
  }

}
