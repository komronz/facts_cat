import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import '../facts.dart';

part 'facts_event.dart';
part 'facts_state.dart';

class FactsBloc extends Bloc<FactsEvent, FactsState> {

  FactsBloc() : super(FactsLoadingState()) {
    on<FactsEvent>((event, emit) async {
      if(event is LoadedFactEvent){
        emit(FactsLoadingState());
        try{
          Dio dio = Dio();
          final uri = Uri.https('cat-fact.herokuapp.com', '/facts');
          final response = await http.get(uri);
          final response_dio = await dio.get('https://cat-fact.herokuapp.com/facts');
          final json = jsonDecode(response.body) as List;
          final json_dio = response_dio.data as List;
          final facts = json.map((e) => Facts.fromJson(e)).toList();
          final facts_dio = json_dio.map((e) => Facts.fromJson(e)).toList();

          final numbers = List.generate(facts_dio.length,
              //facts.length,
                  (index) => index);
          numbers.shuffle();
          int previousNumber = numbers.removeLast();
          int randomNumber = previousNumber;
          if (randomNumber == previousNumber) {
            randomNumber = numbers.removeLast();
          }


          final responseImage = await http.get(Uri.parse('https://cataas.com/cat'));


          emit(FactsLoadedState(index: randomNumber, facts: facts_dio, imageUrl: responseImage.bodyBytes,));
        }catch(errorMessage){
          emit(FailedToLoad(errorMessage: errorMessage.toString()));
        }
      }
    });
  }
}
