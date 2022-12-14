import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constants.dart';
import '../../domain/entities/tv.dart';
import '../bloc/tv/tv_bloc.dart';
import 'now_playing_series.dart';
import 'popular_tv_page.dart';
import 'top_rated_tv_page.dart';
import 'tv_detail_page.dart';
import 'tv_search_page.dart';

class HomeSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/home-series';
  @override
  _HomeSeriesPageState createState() => _HomeSeriesPageState();
}

class _HomeSeriesPageState extends State<HomeSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PopularSeriesBloc>().add(FetchPopularSeries());
      context.read<NowPlayingSeriesBloc>().add(FetchNowPlayingSeries());
      context.read<TopRatedSeriesBloc>().add(FetchTopRatedSeries());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPageTv.ROUTE_NAME);
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubHeading(
                title: 'Now Playing',
                onTap: () => Navigator.pushNamed(
                    context, NowPlayingSeriesPage.ROUTE_NAME),
              ),
              BlocBuilder<NowPlayingSeriesBloc, SeriesState>(
                  builder: (context, state) {
                if (state is SeriesLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SeriesHasData) {
                  return SeriesList(state.tv);
                } else if (state is SeriesHasError) {
                  return Center(
                    child: Text(state.message),
                  );
                } else {
                  return Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Popular',
                onTap: () =>
                    Navigator.pushNamed(context, PopularSeriesPage.ROUTE_NAME),
              ),
              BlocBuilder<PopularSeriesBloc, SeriesState>(
                  builder: (context, state) {
                if (state is SeriesLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SeriesHasData) {
                  return SeriesList(state.tv);
                } else if (state is SeriesHasError) {
                  return Center(
                    child: Text(state.message),
                  );
                } else {
                  return Text('Failed');
                }
              }),
              _buildSubHeading(
                title: 'Top Rated',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedSeriesPage.ROUTE_NAME),
              ),
              BlocBuilder<TopRatedSeriesBloc, SeriesState>(
                  builder: (context, state) {
                if (state is SeriesLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SeriesHasData) {
                  return SeriesList(state.tv);
                } else if (state is SeriesHasError) {
                  return Center(
                    child: Text(state.message),
                  );
                } else {
                  return Text('Failed');
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class SeriesList extends StatelessWidget {
  final List<TV> series;

  SeriesList(this.series);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final serieses = series[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  SeriesDetailPage.ROUTE_NAME,
                  arguments: serieses.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$BASE_IMAGE_URL${serieses.posterPath}',
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: series.length,
      ),
    );
  }
}
