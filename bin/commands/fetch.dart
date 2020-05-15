import 'dart:convert';

import 'package:path/path.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'dart:io' as io;

import '../constants.dart';

Future<Message> fetch(Message message, TeleDart teleDart){

  List team , solo;
  String result = '';

  if (!Constants.sudoUsers.contains(message.from.id)) {
    return teleDart.replyMessage(message, 'Unauthorised User :/');
  }

  //getting the json File
  final io.File teamFile = io.File(join(dirname(io.Platform.script.toFilePath()), 'data', 'registeredTeam.json'));
  final io.File solofile = io.File(join(dirname(io.Platform.script.toFilePath()), 'data', 'registeredSolo.json'));


  try {
    //Decode the jsonFile to List
    team = jsonDecode(teamFile.readAsStringSync());
    solo = jsonDecode(solofile.readAsStringSync());

    result += 'Team\n\n';
    team.forEach((element) => result += "${element['userName']}\t${element['expirience']}\n");

    result += '\nSolo\n\n';
    solo.forEach((element) => result += "${element['userName']}\t${element['expirience']}\n");
    
    return teleDart.replyMessage(message, result);
    
  } catch (e) {
    print(e.toString());
    return teleDart.replyMessage(message, 'Oops Something went wrong!');
  }


}