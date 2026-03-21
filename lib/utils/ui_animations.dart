import 'package:flutter/material.dart';

/// UI 动画增强工具类
/// 提供统一的动画曲线、持续时间和预设动画
class UIAnimations {
  UIAnimations._();

  /// 标准动画持续时间
  static const Duration fastDuration = Duration(milliseconds: 150);
  static const Duration normalDuration = Duration(milliseconds: 250);
  static const Duration slowDuration = Duration(milliseconds: 400);
  static const Duration verySlowDuration = Duration(milliseconds: 600);

  /// 标准动画曲线
  static const Curve standardCurve = Curves.easeInOut;
  static const Curve springCurve = Curves.easeOutBack;
  static const Curve smoothCurve = Curves.easeInOutCubic;
  static const Curve bounceCurve = Curves.bounceOut;
  static const Curve elasticCurve = Curves.elasticOut;

  /// 页面过渡动画
  static Route<T> createSmoothRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0, 0.02);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        final fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: animation, curve: curve),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: animation.drive(tween),
            child: child,
          ),
        );
      },
      transitionDuration: normalDuration,
    );
  }

  /// 缩放页面过渡动画
  static Route<T> createScaleRoute<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;

        final scaleAnimation = Tween<double>(begin: 0.9, end: 1).animate(
          CurvedAnimation(parent: animation, curve: curve),
        );

        final fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: animation, curve: curve),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: normalDuration,
    );
  }

  /// 淡入动画
  static Animation<double> createFadeInAnimation(
    AnimationController controller, {
    Curve curve = standardCurve,
  }) {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// 淡出动画
  static Animation<double> createFadeOutAnimation(
    AnimationController controller, {
    Curve curve = standardCurve,
  }) {
    return Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// 缩放动画
  static Animation<double> createScaleAnimation(
    AnimationController controller, {
    double begin = 0.8,
    double end = 1.0,
    Curve curve = springCurve,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// 位移动画
  static Animation<Offset> createSlideAnimation(
    AnimationController controller, {
    Offset begin = const Offset(0, 0.1),
    Offset end = Offset.zero,
    Curve curve = standardCurve,
  }) {
    return Tween<Offset>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// 旋转动画
  static Animation<double> createRotationAnimation(
    AnimationController controller, {
    double begin = 0.0,
    double end = 2 * 3.14159,
    Curve curve = standardCurve,
  }) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: curve),
    );
  }

  /// 弹性位移动画
  static Animation<Offset> createBounceSlideAnimation(
    AnimationController controller, {
    Offset begin = const Offset(0, -0.2),
    Offset end = Offset.zero,
  }) {
    return Tween<Offset>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: bounceCurve),
    );
  }

  /// 连续脉动动画
  static void startPulsing(
    AnimationController controller, {
    double minScale = 1.0,
    double maxScale = 1.05,
  }) {
    controller.repeat(reverse: true);
  }

  /// 停止脉动动画
  static void stopPulsing(
    AnimationController controller, {
    double targetScale = 1.0,
  }) {
    controller.stop();
    controller.value = 0.0;
  }

  /// 创建脉动动画
  static Animation<double> createPulseAnimation(
    AnimationController controller, {
    double min = 1.0,
    double max = 1.05,
  }) {
    return Tween<double>(begin: min, end: max).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  /// 交错动画（用于列表项）
  static Animation<T> createStaggeredAnimation<T>(
    AnimationController controller,
    Tween<T> tween, {
    int index = 0,
    int staggerDelay = 50,
    Curve curve = standardCurve,
  }) {
    return tween.animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0, 1, curve: curve),
      ),
    );
  }

  /// 创建交错淡入动画
  static List<Animation<double>> createStaggeredFadeIns(
    AnimationController controller,
    int count, {
    int staggerDelay = 50,
  }) {
    return List.generate(
      count,
      (index) => createStaggeredAnimation(
        controller,
        Tween<double>(begin: 0, end: 1),
        index: index,
        staggerDelay: staggerDelay,
      ),
    );
  }

  /// 创建交错位移动画
  static List<Animation<Offset>> createStaggeredSlides(
    AnimationController controller,
    int count, {
    Offset begin = const Offset(0, 0.1),
    Offset end = Offset.zero,
    int staggerDelay = 50,
  }) {
    return List.generate(
      count,
      (index) => createStaggeredAnimation(
        controller,
        Tween<Offset>(begin: begin, end: end),
        index: index,
        staggerDelay: staggerDelay,
      ),
    );
  }
}

/// 动画预设组件
class AnimatedPulse extends StatefulWidget {

  const AnimatedPulse({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.minScale = 1.0,
    this.maxScale = 1.05,
    this.autoStart = true,
  });
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool autoStart;

  @override
  State<AnimatedPulse> createState() => _AnimatedPulseState();
}

class _AnimatedPulseState extends State<AnimatedPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = UIAnimations.createPulseAnimation(
      _controller,
      min: widget.minScale,
      max: widget.maxScale,
    );

    if (widget.autoStart) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

/// 悬停放大组件
class HoverScale extends StatefulWidget {

  const HoverScale({
    super.key,
    required this.child,
    this.scale = 1.05,
    this.duration = const Duration(milliseconds: 200),
  });
  final Widget child;
  final double scale;
  final Duration duration;

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? widget.scale : 1.0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// 点击涟漪组件
class RippleEffect extends StatefulWidget {

  const RippleEffect({
    super.key,
    required this.child,
    this.onTap,
    this.rippleColor,
  });
  final Widget child;
  final VoidCallback? onTap;
  final Color? rippleColor;

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}
