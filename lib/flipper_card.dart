import 'dart:math';

import 'package:flutter/material.dart';

class FlipperCard extends StatefulWidget {
  final Widget frontWidget;
  final Widget backWidget;
  final VoidCallback onTapTramp;

  FlipperCard({
    key,
    this.frontWidget,
    this.backWidget,
    this.onTapTramp,
  }) : super(key: key);

  @override
  FlipperCardState createState() => FlipperCardState();
}

class FlipperCardState extends State<FlipperCard>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> _frontRotation;
  Animation<double> _backRotation;
  bool isFrontVisible = true;
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    isFrontVisible = true;
    controller = AnimationController(
      duration: Duration(milliseconds: 250),
      vsync: this,
    );
    _frontRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.easeInToLinear)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
    _backRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.easeInToLinear)),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: Duration.zero,
      child: Stack(
        children: [
          AnimatedCard(
            animation: _backRotation,
            child: GestureDetector(
              onTap: () => toggleSide(),
              child: widget.backWidget,
            ),
          ),
          AnimatedCard(
            animation: _frontRotation,
            child: GestureDetector(
              onTap: () => toggleSide(),
              child: widget.frontWidget,
            ),
          ),
        ],
      ),
    );
  }

  leftRotation() {
    toggleSide();
  }

  rightRotation() {
    toggleSide();
  }

  toggleSide() {
    if (!isVisible) {
      return;
    }
    if (isFrontVisible) {
      controller.forward();
      isFrontVisible = false;
    } else {
      controller.reverse();
      isFrontVisible = true;
    }
    widget.onTapTramp.call();
  }

  toggleVisible() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  removeCard() {
    setState(() {
      isVisible = false;
      isFrontVisible = true;
    });
  }

}

class AnimatedCard extends StatelessWidget {
  AnimatedCard({
    this.child,
    this.animation,
  });

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        var transform = Matrix4.identity();
        transform.setEntry(3, 2, 0.001);
        transform.rotateY(animation.value);
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }
}
