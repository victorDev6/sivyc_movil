import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sivyc/alerts/loader.dart';
import 'package:sivyc/http/http_handle.dart';
import 'package:sivyc/screens/home.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

   bool _showPassword = false;
   final _formKey = GlobalKey<FormState>();
   final EmailController = TextEditingController();
   final PassController = TextEditingController();
   late SharedPreferences sharedPreferences;
   final GlobalKey<ScaffoldState> _scaffoldstate= new GlobalKey<ScaffoldState>();

   void showSnackBar(String texto) {
      final snackBar = SnackBar(
         content: Text(texto),
         padding: const EdgeInsets.all(15),
         backgroundColor: Theme.of(context).primaryColor,
         duration: const Duration(seconds: 15),

      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
   }

  @override
  Widget build(BuildContext context) {
    return Form(
       key: _formKey,
       autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Scaffold(
         key: _scaffoldstate,
         backgroundColor: Colors.white,
        body: Padding(
           padding: const EdgeInsets.all(25),
           child: Center(
             child: SingleChildScrollView(
               child: Column(
                  children: [
                     const SizedBox(height: 20,),
                     Image.asset('assets/sivyc.png', width: 250,),
                     const SizedBox(height: 25,),
                     const Text('Bienvenido',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        ),
                     ),
                     Text('Iniciar sesion para continuar',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[400]
                        ),
                     ),
                     const SizedBox(height: 20,),
                     Container(
                        decoration: BoxDecoration(
                           color: Colors.grey[100],
                           borderRadius: BorderRadius.circular(15)
                        ),
                        child: TextFormField(
                           controller: EmailController,
                           validator: (value) {
                              if (value == null || value.isEmpty) {
                                 return 'Ingrese su correo electronico';
                              } else if (!EmailValidator.validate(value)) {
                                 return 'Ingrese un correo valido';
                              }
                              return null;
                           },
                           style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 20
                           ),
                           decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: const Icon(Icons.mail, size: 30,),
                              labelText: 'Correo electronico',
                              labelStyle: TextStyle(
                                 fontSize: 18,
                                 color: Colors.grey[400],
                                 fontWeight: FontWeight.w800
                              )
                           ),
                        ),
                     ),
                     const SizedBox(height: 10,),
                     Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: TextFormField(
                           controller: PassController,
                           validator: (value) {
                              if (value == null || value.isEmpty) {
                                 return 'Ingrese su contraseña';
                              }
                              return null;
                           },
                           obscureText: !_showPassword,
                           style: TextStyle(
                               color: Theme.of(context).primaryColor,
                               fontWeight: FontWeight.w600,
                               fontSize: 20
                           ),
                           decoration: InputDecoration(
                               border: InputBorder.none,
                               prefixIcon: const Icon(Icons.lock, size: 30,),
                               labelText: 'Contraseña',
                               labelStyle: TextStyle(
                                   fontSize: 18,
                                   color: Colors.grey[400],
                                   fontWeight: FontWeight.w800
                               ),
                              suffixIcon: IconButton(
                                 icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off, color: Theme.of(context).primaryColor,),
                                 onPressed: () {
                                    setState(() {
                                      _showPassword = !_showPassword;
                                    });
                                 },
                              ),
                           ),
                        ),
                     ),
                     const SizedBox(height: 60,),
                     SizedBox(
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
                              if (_formKey.currentState!.validate()) {
                                 Loader().showCargando(context);
                                 FirebaseMessaging.instance.getToken().then((token) => {
                                    HttpHandle().auth(EmailController.text, PassController.text, token.toString()).then((value) async {
                                       Navigator.of(context).pop();
                                       if (value == 'error') {
                                          showSnackBar('Ocurrio un error de comunicación con los servidores, intente de nuevo.');
                                       } else {
                                          if (value == 'noExiste') {
                                             showSnackBar('No se encontro el usuario. Verifique que los datos ingresados estan escritos correctamente!');
                                          } else {
                                             sharedPreferences = await SharedPreferences.getInstance();
                                             sharedPreferences.setString('correo', EmailController.text);
                                             sharedPreferences.setString('name', value['name']);
                                             sharedPreferences.setInt('id_sivyc', value['id']);
                                             Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Home()), (route) => false);
                                          }
                                       }
                                    })
                                 });
                              }
                           },
                           child: const Text('Iniciar sesion'),
                        ),
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

