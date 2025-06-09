import 'package:flutter/material.dart';
import 'package:task_game/components/custom_button.dart';
import 'package:task_game/components/custom_textformfield.dart';

class CreateRewardView extends StatefulWidget {
  const CreateRewardView({super.key});

  @override
  State<CreateRewardView> createState() => _CreateRewardViewState();
}

class _CreateRewardViewState extends State<CreateRewardView> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.pinkAccent.shade100;
    final overlayColor = Colors.pink.shade100;

    final List<IconData> icons = [
      Icons.card_giftcard, // Gift
      Icons.diamond, // Diamond
      Icons.coffee, // Coffee
      Icons.shopping_bag, // Bag
      Icons.tv, // TV
      Icons.restaurant, // Food
      Icons.flight, // Plane
    ];

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        shape: Border.all(color: Colors.grey.shade300),
        title: Text(
          'Create Reward',
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
              labelText: 'Reward Title',
              hintText: 'Enter Reward Title',
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextFormField(
              labelText: 'Description',
              hintText: 'Enter Reward Description',
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
                    labelText: 'Points Cost',
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
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                textAlign: TextAlign.start,
                'Icon',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            GridView.builder(
                shrinkWrap: true,
                itemCount: icons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12),
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.pink.shade50 : Colors.white,
                        border: Border.all(
                          color:
                              isSelected ? Colors.pink : Colors.grey.shade300,
                          width: isSelected ? 2 : 3,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icons[index],
                        color: Colors.pink,
                        size: 28,
                      ),
                    ),
                  );
                }),
            SizedBox(
              height: 20,
            ),
            CustomButton(
              type: CustomButtonType.primary,
              title: 'Create Reward',
              onPressed: () {},
              color: primaryColor,
              overlayColor: overlayColor,
            )
          ],
        ),
      ),
    );
  }
}
