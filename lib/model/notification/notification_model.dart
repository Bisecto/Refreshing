// notification_model.dart
import 'package:flutter/material.dart';

import 'notification_type.dart';

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? imageUrl;
  final Map<String, dynamic>? data;
  final String userId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
    this.data,
    required this.userId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? 'general',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      imageUrl: json['imageUrl'],
      data: json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
      userId: json['userId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'imageUrl': imageUrl,
      'data': data,
      'userId': userId,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? imageUrl,
    Map<String, dynamic>? data,
    String? userId,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrl: imageUrl ?? this.imageUrl,
      data: data ?? this.data,
      userId: userId ?? this.userId,
    );
  }

  // Helper methods for UI
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  NotificationTypeInfo get typeInfo {
    switch (type.toLowerCase()) {
      case 'order':
        return NotificationTypeInfo(
          icon: Icons.shopping_bag,
          color: Colors.blue,
          backgroundColor: Colors.blue.withOpacity(0.1),
        );
      case 'promotion':
        return NotificationTypeInfo(
          icon: Icons.local_offer,
          color: Colors.orange,
          backgroundColor: Colors.orange.withOpacity(0.1),
        );
      case 'system':
        return NotificationTypeInfo(
          icon: Icons.settings,
          color: Colors.grey,
          backgroundColor: Colors.grey.withOpacity(0.1),
        );
      case 'payment':
        return NotificationTypeInfo(
          icon: Icons.payment,
          color: Colors.green,
          backgroundColor: Colors.green.withOpacity(0.1),
        );
      default:
        return NotificationTypeInfo(
          icon: Icons.notifications,
          color: Colors.blue,
          backgroundColor: Colors.blue.withOpacity(0.1),
        );
    }
  }
}



