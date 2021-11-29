import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpHandle {

   String path = 'http://192.168.137.52:8000';
   //String path = 'http://sivyc.icatech.gob.mx';

   Future auth(String email, String password, String token) async {
      var url = Uri.parse('$path/api/sivycMovil/login');
      try {
         var response = await http.post(url, body: {
            'email': email,
            'password': password,
            'token': token
         });
         if (response.statusCode == 200) {
            String body = utf8.decode(response.bodyBytes);
            return jsonDecode(body);
         }
         return null;
      } catch (e) {
         return 'error';
      }
   }

   Future getNotificaciones(int idUser, int page, bool isRefresh, _homeState) async {
      if (isRefresh) {
         page = 1;
      } else {
         if (page > _homeState.totalPages) {
            return 'fin';
         }
      }
      var url = Uri.parse('$path/api/sivycMovil/getNotificaciones?page=$page');
      try{
         var response = await http.post(url, body: {'idUser': idUser.toString()});
         if (response.statusCode == 200) {
            String body = utf8.decode(response.bodyBytes);
            return jsonDecode(body);
         }
         return 'errorApi';
      } catch (e) {
         return 'error';
      }
   }

   Future updateRead(String id, bool read) async {
      var url = Uri.parse('$path/api/sivycMovil/updateRead');
      try {
         var response = await http.post(url, body: {'id': id, 'read': read.toString()});
         if (response.statusCode == 200) {
            String body = utf8.decode(response.bodyBytes);
            return jsonDecode(body);
         }
         return null;
      } catch (e) {
         return e;
      }
   }

   Future updateToken(String id) async {
      var url = Uri.parse('$path/api/sivycMovil/updateToken');
      try {
         var response = await http.post(url, body: {'id': id});
         if (response.statusCode == 200) {
            String body = utf8.decode(response.bodyBytes);
            return jsonDecode(body);
         }
         return null;
      } catch (e) {
         return e;
      }
   }

}