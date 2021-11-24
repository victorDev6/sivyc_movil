import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sivyc/alerts/loader.dart';
import 'package:sivyc/main.dart';
import 'package:sivyc/modelos/item_model.dart';
import 'package:sivyc/widgets/error_comunicacion.dart';
import '../widgets/design_notification.dart';
import 'package:sivyc/http/http_handle.dart';
import 'package:sivyc/screens/login.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

   String nombre = '';
   int currentPage = 1, id_sivic = 0;
   late int totalPages;
   bool isLoading = true, onError = false, pullUp = false;
   List notificaciones = [];
   late List<ItemModel> menuItems;
   late SharedPreferences sharedPreferences;
   final RefreshController refreshController = RefreshController(initialRefresh: true);
   final CustomPopupMenuController _controller = CustomPopupMenuController();

   @override
  void initState() {
      checkSesion();
      super.initState();
      inicializarNotificacion();
  }

   void inicializarNotificacion() {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
         RemoteNotification? notification = message.notification;
         AndroidNotification? android = message.notification!.android;
         if (notification != null && android != null) {
            flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title,
                notification.body,
                NotificationDetails(
                   android: AndroidNotificationDetails(
                      channel.id,
                      channel.name,
                      //channel.description,
                      color: Color(0xFF541533),
                      playSound: true,
                      icon: '@mipmap/launcher_icon',
                       enableVibration: true,
                      enableLights: true,
                   )
                )
            );
         }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
         RemoteNotification? notification = message.notification;
         AndroidNotification? android = message.notification!.android;
         if (notification != null && android != null) {
            if (mounted) {
               setState(() {
                 refreshController.requestRefresh();
               });
            }
         }
      });
   }

   void checkSesion() async {
      sharedPreferences = await SharedPreferences.getInstance();
      menuItems = [
         ItemModel(sharedPreferences.getString('name')!, Icons.person_outline),
         ItemModel('Cerrar sesión', Icons.arrow_back_ios_rounded),
      ];
      id_sivic = sharedPreferences.getInt('id_sivyc')!;
   }

   void actualizar(String id) {
      setState(() {
         notificaciones.asMap().forEach((key, value) {
            if (value['id'] == id) {
              notificaciones[key]['read_movil'] = true;
            }
         });
      });
   }

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
    return Scaffold(
       appBar: AppBar(
          title: const Text('Sivyc'),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
             CustomPopupMenu(
                 child: Container(
                    child: const Icon(Icons.person, color: Colors.white),
                    padding: const EdgeInsets.all(20),
                 ),
                 menuBuilder: () => ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                       color: const Color(0xFF4C4C4C),
                       child: IntrinsicWidth(
                          child: Column(
                             crossAxisAlignment: CrossAxisAlignment.stretch,
                             children: menuItems
                                 .map((item) => GestureDetector(
                                   behavior: HitTestBehavior.translucent,
                                   //onTap: _controller.hideMenu,
                                   onTap: () {
                                     if (item.title == 'Cerrar sesión') {
                                       Loader().showCargando(context);
                                       HttpHandle().updateToken(id_sivic.toString()).then((valueRes) {
                                         Navigator.of(context).pop();
                                         if (valueRes == 'success') {
                                           sharedPreferences.clear();
                                           Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (route) => false);
                                         } else {
                                           showSnackBar('Ocurrio un error, intente de nuevo por favor');
                                         }
                                       });
                                     }
                                     _controller.hideMenu();
                                   },
                                   child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Row(
                                         children: <Widget>[
                                            Icon(
                                               item.icon,
                                               size: 15,
                                               color: Colors.white,
                                            ),
                                            Expanded(
                                               child: Container(
                                                  margin: const EdgeInsets.only(left: 10),
                                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                                  child: Text(
                                                     item.title,
                                                     style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                     ),
                                                  ),
                                               ),
                                            ),
                                         ],
                                      ),
                                   ),
                                ),
                             ).toList(),
                          ),
                       ),
                    ),
                 ),
                pressType: PressType.singleClick,
                verticalMargin: -10,
                controller: _controller,
             )
          ],
       ),
       backgroundColor: Colors.white,
       body: SmartRefresher(
          footer: CustomFooter(
             builder: (BuildContext context, LoadStatus? mode) {
                Widget body;
                if(mode==LoadStatus.idle){
                   body =  const Text("pull up load!");
                } else if(mode==LoadStatus.loading){
                   body =  const CupertinoActivityIndicator();
                } else if(mode == LoadStatus.failed){
                   body = const Text("Error al cargar!");
                } else if(mode == LoadStatus.canLoading){
                   body = const Text("Suelte para cargar mas");
                } else{
                   body = const Text("Son todas las notificaciones por ahora");
                }
                return Container(
                   height: 55.0,
                   child: Center(child:body),
                );
             },
          ),
         controller: refreshController,
         enablePullUp: pullUp,
         onRefresh: () async {
            currentPage = 1;
            refreshController.resetNoData();
            final result = await HttpHandle().getNotificaciones(id_sivic, currentPage, true, this);
            if (result == 'error' || result == 'errorApi') {
               onError = true;
               pullUp = false;
               refreshController.refreshFailed();
            } else {
               pullUp = true;
               onError = false;
               notificaciones = result['data'];
               totalPages = result['last_page'];
               refreshController.refreshCompleted();
            }
            isLoading = false;
            if (mounted) {
               setState(() {});
            }
         },
          onLoading: () async {
             currentPage++;
            final result = await HttpHandle().getNotificaciones(id_sivic, currentPage, false, this);
            if (result == 'error' || result == 'errorApi') {
               refreshController.loadFailed();
            } else if (result == 'fin') {
               refreshController.loadNoData();
            } else {
               notificaciones.addAll(result['data']);
               totalPages = result['last_page'];
               refreshController.loadComplete();
            }
            setState(() {});
          },
          child: !isLoading
              ? !onError
                  ? designNotificacion(context, notificaciones, this)
                  : ErrorComunicacion(this, context)
              : const SizedBox(),

         /* child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
               child: FutureBuilder(
                   future: HttpHandle().getNotificaciones(342, currentPage, false),
                   builder: (BuildContext context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                         return const Center(child: CircularProgressIndicator(color: Color(0xFF541533),));
                      } else if (snapshot.connectionState == ConnectionState.done) {
                         if (snapshot.hasError) {
                            return ErrorComunicacion(this, context);
                         } else if (snapshot.hasData) {
                            if (snapshot.data == 'error' || snapshot.data == 'errorApi') {
                               return ErrorComunicacion(this, context);
                            }
                            //return Text('kjjk');
                            currentPage++;
                            return designNotificacion(context, snapshot.data, this);
                         } else {
                            return const Text('empty data');
                         }
                      } else {
                         return const Text('errorrrrrr');
                      }
                   }
               ),
            ),
         ), */
       ),
    );
  }


}