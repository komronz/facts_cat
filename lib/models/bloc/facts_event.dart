part of 'facts_bloc.dart';

@immutable
abstract class FactsEvent {}

class LoadedFactEvent extends FactsEvent{}


class LoadNextFactEvent extends FactsEvent{}