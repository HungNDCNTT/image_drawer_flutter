import 'package:flutter/material.dart';
import 'package:image_drawer_flutter/data/data.dart';

class Emojies extends StatefulWidget {
  @override
  _EmojiesState createState() => _EmojiesState();
}

class _EmojiesState extends State<Emojies> {
  List<String>? emojes ;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(blurRadius: 10.9, color: Colors.grey)]),
        child: Column(
          children: <Widget>[
            Padding(
              padding:  EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                   Text("Select Emoji"),
                ],
              ),
            ),
            Divider(
              height: 1,
            ),
             SizedBox(
              height: 10,
            ),
            Container(
              height: 315,
              child: GridView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(mainAxisSpacing: 0.0, maxCrossAxisExtent: 60.0),
                  children: emojis!.map((String emoji) {
                    return GridTile(
                        child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context, emoji);
                      },
                      child: Container(
                        child: Text(
                          emoji,
                          style: TextStyle(fontSize: 35),
                        ),
                      ),
                    ));
                  }).toList()),
            ),
          ],
        ));
  }

  List<String>? emojis;

  @override
  void initState() {
    super.initState();
    emojis = getSmileys();
  }
}
