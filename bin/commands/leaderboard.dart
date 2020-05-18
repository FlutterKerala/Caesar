import 'dart:io' as io;
import 'package:image/image.dart';

Future<Image> genImage (week, csv) async {

  List data = csv.sublist(0,5);

  int canvasWidth = 1080;
  int canvasHeight = 1920;

  Image image = Image(canvasWidth, canvasHeight);

  int bgColor = getColor(18, 28, 46);
  int textColor = getColor(201, 251, 248);
  int boxColor = getColor(27, 36, 52);

  BitmapFont roboto_reg_64 = BitmapFont.fromZip(io.File("assets/roboto-reg-64.zip").readAsBytesSync());
  BitmapFont roboto_bold_64 = BitmapFont.fromZip(io.File("assets/roboto-bold-64.zip").readAsBytesSync());
  BitmapFont roboto_bold_96 = BitmapFont.fromZip(io.File("assets/roboto-bold-96.zip").readAsBytesSync());

  // fill image with bgColor
  fill(image, bgColor);

  // Draw title
  drawImage(image, decodePng(io.File("assets/logo.png").readAsBytesSync()), dstX: 150, dstY: 120);
  drawString(image, roboto_bold_64, 384, 150, "Flutter Kerala", color: textColor);
  drawString(image, roboto_bold_96, 384, 230, "Week ${week}", color: textColor);
  drawImage(image, decodePng(io.File("assets/fk-logo.png").readAsBytesSync()), dstX: 450, dstY: canvasHeight - 220);

  // append user data into image
  int startX = 60;
  int startY = 450;
  int containerWidth = 960;
  int containerHeight = 200;
  int containerMargin = 40;
  int textPadding = 40;
  int textPaddingY = 70;
  int textEnd = startX + containerWidth - textPadding;
  int textX = startX + textPadding;

  for (List team in csv) {
  
	fillRect(image, startX, startY, startX + containerWidth, startY + containerHeight, boxColor);

    drawString(image, roboto_reg_64, textX, startY + textPaddingY, team[1].replaceAll('@', ''),
        color: textColor);
    drawString(image, roboto_bold_64, textEnd - team[2].length * 40, startY + textPaddingY, team[2], color: textColor);
    startY += containerHeight + containerMargin;

  }

  return image;

}
