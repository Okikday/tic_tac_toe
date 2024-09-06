import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/views/gameplay/online_widgets/requests_to_play_online.dart';
import 'package:tic_tac_toe/services/device_provider.dart';

class RequestsListTile extends StatefulWidget {
  const RequestsListTile({super.key});

  @override
  State<RequestsListTile> createState() => _RequestsListTileState();
}

class _RequestsListTileState extends State<RequestsListTile> {
  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<DeviceProvider>(context, listen: false).userId;
    final DatabaseReference query = FirebaseDatabase.instance.ref("onlinePlayers/$uid/requests");
        
    return StreamBuilder(
      stream: query.onValue,
      builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
        
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(
            title: MyText().medium(context, "Requests"),
            trailing: const SizedBox(width: 12, height: 12, child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
          Map<dynamic, dynamic> requests = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          Provider.of<DeviceProvider>(context).setCurrentOnlineGameplayID(requests.entries.first.key.toString());
          
          return ListTile(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => RequestsToPlayOnline()));
            },
            title: MyText().medium(context, "Requests"),
            trailing: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 12,
              child: MyText().small(context, requests.length.toString(), invertColor: true)
            ),
          );
        }else{
          return ListTile(
            title: MyText().medium(context, "Requests"),
            trailing: CircleAvatar(
              radius: 12,
              child: MyText().small(context, "0", invertColor: true)
            ),
          );
        }
      },
    );
  }
}
