import 'dart:convert';
import 'package:path/path.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'dart:io' as io;

import '../constants.dart';

Future<Message> clear(Message message, TeleDart teleDart) async {
  if (!Constants.sudoUsers.contains(message.from.id)) {
    return teleDart.replyMessage(message, 'Unauthorised User :/');
  }

  //getting the json File
  io.File teamFile = io.File(join(
      dirname(io.Platform.script.toFilePath()), 'data', 'registeredTeam.json'));
  
  io.File soloFile = io.File(join(
      dirname(io.Platform.script.toFilePath()), 'data', 'registeredSolo.json'));

  try {
    //Decode the jsonFile to List
    await io.File(teamFile.path).writeAsStringSync(jsonEncode([]));
    await io.File(soloFile.path).writeAsStringSync(jsonEncode([]));
    return teleDart.replyMessage(message, 'Cleared');
  } catch (e) {
    print(e.toString());
    return teleDart.replyMessage(message, 'Oops Something went Wrong!');
  }
}
