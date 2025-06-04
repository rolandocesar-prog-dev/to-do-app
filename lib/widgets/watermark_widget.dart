import 'package:flutter/material.dart';

class WatermarkWidget extends StatelessWidget {
  final Widget child;
  final String? logoPath;
  final double opacity;
  final double size;
  final Alignment alignment;
  final bool rotated;

  const WatermarkWidget({
    super.key,
    required this.child,
    this.logoPath = 'assets/images/logo_voz_liberal.png',
    this.opacity = 0.04, // Sutil pero visible
    this.size = 220,
    this.alignment = Alignment.center,
    this.rotated = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Contenido principal
        child,

        // Marca de agua
        Positioned.fill(
          child: Align(
            alignment: alignment,
            child: IgnorePointer(
              child: Transform.rotate(
                angle: rotated ? -0.2 : 0, // Rotación muy sutil
                child: Opacity(
                  opacity: opacity,
                  child: Image.asset(
                    logoPath!,
                    width: size,
                    height: size,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      // Si no encuentra la imagen, muestra un placeholder sutil
                      return Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.amber.withOpacity(opacity),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons
                              .campaign, // Icono de megáfono para "Voz Liberal"
                          size: size * 0.4,
                          color: Colors.amber.withOpacity(opacity),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Widget alternativo para múltiples marcas de agua
class MultipleWatermarkWidget extends StatelessWidget {
  final Widget child;
  final String? logoPath;
  final double opacity;
  final double size;

  const MultipleWatermarkWidget({
    super.key,
    required this.child,
    this.logoPath = 'assets/images/logo_voz_liberal.png',
    this.opacity = 0.03,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: WatermarkPainter(
                logoPath: logoPath!,
                opacity: opacity,
                size: size,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class WatermarkPainter extends CustomPainter {
  final String logoPath;
  final double opacity;
  final double size;

  WatermarkPainter({
    required this.logoPath,
    required this.opacity,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size canvasSize) {
    // Calcular espaciado para el patrón repetido
    final spacing = size * 1.5;
    final rows = (canvasSize.height / spacing).ceil() + 1;
    final cols = (canvasSize.width / spacing).ceil() + 1;

    final paint =
        Paint()
          ..color = Colors.grey.withOpacity(opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    // Dibujar un patrón repetido sutil
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final x = col * spacing - size / 2;
        final y = row * spacing - size / 2;

        // Dibujar un círculo sutil en lugar del logo para el patrón
        canvas.drawCircle(Offset(x, y), size / 4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
