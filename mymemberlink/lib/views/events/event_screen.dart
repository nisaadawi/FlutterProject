import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mymemberlink/models/myevent.dart';
import 'package:mymemberlink/myconfig.dart';
import 'package:mymemberlink/views/events/new_event.dart';
import 'package:http/http.dart' as http;

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List<MyEvent> eventList = [];
  late double screenWidth, screenHeight;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  String status = "Loading..";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadEventsData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth <= 600){
      
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        actions: [
          IconButton(onPressed: (){
            loadEventsData();
          }, 
          icon: const Icon(Icons.refresh)
          )
        ],
      ),
      body: eventList.isEmpty
      ?   Center(
        child: Text(
          status,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
      )
      :GridView.count(
        childAspectRatio: 0.8,
        crossAxisCount: 2,
        children: 
          List.generate(eventList.length, (index){
            return Card(
              child: InkWell(
                splashColor: Colors.red,
                onLongPress: (){},
                onTap: (){},
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
                  child: Column(children: [
                    Text(eventList[index].eventTitle.toString(),
                    style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis),
                    ),
                    SizedBox(child: Image.network(
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                    "assets/images/na.png",
                                  ),
                              width: screenWidth / 2,
                              height: screenHeight / 6,
                              fit: BoxFit.cover,
                              scale: 4,
                              "${MyConfig.servername}/memberlink/assets/events/${eventList[index].eventFilename}"),
                        ),
                        Text(eventList[index].eventType.toString()),
                        Text(df.format(DateTime.parse(
                            eventList[index].eventDate.toString()))),
                  ],),
                ),
              ),
            );
          })
        ),
    
      drawer: const Drawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, 
              MaterialPageRoute(builder: (content) => const NewEventScreen()));
        },
        child: const Icon(Icons.add),
        ),
      );
    }
    
    void loadEventsData() {
      http
          .get(Uri.parse("${MyConfig.servername}/memberlink/api/load_events.php"))
          .then((response) {
        //log(response.body.toString());
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data['status'] == "success") {
            var result = data['data']['events'];
            eventList.clear();
            for (var item in result) {
              MyEvent myevent = MyEvent.fromJson(item);
              eventList.add(myevent);
            }
            setState(() {});
          } else {
            status = "No Data";
          }
        } else {
          status = "Error loading data";
          print("Error");
          setState(() {});
        }
      });
    }
  }