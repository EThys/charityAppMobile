import 'package:donation/models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:donation/utils/Endpoints.dart';
import 'package:get_storage/get_storage.dart';
import '../utils/StockageKeys.dart';
import '../utils/requetes.dart';

class AuthentificationCtrl with ChangeNotifier {
  AuthentificationCtrl({this.stockage});

  String _token = "";

  String get token {
    var locale = stockage?.read<String>(StockageKeys.tokenKey);
    return locale ?? "";
  }

  set token(String value) {
    stockage?.write(StockageKeys.tokenKey, value);
    _token = value;
  }

  UserModel _user = UserModel();
  List <UserModel> listUsers = [];
  UserModel _userAuth=UserModel();
  GetStorage? stockage;

  List<UserModel> Listregister = [];
  List<UserModel> Listlogin = [];
  bool loading = false;

  UserModel get user {
    var locale = stockage?.read(StockageKeys.userKey);
    _user = UserModel?.fromJson(locale);
    return _user;
  }
  set user(UserModel value) {
    stockage?.write(StockageKeys.userKey, value.toJson());
    _user = value;
  }

  UserModel get userPreference {
    var locale = stockage?.read(StockageKeys.userPreferenceKey);
    _user = UserModel?.fromJson(locale);
    return _user;
  }

  set userPreference(UserModel value) {
    stockage?.write(StockageKeys.userPreferenceKey, value.toJson());
    _user = value;
  }

  //LOGIN USER
  Future<HttpResponse> login(Map data) async {
    var url = "${Endpoints.loginEndpoint}";
    print("URL de connexion: $url");

    HttpResponse response = await postData(url, data);
    print(response.data);
    var test=response.data != null;
    print("azaaaaaaaaaaaaaa ${test}");

    if (test) {
      var token = response.data['token'];
      print("token${token}");
      var user = response.data['user'];

      // Stocker le token
      stockage?.write(StockageKeys.tokenKey, token);

      // // Stocker les informations de l'utilisateur
      // user = UserModel.fromJson(user);
      // this.user = user;
      //
      // print("Informations de l'utilisateur: $user");
      print("Token stocké: ${stockage?.read(StockageKeys.tokenKey)}");

      notifyListeners();
    }

    print("Données de réponse: ${response.data}");
    return response;
  }

  //REGISTER USER
  Future<HttpResponse> register(Map<String, dynamic> userData) async {
    try {
      const url = Endpoints.signUpEndpoint;
      print("URL d'inscription: $url");

      HttpResponse response = await postData(url, userData);

      print(response.data);


      if (response.status==200) {
        var token = response.data['token'];
        var user = response.data['user'];

        // Stocker le token
        stockage?.write(StockageKeys.tokenKey, token);

        // Stocker les informations de l'utilisateur
        user = UserModel.fromJson(user);
        this.user = user;

        print("Inscription réussie: Informations de l'utilisateur - $user");
        print("Token stocké: ${stockage?.read(StockageKeys.tokenKey)}");

        notifyListeners();
      } else {
        print("Échec de l'inscription: ${response.data["errors"]}");
      }

      return response;
    } catch (e) {
      print("Exception lors de l'inscription: $e");
      return HttpResponse(
        status: false,
        errorMsg: "Une erreur est survenue lors de l'inscription",
        isException: true,
      );
    }
  }

  //VERIFY-OTP

  Future<HttpResponse> verifyOtp(Map<String, dynamic> data) async {
    var url = "${Endpoints.verifyOtpEndpoint}";
    var token=stockage?.read(StockageKeys.tokenKey);
    print("URL de vérification OTP: $url");

    HttpResponse response = await postData(url, data,token:token);
    print(response.data);

    var isValidResponse = response.data != null;
    print("Réponse valide: ${isValidResponse}");

    if (isValidResponse) {
      print("Vérification OTP réussie.");
      notifyListeners();
    } else {
      print("Erreur lors de la vérification OTP: ${response.data['error']}");
    }

    print("Données de réponse: ${response.data}");
    return response;
  }

  //RESEND-OTP
  //UPDATE-PASSWORD
  //UPDATE-PROFILE


  //LOGOUT USER

  Future<HttpResponse> logout(Map data) async {
    var url = "${Endpoints.logout}";
    var tkn = stockage?.read(StockageKeys.tokenKey);
    HttpResponse response = await postData(url, data, token: tkn);
    print(response.data);

    return response;
  }

// "identifiant": "jean.dupont@example.com",
// "password": "12345678"
}
void main(){
  var ctrl=AuthentificationCtrl();
  ctrl.register(
      {
        "name":"Oleko",
        "firstname":"Samba",
        "email":"bobibazolela@gmail.com",
        "phone":"0855102655",
        "password":"12345678",
        "city":"Kinshasa",
        "country":"Congo"
    }
  );
}

