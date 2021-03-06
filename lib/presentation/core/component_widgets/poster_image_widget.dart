import 'package:flutter/material.dart';

import '../../../infrastructure/core/credentials.dart';

class PosterImageWidget extends StatelessWidget {
  const PosterImageWidget({
    Key key,
    @required this.movieOrSeries,
  }) : super(key: key);

  final dynamic movieOrSeries;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      "$MOVIE_POSTER_PATH${movieOrSeries.posterPath}",
      fit: BoxFit.cover,
      errorBuilder: (context, e, error) =>
          const Center(child: Icon(Icons.image_outlined)),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes
                : null,
          ),
        );
      },
    );
  }
}
