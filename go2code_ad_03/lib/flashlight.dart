import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:torch_controller/torch_controller.dart';

class FlashLightApp extends StatefulWidget {
  const FlashLightApp({Key? key}) : super(key: key);

  @override
  _FlashLightAppState createState() => _FlashLightAppState();
}

class _FlashLightAppState extends State<FlashLightApp>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  Color _color = Colors.white;
  double _fontSize = 20;
  bool _isClicked = true;
  final TorchController _torchController = TorchController();

  final DecorationTween _decorationTween = DecorationTween(
    begin: BoxDecoration(
      color: Color(0xffC5705D),
      shape: BoxShape.circle,
      border: Border.all(color: Colors.black),
    ),
    end: BoxDecoration(
      color: Color(0xffF8EDE3),
      shape: BoxShape.rectangle,
      boxShadow: const [
        BoxShadow(
          color: Colors.white,
          spreadRadius: 30,
          blurRadius: 15,
          offset: Offset(0, 0),
        ),
      ],
    ),
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  void _toggleFlashlight() {
    if (_isClicked) {
      _animationController.forward();
      _fontSize = 40;
      _color = Color(0xffD0B8A8);
    } else {
      _animationController.reverse();
      _fontSize = 20;
      _color = Colors.white;
    }
    _isClicked = !_isClicked;
    _torchController.toggle();
    HapticFeedback.lightImpact();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 24, 5, 1),
      body: Stack(
        children: [
          GestureDetector(
            onTap: _toggleFlashlight,
            child: Center(
              child: DecoratedBoxTransition(
                position: DecorationPosition.background,
                decoration: _decorationTween.animate(_animationController),
                child: SizedBox(
                  width: 120,
                  height: 120,
                  child: Center(
                    child: Icon(
                      Icons.power_settings_new_outlined,
                      color: _isClicked ? Colors.black : Colors.red,
                      size: 60,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              height: MediaQuery.of(context).size.height / 1.4,
              alignment: Alignment.bottomCenter,
              child: AnimatedDefaultTextStyle(
                curve: Curves.ease,
                style: TextStyle(
                  color: _color,
                  fontSize: _fontSize,
                  letterSpacing: 0.75,
                  fontWeight: FontWeight.bold,
                ),
                duration: const Duration(milliseconds: 200),
                child: Text(!_isClicked ? 'ON' : 'OFF'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}