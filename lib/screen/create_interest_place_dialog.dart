import 'package:flutter/material.dart';

class NewPlaceDialog extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;

  const NewPlaceDialog(
      {Key? key, required this.titleController, required this.descriptionController})
      : super(key: key);

  static Future show(BuildContext context,
      {required TextEditingController controller,
      required TextEditingController descriptionController}) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return NewPlaceDialog(
            titleController: controller,
            descriptionController: descriptionController,
          );
        });
  }

  @override
  State<NewPlaceDialog> createState() => _NewPlaceDialogState();
}

class _NewPlaceDialogState extends State<NewPlaceDialog> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.topCenter,
      title: const Text('Add your interest place'),
      actions: [
        InkWell(
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Cancel',
            ),
          ),
        ),
        InkWell(
          onTap: () {
            if (widget.titleController.text.trim().isNotEmpty &&
                widget.descriptionController.text.trim().isNotEmpty) {
              Navigator.pop(context, true);
            }
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Save',
            ),
          ),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            autofocus: true,
            controller: widget.titleController,
            textCapitalization: TextCapitalization.sentences,
            decoration:
                InputDecoration(hintText: 'Title', errorText: errorText),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextFormField(
            controller: widget.descriptionController,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration:
                InputDecoration(hintText: 'Description', errorText: errorText),
          ),
        ],
      ),
    );
  }
}
