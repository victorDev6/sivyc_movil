import 'package:flutter/material.dart';

Widget ErrorComunicacion(_homeState, BuildContext context) {
   return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Image.asset('assets/error.png', width: 250,),
         const Padding(
           padding: EdgeInsets.all(10.0),
           child: Text('Ocurrio un error de comunicación con los servidores, intente de nuevo.', textAlign: TextAlign.center,),
         ),
         const Padding(
           padding: EdgeInsets.all(10.0),
           child: Text('Deslice hacia abajo para volver a intentarlo!', textAlign: TextAlign.center,),
         )
         /*Padding(
           padding: const EdgeInsets.all(15),
           child: SizedBox(
              height: 55,
              width: double.infinity,
              child: TextButton(
                 style: TextButton.styleFrom(
                     backgroundColor: Theme.of(context).primaryColor,
                     primary: Colors.white,
                     shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(12)
                     )
                 ),
                 onPressed: () {
                    _homeState.actualizarData();
                 },
                 child: const Text('Reintentar'),
              ),
           ),
         )*/
      ],
   );
}