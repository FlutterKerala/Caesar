import 'dart:convert';
import 'package:path/path.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'dart:io' as io;

import '../constants.dart';

Future<Message> registerTeam(Message message, TeleDart teleDart) async {
  String expr;
  String userName;
  String regTime;
  io.File jsonFile;

  bool registered = false;

  List team, solo;

  // get expirience from reponse
  RegExp exp = RegExp(r'^\/registerteam (.+)$');
  try {
    expr = exp.firstMatch(message.text).group(1);
  } catch (e) {
    return teleDart.replyMessage(
      message,
      'Please provide Your expirience along with the command %0AEg: /registerteam 1',
    );
  }

  //Adding user name & time of registration
  userName = message.from.username ?? message.from.id;
  regTime = DateTime.now().toLocal().toString();

  dynamic result = {
    'userName': userName,
    'expirience': expr,
    'time': regTime,
  };

  //getting the json File
  io.File teamFile = io.File(join(
      dirname(io.Platform.script.toFilePath()), 'data', 'registeredTeam.json'));
  io.File solofile = io.File(join(
      dirname(io.Platform.script.toFilePath()), 'data', 'registeredSolo.json'));

  try {
    //Decode the jsonFile to List
    team = jsonDecode(teamFile.readAsStringSync());
    solo = jsonDecode(solofile.readAsStringSync());

    //Checking if the user Already exists
    team.forEach((element) {
      if (element['userName'] == userName) {
        registered = true;
        return;
      }
    });

    solo.forEach((element) {
      if (element['userName'] == userName) {
        registered = true;
        return;
      }
    });
    if (registered) {
      return teleDart.replyMessage(
          message, 'Hey @${message.from.username} you have already registered');
    }

    //ading and encoding back the user to the file
    team.add(result);
    await io.File(teamFile.path).writeAsStringSync(jsonEncode(team));
    return teleDart.replyMessage(message,
        '@${message.from.username} thank you for registering.\nHope to see you on the leaderBoard.');
  } catch (e) {
    print(e.toString());
    return teleDart.replyMessage(message, 'Oops Something went Wrong!');
  }
}
