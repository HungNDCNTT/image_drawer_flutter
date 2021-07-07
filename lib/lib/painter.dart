import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_drawer_flutter/components/all_emojies.dart';
import 'package:image_drawer_flutter/components/emoji.dart';
import 'package:image_drawer_flutter/components/textview.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

import '../components/bottombar_container.dart';

var width = 500;
var height = 500;
var openBottomSheet = false;
ScreenshotController screenshotController = ScreenshotController();
TextEditingController inputTextController = TextEditingController();
String textInput = '';
List type = [];
List fontSize = [];
List<Offset> offsets = [];
List multiWidget = [];
var howMuchWidgetIs = 0;
var slider = 0.0;

class Painter extends StatefulWidget {
  final File imageFile;
  final VoidCallback onBackTap;

  Painter({this.imageFile, this.onBackTap});

  @override
  _PainterState createState() => new _PainterState();
}

class _PainterState extends State<Painter> {
  bool _finished;
  final GlobalKey globalKey = GlobalKey();
  final sCafKey = GlobalKey<ScaffoldState>();
  File _imageFile;
  PainterController painterController;

  PainterController _newController() {
    PainterController controller = new PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.transparent;
    return controller;
  }

  @override
  void initState() {
    type.clear();
    fontSize.clear();
    offsets.clear();
    multiWidget.clear();
    inputTextController.clear();
    howMuchWidgetIs = 0;
    _imageFile = widget.imageFile ?? null;
    painterController = _newController();
    super.initState();
    _finished = false;
    painterController._widgetFinish = _finish;
  }

  Size _finish() {
    setState(() {
      _finished = true;
    });
    return context.size;
  }

