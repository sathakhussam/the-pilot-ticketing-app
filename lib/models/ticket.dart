import 'dart:convert';

import 'package:the_pilot_ticketing_app/models/message.dart';
import 'package:the_pilot_ticketing_app/models/user.dart';

class TicketOverView {
  OtherUser user;
  String id;
  String subject;
  bool resolved;
  String createdAt;
  String unseenMessages;
  Message? finalMessage;

  TicketOverView({
    required this.user,
    required this.id,
    required this.subject,
    required this.resolved,
    required this.createdAt,
    required this.unseenMessages,
    this.finalMessage,
  });

  factory TicketOverView.fromJson(Map<dynamic, dynamic> json) => TicketOverView(
        user: OtherUser.fromJson(json['user']),
        id: json['id'],
        subject: json['subject'],
        resolved: json['resolved'],
        createdAt: json['createdAt'],
        unseenMessages: json['unseenMessages'].toString(),
        finalMessage: Message.fromJson(json["finalMessage"]),
      );
}
