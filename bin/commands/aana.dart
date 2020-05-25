import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';

Future<Message> aana(Message message, TeleDart teleDart) {
  return teleDart.replyMessage(message,
      '🐘🌹💦',
      parse_mode: 'html');
}
