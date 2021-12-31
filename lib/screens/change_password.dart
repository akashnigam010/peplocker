import 'package:flutter/material.dart';
import 'package:peplocker/screens/login.dart';
import 'package:peplocker/utils/app_colors.dart';
import 'package:peplocker/utils/app_lifecycle_aware_state.dart';
import 'package:peplocker/utils/drive_client.dart';
import 'package:peplocker/utils/note_encrypter.dart';
import 'package:peplocker/utils/notes_repository.dart';
import 'package:peplocker/utils/utils.dart';
import 'package:peplocker/widgets/password.dart';
import 'package:peplocker/widgets/pep_raised_button.dart';
import 'package:peplocker/widgets/register_box.dart';

class ChangePassword extends StatefulWidget {
  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends AppLifecycleAwareState<ChangePassword> {
  final currentPWController = TextEditingController();
  final newPWController = TextEditingController();
  final confirmPWController = TextEditingController();
  final FocusNode currentPWFocusNode = FocusNode();
  final FocusNode newPWFocusNode = FocusNode();
  final FocusNode confirmPWFocusNode = FocusNode();
  String currentPWHintText = 'Enter current password';
  String newPWHintText = 'Enter new password';
  String confirmPWHintText = 'Confirm password';
  bool isCurrentPWInvalid = false;
  bool isNewPWInvalid = false;
  bool isConfirmPWInvalid = false;
  String errorMessageCurrentPW;
  String errorMessageNewPW;
  String errorMessageConfirmPW;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    currentPWFocusNode.addListener(() {
      if (currentPWFocusNode.hasFocus) {
        currentPWHintText = '';
      } else {
        currentPWHintText = 'Enter current password';
      }
      setState(() {});
    });
    newPWFocusNode.addListener(() {
      if (newPWFocusNode.hasFocus) {
        newPWHintText = '';
      } else {
        newPWHintText = 'Enter new password';
      }
      setState(() {});
    });
    confirmPWFocusNode.addListener(() {
      if (confirmPWFocusNode.hasFocus) {
        confirmPWHintText = '';
      } else {
        confirmPWHintText = 'Confirm password';
      }
      setState(() {});
    });
  }

  void showLoader(bool flag) {
    setState(() {
      this.isLoading = flag;
    });
  }

  void changePassword() async {
    final currentPW = currentPWController.text;
    final currentPWValidationResult = Utils.checkPassword(currentPW);
    if (currentPWValidationResult.hasError) {
      setState(() {
        this.isCurrentPWInvalid = true;
        this.errorMessageCurrentPW = currentPWValidationResult.errorMessage;
      });
      return;
    } else {
      setState(() {
        this.isCurrentPWInvalid = false;
      });
    }
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
        this.errorMessageConfirmPW = 'Doesn\'t match with the new password';
      });
      return;
    } else {
      setState(() {
        this.isConfirmPWInvalid = false;
      });
    }

    final driveClient =
        DriveClient.fromNoteEncryptor(new NoteEncrypter(currentPW));
    showLoader(true);
    await driveClient.signIn();
    try {
      await driveClient.readAllNotes();
    } on ArgumentError {
      showLoader(false);
      setState(() {
        this.isLoading = false;
        this.isCurrentPWInvalid = true;
        this.errorMessageCurrentPW =
            'Current password is incorrect, please try again';
      });
      return;
    }
    // changing the actual password
    // update note encryptor
    driveClient.noteEncryptor = new NoteEncrypter(newPW);
    NotesRepositoryFactory.getRepository().driveClient = driveClient;
    await NotesRepositoryFactory.getRepository().syncNotes();
    showLoader(false);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => Login(
                  message: "Password changed successfully",
                )),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final node = FocusScope.of(context);
    return Scaffold(
      backgroundColor: Color(AppColors.primaryColor),
      appBar: AppBar(
        // title: Text('Change Password'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: RegisterBox(
            title: 'UPDATE PASSWORD',
            height: height / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // current password
                Password(
                  width: width / 1.5,
                  controller: currentPWController,
                  isInvalid: isCurrentPWInvalid,
                  errorMessage: errorMessageCurrentPW,
                  hintText: currentPWHintText,
                  focusNode: currentPWFocusNode,
                  onEditingComplete: () => node.nextFocus(),
                ),
                // new password
                Password(
                  width: width / 1.5,
                  controller: newPWController,
                  isInvalid: isNewPWInvalid,
                  errorMessage: errorMessageNewPW,
                  hintText: newPWHintText,
                  focusNode: newPWFocusNode,
                  onEditingComplete: () => node.nextFocus(),
                ),
                // new confirm password
                Password(
                  width: width / 1.5,
                  controller: confirmPWController,
                  isInvalid: isConfirmPWInvalid,
                  errorMessage: errorMessageConfirmPW,
                  hintText: confirmPWHintText,
                  focusNode: confirmPWFocusNode,
                  onSubmitted: (_) {
                    node.unfocus();
                    changePassword();
                  },
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: PepRaisedButton(
                      text: 'SUBMIT',
                      onPressed: changePassword,
                      isLoading: this.isLoading),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
