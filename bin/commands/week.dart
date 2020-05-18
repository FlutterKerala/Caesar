import 'dart:io' as io;

import 'package:grizzly_io/io_loader.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:teledart/teledart.dart';
import '../utils/leaderboard.dart';

Future<Message> week(Message message, TeleDart teleDart) async {

  String week;
  // get week from reponse
  RegExp exp = RegExp(r'^\/week (.+)$');
  try {
    week = exp.firstMatch(message.text).group(1);
  } catch (e) {
    return teleDart.replyMessage(message, 'Oops! Something Went Wrong');
  }

  List<List<String>> csv;
  // check if provided week is a number or not
  if (!isNumeric(week)) {
    return teleDart.replyMessage(message, 'Sorry! Invalid Week.');
  }

  final String filePath =
      join(dirname(io.Platform.script.toFilePath()), 'data', 'week$week.csv');

  try {
    //Read CSV From File And Parse
    csv = await readCsv(filePath);
  } catch (e) {
    // If file not found return not found error
    return teleDart.replyMessage(
        message, 'Oops! Cannot Find The Data For The Requested Week');
  }

  // Remove the headers
  csv.removeAt(0);

  // Sort by points
  csv.sort((b, a) => int.parse(a[2]).compareTo(int.parse(b[2])));

  Image image = await genImage(week, csv);

  io.File file = await io.File('test.png').writeAsBytes(encodePng(image));

  return teleDart.replyPhoto(message, file);

}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}
