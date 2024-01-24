import 'package:facts_cat/boxes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/history.dart';

class HistoryDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: const Color(0xff319300),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text('History of facts you saw:',textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white, fontSize: 24),),
            ),
            const Divider(color: Colors.yellowAccent,thickness: 2.0),
            SizedBox(
                height: 600,
                child: ListView.builder(
                  itemCount: historyBox.length,
                  itemBuilder: (context, index) {
                    History history = historyBox.getAt(index);
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(history.fact, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white),),
                          const Divider(color: Colors.white,),
                        ],
                      ),
                    );
                  },
                ),
            ),
          ],
        ),
      ),
    );
  }
}