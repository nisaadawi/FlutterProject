import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({super.key});

  @override
  State<NewEventScreen> createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  String startDateTime = "", endDateTime = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Event"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 4.0, // Adds a shadow for a lifted look
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded edges
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Add padding inside the card
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    hintText: "Event Title",
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      child: Column(
                        children: [
                          const Text("Select Start Date"),
                          Text(startDateTime.isNotEmpty ? startDateTime : "Not selected"),
                        ],
                      ),
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2030),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((selectTime) {
                              if (selectTime != null) {
                                DateTime selectedDateTime = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectTime.hour,
                                  selectTime.minute,
                                );
                                var formatter = DateFormat('dd-MM-yyyy hh:mm a');
                                setState(() {
                                  startDateTime = formatter.format(selectedDateTime);
                                });
                              }
                            });
                          }
                        });
                      },
                    ),
                    GestureDetector(
                      child: Column(
                        children: [
                          const Text("Select End Date"),
                          Text(endDateTime.isNotEmpty ? endDateTime : "Not selected"),
                        ],
                      ),
                      onTap: () {
                        showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2024),
                          lastDate: DateTime(2030),
                        ).then((selectedDate) {
                          if (selectedDate != null) {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((selectTime) {
                              if (selectTime != null) {
                                DateTime selectedDateTime = DateTime(
                                  selectedDate.year,
                                  selectedDate.month,
                                  selectedDate.day,
                                  selectTime.hour,
                                  selectTime.minute,
                                );
                                var formatter = DateFormat('dd-MM-yyyy hh:mm a');
                                setState(() {
                                  endDateTime = formatter.format(selectedDateTime);
                                });
                              }
                            });
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  }