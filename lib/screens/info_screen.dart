import 'package:flutter/material.dart';
import 'package:task_manager/utils/app_colors.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appBlack,
      appBar: AppBar(
        backgroundColor: AppColors.appBlack,
        title: Text('Info'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 40.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'How to use ?',
              style: TextStyle(
                fontSize: 26,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '⚫ Click on the Floating action button to add new task.',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '⚫ Swipe left the task tile to delete.',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Spacer(),
            Text(
              'Developed by : ',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Aman Ansari',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              'Flutter Developer',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
