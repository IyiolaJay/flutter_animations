import 'package:flutter/material.dart';
import 'dart:math' show pi;
import 'package:vector_math/vector_math_64.dart' show Vector3;

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
      home: const BoxAnimation(),
    );
  }
}

class BoxAnimation extends StatefulWidget {
  const BoxAnimation({super.key});

  @override
  State<BoxAnimation> createState() => _BoxAnimationState();
}

class _BoxAnimationState extends State<BoxAnimation>
    with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;
  late Tween<double> _animation;

  @override
  void initState() {
    _xController =
        AnimationController(vsync: this, duration: const Duration(seconds: 30));

    _yController =
        AnimationController(vsync: this, duration: const Duration(seconds: 40));

    _zController =
        AnimationController(vsync: this, duration: const Duration(seconds: 30));

    _animation = Tween<double>(begin: 0, end: pi * 2);
    super.initState();
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    super.dispose();
  }

  final _containerHeightWidth = 100.0;
  @override
  Widget build(BuildContext context) {
    _xController
      ..reset()
      ..repeat();
    _yController
      ..reset()
      ..repeat();
    _zController
      ..reset()
      ..repeat();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
              width: double.infinity,
            ),
            AnimatedBuilder(
              animation:
                  Listenable.merge([_xController, _yController, _zController]),
              builder: (context, child) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..rotateX(_animation.evaluate(_xController))
                    ..rotateY(_animation.evaluate(_yController))
                    ..rotateZ(_animation.evaluate(_zController)),
                  child: Stack(
                    children: [
                      Container(
                        width: _containerHeightWidth,
                        height: _containerHeightWidth,
                        color: Colors.green,
                      ),
                      // back 
                      Transform(
                        alignment:Alignment.center,
                        transform: Matrix4.identity()..translate(Vector3(0,0, -_containerHeightWidth)),
                        child: Container(
                          width: _containerHeightWidth,
                          height: _containerHeightWidth,
                          color: Colors.purple,
                        ),
                      ),
                      // left
                      Transform(
                        alignment:Alignment.centerLeft,
                        transform: Matrix4.identity()..rotateY(pi /2),
                        child: Container(
                          width: _containerHeightWidth,
                          height: _containerHeightWidth,
                          color: Colors.orange,
                        ),
                      ),

                      //right
                      Transform(
                        alignment:Alignment.centerRight,
                        transform: Matrix4.identity()..rotateY(-pi /2),
                        child: Container(
                          width: _containerHeightWidth,
                          height: _containerHeightWidth,
                          color: Colors.brown,
                        ),
                      ),
                      // top
                      Transform(
                        alignment:Alignment.topCenter,
                        transform: Matrix4.identity()..rotateX(-pi / 2),
                        child: Container(
                          width: _containerHeightWidth,
                          height: _containerHeightWidth,
                          color: Colors.blueAccent[400],
                        ),
                      ),
                      
                      //bottom
                      Transform(
                        alignment:Alignment.bottomCenter,
                        transform: Matrix4.identity()..rotateX(pi /2),
                        child: Container(
                          width: _containerHeightWidth,
                          height: _containerHeightWidth,
                          color: Colors.red,
                        ),
                      ),


                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
