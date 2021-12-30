import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peplocker/screens/list_notes.dart';
import 'package:peplocker/utils/app_colors.dart';
import 'package:peplocker/utils/constants.dart';
import 'package:peplocker/utils/drive_client.dart';
import 'package:peplocker/utils/note_encrypter.dart';
import 'package:peplocker/utils/notes_repository.dart';
import 'package:peplocker/utils/utils.dart';
import 'package:peplocker/widgets/login_box.dart';
import 'package:peplocker/widgets/pep_raised_button.dart';

class Login extends StatefulWidget {
  final String message;
  const Login({Key key, this.message}) : super(key: key);
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  String password = '';
  final passwordController = TextEditingController();
  bool isInvalid = false;
  bool isLoading = false;
  String errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.message != null && widget.message.isNotEmpty) {
      Utils.toast(widget.message);
    }
  }

  void showLoader(bool flag) {
    setState(() {
      this.isLoading = flag;
    });
  }

  Future<void> initializeRepoAndNavigateToHome(DriveClient driveClient) async {
    showLoader(true);
    if (driveClient != null) {
      var notes = [];
      try {
        notes = await driveClient.readAllNotes();
      } on ArgumentError {
        showLoader(false);
        Utils.toast('Incorrect password');
        return;
      }
      NotesRepositoryFactory.createRepository(driveClient, notes);
      showLoader(false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ListNotes(
                  driveClient: driveClient,
                )),
      );
    }
  }

  Future<void> submitPassword() async {
    FocusScope.of(context).unfocus();
    final password = passwordController.text;
    // check password rules
    final validationResult = Utils.checkPassword(password);
    if (validationResult.hasError) {
      setState(() {
        isInvalid = true;
        errorMessage = validationResult.errorMessage;
      });
      return;
    } else {
      setState(() {
        isInvalid = false;
      });
      final driveClient = DriveClient.fromNoteEncryptor(new NoteEncrypter(password));
      // signin user - if not already signed in
      showLoader(true);
      await driveClient.signIn();
      showLoader(false);
      await initializeRepoAndNavigateToHome(driveClient);
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
                          color: Color(AppColors.black), fontSize: 20.0),
                      keyboardType: TextInputType.text,
                      inputFormatters: [LengthLimitingTextInputFormatter(30)],
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(AppColors.black)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(AppColors.black)),
                        ),
                        hintText: 'Enter Password',
                        hintStyle: TextStyle(color: Color(AppColors.lightGrey), fontSize: 18.0),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      PepRaisedButton(
                          text: 'LOGIN',
                          onPressed: submitPassword,
                          isLoading: this.isLoading),
                      Container(
                        child: TextButton(
                            onPressed: () => Utils.showSimpleDialog(
                                Text(Constants.passwordRules), true, context),
                            child: Text('Password Rules?',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Color(AppColors.lightGrey),
                                  decoration: TextDecoration.underline,
                                ))),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
