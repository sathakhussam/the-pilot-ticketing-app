import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_pilot_ticketing_app/constants/colors.dart';
import 'package:the_pilot_ticketing_app/providers/tickets.dart';

class CategoryButton extends StatefulWidget {
  const CategoryButton({
    Key? key,
  }) : super(key: key);

  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  var firstState = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      height: 64.0,
      width: MediaQuery.of(context).size.width - 32.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32.0),
        color: Color.fromARGB(255, 223, 223, 223),
        // color: Colors.black,
      ),
      child: Row(children: [
        SizedBox(width: 12.0),
        InkWell(
          onTap: () {
            Provider.of<Tickets>(context, listen: false).changeUnresolved(true);
            print(Provider.of<Tickets>(context, listen: false).unresolved);
          },
          child: Material(
            elevation: Provider.of<Tickets>(context).unresolved ? 10.0 : 0,
            borderRadius: BorderRadius.circular(28.0),
            color: Provider.of<Tickets>(context).unresolved
                ? Colors.white
                : Color.fromARGB(255, 223, 223, 223),
            child: SizedBox(
              height: 48.0,
              width: (MediaQuery.of(context).size.width - 32.0 - 24.0) / 2,
              child: Center(child: innerText("Unresolved")),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Provider.of<Tickets>(context, listen: false)
                .changeUnresolved(false);
            print(Provider.of<Tickets>(context, listen: false).unresolved);
          },
          child: Material(
            elevation: !Provider.of<Tickets>(context).unresolved ? 10.0 : 0,
            borderRadius: BorderRadius.circular(28.0),
            color: !Provider.of<Tickets>(context).unresolved
                ? Colors.white
                : Color.fromARGB(255, 223, 223, 223),
            child: SizedBox(
              height: 48.0,
              width: (MediaQuery.of(context).size.width - 32.0 - 24.0) / 2,
              child: Center(child: innerText("Resolved")),
            ),
          ),
        ),
      ]),
    );
  }

  Text innerText(content) {
    return Text(
      content,
      style: TextStyle(fontWeight: FontWeight.w500, color: primaryColorSwatch),
    );
  }
}
