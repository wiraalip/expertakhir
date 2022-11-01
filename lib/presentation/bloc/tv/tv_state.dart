part of 'tv_bloc.dart';

abstract class SeriesState extends Equatable {
  const SeriesState();

  @override
  List<Object> get props => [];
}

class SeriesEmpty extends SeriesState {}

class SeriesLoading extends SeriesState {}

class SeriesHasData extends SeriesState {
  final List<TV> tv;

  const SeriesHasData(this.tv);
  @override
  List<Object> get props => [tv];
}

class SeriesHasError extends SeriesState {
  final String message;

  const SeriesHasError(this.message);
  @override
  List<Object> get props => [message];
}

class SeriesDetailHasData extends SeriesState {
  final TvSeriesDetail tv;

  const SeriesDetailHasData(this.tv);
  @override
  List<Object> get props => [tv];
}

class WatchlistSeriesHasData extends SeriesState {
  final List<TV> watchlistSeries;

  const WatchlistSeriesHasData(this.watchlistSeries);

  @override
  List<Object> get props => [watchlistSeries];
}

class WatchlistSeriesMessage extends SeriesState {
  final String message;
  const WatchlistSeriesMessage(this.message);
}

class LoadSeriesWatchlistData extends SeriesState {
  final bool status;
  const LoadSeriesWatchlistData(this.status);

  @override
  List<Object> get props => [status];
}
