import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_game/components/custom_button.dart';
import 'package:task_game/components/custom_textformfield.dart';
import 'package:task_game/data/local/quest_helper.dart';
import 'package:task_game/data/model/quest_model.dart';

class CreateQuestsView extends StatefulWidget {
  const CreateQuestsView({super.key});

  @override
  State<CreateQuestsView> createState() => _CreateQuestsViewState();
}

class _CreateQuestsViewState extends State<CreateQuestsView> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController pointsController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    pointsController.dispose();
    super.dispose();
  }

  DateTime? get deadlineDateTime {
    if (selectedDate == null || selectedTime == null) return null;
    return DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
  }

  Future<void> selectDeadlineDate() async {
    DateTime now = DateTime.now();
    DateTime firstSelectableDate = now; // Allow selecting today
    DateTime lastSelectableDate = DateTime(now.year + 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: firstSelectableDate,
      lastDate: lastSelectableDate,
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> selectDeadlineTime() async {
    final now = DateTime.now();
    final initialTime = selectedTime ?? TimeOfDay.now();

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      // Combine picked date and picked time
      final selectedDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      // Compare with now + 2 hours only if the date is today
      if (selectedDate!.day == now.day &&
          selectedDate!.month == now.month &&
          selectedDate!.year == now.year) {
        final minTime = now.add(const Duration(hours: 2));
        if (selectedDateTime.isBefore(minTime)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  backgroundColor: Colors.red,
                  content:
                      Text("Please choose a time at least 2 hours from now.")),
            );
          }

          return;
        }
      }

      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> onCreatePressed() async {
    if (!(formKey.currentState?.validate() ?? false)) {
      return;
    }

    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final pointsStr = pointsController.text.trim();
    final pointsReward = int.tryParse(pointsStr) ?? 0;

    final newQuest = Quest(
      title: title,
      description: description,
      pointsReward: pointsReward,
      deadlineDateTime: deadlineDateTime,
      status: QuestStatus.active, // Default when created
    );

    log(newQuest.toString());

    await QuestDatabaseHelper.instance.createQuest(newQuest);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          backgroundColor: Colors.green, content: Text('Quest Created')),
    );

    Navigator.of(context).pop(); // Go back to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    String formattedDate = selectedDate == null
        ? ''
        : "${selectedDate!.year.toString().padLeft(4, '0')}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";

    String formattedTime =
        selectedTime == null ? '' : selectedTime!.format(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        shape: Border.all(color: Colors.grey.shade300),
        title: Text(
          'Create Quest',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextFormField(
                labelText: 'Quest Title',
                hintText: 'Enter Quest Title',
                controller: titleController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a quest title';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                labelText: 'Description',
                hintText: 'Enter Quest Description',
                maxLines: 5,
                controller: descriptionController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3,
                    child: CustomTextFormField(
                      labelText: 'Points Reward',
                      hintText: 'Enter Points',
                      keyboardType: TextInputType.datetime,
                      controller: pointsController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter points reward';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          pointsController.text = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.loop, size: 18, color: Colors.blue),
                        SizedBox(width: 4),
                        Text(
                          pointsController.text,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  selectDeadlineDate();
                },
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    prefixIcon: Icon(
                      Icons.calendar_month,
                      color: primaryColor,
                    ),
                    labelText: 'Deadline Date',
                    hintText: 'Enter Deadline Date',
                    keyboardType: TextInputType.datetime,
                    enabled: false,
                    controller: TextEditingController(text: formattedDate),
                    validator: (value) {
                      if (selectedDate == null) {
                        return 'Please select a deadline date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  selectDeadlineTime();
                },
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    prefixIcon: Icon(
                      Icons.access_time,
                      color: primaryColor,
                    ),
                    labelText: 'Deadline Time',
                    hintText: 'Enter Deadline Time',
                    enabled: false,
                    controller: TextEditingController(text: formattedTime),
                    validator: (value) {
                      if (selectedTime == null) {
                        return 'Please select a deadline time';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              CustomButton(
                  type: CustomButtonType.primary,
                  title: 'Create Quest',
                  onPressed: onCreatePressed)
            ],
          ),
        ),
      ),
    );
  }
}
