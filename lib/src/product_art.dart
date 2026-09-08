import 'package:flutter/material.dart';

import 'product.dart';

/// Original vector illustrations: bundled in code and available offline.
class ProductArt extends StatelessWidget {
  const ProductArt({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Illustration of ${product.name}',
    image: true,
    child: DecoratedBox(
      decoration: BoxDecoration(color: product.color),
      child: CustomPaint(
        painter: _ProductPainter(product.kind),
        child: const SizedBox.expand(),
      ),
    ),
  );
}

class _ProductPainter extends CustomPainter {
  _ProductPainter(this.kind);
  final ProductKind kind;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = (size.shortestSide / 240).clamp(0.0, 4.0);
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(scale);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 81), width: 146, height: 16),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9),
    );
    void rounded(double x, double y, double w, double h, double r, int color) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromLTWH(x, y, w, h), Radius.circular(r)),
        Paint()..color = Color(color),
      );
    }

    void line(Offset a, Offset b, double width, int color) {
      canvas.drawLine(
        a,
        b,
        Paint()
          ..color = Color(color)
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round,
      );
    }

    switch (kind) {
      case ProductKind.headphones:
        final band = Path()
          ..moveTo(-62, 30)
          ..lineTo(-62, -12)
          ..cubicTo(-62, -97, 62, -97, 62, -12)
          ..lineTo(62, 30);
        canvas.drawPath(
          band,
          Paint()
            ..color = const Color(0xFF393E3C)
            ..strokeWidth = 19
            ..style = PaintingStyle.stroke,
        );
        canvas.drawPath(
          band,
          Paint()
            ..color = const Color(0xFF626560)
            ..strokeWidth = 9
            ..style = PaintingStyle.stroke,
        );
        rounded(-78, -7, 40, 80, 18, 0xFF343B38);
        rounded(38, -7, 40, 80, 18, 0xFF343B38);
        rounded(-72, -2, 19, 64, 10, 0xFF727871);
        rounded(44, -2, 19, 64, 10, 0xFF727871);
        line(const Offset(70, 7), const Offset(70, 43), 3, 0xFF9DA098);
      case ProductKind.chair:
        line(const Offset(-48, 39), const Offset(-66, 86), 10, 0xFF9C704B);
        line(const Offset(45, 39), const Offset(64, 86), 10, 0xFF9C704B);
        rounded(-67, -77, 134, 122, 45, 0xFF697A57);
        rounded(-55, -68, 110, 94, 37, 0xFF899877);
        rounded(-79, -8, 24, 64, 12, 0xFF61754D);
        rounded(55, -8, 24, 64, 12, 0xFF61754D);
        rounded(-68, 22, 136, 37, 17, 0xFF748762);
        line(const Offset(-45, 40), const Offset(46, 40), 2, 0xFF92A17F);
      case ProductKind.lamp:
        rounded(-10, -29, 20, 108, 5, 0xFFAC5A39);
        rounded(-51, 69, 102, 15, 8, 0xFFB56343);
        final shade = Path()
          ..moveTo(-78, -9)
          ..quadraticBezierTo(-75, -85, 0, -85)
          ..quadraticBezierTo(75, -85, 78, -9)
          ..close();
        canvas.drawPath(shade, Paint()..color = const Color(0xFFC97650));
        canvas.drawOval(
          const Rect.fromLTWH(-78, -18, 156, 21),
          Paint()..color = const Color(0xFFE6B78D),
        );
        line(const Offset(-32, -65), const Offset(-46, -37), 5, 0xFFD89572);
      case ProductKind.bag:
        final handles = Path()
          ..moveTo(-33, -19)
          ..lineTo(-33, -53)
          ..cubicTo(-33, -102, 33, -102, 33, -53)
          ..lineTo(33, -19);
        canvas.drawPath(
          handles,
          Paint()
            ..color = const Color(0xFFB5976E)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 10,
        );
        final body = Path()
          ..moveTo(-64, -34)
          ..lineTo(64, -34)
          ..lineTo(75, 77)
          ..quadraticBezierTo(0, 91, -75, 77)
          ..close();
        canvas.drawPath(body, Paint()..color = const Color(0xFFCAB28B));
        rounded(-27, 1, 54, 51, 3, 0xFFBCA17A);
        line(const Offset(-23, 6), const Offset(23, 6), 2, 0xFFD9C6A5);
        line(const Offset(-54, -24), const Offset(-62, 67), 2, 0xFFE2CEAA);
        line(const Offset(54, -24), const Offset(62, 67), 2, 0xFFE2CEAA);
      case ProductKind.bottle:
        rounded(-23, -88, 46, 25, 6, 0xFF244D43);
        rounded(-28, -66, 56, 20, 8, 0xFF396859);
        rounded(-38, -52, 76, 135, 21, 0xFF4D7F6E);
        rounded(-28, -43, 10, 111, 5, 0xFF74A18F);
        rounded(-10, 12, 20, 26, 5, 0xFFC7D8CC);
        line(const Offset(-14, -81), const Offset(14, -81), 2, 0xFF628073);
      case ProductKind.speaker:
        rounded(-75, -55, 150, 132, 30, 0xFF6D657D);
        rounded(-67, -46, 134, 112, 25, 0xFF93879E);
        for (var y = -31; y < 56; y += 9) {
          for (var x = -52; x < 58; x += 9) {
            canvas.drawCircle(
              Offset(x.toDouble(), y.toDouble()),
              1.6,
              Paint()..color = const Color(0xFF645A73),
            );
          }
        }
        rounded(-31, -58, 62, 8, 4, 0xFFB1A6BB);
        canvas.drawCircle(
          const Offset(0, 53),
          3,
          Paint()..color = const Color(0xFFE8EAD9),
        );
    }
  }

  @override
  bool shouldRepaint(covariant _ProductPainter oldDelegate) =>
      kind != oldDelegate.kind;
}
