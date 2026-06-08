import 'package:flutter/material.dart';

class MovieApp extends StatelessWidget {
  const MovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

// ================= MODEL =================

class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<String> trailers;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
  });
}

// ================= SAMPLE DATA =================

final List<Movie> movies = [
  Movie(
    id: 1,
    title: "Dune: Part Two",
    posterUrl:
        "https://images.unsplash.com/photo-1517602302552-471fe67acf66?w=1200",
    rating: 8.6,
    genres: ["Sci-Fi", "Adventure", "Drama"],
    overview:
        "Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.",
    trailers: [
      "Official Trailer #1",
      "IMAX Sneak Peek",
    ],
  ),
  Movie(
    id: 2,
    title: "Deadpool & Wolverine",
    posterUrl:
        "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=1200",
    rating: 8.3,
    genres: ["Action", "Comedy"],
    overview:
        "The multiverse gets messy when Wade Wilson teams up with Wolverine for a not-so-family-friendly mission.",
    trailers: [
      "Red Band Trailer",
      "Behind The Scenes",
    ],
  ),
];

// ================= HOME SCREEN =================

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Movies"),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MovieDetailScreen(movie: movie),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Hero(
                      tag: movie.id,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          movie.posterUrl,
                          width: 80,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "☆ ${movie.rating} • ${movie.genres.join(", ")}",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ================= DETAIL SCREEN =================

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HERO IMAGE
            Stack(
              children: [
                Hero(
                  tag: movie.id,
                  child: Image.network(
                    movie.posterUrl,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 250,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black87,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 16,
                  child: Text(
                    movie.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // GENRES
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 8,
                children: movie.genres
                    .map(
                      (genre) => Chip(
                        label: Text(genre),
                      ),
                    )
                    .toList(),
              ),
            ),

            const SizedBox(height: 10),

            // OVERVIEW
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                movie.overview,
                style: const TextStyle(fontSize: 15),
              ),
            ),

            const SizedBox(height: 20),

            // ACTION BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                      icon: Icon(
                        isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black,
                      ),
                    ),
                    const Text("Favorite"),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.star_border),
                    ),
                    const Text("Rate"),
                  ],
                ),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.share),
                    ),
                    const Text("Share"),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            // TRAILERS
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Trailers",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: movie.trailers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.play_circle_fill),
                  title: Text(movie.trailers[index]),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}