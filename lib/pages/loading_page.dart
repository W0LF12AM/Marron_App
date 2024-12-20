import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:maroon_app/widgets/default.dart';

class LoadingPage extends StatelessWidget {
  final String pesan;
  const LoadingPage({Key? key, required this.pesan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadingAnimationWidget.staggeredDotsWave(
                color: mainColor, size: 50),
            SizedBox(
              height: 20,
            ),
            Text(
              pesan,
              style: Loading_Style,
            )
          ],
        ),
      ),
    );
  }
}
