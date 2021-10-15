import 'package:flutter/material.dart';
import 'package:task_manager/database/app_database.dart';
import 'package:task_manager/models/task_model.dart';
import 'package:task_manager/screens/info_screen.dart';
import 'package:task_manager/test.dart';
import 'package:task_manager/utils/app_colors.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TextEditingController _taskController;
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();

  late DateTime _timeBackPressed = DateTime.now();

  @override
  void initState() {
    super.initState();
    _taskController = TextEditingController();
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final _timeDifference = DateTime.now().difference(_timeBackPressed);
        final isWarningExist = _timeDifference >= Duration(seconds: 2);
        _timeBackPressed = DateTime.now();
        if (isWarningExist) {
          final warningMessage = 'Press back again to exit.';
          _scaffoldMessengerKey.currentState!.showSnackBar(
            SnackBar(
              elevation: 0,
              width: MediaQuery.of(context).size.width * 0.50,
              content: Text(warningMessage),
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
          );
          return false;
        } else {
          return true;
        }
      },
      child: ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          backgroundColor: AppColors.appBlack,
          appBar: AppBar(
            backgroundColor: AppColors.appBlack,
            title: Text('My Tasks'),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InfoScreen(),
                    ),
                  );
                },
                icon: Icon(Icons.info_outline),
              ),
            ],
          ),
          body: FutureBuilder<List<TaskModel>?>(
            future: _taskList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  return _taskScreen(snapshot.data!);
                }
                return _emptyTask();
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          floatingActionButton: _buildFloatingActionButton(),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
        isExtended: false,
        child: Icon(
          Icons.add,
          size: 30,
        ),
        backgroundColor: AppColors.appBlack,
        onPressed: () async {
          showModalBottomSheet<void>(
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(10.0))),
            backgroundColor: AppColors.appBlack,
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          autofocus: true,
                          validator: (str) {
                            if (str!.isEmpty || str.length < 2) {
                              return '*Can not be Empty!';
                            }
                            return null;
                          },
                          controller: _taskController,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                              color: Colors.white,
                            ),
                            border: InputBorder.none,
                            hintText: 'New Task',
                            hintStyle: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            TaskModel taskModel =
                                TaskModel(description: _taskController.text);
                            taskModel = await TaskDatabase.instance
                                .createTask(taskModel);
                            print(taskModel.id);
                            if (taskModel.id != null) {
                              setState(() {});
                              _taskController.clear();
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(
                            color: AppColors.appBlack,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  Widget _emptyTask() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.10,
          ),
          Image.asset(
            'assets/images/icNoTask.png',
            width: MediaQuery.of(context).size.width * 0.70,
            height: MediaQuery.of(context).size.height * 0.40,
          ),
          SizedBox(height: 10.0),
          Text(
            ' Organizing your tasks with a list can make everything much more manageable and make you feel mentally focused.',
            style: TextStyle(
              fontSize: 18.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<List<TaskModel>?> _taskList() async {
    List<TaskModel>? task = await TaskDatabase.instance.readAllTasks();
    return task;
  }

  Widget _taskScreen(List<TaskModel> tasks) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return _taskTile(
            controller: AnimationController(
                vsync: this, duration: const Duration(milliseconds: 200)),
            index: index,
            task: tasks[index],
          );
        },
      ),
    );
  }

  Widget _taskTile({
    required AnimationController controller,
    required TaskModel task,
    required int index,
  }) {
    final List<List<Color>> taskColors = [
      [
        AppColors.taskColor1,
        AppColors.taskColor2,
      ],
      [
        AppColors.taskColor3,
        AppColors.taskColor4,
      ],
    ];

    return SlideMenu(
      controller: controller,
      menuItems: <Widget>[
        IconButton(
          onPressed: () {
            controller.animateTo(.0);
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Delete Task !'),
                  content: Text('Have you completed the task!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        controller.animateTo(0);
                        Navigator.pop(context);
                      },
                      child: Text('NO'),
                    ),
                    TextButton(
                      onPressed: () async {
                        int result =
                            await TaskDatabase.instance.deleteTask(task.id!);
                        if (result > 0) {
                          setState(() {});
                          controller.animateTo(0);
                          Navigator.pop(context);
                        } else {
                          print('Not Deleted');
                        }
                      },
                      child: Text('YES'),
                    ),
                  ],
                );
              },
            );
          },
          icon: Icon(
            Icons.delete,
            size: 35,
          ),
        ),
      ],
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 15.0),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-1.0, -7.0),
            end: Alignment(1.0, 4.0),
            colors: [
              taskColors[index % 2][1],
              taskColors[index % 2][0],
            ],
          ),
          border: Border.all(color: AppColors.greyBorder),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          task.description,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            // HSLColor.fromColor((journalColors[index % 4][0]))
            //     .withLightness(0.45)
            //     .toColor(),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
