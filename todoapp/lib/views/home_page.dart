import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todolist/utils/routes/routes.dart';
import 'package:todolist/utils/shared_preferance/token_storage.dart';
import 'package:todolist/utils/theme/app_pallete.dart';
import 'package:todolist/viewModel/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:todolist/views/components/task_view_modal.dart';

import '../services/queries/task_queries.dart';
import 'components/task_create_modal.dart';
import 'components/task_edit_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Provider.of<AuthViewModel>(context, listen: false).updateUserDetails(context);
    super.initState();
  }

  Future<void> logout() async {
    await Provider.of<AuthViewModel>(context, listen: false).logout();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(Routes.loginScreen, (route) => false);
    }
  }

  void _toggleTaskCompletion(String taskId, bool currentStatus) {
    final client = GraphQLProvider.of(context).value;
    client.mutate(
      MutationOptions(
        document: gql(updateTaskMutation),
        variables: {
          'id': taskId,
          'completed': !currentStatus,
        },
        onCompleted: (dynamic resultData) {
          // Optionally handle onComplete
        },
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error updating task: $error')),
          );
        },
      ),
    );
  }

  void _createTask(BuildContext context, VoidCallback refetch) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: TaskCreateModal(refetch: refetch));
      },
    );
  }

  void _editTask(BuildContext context, Map task, VoidCallback refetch, String id) {
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: TaskEditModal(task: task, refetch: refetch, id: id));
      },
    );
  }

  void _deleteTask(BuildContext context, String taskId, VoidCallback refetch) {
    final client = GraphQLProvider.of(context).value;
    client.mutate(
      MutationOptions(
        document: gql(deleteTaskMutation),
        variables: {
          'id': taskId,
        },
        onCompleted: (dynamic resultData) {
          refetch();
        },
        onError: (error) {
          print(error);
        },
      ),
    );
  }

  void showTaskViewModal(BuildContext context, Map task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: TaskViewModal(task: task));
      },
    );
  }

  bool isAnyTaskPending(List<dynamic> tasks) {
    print(tasks);
    for (var task in tasks) {
      if (task['attributes']['completed'] == false) {
        return true;
      }
    }
    return false;
  }

  bool isAnyTaskCompleted(List<dynamic> tasks) {
    for (var task in tasks) {
      if (task['attributes']['completed'] == true) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPallete.primaryColor,
        title: Consumer<AuthViewModel>(
          builder: (context, provider, child) {
            return Text(
              'Welcome ${provider.user["username"]}',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout,
            color: Colors.white,
          ),
        ],
      ),
      body: Consumer<AuthViewModel>(
        builder: (context, provider, child) {
          return Query(
            options: QueryOptions(
              document: gql(getTasksQuery),
              variables: {'userId': provider.user["id"]},
            ),
            builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
              if (result.hasException) {
                print(result.exception.toString());

                return Center(child: Text('No Task Found'));
              }

              if (result.isLoading) {
                return Center(child: CircularProgressIndicator());
              }

              final List tasks = result.data?['tasks']['data'] ?? [];

              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () => _createTask(context, refetch ?? () {}),
                  child: Icon(Icons.add),
                  backgroundColor: AppPallete.primaryColor,
                ),
                body: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      if (tasks.isEmpty)
                        Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * .4, left: 16, right: 16),
                            child: Text(
                              "No Tasks Found",
                              style: GoogleFonts.poppins(
                                  color: AppPallete.primaryColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            )),
                      if (isAnyTaskPending(tasks))
                        Container(
                            margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Pending Tasks",
                              style: GoogleFonts.poppins(
                                  color: AppPallete.primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                      ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index]['attributes'];
                          final taskId = tasks[index]['id'];
                          final title = task['title'];
                          final description = task['description'];
                          final completed = task['completed'];
                          if (completed == true) return SizedBox();
                          return Container(
                            margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                            child: GestureDetector(
                              onTap: () => showTaskViewModal(context, task),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: AppPallete.primaryColor,
                                      width: 2,
                                    )),
                                tileColor: AppPallete.primaryColor.withOpacity(.03),
                                leading: Checkbox(
                                  value: completed ?? false,
                                  activeColor: AppPallete.primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  onChanged: (bool? value) {
                                    _toggleTaskCompletion(taskId, completed);
                                    refetch?.call(); // Refetch tasks to update the list
                                  },
                                ),
                                title: Text(
                                  title ?? "",
                                  style: GoogleFonts.poppins(
                                      // decoration:
                                      //     completed ? TextDecoration.lineThrough : TextDecoration.none,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  description ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        _editTask(context, task, refetch ?? () {}, taskId);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.red.withOpacity(1),
                                      onPressed: () {
                                        _deleteTask(context, taskId, refetch ?? () {});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      if (isAnyTaskCompleted(tasks))
                        Container(
                            margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Completed Tasks",
                              style: GoogleFonts.poppins(
                                  color: AppPallete.primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                      ListView.builder(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: tasks.length,
                        itemBuilder: (context, index) {
                          final task = tasks[index]['attributes'];
                          final taskId = tasks[index]['id'];
                          final title = task['title'];
                          final description = task['description'];
                          final completed = task['completed'];
                          if (completed == false) return SizedBox();
                          return Container(
                            margin: EdgeInsets.only(top: 16, left: 16, right: 16),
                            child: GestureDetector(
                              onTap: () => showTaskViewModal(context, task),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(
                                      color: AppPallete.primaryColor,
                                      width: 2,
                                    )),
                                tileColor: AppPallete.primaryColor.withOpacity(.03),
                                leading: Checkbox(
                                  value: completed ?? false,
                                  activeColor: AppPallete.primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  onChanged: (bool? value) {
                                    _toggleTaskCompletion(taskId, completed);
                                    refetch?.call();
                                  },
                                ),
                                title: Text(
                                  title ?? "",
                                  style: GoogleFonts.poppins(
                                      // decoration:
                                      //     completed ? TextDecoration.lineThrough : TextDecoration.none,
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  description ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        _editTask(context, task, refetch ?? () {}, taskId);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.red.withOpacity(1),
                                      onPressed: () {
                                        _deleteTask(context, taskId, refetch ?? () {});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
