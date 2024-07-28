import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todolist/services/queries/task_queries.dart';
import 'package:todolist/utils/theme/app_pallete.dart';

import '../../viewModel/auth_view_model.dart';

class TaskCreateModal extends StatefulWidget {
  final VoidCallback refetch;

  TaskCreateModal({required this.refetch});

  @override
  _TaskCreateModalState createState() => _TaskCreateModalState();
}

class _TaskCreateModalState extends State<TaskCreateModal> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  void _createTask() {
    final client = GraphQLProvider.of(context).value;
    final userId = Provider.of<AuthViewModel>(context, listen: false).user["id"];
    client.mutate(
      MutationOptions(
        document: gql(createTaskMutation),
        variables: {
          'title': titleController.text.trim(),
          'description': descriptionController.text.trim(),
          'completed': isCompleted,
          'publishedAt': DateTime.now().toIso8601String().split('.').first + "Z",
          'userId': userId.toString(),
        },
        onCompleted: (dynamic resultData) {
          widget.refetch();
          Navigator.of(context).pop();
        },
        onError: (error) {
          print(error);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating task: $error')),
          );
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
                "Create Task",
                style: GoogleFonts.poppins(
                    color: AppPallete.primaryColor, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
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
                onPressed: _createTask,
                child: Text(
                  'Create Task',
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
