import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/common/styles/constants.dart';
import 'package:tic_tac_toe/models/gameplay.dart';

class OnlineGridboard3By3 extends StatefulWidget {
  final List<dynamic>? gameplayList;
  final String playAs;
  final String gameplayID;
  
  const OnlineGridboard3By3({
    super.key,
    required this.gameplayList,
    required this.playAs,
    required this.gameplayID,
  });

  @override
  State<OnlineGridboard3By3> createState() => _OnlineGridboard3By3State();
}

class _OnlineGridboard3By3State extends State<OnlineGridboard3By3> {
 

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 176, 216, 178).withOpacity(0.5),
                const Color.fromARGB(255, 201, 164, 209).withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              CustomPaint(
                size: const Size(300, 300),
                painter: HashShapePainter(),
              ),
              GridView.builder(
                padding: const EdgeInsets.all(0),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  String? textToShow = widget.gameplayList![index];
                  if(textToShow != null){
                    if(textToShow == "0"){
                      textToShow = 'O';
                    }else if(textToShow == '1'){
                      textToShow = 'X';
                    }else{
                      textToShow = '';
                    }
                  }
                  return GridItem(
                    text: textToShow ?? "",
                    onpressed: () async{
                      debugPrint("$index clicked!");
                      debugPrint("Play as: ${widget.playAs}");
                      if(widget.playAs == "player1"){
                        final int useIndex = index;
                        DatabaseReference dbGameplayRef = FirebaseDatabase.instance.ref("gameSessions/${widget.gameplayID}/gameplayList");
                        DataSnapshot dataSnapshot = await dbGameplayRef.get();
                        List<dynamic>? list = dataSnapshot.value as List<dynamic>?;
                        print("${dataSnapshot.exists}");
                        int count = 0;
                        for(int i = 0; i < list!.length; i++){
                          list[i] != "null" ? count++ : count;
                        }
                        if(count%2 == 0){
                         list[useIndex] = "1";
                        }
                        await dbGameplayRef.update({
                          for(int i = 0; i < list.length; i++) i.toString() : list[i].toString()
                        });
                        List<int?> listToCheck = [];
                        for(int i = 0; i < list.length; i++){
                          final dynamic item = list[i];
                          if(item == "null" || item == null){
                            listToCheck.add(null);
                          }else if(item == "0"){
                            listToCheck.add(0);
                          }else if(item == "1"){
                            listToCheck.add(1);
                          }
                        }
                        final int? checkWinner = Gameplay().checkWinnerGrid3(listToCheck, count);
                        if(checkWinner == 0){
                          await FirebaseDatabase.instance.ref("gameSessions/${widget.gameplayID}/").update({
                            'currentWinBy': "player2"
                          });
                          //O won
                        }else if(checkWinner == 1){
                          //X won
                          await FirebaseDatabase.instance.ref("gameSessions/${widget.gameplayID}/").update({
                            'currentWinBy': "player1"
                          });
                        }
                      }
                      if(widget.playAs == "player2"){
                        final int useIndex = index;
                        DatabaseReference dbGameplayRef = FirebaseDatabase.instance.ref("gameSessions/${widget.gameplayID}/gameplayList");
                        DataSnapshot dataSnapshot = await dbGameplayRef.get();
                        List<dynamic>? list = dataSnapshot.value as List<dynamic>?;
                        print("${dataSnapshot.exists}");
                        int count = 0;
                        for(int i = 0; i < list!.length; i++){
                          list[i] != "null" ? count++ : count;
                        }
                        if(count%2 == 1){
                         list[useIndex] = "0";
                        }
                        await dbGameplayRef.update({
                          for(int i = 0; i < list.length; i++) i.toString() : list[i].toString()
                        });
                         List<int?> listToCheck = [];
                        for(int i = 0; i < list.length; i++){
                          final dynamic item = list[i];
                          if(item == "null" || item == null){
                            listToCheck.add(null);
                          }else if(item == "0"){
                            listToCheck.add(0);
                          }else if(item == "1"){
                            listToCheck.add(1);
                          }
                        }
                        final int? checkWinner = Gameplay().checkWinnerGrid3(listToCheck, count);
                        if(checkWinner == 0){
                          await FirebaseDatabase.instance.ref("gameSessions/${widget.gameplayID}/").update({
                            'currentWinBy': "player2"
                          });
                          //O won
                        }else if(checkWinner == 1){
                          //X won
                          await FirebaseDatabase.instance.ref("gameSessions/${widget.gameplayID}/").update({
                            'currentWinBy': "player1"
                          });
                        }
                      }
                      
                     
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class GridItem extends StatefulWidget {
  final String text;
  final void Function()? onpressed;
  const GridItem({
    super.key,
    this.onpressed,
    this.text = "lol",
  });
  @override
  State<GridItem> createState() => _GridItemState();
}

class _GridItemState extends State<GridItem>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Color?> colorVal;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    colorVal = ColorTween(
            begin: Colors.transparent, end: Colors.white.withOpacity(0.1))
        .animate(controller);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        controller.forward();
        Future.delayed(const Duration(milliseconds: 260), () {
          controller.reverse();
        });
      },
      onTap: () {
        widget.onpressed == null ? () {} : widget.onpressed!();
      },
      child: AnimatedBuilder(
        animation: colorVal,
        builder: (BuildContext context, Widget? child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: colorVal.value,
            ),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                color: Colors.transparent,
                child: MyText().big(
                  context,
                  widget.text == "null" ? "" : widget.text,
                  align: TextAlign.center,
                  adjust: 16,
                  color: Colors.red,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Painter for 3 by 3 grid
class HashShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final double thirdWidth = size.width / 3;
    final double thirdHeight = size.height / 3;
    const double lineThickness = 8.0;
    const double radius = 24.0;

    final RRect topRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          0, thirdHeight - lineThickness / 2, size.width, lineThickness),
      const Radius.circular(radius),
    );
    final RRect bottomRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          0, 2 * thirdHeight - lineThickness / 2, size.width, lineThickness),
      const Radius.circular(radius),
    );

    final RRect leftRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          thirdWidth - lineThickness / 2, 0, lineThickness, size.height),
      const Radius.circular(radius),
    );
    final RRect rightRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          2 * thirdWidth - lineThickness / 2, 0, lineThickness, size.height),
      const Radius.circular(radius),
    );

    canvas.drawRRect(topRect, paint);
    canvas.drawRRect(bottomRect, paint);
    canvas.drawRRect(leftRect, paint);
    canvas.drawRRect(rightRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
