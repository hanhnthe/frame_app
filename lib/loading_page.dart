import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget{
  const LoadingPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LoadingPage());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}