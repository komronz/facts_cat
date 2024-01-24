part of 'facts_bloc.dart';

@immutable
abstract class FactsState {}

class FactsLoadingState extends FactsState {}

class FactsLoadedState extends FactsState {
  final List<Facts> facts;
  final int index;
  final Uint8List imageUrl;
  FactsLoadedState({required this.index, required this.facts, required this.imageUrl,});
}

class FailedToLoad extends FactsState {
  final String errorMessage;
  FailedToLoad({required this.errorMessage});
}
