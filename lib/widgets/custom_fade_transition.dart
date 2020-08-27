import 'package:flutter/material.dart';

class CustomFadeTransition extends StatefulWidget {
  const CustomFadeTransition({
    Key key,
    @required this.child,
    this.duration = const Duration(milliseconds: 900),
  }) : super(key: key);

  final Widget child;
  final Duration duration; 

  @override
  _CustomFadeTransitionState createState() => _CustomFadeTransitionState();
}

class _CustomFadeTransitionState extends State<CustomFadeTransition> with SingleTickerProviderStateMixin {

  AnimationController _animationController;
  Animation<double> _opacity;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: widget.duration);
    _opacity = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: widget.child,
    );
  }
}