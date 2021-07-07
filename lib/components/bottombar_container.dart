import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_drawer_flutter/lib/painter.dart';

class BottomBarContainer extends StatefulWidget {
  final Color colors;
  final Function onTap;
  final String title;
  final IconData icons;
  final PainterController controller;
  final bool background;
  final bool isBrush;

  const BottomBarContainer({
    Key key,
    this.onTap,
    this.title,
    this.icons,
    this.colors,
    this.controller,
    this.background = false,
    this.isBrush = false,
  }) : super(key: key);

  @override
  _BottomBarContainerState createState() => _BottomBarContainerState();
}

class _BottomBarContainerState extends State<BottomBarContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      color: widget.colors,
      child: Material(
        color: Colors.black87,
        child: InkWell(
          onTap: widget.isBrush ? _pickColor : widget.onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
               widget.isBrush?_iconData: widget.icons,
                color: Colors.white,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                widget.title,
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _pickColor() {
    Color pickerColor = _color;
    showDialog(
        context: context,
        child: AlertDialog(
          title: const Text('Pick a color!'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color c) => pickerColor = c,
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Got it'),
              onPressed: () {
                setState(() => _color = pickerColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }

  Color get _color => widget.background ? widget.controller.backgroundColor : widget.controller.drawColor;

  IconData get _iconData => widget.background ? Icons.format_color_fill : FontAwesomeIcons.brush;

  set _color(Color color) {
    if (widget.background) {
      widget.controller.backgroundColor = color;
    } else {
      widget.controller.drawColor = color;
    }
  }
}
