import 'dart:io' as io;

import 'package:grizzly_io/io_loader.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';

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

  // Adjust image height dynamically according to the lenght of the list
  int imageHeight = 100 + ((csv.length) * 25);

  Image image = Image(340, imageHeight);

  // fill image with white bg
  fill(image, getColor(255, 255, 255));

  // Draw title
  drawString(image, arial_24, 40, 10, "Week ${week}'s Leaderboard ",
      color: getColor(0, 0, 0));

  // append user data into image
  int startPoint = 50;
  for (List team in csv) {
    drawString(image, arial_24, 30, startPoint, team[1].replaceAll('@', ''),
        color: getColor(0, 0, 0));
    drawString(image, arial_24, 200, startPoint, team[2] + ' ' + (team[2] == 1 ? 'Point' : 'Points'),
        color: getColor(119, 0, 207));
    startPoint += 30;
  }
  
  io.File file = await io.File('test.png').writeAsBytes(encodePng(image));
  return teleDart.replyPhoto(message, file);
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}
