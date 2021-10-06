import 'package:flutter/material.dart';

class FirstRoutePage extends StatelessWidget {
  const FirstRoutePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Route'),
      ),
      body: Center(
        child: ElevatedButton(
            child: const Text('Open route'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SecondRoutePage()),
              );
            }),
      ),
    );
  }
}

class SecondRoutePage extends StatelessWidget {
  const SecondRoutePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Second Route"),
      ),
      body: Center(
        child: ElevatedButton(
            child: const Text('Go back!'),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
    );
  }
}
