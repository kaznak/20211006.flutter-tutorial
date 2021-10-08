import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConsumerCounter extends ConsumerWidget {
  final StateProvider<int> counterProvider;
  final String title;

  const ConsumerCounter(
      {Key? key, this.title = 'Counter example', required this.counterProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        // Consumer is a widget that allows you reading providers.
        // You could also use the hook "ref.watch(" if you uses flutter_hooks
        child: Consumer(builder: (context, ref, _) {
          final count = ref.watch(counterProvider).state;
          return Text('$count');
        }),
      ),
      floatingActionButton: FloatingActionButton(
        // The read method is an utility to read a provider without listening to it
        onPressed: () => ref.read(counterProvider).state++,
        child: const Icon(Icons.add),
      ),
    );
  }
}
