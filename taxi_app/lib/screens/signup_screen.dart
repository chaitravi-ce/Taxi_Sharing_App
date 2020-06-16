import 'package:flutter/material.dart';

import './login_screen.dart';
import '../widgets/ui_Container.dart';
import '../providers/user.dart';

class SignUpScreen extends StatefulWidget {

  static const routeName = '/signup';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  bool _obscureText = true;
  bool _obscureText1 = true;
  final _phonefocus = FocusNode();
  final _usernamefocus = FocusNode();
  final _pass1focus = FocusNode();
  final _pass2focus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  void _toggleSeen(){
    setState(() {
      _obscureText = !_obscureText;
    });   
  }

  void _toggleSeen1(){
    setState(() {
      _obscureText1 = !_obscureText1;
    });
  }

  @override
  void dispose() {
    _phonefocus.dispose();
    _usernamefocus.dispose();
    _pass1focus.dispose();
    _pass2focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var _newUser = User(
      id: null,
      name: '',
      contactNo: '',
      username: '',
      password: '',
    );

    String _passcheck; 

    void submit(){
      if(_passcheck != _newUser.password){
        return;
      }
      final isValid = _formKey.currentState.validate();
      if (!isValid) {
        return;
      }
      _formKey.currentState.save();
      print(_newUser.name);
      print(_newUser.contactNo);
      print(_newUser.username);
      print(_newUser.password);
    }

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset("assets/images/signup_top.png", width: size.width*0.3,),
          ),
          SingleChildScrollView(
            child: Column(children: <Widget>[
              Text('SIGN UP', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              SizedBox(height: size.height*0.02,),
              Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  UiContainer(
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.person, color: Theme.of(context).primaryColor,),
                        hintText: 'Name'
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_phonefocus);
                      },
                      onSaved: (value) {
                        _newUser = User(
                          name: value,
                          contactNo: _newUser.contactNo,
                          username: _newUser.username,
                          password: _newUser.password,
                          id: _newUser.id,
                        );
                      }
                    ),
                    Theme.of(context).accentColor,
                  ),
                  UiContainer(
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.contact_phone, color: Theme.of(context).primaryColor,),
                        hintText: 'Contact No.'
                      ),
                      keyboardType: TextInputType.number,
                      focusNode: _phonefocus,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_usernamefocus);
                      },
                      onSaved: (value) {
                        _newUser = User(
                          name: _newUser.name,
                          contactNo: value,
                          username: _newUser.username,
                          password: _newUser.password,
                          id: _newUser.id,
                        );
                      }
                    ),
                    Theme.of(context).accentColor,
                  ),
                  UiContainer(
                    TextFormField(
                      decoration: InputDecoration(
                        icon: Icon(Icons.account_circle, color: Theme.of(context).primaryColor,),
                        hintText: 'Username'
                      ),
                      focusNode: _usernamefocus,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_pass1focus);
                      },
                      onSaved: (value) {
                        _newUser = User(
                          name: _newUser.name,
                          contactNo: _newUser.contactNo,
                          username: value,
                          password: _newUser.password,
                          id: _newUser.id,
                        );
                      }
                    ),
                    Theme.of(context).accentColor,
                  ),
                  UiContainer(
                    TextFormField(
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock, color: Theme.of(context).primaryColor,),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.visibility), 
                          color: Theme.of(context).primaryColor,
                          onPressed: _toggleSeen,
                        ),
                        hintText: 'Password',
                      ),
                      focusNode: _pass1focus,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_pass2focus);
                      },
                      onSaved: (value) {
                        _newUser = User(
                          name: _newUser.name,
                          contactNo: _newUser.contactNo,
                          username: _newUser.username,
                          password: value,
                          id: _newUser.id,
                        );
                      }
                    ),
                    Theme.of(context).accentColor,
                  ),
                  UiContainer(
                    TextFormField(
                      obscureText: _obscureText1,
                      decoration: InputDecoration(
                        icon: Icon(Icons.lock, color: Theme.of(context).primaryColor,),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.visibility), 
                          color: Theme.of(context).primaryColor,
                          onPressed: _toggleSeen1,  
                        ),
                        hintText: 'Confirm Password',
                      ),
                      focusNode: _pass2focus,
                      onSaved: (value) {
                        _passcheck = value;
                      },
                      onFieldSubmitted: (_) => submit,
                    ),
                    Theme.of(context).accentColor,
                  ),
                ])
              ),
              SignupLogin(
                FlatButton(
                  onPressed: submit, 
                  child: Text('Sign Up', style: TextStyle(color: Colors.white),)
                ),
                Theme.of(context).primaryColor,
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Text(
                  "Already have an accout ?", 
                  style: TextStyle(
                    color: Theme.of(context).primaryColor, 
                  ),
                ),
                SizedBox(width: 5,),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(LoginScreen.routeName);
                  },
                  child: Text(
                    'Login', 
                    style: TextStyle(
                      color: Theme.of(context).primaryColor, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ],)
            ],),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset("assets/images/main_bottom.png", width: size.width*0.23),
          )
        ],),
      ),
    );
  }
}