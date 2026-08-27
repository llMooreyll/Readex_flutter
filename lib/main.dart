import 'package:flutter/material.dart';

void main() {
  runApp(const ReadItLaterApp());
}

class ReadItLaterApp extends StatelessWidget {
  const ReadItLaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '稍后读',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const _BootstrapPage(),
    );
  }
}

class _BootstrapPage extends StatelessWidget {
  const _BootstrapPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('稍后读')),
      body: const Center(child: Text('应用基础环境已就绪')),
    );
  }
}
