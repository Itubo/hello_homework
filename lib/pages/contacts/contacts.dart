import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ContactsPageBody();
}

class ContactsPageBody extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            // floating: true,
            pinned: true,
            title: Text("联系人"),
            centerTitle: true,
            leading: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                    image: AssetImage("assets/images/work.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            actions: [
              SizedBox(
                width: 80,
                child: IconButton(
                    padding: EdgeInsets.all(8),
                    onPressed: () {},
                    icon: Icon(Icons.add)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
