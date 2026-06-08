import 'package:flutter/material.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movie Browser',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const GenreScreen(),
    );
  }
}

class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

final List<Movie> allMovies = [
  Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Action', 'Sci-Fi'],
    posterUrl: 'https://picsum.photos/300/450?1',
    rating: 8.8,
  ),
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Drama'],
    posterUrl: 'https://picsum.photos/300/450?2',
    rating: 9.0,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Drama', 'Sci-Fi'],
    posterUrl: 'https://picsum.photos/300/450?3',
    rating: 8.7,
  ),
  Movie(
    title: 'Toy Story',
    year: 1995,
    genres: ['Comedy', 'Animation'],
    posterUrl: 'https://picsum.photos/300/450?4',
    rating: 8.3,
  ),
  Movie(
    title: 'Avengers: Endgame',
    year: 2019,
    genres: ['Action', 'Adventure'],
    posterUrl: 'https://picsum.photos/300/450?5',
    rating: 8.4,
  ),
  Movie(
    title: 'The Hangover',
    year: 2009,
    genres: ['Comedy'],
    posterUrl: 'https://picsum.photos/300/450?6',
    rating: 7.7,
  ),
];

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  String searchQuery = '';

  final List<String> genres = [
    'Action',
    'Drama',
    'Comedy',
    'Sci-Fi',
    'Adventure',
    'Animation',
  ];

  final Set<String> selectedGenres = {};

  String selectedSort = 'A-Z';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    List<Movie> visibleMovies = allMovies.where((movie) {
      final matchesSearch = movie.title
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      final matchesGenre = selectedGenres.isEmpty ||
          movie.genres.any(
            (genre) => selectedGenres.contains(genre),
          );

      return matchesSearch && matchesGenre;
    }).toList();

    switch (selectedSort) {
      case 'A-Z':
        visibleMovies.sort(
          (a, b) => a.title.compareTo(b.title),
        );
        break;

      case 'Z-A':
        visibleMovies.sort(
          (a, b) => b.title.compareTo(a.title),
        );
        break;

      case 'Year':
        visibleMovies.sort(
          (a, b) => b.year.compareTo(a.year),
        );
        break;

      case 'Rating':
        visibleMovies.sort(
          (a, b) => b.rating.compareTo(a.rating),
        );
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Browser'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(
            screenWidth < 600 ? 16 : 24,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Find a Movie',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                decoration: InputDecoration(
                  hintText:
                      'Search movie title...',
                  prefixIcon:
                      const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  const Text(
                    'Genres',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (selectedGenres.isNotEmpty)
                    CircleAvatar(
                      radius: 12,
                      child: Text(
                        '${selectedGenres.length}',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: genres.map((genre) {
                  final selected =
                      selectedGenres.contains(genre);

                  return FilterChip(
                    label: Text(genre),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        if (selected) {
                          selectedGenres.remove(
                              genre);
                        } else {
                          selectedGenres.add(
                              genre);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  const Text(
                    'Sort:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),

                  DropdownButton<String>(
                    value: selectedSort,
                    items: const [
                      DropdownMenuItem(
                        value: 'A-Z',
                        child: Text('A-Z'),
                      ),
                      DropdownMenuItem(
                        value: 'Z-A',
                        child: Text('Z-A'),
                      ),
                      DropdownMenuItem(
                        value: 'Year',
                        child: Text('Year'),
                      ),
                      DropdownMenuItem(
                        value: 'Rating',
                        child: Text('Rating'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedSort = value!;
                      });
                    },
                  ),

                  const Spacer(),

                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        searchQuery = '';
                        selectedGenres.clear();
                        selectedSort = 'A-Z';
                      });
                    },
                    icon: const Icon(Icons.clear),
                    label:
                        const Text('Clear Filters'),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Expanded(
                child: LayoutBuilder(
                  builder:
                      (context, constraints) {
                    if (constraints.maxWidth <
                        800) {
                      return ListView.builder(
                        itemCount:
                            visibleMovies.length,
                        itemBuilder:
                            (context, index) {
                          return MovieCard(
                            movie:
                                visibleMovies[index],
                          );
                        },
                      );
                    }

                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 2.2,
                      children: visibleMovies
                          .map(
                            (movie) =>
                                MovieCard(
                              movie: movie,
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin:
          const EdgeInsets.symmetric(vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final posterWidth =
              constraints.maxWidth > 500
                  ? 140.0
                  : 100.0;

          return Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(12),
                  child: Image.network(
                    movie.posterUrl,
                    width: posterWidth,
                    height: posterWidth * 1.4,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        movie.title,
                        style:
                            const TextStyle(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Year: ${movie.year}',
                      ),

                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 6,
                        children: movie.genres
                            .map(
                              (g) => Chip(
                                label:
                                    Text(g),
                              ),
                            )
                            .toList(),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        '⭐ ${movie.rating}',
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}