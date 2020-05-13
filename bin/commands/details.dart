import 'dart:convert';
import 'package:path/path.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'dart:io' as io;

import '../constants.dart';

Future<Message> details(Message message, TeleDart teleDart) async {
  List team , solo;

  if (!Constants.sudoUsers.contains(message.from.id)) {
    return teleDart.replyMessage(message, 'Unauthorised User :/');
  }

  //getting the json File
  io.File teamFile = io.File(join(dirname(io.Platform.script.toFilePath()), 'data', 'registeredTeam.json'));
  io.File solofile = io.File(join(dirname(io.Platform.script.toFilePath()), 'data', 'registeredSolo.json'));

  try {
    //Decode the jsonFile to List
    team = jsonDecode(teamFile.readAsStringSync());
    solo = jsonDecode(solofile.readAsStringSync());

    return teleDart.replyMessage(message, 'Team : ${team.length}\nSolo : ${solo.length}\nTotal : ${team.length + solo.length}');
  } catch (e) {
    print(e.toString());
    return teleDart.replyMessage(message, 'OOPs Something went Wrong!');
  }
}
