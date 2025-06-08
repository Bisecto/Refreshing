// notification_badge.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:refreshing_co/res/app_colors.dart';

import '../../../../bloc/notification_bloc/notification_bloc.dart';
import '../../../../bloc/notification_bloc/notification_event.dart';
import '../../../../bloc/notification_bloc/notification_state.dart';
import 'notification.dart';

class NotificationBadge extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double? badgeSize;
  final Color? badgeColor;
  final TextStyle? badgeTextStyle;

  const NotificationBadge({
    Key? key,
    required this.child,
    this.onTap,
    this.badgeSize = 18,
    this.badgeColor,
    this.badgeTextStyle,
  }) : super(key: key);

  @override
  State<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Load unread count when widget initializes
    context.read<NotificationBloc>().add(LoadUnreadCountEvent());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _animateBadge() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          widget.onTap ??
          () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const NotificationPage()),
            );
          },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          widget.child,
          BlocConsumer<NotificationBloc, NotificationState>(
            listener: (context, state) {
              if (state is UnreadCountLoaded && state.unreadCount > 0) {
                _animateBadge();
              }
            },
            builder: (context, state) {
              int unreadCount = 0;

              if (state is NotificationLoaded) {
                unreadCount = state.unreadCount;
              } else if (state is UnreadCountLoaded) {
                unreadCount = state.unreadCount;
              } else {
                unreadCount =
                    context.read<NotificationBloc>().currentUnreadCount;
              }

              if (unreadCount == 0) {
                return const SizedBox.shrink();
              }

              return Positioned(
                right: -4,
                top: -4,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    );
                  },
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: widget.badgeSize!,
                      minHeight: widget.badgeSize!,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: widget.badgeColor ?? Colors.red,
                      borderRadius: BorderRadius.circular(
                        widget.badgeSize! / 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (widget.badgeColor ?? Colors.red).withOpacity(
                            0.3,
                          ),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      unreadCount > 99 ? '99+' : unreadCount.toString(),
                      style:
                          widget.badgeTextStyle ??
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// Enhanced notification icon with beautiful design
class AnimatedNotificationIcon extends StatefulWidget {
  final double size;
  final Color? color;
  final VoidCallback? onTap;

  const AnimatedNotificationIcon({
    Key? key,
    this.size = 24,
    this.color,
    this.onTap,
  }) : super(key: key);

  @override
  State<AnimatedNotificationIcon> createState() =>
      _AnimatedNotificationIconState();
}

class _AnimatedNotificationIconState extends State<AnimatedNotificationIcon>
    with TickerProviderStateMixin {
  late AnimationController _bellController;
  late AnimationController _glowController;
  late Animation<double> _bellAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _bellController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _bellAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _bellController, curve: Curves.easeInOut),
    );

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _bellController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _triggerBellAnimation() {
    _bellController.forward().then((_) {
      _bellController.reverse().then((_) {
        _bellController.forward().then((_) {
          _bellController.reverse();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _triggerBellAnimation();
        widget.onTap?.call();
      },
      child: BlocListener<NotificationBloc, NotificationState>(
        listener: (context, state) {
          if (state is UnreadCountLoaded && state.unreadCount > 0) {
            _triggerBellAnimation();
          }
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: AnimatedBuilder(
            animation: Listenable.merge([_bellAnimation, _glowAnimation]),
            builder: (context, child) {
              return Transform.rotate(
                angle: _bellAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: (widget.color ?? AppColors.appMainColor)
                            .withOpacity(0.3 * _glowAnimation.value),
                        blurRadius: 15 * _glowAnimation.value,
                        spreadRadius: 2 * _glowAnimation.value,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    size: widget.size,
                    color: widget.color ?? AppColors.appMainColor,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


