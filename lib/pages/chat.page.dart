import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:the_pilot_ticketing_app/constants/colors.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({
    required this.name,
    required this.imageUrl,
    required this.userId,
    Key? key,
  }) : super(key: key);

  final String name;
  final String imageUrl;
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(),
      bottomSheet: bottomSheet(context),
      body: ListView(
        children: [
          SizedBox(height: 8.0),
          EachMessage(byUser: true, message: "hi", timeSent: "12.10 PM"),
          EachMessage(byUser: false, message: "hello", timeSent: "12.10 PM"),
          EachMessage(
              byUser: false,
              message:
                  "I hope you're doing fine I hope you're doing fine I hope you're doing fine I hope you're doing fine ",
              timeSent: "12.10 PM"),
        ],
      ),
    );
  }

  AppBar customAppBar() {
    return AppBar(
      toolbarHeight: 72.0,
      backgroundColor: Colors.white,
      elevation: 2,
      leading: profileImage(),
      title: Text(
        name,
        style: const TextStyle(
            color: primaryColorSwatch,
            fontWeight: FontWeight.w500,
            fontSize: 16.0),
      ),
      actions: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Color(0xff246BFD),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Center(
            child: Text(
              "Resolve",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0),
            ),
          ),
        )
      ],
    );
  }

  Container bottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 32 - 16 - 56,
            height: 56.0,
            decoration: BoxDecoration(
              color: const Color(0xfff6f6f6),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Row(
              children: [
                const InputFieldTextCustom(),
                const SizedBox(width: 8.0),
                InkWell(
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.attachment,
                      size: 24.0,
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
              ],
            ),
          ),
          const SizedBox(width: 12.0),
          InkWell(
            onTap: () {},
            child: const CircleAvatar(
              radius: 26.0,
              child: Icon(Icons.send),
            ),
          )
        ],
      ),
    );
  }

  Padding profileImage() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: CircleAvatar(
        backgroundColor: Colors.grey,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(28.0),
            child: Image.network(
              imageUrl,
            )),
      ),
    );
  }
}

class EachMessage extends StatelessWidget {
  const EachMessage({
    required this.byUser,
    required this.message,
    required this.timeSent,
    Key? key,
  }) : super(key: key);

  final bool byUser;
  final String message;
  final String timeSent;

  @override
  Widget build(BuildContext context) {
    final List<Widget> childElems = [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        decoration: BoxDecoration(
            color: byUser ? Color(0xff246BFD) : Colors.grey,
            borderRadius: BorderRadius.only(
              topLeft: byUser ? Radius.circular(10.0) : Radius.circular(0.0),
              topRight: !byUser ? Radius.circular(10.0) : Radius.circular(0.0),
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            )),
        child: Text(
          message,
          style: TextStyle(
            color: byUser ? Colors.white : Colors.black,
            fontSize: 16.0,
          ),
        ),
      ),
      Text(
        timeSent,
        style: TextStyle(
            color: primaryColorSwatch,
            fontWeight: FontWeight.w500,
            fontSize: 12.0),
      ),
    ];
    return Row(
      mainAxisAlignment:
          byUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: byUser ? childElems.reversed.toList() : childElems,
    );
  }
}

class InputFieldTextCustom extends StatelessWidget {
  const InputFieldTextCustom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: TextField(
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          minLines: null,
          maxLines:
              null, // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
          expands: true,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration.collapsed(
            hintText: 'Type Here',
          ),
          cursorColor: Colors.white,
        ),
      ),
    );
  }
}
