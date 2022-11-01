part of 'searchtv_bloc.dart';

abstract class SearchTVEvent extends Equatable {
  const SearchTVEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChange extends SearchTVEvent {
  final String query;

  OnQueryChange(this.query);

  @override
  List<Object> get props => [query];
}
