import 'dart:convert';
import 'package:path/path.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'dart:io' as io;

Future<Message> unregister(Message message, TeleDart teleDart) async {
  String userName;

  bool registered = true;

  List team, solo;

  //Adding user name & time of registration
  userName = message.from.username;

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
        registered = false;
        team.remove(element);
        return;
      }
    });

    if (registered) {
      solo.forEach(
        (element) {
          if (element['userName'] == userName) {
            registered = false;
            solo.remove(element);
            return;
          }
        },
      );
    }
    if (!registered) {
      return teleDart.replyMessage(
          message, 'Hey @${message.from.username} you were not registered :|');
    }

    //encoding back the user to the file
    await io.File(teamFile.path).writeAsStringSync(jsonEncode(team));
    await io.File(teamFile.path).writeAsStringSync(jsonEncode(solo));
    return teleDart.replyMessage(message,
        '@${message.from.username} you have been un-registered from this weeks challenge.');
  } catch (e) {
    print(e.toString());
    return teleDart.replyMessage(message, 'Oops Something went Wrong!');
  }
}
