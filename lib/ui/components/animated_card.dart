import 'package:flutter/material.dart';
import '../../constants/ui_constants.dart';

class AnimatedCard extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final bool animate;
  final Offset beginOffset;

  const AnimatedCard({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.animate = true,
    this.beginOffset = const Offset(0, 0.1),
  }) : super(key: key);

  @override
  _AnimatedCardState createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _slideAnimation = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (widget.animate) {
      if (widget.delay == Duration.zero) {
        _controller.forward();
      } else {
        Future.delayed(widget.delay, () {
          if (mounted) {
            _controller.forward();
          }
        });
      }
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
