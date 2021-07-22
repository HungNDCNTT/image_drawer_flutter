import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      left: 0,
      bottom: 0,
      child: Container(
        color: Colors.grey.withOpacity(0.8),
        child: Center(
          child: Container(
            width: 120,
            height: 120,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Container(
                  height: 20,
                ),
                Text('Loading...'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
