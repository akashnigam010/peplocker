import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:peplocker/model/note.dart';
import 'package:peplocker/utils/constants.dart';
import 'package:peplocker/utils/google_auth_client.dart';

class DriveClient {
  final _fileName = Constants.driveFileName;
  final _driveFolderName = Constants.driveFolderName;
  final _driveFolderMimeType = Constants.driveFolderMimeType;

  Future<signIn.GoogleSignInAccount> signInUser() async {
    final googleSignIn =
        signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.DriveFileScope]);
    final signIn.GoogleSignInAccount account = await googleSignIn.signIn();
    return account;
  }

  Future<List<Note>> parseStreamToNotes(Stream<List<int>> stream) async {
    List<int> streamData = [];
    await for (List<int> data in stream) {
      streamData.addAll(data);
    }
    var jsonString = utf8.decode(streamData);
    List<Note> notes =
        (json.decode(jsonString) as List).map((i) => Note.fromJson(i)).toList();
    return notes;
  }

  Future<List<Note>> readAllNotes() async {
    final account = await signInUser();
    if (account != null) {
      final authHeaders = await account.authHeaders;
      final authenticateClient = GoogleAuthClient(authHeaders);
      final driveApi = drive.DriveApi(authenticateClient);

      final dbFileList = await driveApi.files.list(q: "name = '$_fileName'");
      if (dbFileList.files.length > 0) {
        final drive.Media result = await driveApi.files.get(
            dbFileList.files[0].id,
            downloadOptions: drive.DownloadOptions.FullMedia);
        return parseStreamToNotes(result.stream);
      }
    }
    return [];
  }

  drive.Media getUploadMedia(List<Note> notes) {
    String jsonString = jsonEncode(notes);
    var byteArray = utf8.encode(jsonString);
    final Stream<List<int>> mediaStream =
        Future.value(byteArray).asStream().asBroadcastStream();
    return drive.Media(mediaStream, byteArray.length);
  }

  Future<void> writeNotes(List<Note> notes) async {
    final account = await signInUser();
    if (account != null) {
      final authHeaders = await account.authHeaders;
      final authenticateClient = GoogleAuthClient(authHeaders);
      final driveApi = drive.DriveApi(authenticateClient);

      var folderId;
      // search app folder
      final folderList = await driveApi.files.list(
          q: "mimeType='$_driveFolderMimeType' and name='$_driveFolderName'");
      if (folderList.files.length <= 0) {
        // create folder
        var driveFolder = new drive.File();
        driveFolder.name = _driveFolderName;
        driveFolder.mimeType = _driveFolderMimeType;
        var response = await driveApi.files.create(driveFolder, $fields: "id");
        folderId = response.id;
      } else {
        folderId = folderList.files[0].id;
      }

      // search db file inside app folder
      final dbFiles = await driveApi.files.list(q: "name = '$_fileName'");
      var dbFile = new drive.File();
      dbFile.name = _fileName;

      if (dbFiles.files.length > 0) {
        // update file
        await driveApi.files.update(dbFile, dbFiles.files[0].id,
            uploadMedia: getUploadMedia(notes));
      } else {
        // create file
        dbFile.parents = [folderId];
        await driveApi.files.create(dbFile, uploadMedia: getUploadMedia(notes));
      }
    }
  }
}
