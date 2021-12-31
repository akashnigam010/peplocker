import 'package:flutter/material.dart';
import 'package:peplocker/screens/list_notes.dart';
import 'package:peplocker/utils/app_colors.dart';
import 'package:peplocker/utils/constants.dart';
import 'package:peplocker/utils/drive_client.dart';
import 'package:peplocker/utils/note_encrypter.dart';
import 'package:peplocker/utils/notes_repository.dart';
import 'package:peplocker/utils/utils.dart';
import 'package:peplocker/widgets/password.dart';
import 'package:peplocker/widgets/pep_raised_button.dart';
import 'package:peplocker/widgets/register_box.dart';

class SetPassword extends StatefulWidget {
  final String message;
  const SetPassword({Key key, this.message}) : super(key: key);
  @override
  SetPasswordState createState() => SetPasswordState();
}

class SetPasswordState extends State<SetPassword> {
  String password = '';
  final newPWController = TextEditingController();
  final confirmPWController = TextEditingController();
  bool isInvalid = false;
  bool isLoading = false;
  String errorMessage;
  FocusNode newPWFocusNode = FocusNode();
  FocusNode confirmPWFocusNode = FocusNode();
  String newPWHintText = 'Enter Password';
  String confirmPWHintText = 'Re-enter Password';

  bool isNewPWInvalid = false;
  bool isConfirmPWInvalid = false;

  String errorMessageNewPW;
  String errorMessageConfirmPW;

  @override
  void initState() {
    super.initState();
    if (widget.message != null && widget.message.isNotEmpty) {
      Utils.toast(widget.message);
    }
    newPWFocusNode.addListener(() {
      if (newPWFocusNode.hasFocus) {
        newPWHintText = '';
      } else {
        newPWHintText = 'Enter Password';
      }
      setState(() {});
    });
    confirmPWFocusNode.addListener(() {
      if (confirmPWFocusNode.hasFocus) {
        confirmPWHintText = '';
      } else {
        confirmPWHintText = 'Re-enter Password';
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
        Utils.toast('''Password already exists for this account !
Please use the same password.''');
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
    final newPW = newPWController.text;
    final newPWValidationResult = Utils.checkPassword(newPW);
    if (newPWValidationResult.hasError) {
      setState(() {
        this.isNewPWInvalid = true;
        this.errorMessageNewPW = newPWValidationResult.errorMessage;
      });
      return;
    } else {
      setState(() {
        this.isNewPWInvalid = false;
      });
    }
    final newConfirmPW = confirmPWController.text;
    final newConfirmPWValidationResult = Utils.checkPassword(newConfirmPW);
    if (newConfirmPWValidationResult.hasError) {
      setState(() {
        this.isConfirmPWInvalid = true;
        this.errorMessageConfirmPW = newConfirmPWValidationResult.errorMessage;
      });
      return;
    }
    if (newPW != newConfirmPW) {
      setState(() {
        this.isConfirmPWInvalid = true;
        this.errorMessageConfirmPW = 'Passwords don\'t match with each other';
      });
      return;
    } else {
      setState(() {
        this.isConfirmPWInvalid = false;
      });
    }

    final driveClient = DriveClient.fromNoteEncryptor(new NoteEncrypter(newPW));
    // signin user - if not already signed in
    showLoader(true);
    await driveClient.signIn();
    showLoader(false);
    await initializeRepoAndNavigateToHome(driveClient);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final node = FocusScope.of(context);
    return Scaffold(
      backgroundColor: Color(AppColors.primaryColor),
      body: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 40.0),
          child: Stack(
            children: <Widget>[
              RegisterBox(
                title: 'SET PASSWORD',
                height: height / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Password(
                      width: width / 1.5,
                      controller: newPWController,
                      isInvalid: isNewPWInvalid,
                      errorMessage: errorMessageNewPW,
                      focusNode: newPWFocusNode,
                      hintText: newPWHintText,
                      onEditingComplete: () => node.nextFocus(),
                    ),
                    Password(
                      width: width / 1.5,
                      controller: confirmPWController,
                      isInvalid: isConfirmPWInvalid,
                      errorMessage: errorMessageConfirmPW,
                      focusNode: confirmPWFocusNode,
                      hintText: confirmPWHintText,
                      onSubmitted: (_) {
                        node.unfocus();
                        submitPassword();
                      },
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        PepRaisedButton(
                            text: 'Set Password',
                            onPressed: submitPassword,
                            isLoading: this.isLoading),
                        Container(
                          child: TextButton(
                              onPressed: () => Utils.showSimpleDialog(
                                  Text(Constants.passwordRules), true, context),
                              child: Text('Password Rules?',
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
      ),
    );
  }
}
