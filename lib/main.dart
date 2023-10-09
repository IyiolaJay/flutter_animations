import 'package:flutter/material.dart';
import 'dart:math' show pi;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animator',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const ArcSpinner(),
    );
  }
}

enum CircleSide { left, right }

extension ToPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();

    late Offset offset;
    late bool clockwise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockwise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockwise = true;
        break;
    }
    path.arcToPoint(offset,
        radius: Radius.elliptical(size.width / 2, size.height / 2),
        clockwise: clockwise);

    path.close();
    return path;
  }
}

class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  HalfCircleClipper({required this.side});

  @override
  Path getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class ArcSpinner extends StatefulWidget {
  const ArcSpinner({super.key});

  @override
  State<ArcSpinner> createState() => _ArcSpinnerState();
}

class _ArcSpinnerState extends State<ArcSpinner>
    with TickerProviderStateMixin {
  late AnimationController _counterClockwiseController;
  late Animation _counterClockwiseAnimation;

  late AnimationController _flipAnimationController;
  late Animation _flipAnimation;

  @override
  void dispose() {
    _counterClockwiseController.dispose();
    _flipAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _counterClockwiseController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _counterClockwiseAnimation = Tween<double>(begin: 0, end: -(pi / 2))
        .animate(CurvedAnimation(
            parent: _counterClockwiseController, curve: Curves.bounceOut));

    //flip animation
    _flipAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(CurvedAnimation(
        parent: _counterClockwiseController, curve: Curves.bounceOut));

    _counterClockwiseController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
      

        _flipAnimation = Tween<double>(
                begin: _flipAnimation.value, end: _flipAnimation.value + pi)
            .animate(CurvedAnimation(
                parent: _flipAnimationController, curve: Curves.bounceOut));

        _flipAnimationController
          ..reset()
          ..forward();
      }
    });

    _flipAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed){

     
      _counterClockwiseAnimation = Tween<double>(
              begin: _counterClockwiseAnimation.value,
              end: _counterClockwiseAnimation.value + -(pi / 2))
          .animate(CurvedAnimation(
              parent: _counterClockwiseController, curve: Curves.bounceOut));

      _counterClockwiseController
        ..reset()
        ..forward();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 1), () {
      _counterClockwiseController
        ..reset()
        ..forward();
    });

    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _counterClockwiseController,
          builder: (context, child) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..rotateZ(_counterClockwiseAnimation.value),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                AnimatedBuilder(
                    animation: _flipAnimationController,
                    builder: (context, child) {
                      return Transform(
                        alignment: Alignment.centerRight,
                        transform: Matrix4.identity()
                          ..rotateY(_flipAnimation.value),
                        child: ClipPath(
                          clipper: HalfCircleClipper(side: CircleSide.left),
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.blue,
                          ),
                        ),
                      );
                    }),
                AnimatedBuilder(
                    animation: _flipAnimation,
                    builder: (context, child) {
                      return Transform(
                        transform: Matrix4.identity()
                          ..rotateY(_flipAnimation.value),
                        alignment: Alignment.centerLeft,
                        child: ClipPath(
                          clipper: HalfCircleClipper(side: CircleSide.right),
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.yellow,
                          ),
                        ),
                      );
                    }),
              ]),
            );
          },
        ),
      ),
    );
  }
}
