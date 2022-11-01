import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/utils.dart';
import '../bloc/tv/tv_bloc.dart';
import '../widgets/tv_card_list.dart';

class WatchlistSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-series';

  @override
  _WatchlistSeriesPageState createState() => _WatchlistSeriesPageState();
}

class _WatchlistSeriesPageState extends State<WatchlistSeriesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<WatchlistSeriesBloc>().add(FetchWatchlistSeries()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<WatchlistSeriesBloc>().add(FetchWatchlistSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistSeriesBloc, SeriesState>(
          builder: (context, state) {
            if (state is SeriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistSeriesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final series = state.watchlistSeries[index];
                  return SeriesCard(series);
                },
                itemCount: state.watchlistSeries.length,
              );
            } else if (state is SeriesHasError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(child: const Text('No Watchlist Series'));
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
