import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mymemberlink/models/myevent.dart';
import 'package:mymemberlink/myconfig.dart';
import 'package:mymemberlink/views/events/edit_event.dart';
import 'package:mymemberlink/views/events/new_event.dart';
import 'package:http/http.dart' as http;
import 'package:mymemberlink/views/shared/drawer_main_screen.dart';

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
        childAspectRatio: 0.75,
        crossAxisCount: 2,
        children: 
          List.generate(eventList.length, (index){
            return Card(
              child: InkWell(
                splashColor: Colors.red,
                onLongPress: (){
                  deleteDialog(index);
                },
                onTap: (){
                  showEventDetailsDialog(index);
                },
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
                                    SizedBox(
                                      height: screenHeight/6,
                                      child: Image.asset(
                                        "assets/images/na.png",
                                      ),
                                  ),
                              width: screenWidth / 2,
                              height: screenHeight / 6,
                              fit: BoxFit.cover,
                              scale: 4,
                              "${MyConfig.servername}/memberlink/assets/events/${eventList[index].eventFilename}"),
                        ),
                        //Text(eventList[index].eventType.toString()),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Text(
                            eventList[index].eventType.toString(),
                            style: const TextStyle(
                                fontSize: 18, 
                                fontWeight: FontWeight.bold,),
                                textAlign: TextAlign.left,
                          ),
                        ),
                        Text(df.format(DateTime.parse(
                            eventList[index].eventDate.toString()))),
                        Text(truncateString(
                          eventList[index].eventDescription.toString(), 45)),
                  ],),
                ),
              ),
            );
          })
        ),
    
      drawer: MainScreenDrawer(),
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
    
    String truncateString(String str, int length) {
      if (str.length > length) {
        str = str.substring(0, length);
        return "$str...";
      } else {
        return str;
      }
    }
    
      void showEventDetailsDialog(int index) {
        showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(eventList[index].eventTitle.toString()),
            content: SingleChildScrollView(
              child: Column(children: [
                Image.network(
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                          "assets/images/na.png",
                        ),
                    width: screenWidth,
                    height: screenHeight / 4,
                    fit: BoxFit.cover,
                    scale: 4,
                    "${MyConfig.servername}/memberlink/assets/events/${eventList[index].eventFilename}"),
                Text(eventList[index].eventType.toString()),
                Text(df.format(
                    DateTime.parse(eventList[index].eventDate.toString()))),
                Text(eventList[index].eventLocation.toString()),
                const SizedBox(height: 10),
                Text(
                  eventList[index].eventDescription.toString(),
                  textAlign: TextAlign.justify,
                )
              ]),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  MyEvent myevent = eventList[index];
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => EditEventScreen(
                                myevent: myevent,
                              )));
                  loadEventsData();
                },
                child: const Text("Edit Event"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Close"),
              )
            ],
          );
        });
      }
      
      void deleteDialog(int index) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                title: Text(
                  "Delete \"${truncateString(eventList[index].eventTitle.toString(), 20)}\"",
                  style: const TextStyle(fontSize: 18),
                ),
                content:
                    const Text("Are you sure you want to delete this event?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("No"),
                  ),
                  TextButton(
                    onPressed: () {
                      deleteEvent(index);
                      Navigator.pop(context);
                    },
                    child: const Text("Yes"),
                  )
                ]);
          });
        }
    
      void deleteEvent(int index) {
        http.post(
          Uri.parse("${MyConfig.servername}/memberlink/api/delete_event.php"),
          body: {
            "eventid": eventList[index].eventId.toString()
          }).then((response) {
        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          // log(data.toString());
          if (data['status'] == "success") {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Success"),
              backgroundColor: Colors.green,
            ));
            loadEventsData(); //reload data
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Failed"),
              backgroundColor: Colors.red,
            ));
          }
        }
      }); 
    }
  }