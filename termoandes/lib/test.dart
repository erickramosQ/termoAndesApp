import 'package:flutter/material.dart';

// Define la paleta de colores para el loader
const Color _kProgressColor = Color(0xFFFF802F); // Naranja/Progreso
const Color _kBackgroundColor = Color(0xFFF0F0F0); // Gris claro, para el fondo

class HorizontalLoader extends StatefulWidget {
  final double height;
  final double width;
  final double borderRadius;

  const HorizontalLoader({
    super.key,
    this.height = 30.0,
    this.width = 250.0,
    this.borderRadius = 15.0,
  });

  @override
  State<HorizontalLoader> createState() => _HorizontalLoaderState();
}

class _HorizontalLoaderState extends State<HorizontalLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Controlador para simular la carga (0.0 a 1.0)
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(seconds: 2), // Duración de la animación
        )..repeat(
          reverse: true,
        ); // Repetir la animación de ida y vuelta (simulación)

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Asegura que el radio de borde no sea mayor que la mitad de la altura
    final effectiveRadius = widget.height / 2;

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(effectiveRadius),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: _ProgressPainter(
                progress: _animation.value, // Valor animado de 0.0 a 1.0
                progressColor: _kProgressColor,
                backgroundColor: _kBackgroundColor,
                barHeight: widget.height,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double barHeight;

  _ProgressPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.barHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Dibujar el fondo completo (gris claro)
    final backgroundPaint = Paint()..color = backgroundColor;
    final fullRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(fullRect, backgroundPaint);

    // 2. Dibujar la parte de progreso (naranja)
    final progressPaint = Paint()..color = progressColor;
    // Calcular el ancho cubierto por el progreso
    final progressWidth = size.width * progress;

    if (progressWidth > 0) {
      final progressRect = Rect.fromLTWH(0, 0, progressWidth, size.height);

      // Dibujar la barra de progreso
      canvas.drawRect(progressRect, progressPaint);

      // 3. Dibujar la tapa/pin naranja en el extremo izquierdo
      // El radio es la mitad de la altura de la barra.
      final circleRadius = barHeight / 2;
      final circleCenter = Offset(circleRadius, size.height / 2);

      // Dibujar el círculo encima del inicio de la barra
      canvas.drawCircle(circleCenter, circleRadius, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressPainter oldDelegate) {
    // Solo repintar si el progreso ha cambiado
    return oldDelegate.progress != progress;
  }
}

// Ejemplo de uso
class LoaderScreen extends StatelessWidget {
  const LoaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Horizontal Progress Loader'),
        backgroundColor: const Color(0xFF008BB8),
      ),
      body: const Center(child: HorizontalLoader(width: 300, height: 40)),
    );
  }
}
