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
    this.logoPath = 'assets/images/voz_liberal.png',
    this.opacity = 0.1, // Sutil pero visible
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
                      // Fallback si no encuentra la imagen - Mostrar logo temporal
                      return Container(
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.amber.withOpacity(opacity * 2),
                            width: 3,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.campaign, // Megáfono para "Voz Liberal"
                              size: size * 0.3,
                              color: Colors.amber.withOpacity(opacity * 2),
                            ),
                            SizedBox(height: size * 0.05),
                            Text(
                              'VOZ\nLIBERAL',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: size * 0.08,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.withOpacity(opacity * 2),
                              ),
                            ),
                          ],
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
