import 'package:flutter/material.dart';

class EmoJiView extends StatefulWidget {
  final double left;
  final double top;
  final VoidCallback? onTap;
  final Function(DragUpdateDetails)? onPanUpdate;
  final double fontSize;
  final String value;
  final TextAlign? align;

  const EmoJiView({
    Key? key,
    this.left = 0.0,
    this.top = 0.0,
    this.onTap,
    this.onPanUpdate,
    this.fontSize = 0.0,
    this.value = '',
    this.align,
  }) : super(key: key);

  @override
  _EmoJiViewState createState() => _EmoJiViewState();
}

class _EmoJiViewState extends State<EmoJiView> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      top: widget.top,
      child: GestureDetector(
          onTap: widget.onTap,
          onPanUpdate: widget.onPanUpdate,
          child: Text(widget.value,
              textAlign: widget.align,
              style: TextStyle(
                fontSize: widget.fontSize,
              ))),
    );
  }
}
