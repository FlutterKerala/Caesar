import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

import 'commands/clear.dart';
import 'commands/details.dart';
import 'commands/registerSolo.dart';
import 'commands/registerTeam.dart';
import 'commands/start.dart';
import 'commands/unregister.dart';
import 'commands/week.dart';
import 'constants.dart';
import 'utils/downloadcsv.dart';
import 'dart:io' show Platform;

void main(List<String> args) async {
  Map<String, String> envVars = Platform.environment;
  
  var teleDart = TeleDart(Telegram(envVars['BOTTOKEN']), Event());

  await teleDart
      .start()
      .then((User me) => print('${me.username} is initialised'));

  teleDart
      .onCommand('start')
      .listen((Message message) => start(message, teleDart));

  teleDart
      .onCommand('week')
      .listen((Message message) => week(message, teleDart));

  teleDart
      .onCommand('registersolo')
      .listen((Message message) => registerSolo(message, teleDart));

  teleDart
      .onCommand('registerteam')
      .listen((Message message) => registerTeam(message, teleDart));

  teleDart
      .onCommand('clear')
      .listen((Message message) => clear(message, teleDart));

  teleDart
      .onCommand('details')
      .listen((Message message) => details(message, teleDart));

  teleDart
      .onCommand('unregister')
      .listen((Message message) => unregister(message, teleDart));

  teleDart.onMessage().listen((event) async {
    if (event.document != null) {
      if (Constants.sudoUsers.contains(event.from.id)) {
        await downloadCSV(event.document.file_id, event.document.file_name);
      } else {
        return teleDart.replyMessage(event, 'Unauthorized User! :/');
      }
    }
  });
}
