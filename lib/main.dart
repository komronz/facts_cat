import 'dart:typed_data';

import 'package:facts_cat/boxes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/bloc/facts_bloc.dart';
import 'models/facts.dart';
import 'models/history.dart';
import 'widgets/history_drawer.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HistoryAdapter());
  historyBox = await Hive.openBox<History>('history');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FactsBloc()..add(LoadedFactEvent()),
      child: MaterialApp(
        debugShowMaterialGrid: false,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //late Box<History> _historyBox;
  late Uint8List _imageBytes;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _historyBox = Hive.box<History>('history');
  // }


  @override
  Widget build(BuildContext context) {
    //List<History> _historyList = _historyBox.values.toList();
    return Scaffold(
      backgroundColor: const Color(0xffbac232),
      drawer: HistoryDrawer(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text('Cat Facts'),
        centerTitle: true,
        backgroundColor: const Color(0xff878d25),
      ),
      body: BlocBuilder<FactsBloc, FactsState>(
        builder: (context, state) {
          if (state is FactsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          } else if (state is FactsLoadedState) {
            _imageBytes = state.imageUrl;
            final List<Facts> facts = state.facts;
            final int index = state.index;
            final String fact = facts[index].text;

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset:
                              const Offset(2, 2), // changes position of shadow
                            ),
                          ],
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: MemoryImage(_imageBytes),
                          )),
                    ),
                  ),
                  Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        fact,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor:
                        MaterialStatePropertyAll(Colors.black),
                        foregroundColor:
                        MaterialStatePropertyAll(Colors.white),
                      ),
                      onPressed: () async {
                        // final History newHistory = History(fact: fact);
                        // setState(() {
                        //   _historyList = [..._historyList, newHistory];
                        // });
                        //await _historyBox.add(newHistory);
                        setState(() {
                          historyBox.put('key_${DateTime.now()}', History(fact: fact));
                        });
                        BlocProvider.of<FactsBloc>(context, listen: false)
                            .add(LoadedFactEvent());
                      },
                      child: const Text('Another fact!')),
                ],
              ),
            );
          } else if (state is FailedToLoad) {
            return Center(child: Text(state.errorMessage));
          } else {
            return Container();
          }
        },
      ),
    );
  }
}