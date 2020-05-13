import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';

import 'commands/clear.dart';
import 'commands/details.dart';
import 'commands/registerSolo.dart';
import 'commands/registerTeam.dart';
import 'commands/start.dart';
import 'commands/week.dart';
import 'constants.dart';
import 'utils/downloadcsv.dart';

void main(List<String> args) async {
  var teleDart = TeleDart(Telegram(Constants.botKey), Event());

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
      .onCommand('registerSolo')
      .listen((Message message) => registerSolo(message, teleDart));
  
  teleDart
      .onCommand('registerTeam')
      .listen((Message message) => registerTeam(message, teleDart));

  teleDart
      .onCommand('clear')
      .listen((Message message) => clear(message, teleDart));
  
  teleDart
      .onCommand('details')
      .listen((Message message) => details(message, teleDart));

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