  @override
  Widget build(BuildContext context) {
    Widget child = new CustomPaint(
      willChange: true,
      painter: new _PainterPainter(painterController._pathHistory, repaint: painterController),
    );
    child = new ClipRect(child: child);
    if (!_finished) {
      child = new GestureDetector(
        child: child,
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
      );
    }
    return Scaffold(
      key: sCafKey,
      // appBar: PreferredSize(
      //   preferredSize: Size(50,50),
      //   child: AppBar(
      //     backgroundColor: Colors.blue,
      //     actions: [Icon(Icons.ac_unit)],
      //   ),
      // ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              sCafKey.currentState.showBottomSheet((context) => SizedBox());
            },
            child: Center(
              child: Screenshot(
                controller: screenshotController,
                child: Container(
                  margin: EdgeInsets.all(20),
                  color: Colors.white,
                  width: double.infinity,
                  height: double.infinity,
                  child: RepaintBoundary(
                    key: globalKey,
                    child: Stack(
                      children: [
                        widget.imageFile != null
                            ? Image.file(
                                widget.imageFile,
                                height: double.infinity,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              )
                            : Container(),
                        Container(
                          child: child,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Stack(
                          children: multiWidget.asMap().entries.map((f) {
                            return type[f?.key] == 1
                                ? EmoJiView(
                                    left: offsets[f?.key]?.dx,
                                    top: offsets[f?.key]?.dy,
                                    onTap: () {
                                      sCafKey.currentState.showBottomSheet((context) => Sliders(
                                            size: f?.key,
                                            sizeValue: fontSize[f?.key]?.toDouble(),
                                            newSize: (value) {
                                              setState(() {
                                                fontSize[f?.key] = value;
                                              });
                                            },
                                          ));
                                    },
                                    onPanUpdate: (details) {
                                      setState(() {
                                        offsets[f?.key] = Offset(offsets[f?.key].dx + details?.delta?.dx, offsets[f.key].dy + details.delta.dy);
                                      });
                                    },
                                    value: f.value.toString(),
                                    fontSize: fontSize[f.key].toDouble(),
                                    align: TextAlign.center,
                                  )
                                : type[f?.key] == 2
                                    ? TextView(
                                        left: offsets[f?.key]?.dx,
                                        top: offsets[f?.key]?.dy,
                                        onTap: () {
                                          sCafKey.currentState.showBottomSheet((context) => Sliders(
                                                size: f?.key,
                                                sizeValue: fontSize[f?.key]?.toDouble(),
                                                isTextSize: true,
                                                newSize: (size) {
                                                  setState(() {
                                                    fontSize[f?.key] = size;
                                                  });
                                                },
                                              ));
                                        },
                                        onPanUpdate: (details) {
                                          setState(() {
                                            offsets[f.key] = Offset(offsets[f.key].dx + details.delta.dx, offsets[f.key].dy + details.delta.dy);
                                          });
                                        },
                                        value: f.value.toString(),
                                        fontSize: fontSize[f.key].toDouble(),
                                        align: TextAlign.center,
                                      )
                                    : Container();
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.black, boxShadow: [BoxShadow(blurRadius: 10.9)]),
        height: 70,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            BottomBarContainer(
              icons: Icons.keyboard_return,
              onTap: () {
                if (widget.onBackTap == null) {
                  Navigator.pop(context);
                } else {
                  widget.onBackTap();
                }
                setState(() {
                  _imageFile = null;
                  inputTextController.text = '';
                  painterController.clear();
                  type.clear();
                  fontSize.clear();
                  offsets.clear();
                  multiWidget.clear();
                  inputTextController.clear();
                  howMuchWidgetIs = 0;
                });
              },
              title: 'Back',
            ),
            BottomBarContainer(
              colors: Colors.black,
              icons: FontAwesomeIcons.brush,
              isBrush: true,
              controller: painterController,
              title: 'Colors',
            ),
            BottomBarContainer(
              icons: Icons.text_fields,
              onTap: () {
                showDialogInputText();
              },
              title: 'Text',
            ),
            BottomBarContainer(
              icons: FontAwesomeIcons.smile,
              onTap: () {
                Future getemojis = showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Emojies();
                    });
                getemojis.then((value) {
                  if (value != null) {
                    setState(() {
                      type.add(1);
                      fontSize.add(25);
                      offsets.add(Offset.zero);
                      multiWidget.add(value ?? '');
                      howMuchWidgetIs++;
                    });
                  }
                });
              },
              title: 'Emoji',
            ),
            BottomBarContainer(
              icons: Icons.delete,
              onTap: () {
                setState(() {
                  painterController.clear();
                  type.clear();
                  fontSize.clear();
                  offsets.clear();
                  multiWidget.clear();
                  howMuchWidgetIs = 0;
                });
              },
              title: 'Clear all',
            ),
            _buildThickness(),
            BottomBarContainer(
              icons: Icons.undo,
              onTap: () {
                if (painterController.isEmpty) {
                } else {
                  painterController.undo();
                }
                if (multiWidget != null && multiWidget.length > 0) {
                  setState(() {
                    multiWidget.removeLast();
                    type.removeLast();
                    fontSize.removeLast();
                    offsets.removeLast();
                    howMuchWidgetIs--;
                  });
                }
              },
              title: 'Undo',
            ),
            BottomBarContainer(
              icons: Icons.check,
              onTap: _onDonePress,
              title: 'Done',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThickness() {
    return Column(
      children: [
        StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
          return Container(
              child: Slider(
            value: painterController.thickness,
            onChanged: (double value) => setState(() {
              painterController.thickness = value;
            }),
            min: 1.0,
            max: 20.0,
            activeColor: Colors.white,
          ));
        }),
        Text(
          'Thickness',
          style: TextStyle(color: Colors.white),
        )
      ],
    );
  }

  void showDialogInputText() {
    showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: AlertDialog(
                title: Text("Input Text"),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel")),
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          textInput = inputTextController.text;
                          type.add(2);
                          fontSize.add(25);
                          offsets.add(Offset.zero);
                          multiWidget.add(textInput ?? '');
                          howMuchWidgetIs++;
                        });
                        inputTextController.clear();
                        Navigator.pop(context);
                      },
                      child: Text("OK")),
                ],
                content: Container(
                  width: 350,
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.5), borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: inputTextController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 5),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 3,
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _onPanStart(DragStartDetails start) {
    Offset pos = (context.findRenderObject() as RenderBox).globalToLocal(start.globalPosition);
    painterController._pathHistory.add(pos);
    painterController._notifyListeners();
  }

  void _onPanUpdate(DragUpdateDetails update) {
    Offset pos = (context.findRenderObject() as RenderBox).globalToLocal(update.globalPosition);
    painterController._pathHistory.updateCurrent(pos);
    painterController._notifyListeners();
  }

  void _onPanEnd(DragEndDetails end) {
    painterController._pathHistory.endCurrent();
    painterController._notifyListeners();
  }

  void _onDonePress() {
    _imageFile = null;
    screenshotController.capture(delay: Duration(milliseconds: 500), pixelRatio: 1.5).then((File image) async {
      //print("Capture Done");
      setState(() {
        _imageFile = image;
      });
      final paths = await getApplicationDocumentsDirectory();
      image.copy(paths.path + '/' + DateTime.now().millisecondsSinceEpoch.toString() + '.png');
      print('Image link: $image');
    }).catchError((onError) {
      print(onError);
    });
  }
}

class _PainterPainter extends CustomPainter {
  final _PathHistory _path;

  _PainterPainter(this._path, {Listenable repaint}) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    _path.draw(canvas, size);
  }

  @override
  bool shouldRepaint(_PainterPainter oldDelegate) {
    return true;
  }
}

class _PathHistory {
  List<MapEntry<Path, Paint>> _paths;
  Paint currentPaint;
  Paint _backgroundPaint;
  bool _inDrag;

  bool get isEmpty => _paths.isEmpty || (_paths.length == 1 && _inDrag);

  _PathHistory() {
    _paths = new List<MapEntry<Path, Paint>>();
    _inDrag = false;
    _backgroundPaint = new Paint()..blendMode = BlendMode.dstOver;
  }

  void setBackgroundColor(Color backgroundColor) {
    _backgroundPaint.color = backgroundColor;
  }

  void undo() {
    if (!_inDrag) {
      _paths.removeLast();
    }
  }

  void clear() {
    if (!_inDrag) {
      _paths.clear();
    }
  }

  void add(Offset startPoint) {
    if (!_inDrag) {
      _inDrag = true;
      Path path = new Path();
      path.moveTo(startPoint.dx, startPoint.dy);
      _paths.add(new MapEntry<Path, Paint>(path, currentPaint));
    }
  }

  void updateCurrent(Offset nextPoint) {
    if (_inDrag) {
      Path path = _paths.last.key;
      path.lineTo(nextPoint.dx, nextPoint.dy);
    }
  }

  void endCurrent() {
    _inDrag = false;
  }

  void draw(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());
    for (MapEntry<Path, Paint> path in _paths) {
      Paint p = path.value;
      canvas.drawPath(path.key, p);
    }
    canvas.drawRect(new Rect.fromLTWH(0.0, 0.0, size.width, size.height), _backgroundPaint);
    canvas.restore();
  }
}

typedef PictureDetails PictureCallback();

class PictureDetails {
  final Picture picture;
  final int width;
  final int height;

