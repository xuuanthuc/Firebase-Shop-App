import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token; //gan vao cac yeu cau tiep can cac diem cuoi can xac thuc
  DateTime _expiryDate; // thoi gian het han cua _token,
  String _userID;

  bool get isAuth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }
  String get userId{
    return _userID;
  }


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
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userID = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );

      notifyListeners();
      print('lay du lieu');
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({'token': _token, 'userId': _userID, 'expiryDate':_expiryDate.toIso8601String()});
      prefs.setString('userData', userData);
      print(userData);
    } catch (error) {
      throw error;
    }
  }
  Future<bool> tryAutoLogin() async {
    print('try auto login');
    final preps = await SharedPreferences.getInstance();
    if(!preps.containsKey('userData')){
      print('false');
      return false;

    }
    final _extracedUserData = jsonDecode(preps.getString('userData')) as Map<String, Object>;
    // print(_extracedUserData);
    _token = _extracedUserData['token'];
    _userID = _extracedUserData['userId'];
    _expiryDate = DateTime.parse(_extracedUserData['expiryDate']);
    print(_token);
    print(_userID);
    notifyListeners();

    return true;
  }
  Future<void> signup(String email, String password) async {
    return _authentication(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authentication(email, password, 'signInWithPassword');
  }

  void loggout() async {
    _userID = null;
    _token = null;
    _expiryDate = null;
    notifyListeners();
    final preps = await SharedPreferences.getInstance();
    preps.clear();
  }
}
