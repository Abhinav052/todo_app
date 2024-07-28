import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:todolist/services/queries/task_queries.dart';
import 'package:todolist/utils/theme/app_pallete.dart';

class TaskEditModal extends StatefulWidget {
  final Map task;
  final VoidCallback refetch;
  final String id;
  TaskEditModal({required this.task, required this.refetch, required this.id});

  @override
  _TaskEditModalState createState() => _TaskEditModalState();
}

class _TaskEditModalState extends State<TaskEditModal> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late bool isCompleted;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task['title']);
    descriptionController = TextEditingController(text: widget.task['description']);
    isCompleted = widget.task['completed'];
  }

  void _updateTask() {
    final client = GraphQLProvider.of(context).value;
    client.mutate(
      MutationOptions(
        document: gql(updateCompleteTaskMutation),
        variables: {
          'id': widget.id,
          'title': titleController.text,
          'description': descriptionController.text,
          'completed': isCompleted,
        },
        onCompleted: (dynamic resultData) {
          widget.refetch();
          Navigator.of(context).pop();
        },
        onError: (error) {
          print(error);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Update Task",
                  style: GoogleFonts.poppins(
                      color: AppPallete.primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
                )),
            ListTile(
              title: TextFormField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
            ),
            ListTile(
              title: TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
            ),
            ListTile(
              leading: Checkbox(
                value: isCompleted,
                onChanged: (bool? value) {
                  setState(() {
                    isCompleted = value ?? false;
                  });
                },
              ),
              title: Text('Completed'),
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppPallete.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _updateTask,
                child: Text(
                  'Update Task',
                  style: GoogleFonts.poppins(
                      color: AppPallete.surfaceColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
