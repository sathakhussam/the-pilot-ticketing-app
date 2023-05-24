import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_pilot_ticketing_app/constants/colors.dart';
import 'package:the_pilot_ticketing_app/models/message.dart';
import 'package:the_pilot_ticketing_app/models/user.dart';
import 'package:the_pilot_ticketing_app/network/api.dart';

import '../providers/authorization.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    required this.name,
    required this.imageUrl,
    required this.userId,
    required this.ticketId,
    Key? key,
  }) : super(key: key);

  final String name;
  final String imageUrl;
  final String userId;
  final String ticketId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var message = TextEditingController();
  final api = ThePilotApi();
  var intervalBetween = 5;
  Stream<http.Response> getMessages() async* {
    yield* Stream.periodic(Duration(seconds: intervalBetween), (_) {
      print('p');
      return http.get(
          Uri.parse('http://139.59.38.60/api/v1/ticket/${widget.ticketId}'),
          headers: {
            'Content-Type': 'application/json',
            'authorization':
                'Bearer ${Provider.of<Authorization>(context, listen: false).user?.token}'
          });
    }).asyncMap((event) async => await event);
  }

  @override
  void initState() {
    // TODO: implement initState
    api.setUser(Provider.of<Authorization>(context, listen: false).user ??
        User(
          token: '',
          userId: '',
          firstName: '',
          secondName: '',
          email: '',
          profileUrl: '',
        ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: customAppBar(),
        bottomSheet: bottomSheet(context),
        body: StreamBuilder<http.Response>(
          stream: getMessages(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Sorry There Seems To Be A Problem"),
              );
            } else if (snapshot.hasData) {
              var body = snapshot.data?.body.runtimeType == String
                  ? snapshot.data?.body
                  : "{}";
              var respDecoded = jsonDecode(body.toString());
              var messages =
                  respDecoded['data'].map((v) => Message.fromJson(v)).toList();
              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) => EachMessage(
                    byUser: messages[index].by != "user",
                    message: messages[index].content,
                    filePath: messages[index].filePath.runtimeType == String
                        ? messages[index].filePath
                        : "",
                    seen: messages[index].seen,
                    last: messages.length - 1 == index ? true : false,
                    timeSent: messages[index].sentAt),
              );
            }
            return Center(child: const CircularProgressIndicator());
          },
        ));
  }

  AppBar customAppBar() {
    return AppBar(
      toolbarHeight: 72.0,
      backgroundColor: Colors.white,
      elevation: 2,
      leading: profileImage(),
      title: Text(
        widget.name,
        style: const TextStyle(
            color: primaryColorSwatch,
            fontWeight: FontWeight.w500,
            fontSize: 16.0),
      ),
      actions: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Material(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: InkWell(
              splashColor: Colors.grey,
              onTap: () async {
                try {
                  // await api.resolveTicket(widget.ticketId);
                  Navigator.pop(context, true);
                } catch (e) {
                  print(e);
                }
              },
              child: Container(
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
              ),
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
                InputFieldTextCustom(context),
                const SizedBox(width: 8.0),
                // InkWell(
                //   onTap: () {
                //     print('object');
                //   },
                //   child: const Padding(
                //     padding: EdgeInsets.all(8.0),
                //     child: Icon(
                //       Icons.attachment,
                //       size: 24.0,
                //     ),
                //   ),
                // ),
                const SizedBox(width: 8.0),
              ],
            ),
          ),
          const SizedBox(width: 12.0),
          InkWell(
            onTap: () {
              String msg = message.text;
              setState(() {
                intervalBetween = 0;
                message.text = '';
              });
              api.sendMessage(widget.ticketId, msg);
              Timer.run(() => print('object'));
              Timer(Duration(seconds: 2), () {
                print('object 2');
                setState(() {
                  intervalBetween = 5;
                });
              });
            },
            child: const CircleAvatar(
              radius: 26.0,
              child: Icon(Icons.send),
            ),
          )
        ],
      ),
    );
  }

  Expanded InputFieldTextCustom(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: TextField(
          controller: message,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.multiline,
          minLines: null,
          maxLines:
              null, // If this is null, there is no limit to the number of lines, and the text container will start with enough vertical space for one line and automatically grow to accommodate additional lines as they are entered.
          expands: true,
          textAlignVertical: TextAlignVertical.center,
          decoration: const InputDecoration.collapsed(
            hintText: 'Type Here',
          ),
          cursorColor: Colors.white,
        ),
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
            child: widget.imageUrl != ''
                ? Image.network(
                    widget.imageUrl,
                  )
                : CircleAvatar(
                    radius: 32.0,
                    backgroundColor: Color(0xff333333),
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
    required this.filePath,
    required this.seen,
    required this.last,
    Key? key,
  }) : super(key: key);

  final bool byUser;
  final String message;
  final String timeSent;
  final String filePath;
  final bool seen;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final List<Widget> childElems = [
      Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
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
    return Column(
      crossAxisAlignment:
          byUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        filePath != ""
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Image.network(
                  'http://${filePath}',
                  fit: BoxFit.cover,
                ),
              )
            : SizedBox(),
        Row(
          mainAxisAlignment:
              byUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: byUser ? childElems.reversed.toList() : childElems,
        ),
        (last == true && seen == true)
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text("seen"),
              )
            : SizedBox(),
        last == true ? SizedBox(height: 100.0) : SizedBox()
      ],
    );
  }
}
