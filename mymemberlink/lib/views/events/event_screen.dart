import 'package:flutter/material.dart';
import 'package:mymemberlink/views/events/new_event.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        actions: [
          IconButton(onPressed: (){}, 
          icon: const Icon(Icons.refresh))
        ],
      ),
      body: const Center(
        child: Text("Events..."),
      ),
      drawer: const Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, 
              MaterialPageRoute(builder: (content) => const NewEventScreen()));
        },
        child: const Icon(Icons.add),
        ),
      );
    }
  }