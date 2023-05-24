// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the_pilot_ticketing_app/models/ticket.dart';
import 'package:the_pilot_ticketing_app/models/user.dart';
import 'package:the_pilot_ticketing_app/network/api.dart';
import 'package:the_pilot_ticketing_app/providers/authorization.dart';
import 'package:the_pilot_ticketing_app/providers/tickets.dart';
import 'package:the_pilot_ticketing_app/widgets/category_button.widget.dart';
import 'package:the_pilot_ticketing_app/widgets/custom_app_bar.widget.dart';
import 'package:the_pilot_ticketing_app/widgets/each_chat_list.widget.dart';

import '../constants/colors.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final api = ThePilotApi();
  var tickets;
  var resolvedTickets;
  var unresolvedTickets;
  @override
  void initState() {
    print('new init');
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      Provider.of<Authorization>(context, listen: false)
          .setUser(userFromJson(Hive.box('setting').get('user')));
      api.setUser(Provider.of<Authorization>(context, listen: false).user ??
          User(
            token: '',
            userId: '',
            firstName: '',
            secondName: '',
            email: '',
            profileUrl: '',
          ));
      setState(() {
        tickets = api.getTickets();
      });
    });
    super.initState();
  }

  Future<void> fetchTicketsAgain() async {
    setState(() {
      tickets = api.getTickets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          SizedBox(height: 12.0),
          CustomAppBar(),
          SizedBox(height: 16.0),
          CategoryButton(),
          SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Tickets',
              style: TextStyle(
                  color: primaryColorSwatch,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0),
            ),
          ),
          FutureBuilder(
            future: tickets,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                var respDecoded = jsonDecode(snapshot.data.toString());
                resolvedTickets = respDecoded['data']['resolvedTickets']
                    .map((v) => TicketOverView.fromJson(v))
                    .toList();
                unresolvedTickets = respDecoded['data']['unresolvedTickets']
                    .map((v) => TicketOverView.fromJson(v))
                    .toList(); // Provider.of<Tickets>(context, listen: false)
                //     .setResolvedTickets(resolvedTickets);
                // Provider.of<Tickets>(context, listen: false)
                //     .setUnresolvedTickets(unresolvedTickets);
                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: fetchTicketsAgain,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: Provider.of<Tickets>(context).unresolved
                            ? unresolvedTickets.length
                            : resolvedTickets.length,
                        itemBuilder: (context, index) => EachChatList(
                              imageUrl: Provider.of<Tickets>(context).unresolved
                                  ? unresolvedTickets[index].user.profileUrl
                                  : resolvedTickets[index].user.profileUrl,
                              username: Provider.of<Tickets>(context).unresolved
                                  ? '${unresolvedTickets[index].subject} ${unresolvedTickets[index].user.firstName}'
                                  : '${resolvedTickets[index].subject} ${resolvedTickets[index].user.firstName}',
                              finalMessage: Provider.of<Tickets>(context)
                                      .unresolved
                                  ? unresolvedTickets[index]
                                      .finalMessage
                                      .content
                                  : resolvedTickets[index].finalMessage.content,
                              timeInString: Provider.of<Tickets>(context)
                                      .unresolved
                                  ? unresolvedTickets[index].finalMessage.sentAt
                                  : resolvedTickets[index].finalMessage.sentAt,
                              unseenChats:
                                  Provider.of<Tickets>(context).unresolved
                                      ? unresolvedTickets[index].unseenMessages
                                      : resolvedTickets[index].unseenMessages,
                              userId: Provider.of<Tickets>(context).unresolved
                                  ? unresolvedTickets[index].user.userId
                                  : resolvedTickets[index].user.userId,
                              ticketId: Provider.of<Tickets>(context).unresolved
                                  ? unresolvedTickets[index].id
                                  : resolvedTickets[index].id,
                              recallFunc: fetchTicketsAgain,
                            )),
                  ),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Expanded(
                  child: Center(
                    child: Text('Sorry, failed to load data.'),
                  ),
                );
              } else {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }),
          )
        ],
      ),
    );
  }
}
