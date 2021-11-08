import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader {
   showCargando(context) {
      showDialog(
         context: context,
         builder: (_) => Material(
            type: MaterialType.transparency,
            child: WillPopScope(
               onWillPop: () async => false,
               child: Center(
                  // Aligns the container to center
                  child: Container(
                     // A simplified version of dialog.
                     child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                           SpinKitFadingCircle(
                           color: Colors.white,
                              size: 50.0,
                           )
                        ],
                     ),
                  ),
               ),
            ),
         ),
      );
   }
}
