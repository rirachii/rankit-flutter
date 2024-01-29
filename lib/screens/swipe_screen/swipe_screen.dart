import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:rankit_flutter/objects/list_data.dart';
import 'package:rankit_flutter/objects/item.dart';
import 'package:rankit_flutter/screens/list_reorder_screen.dart';
import 'package:rankit_flutter/screens/swipe_screen/button.dart';
import 'package:rankit_flutter/screens/swipe_screen/card.dart';

import '../../objects/box.dart' as global_box;


class SwipeScreen extends StatefulWidget {
  final ListData listData;

  const SwipeScreen({super.key, required this.listData});

  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  final AppinioSwiperController controller = AppinioSwiperController();
  late String listId = widget.listData.listId;
  late String listName= widget.listData.listName;
  late String listDescription = widget.listData.listDescription;
  late List<Item> itemFields = widget.listData.items;

  Map<int, Item> left = {};
  Map<int, Item> right = {};
  Map<int, Item> top = {};
  Map<int, Item> bottom = {};

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then((_) {
      _shakeCard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Rank List'),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.55,
              child: AppinioSwiper(
                onSwipeEnd: _swipeEnd,
                onEnd: _onEnd,
                controller: controller,
                cardCount: itemFields.length,
                cardBuilder: (BuildContext context, int index) {
                  return SwipeCard(item: itemFields[index]);
                },
              ),
            ),
            SizedBox(
              height: 100,
              child: IconTheme.merge(
                data: const IconThemeData(size: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    swipeLeftButton(controller),
                    const SizedBox(
                      width: 20,
                    ),
                    swipeDownButton(controller),
                    const SizedBox(
                      width: 20,
                    ),
                    swipeRightButton(controller),
                    const SizedBox(
                      width: 20,
                    ),
                    unswipeButton(controller),
                  ],
                ),
              ),
            )
            // add more SizedBox widgets as needed
          ],
        ),
      ),
    );
  }

  void _onEnd() {
    if (bottom.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ListReorderScreen(
            listData: widget.listData,
          ),
        ),
      );
    }
  }

  void _swipeEnd(int previousIndex, int targetIndex, SwiperActivity activity) {
    // print('Left: $left');
    // print('Right: $right');
    // print('Top: $top');
    // print('Bottom: $bottom');
    switch (activity) {
      case Swipe():
        switch (activity.direction) {
          case AxisDirection.left:
            left[previousIndex] = itemFields[previousIndex];
            break;
          case AxisDirection.right:
            right[previousIndex] = itemFields[previousIndex];
            break;
          case AxisDirection.up:
            top[previousIndex] = itemFields[previousIndex];
            break;
          case AxisDirection.down:
            bottom[previousIndex] = itemFields[previousIndex];
            break;
        }
        print('The card was swiped to the : ${activity.direction}');
        print('previous index: $previousIndex, target index: $targetIndex');
        break;
      case Unswipe():
        switch (activity.direction) {
          case AxisDirection.left:
            left.remove(targetIndex);
            break;
          case AxisDirection.right:
            right.remove(targetIndex);
            break;
          case AxisDirection.up:
            top.remove(targetIndex);
            break;
          case AxisDirection.down:
            bottom.remove(targetIndex);
            break;
        }
        print('A ${activity.direction.name} swipe was undone.');
        print('previous index: $previousIndex, target index: $targetIndex');
        break;
      case CancelSwipe():
        print('A swipe was cancelled');
        break;
      case DrivenActivity():
        print('Driven Activity');
        break;
    }
  }

  // Animates the card back and forth to teach the user that it is swipable.
  Future<void> _shakeCard() async {
    const double distance = 30;
    // We can animate back and forth by chaining different animations.
    await controller.animateTo(
      const Offset(-distance, 0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
    await controller.animateTo(
      const Offset(distance, 0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    // We need to animate back to the center because `animateTo` does not center
    // the card for us.
    await controller.animateTo(
      const Offset(0, 0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }
}
