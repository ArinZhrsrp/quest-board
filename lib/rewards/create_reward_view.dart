import 'package:flutter/material.dart';
import 'package:task_game/components/custom_button.dart';
import 'package:task_game/components/custom_textformfield.dart';
import 'package:task_game/data/local/reward_helper.dart';
import 'package:task_game/data/model/reward_model.dart';

class CreateRewardView extends StatefulWidget {
  const CreateRewardView({super.key});

  @override
  State<CreateRewardView> createState() => _CreateRewardViewState();
}

class _CreateRewardViewState extends State<CreateRewardView> {
  final formKey = GlobalKey<FormState>();

  int selectedIndex = -1;

  final titleController = TextEditingController();
  final descController = TextEditingController();
  final pointsController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    pointsController.dispose();
    super.dispose();
  }

  Future<void> onCreatePressed() async {
    if (formKey.currentState?.validate() != true) {
      return; // Show validation errors
    }

    if (selectedIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an icon')),
      );
      return;
    }

    final reward = Reward(
      title: titleController.text,
      description: descController.text,
      pointsCost: int.parse(pointsController.text),
      iconIndex: selectedIndex,
    );

    await RewardDatabaseHelper.instance.createReward(reward);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          backgroundColor: Colors.green,
          content: Text('Reward created successfully!')),
    );

    Navigator.pop(context);
  }

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
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextFormField(
                labelText: 'Reward Title',
                hintText: 'Enter Reward Title',
                controller: titleController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a reward title';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              CustomTextFormField(
                labelText: 'Description',
                hintText: 'Enter Reward Description',
                maxLines: 5,
                controller: descController,
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
                      labelText: 'Points Cost',
                      hintText: 'Enter Points',
                      keyboardType: TextInputType.datetime,
                      controller: pointsController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter reward points costs';
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
                          color:
                              isSelected ? Colors.pink.shade50 : Colors.white,
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
                onPressed: onCreatePressed,
                color: primaryColor,
                overlayColor: overlayColor,
              )
            ],
          ),
        ),
      ),
    );
  }
}
