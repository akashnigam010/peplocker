import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peplocker/screens/list_notes.dart';
import 'package:peplocker/utils/app_colors.dart';
import 'package:peplocker/utils/constants.dart';
import 'package:peplocker/utils/drive_client.dart';
import 'package:peplocker/widgets/login-box.dart';
import 'package:peplocker/widgets/pep_button.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  String password = '';
  final passwordController = TextEditingController();
  bool isInvalid = false;
  String errorMessage;

  @override
  void initState() {
    super.initState();
  }

  Future<void> submitPassword() async {
    final password = passwordController.text;
    bool isError = false;
    String error;
    // password rules
    // if (password.isEmpty) {
    //   isError = true;
    //   error = Constants.emptyPW;
    // } else if (password.length < Constants.lengthPWPattern) {
    //   isError = true;
    //   error = Constants.lengthPW;
    // } else if (!Constants.lowerCasePWPattern.hasMatch(password)) {
    //   isError = true;
    //   error = Constants.lowerCasePW;
    // } else if (!Constants.upperCasePWPattern.hasMatch(password)) {
    //   isError = true;
    //   error = Constants.upperCasePW;
    // } else if (!Constants.numberPWPattern.hasMatch(password)) {
    //   isError = true;
    //   error = Constants.numberPW;
    // } else if (!Constants.specialCharPWPattern.hasMatch(password)) {
    //   isError = true;
    //   error = Constants.specialCharPW;
    // } else if (Constants.whitespacePWPattern.hasMatch(password)) {
    //   isError = true;
    //   error = Constants.whitespacePW;
    // }

    if (isError) {
      setState(() {
        isInvalid = true;
        errorMessage = error;
      });
      return;
    } else {
      setState(() {
        isInvalid = false;
      });
      final driveClient = DriveClient(password);
      // signin user - if not already signed in
      if (!(await driveClient.isSignedIn())) {
        await driveClient.signIn();
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ListNotes(
                  driveClient: driveClient,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(AppColors.primaryColor),
      body: Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Stack(
          children: <Widget>[
            LoginBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: TextField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      cursorColor: Color(AppColors.black),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(AppColors.black), fontSize: 16.0),
                      keyboardType: TextInputType.name,
                      inputFormatters: [LengthLimitingTextInputFormatter(30)],
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(AppColors.black)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(AppColors.black)),
                        ),
                        labelText: 'Enter Password',
                        labelStyle: TextStyle(color: Color(AppColors.black)),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        errorText: isInvalid ? errorMessage : null,
                        errorStyle: TextStyle(color: Color(AppColors.black)),
                      ),
                      maxLines: 1,
                      controller: passwordController,
                      onSubmitted: (String val) {
                        submitPassword();
                      },
                    ),
                  ),
                  PepButton(
                      text: 'SUBMIT',
                      onPressed: submitPassword,
                      isLoading: false),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
