import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state.dart';
import '../component/template/consumer_counter.dart';

class ProviderCounterApp extends StatelessWidget {
  const ProviderCounterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
        child: MaterialApp(
            home: ConsumerCounter(
      counterProvider: counterProvider,
    )));
  }
}
