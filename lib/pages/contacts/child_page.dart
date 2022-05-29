import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SearchBar(),
          Expanded(
            flex: 1,
            child: MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: itemBuilder,
                itemCount: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return Container(
      height: 80,
      color: Colors.amber,

    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _textEditingController = TextEditingController();
  bool _showClean = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      color: Color.fromRGBO(143, 148, 251, 1),
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            height: 44,
            child: Row(
              children: [
                Container(
                  width: 370,
                  height: 34,
                  margin: EdgeInsets.only(left: 5, right: 5),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.search,color: Colors.grey,), //放大镜
                      Expanded(
                        child: TextField(
                          controller: _textEditingController,
                          onChanged: _onchange,
                          cursorColor: Colors.green,
                          autofocus: true,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.only(left: 5, bottom: 10),
                            border: InputBorder.none,
                            hintText: '搜索',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      if (this._showClean)
                        GestureDetector(
                          child: Icon(
                            Icons.cancel,
                            size: 20,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            _textEditingController.clear();
                            setState(() {
                              this._onchange("");
                            });
                          },
                        ),
                    ],
                  ),
                ), //圆角背景

                GestureDetector(
                  child: Text('取消'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onchange(String value) {
    if (value.length > 0) {
      setState(() {
        this._showClean = true;
      });
    } else {
      setState(() {
        this._showClean = false;
      });
    }
  }
}
