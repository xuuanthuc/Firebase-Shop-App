import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
class Auth with ChangeNotifier {
  String _token; //gan vao cac yeu cau tiep can cac diem cuoi can xac thuc
  DateTime _expiryDate; // thoi gian het han cua _token,
  String _userID;

  Future<void> _authentication(
      String email, String password, String urlAuth) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlAuth?key=AIzaSyBCOgolIIeuNhygGu56-ppMY1VtbvsUHM4';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if(responseData['error'] != null){
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authentication(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authentication(email, password, 'signInWithPassword');
  }
}
