import 'dart:convert';

import 'package:path/path.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'dart:io' as io;

import '../constants.dart';
import 'week.dart';

Future<Message> fetch(Message message, TeleDart teleDart) async {
  List team, solo;

  if (!Constants.sudoUsers.contains(message.from.id)) {
    return teleDart.replyMessage(message, 'Unauthorised User :/');
  }

  //getting the json File
  final io.File teamFile = io.File(join(
      dirname(io.Platform.script.toFilePath()), 'data', 'registeredTeam.json'));
  final io.File solofile = io.File(join(
      dirname(io.Platform.script.toFilePath()), 'data', 'registeredSolo.json'));

  try {
    //Decode the jsonFile to List
    team = jsonDecode(teamFile.readAsStringSync());
    solo = jsonDecode(solofile.readAsStringSync());
    String teamRes = '', soloRes = '';
    int index = 1;

    teamRes += 'Members Registered For Team\n\n';
    soloRes += 'Members Registered As Solo\n\n';

    for (Map element in team) {
      String uName;
      if (isNumeric(element['userName'])) {
        ChatMember userInfo = await teleDart.telegram
            .getChatMember(-1001256945986, int.parse(element['userName']));
        uName =
            '<a href="tg://user?id=${element['userName']}">${userInfo.user.first_name + userInfo.user.last_name ?? ""}</a>';
      } else {
        uName = '@${element['userName']}';
      }
      teamRes +=
          "${index++}. $uName with ${element['expirience']} month(s) experience 🧑‍💻\n";
    }
    index = 1;
    for (Map element in solo) {
      String uName;
      if (isNumeric(element['userName'])) {
        ChatMember userInfo = await teleDart.telegram
            .getChatMember(-1001256945986, int.parse(element['userName']));
        uName =
            '<a href="tg://user?id=${element['userName']}">${userInfo.user.first_name + userInfo.user.last_name ?? ""}</a>';
      } else {
        uName = '@${element['userName']}';
      }
      soloRes +=
          "${index++}. $uName with ${element['expirience']} month(s) experience 🧑‍💻\n";
    }

    await teleDart.replyMessage(message, soloRes,
        parse_mode: 'HTML', withQuote: true, disable_web_page_preview: true);
    return teleDart.replyMessage(message, teamRes,
        parse_mode: 'HTML', withQuote: true, disable_web_page_preview: true);
  } catch (e) {
    print(e.toString());
    return teleDart.replyMessage(message, 'Oops Something went wrong!');
  }
}