  const PictureDetails(this.picture, this.width, this.height);

// Future<Image> toImage() {
//   return picture.toImage(width, height);
// }
//
// Future<Uint8List> toPNG() async {
//   final image = await toImage();
//   return (await image.toByteData(format: ImageByteFormat.png)).buffer.asUint8List();
// }
}

class PainterController extends ChangeNotifier {
  Color _drawColor = Colors.orange;
  Color _backgroundColor = Colors.transparent;
  bool _eraseMode = false;

  double _thickness = 1.0;
  PictureDetails _cached;
  _PathHistory _pathHistory;
  ValueGetter<Size> _widgetFinish;

  PainterController() {
    _pathHistory = new _PathHistory();
  }

  bool get isEmpty => _pathHistory.isEmpty;

  bool get eraseMode => _eraseMode;

  set eraseMode(bool enabled) {
    _eraseMode = enabled;
    _updatePaint();
  }

  Color get drawColor => _drawColor;

  set drawColor(Color color) {
    _drawColor = color;
    _updatePaint();
  }

  Color get backgroundColor => _backgroundColor;

  set backgroundColor(Color color) {
    _backgroundColor = color;
    _updatePaint();
  }

  double get thickness => _thickness;

  set thickness(double t) {
    _thickness = t;
    _updatePaint();
  }

