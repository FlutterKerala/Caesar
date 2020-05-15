import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';

import '../constants.dart';

DateTime stopTime = DateTime.fromMillisecondsSinceEpoch(1621093829000);

Future<Message> stopreg(Message message, TeleDart teleDart) {

  if (!Constants.sudoUsers.contains(message.from.id)) {
    return teleDart.replyMessage(message, 'Unauthorised User :/');
  }

  stopTime = DateTime.now().toUtc();
  return teleDart.replyMessage(message,
      'This weeks Registration has been closed. The challenge will be announced soon');
}
