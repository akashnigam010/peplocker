import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peplocker/screens/list_notes.dart';
import 'package:peplocker/screens/on_boarding.dart';
import 'package:peplocker/utils/app_colors.dart';
import 'package:peplocker/utils/constants.dart';
import 'package:peplocker/utils/drive_client.dart';
import 'package:peplocker/utils/note_encrypter.dart';
import 'package:peplocker/utils/notes_repository.dart';
import 'package:peplocker/utils/utils.dart';
import 'package:peplocker/widgets/login_box.dart';
import 'package:peplocker/widgets/password.dart';
import 'package:peplocker/widgets/pep_raised_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  FocusNode focusNode = FocusNode();
  String hintText = 'Enter Password';

  @override
  void initState() {
    super.initState();
    if (widget.message != null && widget.message.isNotEmpty) {
      Utils.toast(widget.message);
    }
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        hintText = '';
      } else {
        hintText = 'Enter Password';
      }
      setState(() {});
    });
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
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => ListNotes(
                    driveClient: driveClient,
                  )),
          (route) => false);
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
      final driveClient =
          DriveClient.fromNoteEncryptor(new NoteEncrypter(password));
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
                  Password(
                    width: MediaQuery.of(context).size.width / 1.5,
                    controller: passwordController,
                    isInvalid: isInvalid,
                    errorMessage: errorMessage,
                    focusNode: focusNode,
                    hintText: hintText,
                    onSubmitted: (String val) {
                      submitPassword();
                    },
                  ),
                  SizedBox(height: 20),
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PepRaisedButton(
                          text: 'LOGIN',
                          onPressed: submitPassword,
                          isLoading: this.isLoading),
                      SizedBox(height: 10),
                      Container(
                        child: TextButton(
                            onPressed: () async {
                              await DriveClient().signOut();
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool(Constants.isFirstLaunch, true);
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OnboardingScreen()),
                                  (route) => false);
                            },
                            child: Text('Logout from Google Drive',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Color(AppColors.greyBlack),
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
