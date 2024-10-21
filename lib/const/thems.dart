import 'dart:math';
import 'package:flutter/material.dart';

TextStyle style({
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
}) =>
    TextStyle(
      color: color ?? Colors.white,
      fontWeight: fontWeight ?? FontWeight.bold,
      overflow: TextOverflow.fade,
      fontSize: fontSize ?? 20,
    );

// Define light theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    color: Colors.deepPurple,  // Primary color for light theme
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: TextTheme(
    bodyLarge: style(color: Colors.black),   // Replaces bodyText1
    bodyMedium: style(color: Colors.black54),  // Replaces bodyText2
    headlineLarge: style(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),  // Replaces headline1
    labelLarge: style(fontSize: 18, color: Colors.white),  // Replaces button
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  primaryColor: Colors.deepPurple,
  colorScheme: const ColorScheme.light(
    primary: Colors.deepPurple,
    secondary: Colors.deepPurpleAccent,
    error: Colors.redAccent,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    color: Colors.deepPurpleAccent,  // Primary color for dark theme
    centerTitle: true,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: TextTheme(
    bodyLarge: style(color: Colors.white),   // Replaces bodyText1
    bodyMedium: style(color: Colors.white70),  // Replaces bodyText2
    headlineLarge: style(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),  // Replaces headline1
    labelLarge: style(fontSize: 18, color: Colors.white),  // Replaces button
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  primaryColor: Colors.deepPurpleAccent,
  colorScheme: const ColorScheme.dark(
    primary: Colors.deepPurpleAccent,
    secondary: Colors.deepPurple,
    secondaryContainer: Colors.red,
    error: Colors.redAccent,
  ),
);


class AlbumArtWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hi = MediaQuery.of(context).size.height;
    final wi = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: hi/6,
          width: hi/6,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Colors.deepPurpleAccent,
          ),
        ),
        Container(
          height: hi/9,
          width: hi/9,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Colors.deepPurpleAccent[100],
          ),
        ),
        Container(
          height: hi/15,
          width: hi/15,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: Colors.white70,
          ),
        )
      ],
    );
  }
}

class StackContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final double? radius;
  final String? text;

  const StackContainer(
      {super.key, this.height, this.width, this.radius, this.text});

  @override
  Widget build(BuildContext context) {
    final hi = MediaQuery.of(context).size.height;
    final wi = MediaQuery.of(context).size.width;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: height! / 2,
          width: height! / 2,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(
                Radius.circular(radius!)
            ),
          ),
        ),
        Container(
          height: height! / 3,
          width: height! / 3,
          decoration: BoxDecoration(
            color: Colors.red[300],
            borderRadius: BorderRadius.all(
                Radius.circular(radius!)
            ),
          ),
        ),
        CurvedText(
          text: text!,
          radius: hi/5.5, // Adjust radius for the curvature
        ),
        Container(
          height: height! / 5,
          width: height! / 5,
          decoration: BoxDecoration(
            color: Colors.red[100],
            borderRadius: BorderRadius.all(
                Radius.circular(radius!)
            ),
          ),
          child: const Center(
            child: Icon(
              Icons.music_note,
              size: 50,
            ),
          ),
        ),
      ],
    );
  }
}

class CurvedText extends StatelessWidget {
  final String text;
  final double radius;

  CurvedText({required this.text, required this.radius});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(2 * radius, 2 * radius),
      painter: CurvedTextPainter(text, radius),
    );
  }
}

class CurvedTextPainter extends CustomPainter {
  final String text;
  final double radius;

  CurvedTextPainter(this.text, this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final TextStyle textStyle = TextStyle(color: Colors.white, fontSize: 18);
    final TextPainter textPainter =
    TextPainter(textAlign: TextAlign.center, textDirection: TextDirection.ltr);

    double anglePerLetter = 2 * pi /
        text.length; // Calculate angle step for each letter
    double startAngle = -pi / 2 -
        (anglePerLetter * text.length / 2); // Start angle for centered text

    for (int i = 0; i < text.length; i++) {
      // Calculate angle for each letter
      double charAngle = startAngle + (i * anglePerLetter);
      Offset charOffset = Offset(
        radius + radius * cos(charAngle),
        radius + radius * sin(charAngle),
      );

      canvas.save();
      canvas.translate(charOffset.dx, charOffset.dy);
      canvas.rotate(charAngle + pi / 2); // Rotate text to align with the curve

      textPainter.text = TextSpan(text: text[i], style: textStyle);
      textPainter.layout();
      textPainter.paint(
          canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CurvedTextPainter oldDelegate) {
    return oldDelegate.text != text || oldDelegate.radius != radius;
  }
}

