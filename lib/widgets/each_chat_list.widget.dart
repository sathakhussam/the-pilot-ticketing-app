import 'package:flutter/material.dart';
import 'package:the_pilot_ticketing_app/constants/colors.dart';
import 'package:the_pilot_ticketing_app/pages/chat.page.dart';

class EachChatList extends StatelessWidget {
  final String imageUrl;
  final String username;
  final String userId;
  final String finalMessage;
  final String timeInString;
  final String unseenChats;

  const EachChatList({
    required this.imageUrl,
    required this.username,
    required this.finalMessage,
    required this.timeInString,
    required this.unseenChats,
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                      name: username,
                      userId: userId,
                      imageUrl: imageUrl,
                    )));
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 32,
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        height: 64.0,
        // color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28.0,
                  backgroundColor: Colors.grey,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(28.0),
                      child: Image.network(
                        imageUrl,
                      )),
                ),
                SizedBox(width: 12.0),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                            color: primaryColorSwatch,
                            fontSize: 16.0,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        finalMessage,
                        style: TextStyle(
                            color: primaryColorSwatch,
                            fontSize: 12.0,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeInString,
                  style: TextStyle(
                      color: primaryColorSwatch,
                      fontSize: 12.0,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4.0),
                CircleAvatar(
                  backgroundColor: Color(0xff246BFD),
                  radius: 10.0,
                  child: Text(
                    unseenChats,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
