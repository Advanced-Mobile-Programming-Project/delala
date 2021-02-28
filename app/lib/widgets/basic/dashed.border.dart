import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class DashedInputBorder extends InputBorder {
  final BorderRadius borderRadius;
  final double gap;

  const DashedInputBorder({
    BorderSide borderSide = const BorderSide(),
    this.borderRadius = const BorderRadius.only(
      topLeft: Radius.circular(4.0),
      topRight: Radius.circular(4.0),
    ),
    this.gap = 4,
  })  : assert(borderRadius != null),
        super(borderSide: borderSide);

  @override
  DashedInputBorder copyWith({BorderSide borderSide}) {
    return DashedInputBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions =>
      EdgeInsets.only(bottom: borderSide.width);

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..addRect(Rect.fromLTWH(rect.left, rect.top, rect.width,
          math.max(0.0, rect.height - borderSide.width)));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  bool get isOutline => false;

  @override
  void paint(Canvas canvas, Rect rect,
      {double gapStart,
      double gapExtent = 0.0,
      double gapPercentage = 0.0,
      TextDirection textDirection}) {
    double x = rect.size.width;
    double y = rect.size.height;

    Path _bottomPath = getDashedPath(
      a: math.Point(0, y),
      b: math.Point(x, y),
      gap: gap,
    );

    canvas.drawPath(_bottomPath, borderSide.toPaint());
  }

  Path getDashedPath({
    @required math.Point<double> a,
    @required math.Point<double> b,
    @required gap,
  }) {
    Size size = Size(b.x - a.x, b.y - a.y);
    Path path = Path();
    path.moveTo(a.x, a.y);
    bool shouldDraw = true;
    math.Point currentPoint = math.Point(a.x, a.y);

    num radians = math.atan(size.height / size.width);

    num dx = math.cos(radians) * gap < 0
        ? math.cos(radians) * gap * -1
        : math.cos(radians) * gap;

    num dy = math.sin(radians) * gap < 0
        ? math.sin(radians) * gap * -1
        : math.sin(radians) * gap;

    while (currentPoint.x <= b.x && currentPoint.y <= b.y) {
      shouldDraw
          ? path.lineTo(currentPoint.x, currentPoint.y)
          : path.moveTo(currentPoint.x, currentPoint.y);
      shouldDraw = !shouldDraw;
      currentPoint = math.Point(
        currentPoint.x + dx,
        currentPoint.y + dy,
      );
    }
    return path;
  }

  @override
  ShapeBorder scale(double t) {
    return DashedInputBorder(borderSide: borderSide.scale(t));
  }
}

class DashedBoxPainter extends CustomPainter {
  final BuildContext context;
  final Color color;
  final double width;
  final double gap;

  DashedBoxPainter(this.context, {this.color, this.width, this.gap});

  Path getDashedPath({
    @required math.Point<double> a,
    @required math.Point<double> b,
    @required gap,
  }) {
    Size size = Size(b.x - a.x, b.y - a.y);
    Path path = Path();
    path.moveTo(a.x, a.y);
    bool shouldDraw = true;
    math.Point currentPoint = math.Point(a.x, a.y);

    num radians = math.atan(size.height / size.width);

    num dx = math.cos(radians) * gap < 0
        ? math.cos(radians) * gap * -1
        : math.cos(radians) * gap;

    num dy = math.sin(radians) * gap < 0
        ? math.sin(radians) * gap * -1
        : math.sin(radians) * gap;

    while (currentPoint.x <= b.x && currentPoint.y <= b.y) {
      shouldDraw
          ? path.lineTo(currentPoint.x, currentPoint.y)
          : path.moveTo(currentPoint.x, currentPoint.y);
      shouldDraw = !shouldDraw;
      currentPoint = math.Point(
        currentPoint.x + dx,
        currentPoint.y + dy,
      );
    }
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = this.color ?? Theme.of(context).primaryColor
      ..strokeWidth = this.width ?? 1
      ..style = PaintingStyle.stroke;

    double x = size.width;
    double y = size.height;

    Path _bottomPath = getDashedPath(
      a: math.Point(0, y),
      b: math.Point(x, y),
      gap: gap ?? 4,
    );

    canvas.drawPath(_bottomPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
