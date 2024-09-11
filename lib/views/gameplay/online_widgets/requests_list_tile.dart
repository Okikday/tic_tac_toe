import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/utils/device_utils.dart';
import 'package:tic_tac_toe/services/providers/device_provider.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/requests_to_play_online.dart';

class RequestsListTile extends StatefulWidget {
  const RequestsListTile({super.key});

  @override
  State<RequestsListTile> createState() => _RequestsListTileState();
}

class _RequestsListTileState extends State<RequestsListTile> {
  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<DeviceProvider>(context, listen: false).userId;
    final DatabaseReference query = FirebaseDatabase.instance.ref("onlinePlayers/$uid");
    final double screenWidth = DeviceUtils.getScreenWidth(context);

    return StreamBuilder(
      stream: query.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        return loadRequestsAndWaiting(snapshot, screenWidth, context);
      },
    );
  }

  SizedBox loadRequestsAndWaiting(AsyncSnapshot<DatabaseEvent> snapshot, double screenWidth, BuildContext context) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return waitingTopBar(screenWidth, context);
    } else if (snapshot.hasData && snapshot.data?.snapshot.value != null ) {
      if(snapshot.data!.snapshot.child("requests").exists || snapshot.data!.snapshot.child("sentRequests").exists){
        Map<dynamic, dynamic> requests;
      Map<dynamic, dynamic> sentRequests;
      if(snapshot.data!.snapshot.child("requests").value is Map){
         requests = snapshot.data!.snapshot.child("requests").value as Map<dynamic, dynamic>;
      }else{requests = {};}
      if(snapshot.data!.snapshot.child("sentRequests").value is Map){
        sentRequests = snapshot.data!.snapshot.child("sentRequests").value as Map<dynamic, dynamic>;
      }else{sentRequests = {};}
    
       return topBar(screenWidth, context, requests, sentRequests);
      }else{return defaultTopBar(screenWidth, context);}
    
    } else {
      return defaultTopBar(screenWidth, context);
    }
  }



  SizedBox topBar(double screenWidth, BuildContext context, Map<dynamic, dynamic> requests,  Map<dynamic, dynamic> sentRequests){
    return SizedBox(
          width: screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () {
                  DeviceUtils.pushMaterialPage(context, RequestsToPlayOnline(requests: requests,));
                },
                child: Row(
                  children: [
                    MyText().medium(context, "Requests"),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 12,
                        child: MyText().small(context, requests.length.toString(),), // Show number of requests
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  // Logic for waiting button
                },
                child: Row(
                  children: [
                    MyText().medium(context, "Waiting"),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 60, 142, 63),
                        radius: 12,
                        child: MyText().small(context, sentRequests.length.toString(),), // Placeholder value for waiting
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
  }

  SizedBox defaultTopBar(double screenWidth, BuildContext context) {
    return SizedBox(
          width: screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () {
                  DeviceUtils.showFlushBar(context, "No one has sent you a request yet.");
                },
                child: Row(
                  children: [
                    MyText().medium(context, "Requests"),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 12,
                        child: MyText().small(context, "0",), // No requests available
                      ),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  DeviceUtils.showFlushBar(context, "You haven't made a request, so nothing to wait for");
                },
                child: Row(
                  children: [
                    MyText().medium(context, "Waiting"),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 60, 142, 63),
                        radius: 12,
                        child: MyText().small(context, "0",), // No waiting data available
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
  }

  SizedBox waitingTopBar(double screenWidth, BuildContext context) {
    return SizedBox(
          width: screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                onPressed: () {
                  DeviceUtils.showFlushBar(context, "Loading requests list");
                },
                child: Row(
                  children: [
                    MyText().medium(context, "Requests"),
                    const SizedBox(width: 12, height: 12, child: CircularProgressIndicator()), // Loading indicator for requests
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  DeviceUtils.showFlushBar(context, "Loading waiting lists");
                },
                child: Row(
                  children: [
                    MyText().medium(context, "Waiting"),
                    CircleAvatar(
                      backgroundColor: const Color.fromARGB(255, 60, 142, 63),
                      radius: 12,
                      child: MyText().small(context, "0", invertColor: true), // No waiting data yet
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
  }
}
