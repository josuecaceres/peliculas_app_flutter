import 'package:flutter/material.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/screens/screens.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late ScrollController _scrollController;
  Color _textColor = Colors.white;
  static const kExpandedHeight = 250.0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _textColor = _isSliverAppBarExpanded ? Colors.white : Colors.black;
        });
      });
  }

  bool get _isSliverAppBarExpanded {
    return _scrollController.hasClients && _scrollController.offset > kExpandedHeight - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)?.settings.arguments as Movie;

    return Scaffold(
        body: CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        _CustomAppBar(movie, _isSliverAppBarExpanded, _textColor),
        SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              _PosterAndTitle(movie),
              _Overview(movie),
              _Overview(movie),
              _Overview(movie),
              CastingCards(idMovie: movie.id),
            ],
          ),
        ),
      ],
    ));
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie movie;
  final bool isSliverAppBarExpanded;
  final Color textColor;

  const _CustomAppBar(this.movie, this.isSliverAppBarExpanded, this.textColor);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: isSliverAppBarExpanded ? Text(movie.title, style: TextStyle(color: textColor)) : null,
      pinned: true,
      snap: false,
      floating: false,
      expandedHeight: 250,
      flexibleSpace: isSliverAppBarExpanded
          ? null
          : FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: const EdgeInsets.all(0),
              title: Container(
                width: double.infinity,
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
                color: Colors.black12,
                child: Text(
                  movie.title,
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              stretchModes: const <StretchMode>[StretchMode.fadeTitle],
              background: FadeInImage(
                placeholder: const AssetImage('assets/img/loading.gif'),
                image: NetworkImage(movie.fullBackdropPhat),
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;

  const _PosterAndTitle(this.movie);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
                placeholder: const AssetImage('assets/img/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg),
                height: 150,
              ),
            ),
          ),
          const SizedBox(width: 10),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  movie.title,
                  style: textTheme.headlineSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  movie.originalTitle,
                  style: textTheme.titleSmall,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Row(
                  children: <Widget>[
                    const Icon(Icons.star_outline, size: 15, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text('${movie.voteAverage}', style: textTheme.bodySmall)
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final Movie movie;

  const _Overview(this.movie);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        movie.overview,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
