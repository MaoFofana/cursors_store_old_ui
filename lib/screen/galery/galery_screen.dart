
import 'package:cs/components/bottom_menu.dart';
import 'package:flutter/material.dart';

class GaleryScreenMain extends StatefulWidget {
  const GaleryScreenMain({Key? key}) : super(key: key);

  @override
  State<GaleryScreenMain> createState() => _GaleryScreenMainState();
}

class _GaleryScreenMainState extends State<GaleryScreenMain> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Padding(
                padding: EdgeInsets.all(15),
                child: SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    child: Text('Galeries'),
                  ),
                ),
              ),

            ],
          ),
        ),
        bottomNavigationBar: BottomMenu(index: 2),
      ),
    );
  }
}