  void _updatePaint() {
    Paint paint = new Paint();
    if (_eraseMode) {
      paint.blendMode = BlendMode.clear;
      paint.color = Color.fromARGB(0, 255, 0, 0);
    } else {
      paint.color = drawColor;
    }
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = thickness;
    _pathHistory.currentPaint = paint;
    _pathHistory.setBackgroundColor(backgroundColor);
    notifyListeners();
  }

  void undo() {
    if (!isFinished()) {
      _pathHistory.undo();
      notifyListeners();
    }
  }

  void _notifyListeners() {
    notifyListeners();
  }

  void clear() {
    if (!isFinished()) {
      _pathHistory.clear();
      notifyListeners();
    }
  }

  PictureDetails finish() {
    if (!isFinished()) {
      _cached = _render(_widgetFinish());
    }
    return _cached;
  }

  PictureDetails _render(Size size) {
    PictureRecorder recorder = new PictureRecorder();
    Canvas canvas = new Canvas(recorder);
    _pathHistory.draw(canvas, size);
    return new PictureDetails(recorder.endRecording(), size.width.floor(), size.height.floor());
  }

  bool isFinished() {
    return _cached != null;
  }
}

typedef NewSize(double a);

class Sliders extends StatefulWidget {
  final int size;
  final sizeValue;
  final NewSize newSize;
  final bool isTextSize;

  const Sliders({
    Key key,
    this.size,
    this.sizeValue,
    this.newSize,
    this.isTextSize = false,
  }) : super(key: key);

  @override
  _SlidersState createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> {
  @override
  void initState() {
    slider = widget.sizeValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String text = widget.isTextSize ? 'Text Size' : 'Emoji Size';
    return Container(
        height: 120,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(text ?? ''),
            ),
            Divider(
              height: 1,
            ),
            Slider(
                value: slider,
                min: 0.0,
                max: 100.0,
                onChangeEnd: (v) {
                  widget.newSize(v);
                  setState(() {
                    fontSize[widget.size] = v.toInt();
                  });
                },
                onChanged: (v) {
                  setState(() {
                    widget.newSize(v);
                    slider = v;
                    print(v.toInt());
                    fontSize[widget.size] = v.toInt();
                  });
                }),
          ],
        ));
  }
}

class DrawBar extends StatelessWidget {
  final PainterController _controller;

  DrawBar(this._controller);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return Container(
                child: Slider(
              value: _controller.thickness,
              onChanged: (double value) => setState(() {
                _controller.thickness = value;
              }),
              min: 1.0,
              max: 20.0,
              activeColor: Colors.white,
            ));
          })),
          StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return RotatedBox(
                quarterTurns: _controller.eraseMode ? 2 : 0,
                child: IconButton(
                    icon: Icon(Icons.create),
                    tooltip: (_controller.eraseMode ? 'Disable' : 'Enable') + ' eraser',
                    onPressed: () {
                      setState(() {
                        _controller.eraseMode = !_controller.eraseMode;
                      });
                    }));
          }),
          ColorPickerButton(_controller, false),
          ColorPickerButton(_controller, true),
        ],
      ),
    );
  }
}

class ColorPickerButton extends StatefulWidget {
  final PainterController _controller;
  final bool _background;

  ColorPickerButton(this._controller, this._background);

  @override
  _ColorPickerButtonState createState() => new _ColorPickerButtonState();
}

class _ColorPickerButtonState extends State<ColorPickerButton> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(icon: Icon(_iconData, color: _color), tooltip: widget._background ? 'Change background color' : 'Change draw color', onPressed: _pickColor),
        Text(
          'Brush',
          style: TextStyle(color: Colors.white),
        )
      ],
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

  Color get _color => widget._background ? widget._controller.backgroundColor : widget._controller.drawColor;

  IconData get _iconData => widget._background ? Icons.format_color_fill : FontAwesomeIcons.brush;

  set _color(Color color) {
    if (widget._background) {
      widget._controller.backgroundColor = color;
    } else {
      widget._controller.drawColor = color;
    }
  }
}
