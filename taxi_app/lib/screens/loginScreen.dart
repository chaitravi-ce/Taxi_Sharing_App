import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './signup_screen.dart';
import '../widgets/ui_Container.dart';
import './main_screen.dart';
import '../models/profilemodel.dart';
import 'package:progress_indicators/progress_indicators.dart';

class LoginScreen extends StatefulWidget {

  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  var _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _passwordfocus = FocusNode();

  @override
  void dispose() {
    _passwordfocus.dispose();
    super.dispose();
  }

  void toggleSeen(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  dynamic showErrorDialog(String message) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'An Error Occurred!',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).primaryColor
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Okay',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> authorize() async{
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    //setState(() {
    //  _isLoading = true;
    //});
    _formKey.currentState.save();
    print(_usernameController.text);
    print(_passwordController.text);   
    final url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCE4eIGuIXww0YRBda6xsaN2fxzSiKY_cA'; 
    final response = await http.post(
      url,
      body: json.encode(
        {
          'email': _usernameController.text,
          'password': _passwordController.text,
          'returnSecureToken': true,
        },
      ),
    );
    final responseData = json.decode(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", responseData['email']);
    prefs.setString("token", responseData['idToken']);
    prefs.setString("userId", responseData['localId']);
    //final expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn'],),),);
    //prefs.setString('expiryDate', expiryDate.toString());
    print("===================================");
    print(responseData);
    if(responseData['error']!=null){
      var error = responseData['error']['message'];
      var message = 'Auth'; 
      if(error.contains('EMAIL_NOT_FOUND')){
        message = 'The entered email is not registered';
      }else if(error.contains('INVALID_EMAIL')){
        message = 'The entered Email is not valid. Please enter a valid email';
      }else if(error.contains('INVALID_PASSWORD')){
        message = 'The password you entered is incorrect';
      }
      print("hhhh============================================");    
      return showErrorDialog(message);
    }else{
      SharedPreferences prefs1 = await SharedPreferences.getInstance();
      String emailFinal = prefs1.get("email");
      print(emailFinal);
      final url = 'https://samelocationsametaxi.firebaseio.com/users.json';
      final response = await http.get(url);
      print('url fetched');
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        print('in null');
        return;
      }
      print(extractedData);
      extractedData.forEach((id, user){
      if(emailFinal == user['username']){
        print('======================================================================');
        String nameu = user['name'];
        String contactNo = user['contactNo'];
        print(nameu);
        print(contactNo);
        print(user);
        Profilee.mydefineduser=user;
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
      }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: _isLoading == true ? Center(
        child: JumpingText('Loging In...', style: TextStyle(color: Theme.of(context).primaryColor),)
      ) : Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset("assets/images/main_top.png", width: size.width*0.3,),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset("assets/images/login_bottom.png", width: size.width*0.5),
          ),
          SingleChildScrollView(
            child: Column(children: <Widget>[
              SizedBox(height: size.height*0.08),
              Text('LOGIN', style: GoogleFonts.grenze(
                fontSize: 32, 
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height*0.03,),
              SvgPicture.asset("assets/icons/login.svg"),
              SizedBox(height: size.height*0.03,),
              Form(
                key: _formKey,
                child: Column(children: <Widget>[
                UiContainer(
                  TextFormField(
                    controller: _usernameController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person, color: Theme.of(context).primaryColor,),
                      hintText: 'Username (Email ID)'
                    ),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordfocus);
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Username should not be empty';
                      }
                      if(!value.contains('@')){
                        return 'Enter a Valid Username';
                      }
                      return null;
                    },
                  ),
                  Theme.of(context).accentColor,
                  size.width*0.8,
                ),
                UiContainer(
                  TextFormField(
                    obscureText: _obscureText,
                    controller: _passwordController,
                    focusNode: _passwordfocus,
                    decoration: InputDecoration(
                      icon: Icon(
                        Icons.lock, 
                        color: Theme.of(context).primaryColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.visibility), 
                        color: Theme.of(context).primaryColor,
                        onPressed: toggleSeen,  
                      ),
                      hintText: 'Password',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Password should not be empty';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_){
                      authorize(); 
                    },
                  ),
                  Theme.of(context).accentColor,
                  size.width*0.8
                ),
              ])
              ),
              UiContainer(
                FlatButton(
                  onPressed: authorize, 
                  child: Text('Login', style: TextStyle(color: Colors.white),)
                ),
                Theme.of(context).primaryColor,
                size.width*0.4
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Text(
                  "Don't have an accout ?", 
                  style: TextStyle(
                    color: Theme.of(context).primaryColor, 
                  ),
                ),
                SizedBox(width: 5,),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed(SignUpScreen.routeName);
                  },
                  child: Text(
                    'Sign Up', 
                    style: TextStyle(
                      color: Theme.of(context).primaryColor, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ],),
              SizedBox(height: size.height*0.15),
            ],),
          ),         
        ],),
      ),
    );
  }
  
}