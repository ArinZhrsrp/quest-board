import 'package:flutter/material.dart';
import 'package:task_game/components/custom_button.dart';
import 'package:task_game/components/custom_textformfield.dart';

class CreateQuestsView extends StatefulWidget {
  const CreateQuestsView({super.key});

  @override
  State<CreateQuestsView> createState() => _CreateQuestsViewState();
}

class _CreateQuestsViewState extends State<CreateQuestsView> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

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
        child: Column(
          children: [
            CustomTextFormField(
              labelText: 'Quest Title',
              hintText: 'Enter Quest Title',
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              labelText: 'Description',
              hintText: 'Enter Quest Description',
              maxLines: 5,
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
                        '100',
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
                DateTime now = DateTime.now();
                DateTime firstSelectableDate = now.add(Duration(days: 4));
                DateTime lastSelectableDate =
                    DateTime(now.year + 1, now.month, now.day);

                DateTime? selectedDate;

                DateTime initialDate = selectedDate ?? firstSelectableDate;

                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: initialDate,
                    firstDate: firstSelectableDate,
                    lastDate: lastSelectableDate);
                // if (pickedDate != null) {
                //   controller.updateSelectedDate(pickedDate);
                // }
              },
              child: CustomTextFormField(
                prefixIcon: Icon(
                  Icons.calendar_month,
                  color: primaryColor,
                ),
                labelText: 'Deadline Date',
                hintText: 'Enter Deadline Date',
                keyboardType: TextInputType.datetime,
                enabled: false,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                TimeOfDay? selectedTime;

                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: selectedTime ?? TimeOfDay.now(),
                );
                // if (pickedTime != null) {
                //   // Convert TimeOfDay to DateTime for storage or further use
                //   final DateTime now = DateTime.now();
                //   final DateTime selectedTime = DateTime(now.year, now.month,
                //       now.day, pickedTime.hour, pickedTime.minute);
                //   controller.updateSelectedTime(
                //       selectedTime); // Update your controller accordingly
                // }
              },
              child: CustomTextFormField(
                prefixIcon: Icon(
                  Icons.access_time,
                  color: primaryColor,
                ),
                labelText: 'Deadline Time',
                hintText: 'Enter Deadline Time',
                enabled: false,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CustomButton(
                type: CustomButtonType.primary,
                title: 'Create Quest',
                onPressed: () {})
          ],
        ),
      ),
    );
  }
}
