import 'package:flutter/material.dart';

class TextView extends StatefulWidget {
  final double left;
  final double top;
  final VoidCallback? onTap;
  final Function(DragUpdateDetails)? onPanUpdate;
  final double fontSize;
  final String value;
  final TextAlign? align;

  const TextView({
    Key? key,
    this.left=0.0,
    this.top=0.0,
    this.onTap,
    this.onPanUpdate,
    this.fontSize=0.0,
    this.value='',
    this.align,
  }) : super(key: key);

  @override
  _TextViewState createState() => _TextViewState();
}

class _TextViewState extends State<TextView> {
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
                color: Colors.orange,
                fontWeight: FontWeight.w600,
              ))),
    );
  }
}
