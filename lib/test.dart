import 'package:flutter/material.dart';

class SlideMenu extends StatefulWidget {
  final AnimationController controller;
  final Widget child;
  final List<Widget> menuItems;

  SlideMenu(
      {required this.controller, required this.child, required this.menuItems});

  @override
  _SlideMenuState createState() => new _SlideMenuState();
}

class _SlideMenuState extends State<SlideMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  initState() {
    super.initState();
    _controller = widget.controller;
    // AnimationController(
    //     vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = Tween(
      begin: Offset(0.0, 0.0),
      end: Offset(-0.2, 0.0),
    ).animate(
      CurveTween(curve: Curves.decelerate).animate(_controller),
    );

    return GestureDetector(
      onHorizontalDragUpdate: (data) {
        // we can access context.size here
        setState(() {
          _controller.value -= data.primaryDelta! / context.size!.width;
        });
      },
      onHorizontalDragEnd: (data) {
        if (data.primaryVelocity! > 2500)
          _controller
              .animateTo(.0); //close menu on fast swipe in the right direction
        else if (_controller.value >= .5 ||
            data.primaryVelocity! <
                -2500) // fully open if dragged a lot to left or on fast swipe to left
          _controller.animateTo(1.0);
        else // close if none of above
          _controller.animateTo(.0);
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SlideTransition(position: animation, child: widget.child),
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraint) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Stack(
                      children: <Widget>[
                        Positioned(
                          right: .0,
                          // top: .0,
                          bottom: 2,
                          width: constraint.maxWidth * animation.value.dx * -1,
                          child: Row(
                            children: widget.menuItems.map((child) {
                              return Expanded(
                                child: child,
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
