import 'package:flutter/material.dart';
import 'ticket_generation_screen.dart';

class TouristPlacesScreen extends StatefulWidget {
  const TouristPlacesScreen({super.key});

  @override
  State<TouristPlacesScreen> createState() => _TouristPlacesScreenState();
}

class _TouristPlacesScreenState extends State<TouristPlacesScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  
  final List<String> _categories = [
    'All',
    'Historical',
    'Religious',
    'Natural',
    'Cultural',
  ];

  final List<Map<String, dynamic>> _touristPlaces = [
    {
      'name': 'Statue of Unity',
      'location': 'Kevadia',
      'category': 'Historical',
      'price': 150.0,
      'rating': 4.5,
      'description': 'The world\'s tallest statue dedicated to Sardar Vallabhbhai Patel, the Iron Man of India. Standing at 182 meters, it\'s a tribute to India\'s unity and a symbol of engineering excellence.',
      'timings': '8:00 AM - 6:00 PM',
      'bestTime': 'October to March',
      'attractions': ['High-speed elevators', 'Museum & Gallery', 'Valley of Flowers', 'River cruise', 'Light & Sound show'],
      'imagePath': 'assets/images/statue_of_unity.jpeg',
      'isPopular': true,
    },
    {
      'name': 'Somnath Temple',
      'location': 'Somnath',
      'category': 'Religious',
      'price': 0.0,
      'rating': 4.7,
      'description': 'One of the twelve sacred Jyotirlinga shrines of Lord Shiva. Known as the eternal shrine, it has been rebuilt several times throughout history and stands as a testament to faith and resilience.',
      'timings': '6:00 AM - 9:00 PM',
      'bestTime': 'October to March',
      'attractions': ['Main temple complex', 'Sound & Light show', 'Beach nearby', 'Triveni Sangam', 'Temple museum'],
      'imagePath': 'assets/images/somnath_temple.jpeg',
      'isPopular': true,
    },
    {
      'name': 'Gir National Park',
      'location': 'Gir Forest',
      'category': 'Natural',
      'price': 300.0,
      'rating': 4.4,
      'description': 'The last refuge of Asiatic lions in the world and the only place where you can see them in their natural habitat. Home to over 500 lions and diverse wildlife spread across 1,412 sq km.',
      'timings': '6:00 AM - 5:30 PM (Closed on Wednesdays)',
      'bestTime': 'December to March',
      'attractions': ['Lion safari', 'Wildlife photography', 'Bird watching', 'Nature trails', 'Interpretation zone'],
      'imagePath': 'assets/images/gir_lion.jpeg',
      'isPopular': true,
    },
    {
      'name': 'Sabarmati Ashram',
      'location': 'Ahmedabad',
      'category': 'Historical',
      'price': 50.0,
      'rating': 4.3,
      'description': 'Mahatma Gandhi\'s residence for over a decade and the epicenter of India\'s freedom struggle. Now a museum showcasing his life, philosophy, and the historic Salt March movement.',
      'timings': '8:30 AM - 6:30 PM',
      'bestTime': 'October to March',
      'attractions': ['Gandhi Museum', 'Prayer ground', 'Spinning wheel demo', 'River walk', 'Library & archives'],
      'imagePath': 'assets/images/sabarmati_ashram.jpeg',
      'isPopular': false,
    },
    {
      'name': 'Kutch Desert',
      'location': 'Bhuj',
      'category': 'Natural',
      'price': 200.0,
      'rating': 4.6,
      'description': 'The Great Rann of Kutch, a mesmerizing seasonal salt marsh famous for its endless white salt desert and the vibrant Rann Utsav festival celebrated under the full moon.',
      'timings': '6:00 PM - 10:00 PM (During Rann Utsav)',
      'bestTime': 'November to February',
      'attractions': ['White salt desert', 'Cultural performances', 'Camel rides', 'Handicraft markets', 'Traditional music & dance'],
      'imagePath': 'assets/images/kutch_desert.jpeg',
      'isPopular': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredPlaces {
    return _touristPlaces.where((place) {
      final matchesCategory = _selectedCategory == 'All' || place['category'] == _selectedCategory;
      final matchesSearch = place['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                           place['location'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Tourist Places'),
        backgroundColor: Colors.orange[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PlaceSearchDelegate(_touristPlaces),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange[700],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search places...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(16),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                
                // Category Filter
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          backgroundColor: Colors.white.withOpacity(0.2),
                          selectedColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.orange[700] : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Places List
          Expanded(
            child: _filteredPlaces.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No places found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try adjusting your search or filter',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredPlaces.length,
                    itemBuilder: (context, index) {
                      final place = _filteredPlaces[index];
                      return _buildPlaceCard(place);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> place) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () {
            _showPlaceDetails(place);
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image and badges
              Container(
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                      child: Image.asset(
                        place['imagePath'],
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 160,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 40,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Image coming soon',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    if (place['isPopular'])
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red[600],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, size: 12, color: Colors.white),
                              SizedBox(width: 4),
                              Text(
                                'Popular',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    // Category badge
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(place['category']),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          place['category'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and rating
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            place['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star, size: 14, color: Colors.green[700]),
                              const SizedBox(width: 2),
                              Text(
                                place['rating'].toString(),
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Location
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          place['location'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Description
                    Text(
                      place['description'],
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Price and Book button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          place['price'] == 0
                              ? 'Free Entry'
                              : '₹${place['price'].toStringAsFixed(0)} per person',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: place['price'] == 0 ? Colors.green[600] : Colors.orange[700],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const TicketGenerationScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[700],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: const Text(
                            'Book Now',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Historical':
        return Colors.brown[600]!;
      case 'Religious':
        return Colors.purple[600]!;
      case 'Natural':
        return Colors.green[600]!;
      case 'Cultural':
        return Colors.blue[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  void _showPlaceDetails(Map<String, dynamic> place) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Title and rating
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        place['name'],
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.green[700]),
                          const SizedBox(width: 4),
                          Text(
                            place['rating'].toString(),
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Location and category
                Row(
                  children: [
                    Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      place['location'],
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(place['category']),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        place['category'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  place['description'],
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Details Grid
                _buildDetailSection('Timings', place['timings'], Icons.access_time),
                _buildDetailSection('Best Time to Visit', place['bestTime'], Icons.calendar_today),
                _buildDetailSection(
                  'Entry Fee', 
                  place['price'] == 0 ? 'Free' : '₹${place['price'].toStringAsFixed(0)} per person',
                  Icons.attach_money,
                ),

                const SizedBox(height: 24),

                // Attractions
                const Text(
                  'Attractions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: place['attractions'].map<Widget>((attraction) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.orange[300]!),
                      ),
                      child: Text(
                        attraction,
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                // Book Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TicketGenerationScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      place['price'] == 0 ? 'Get Entry Pass' : 'Book Ticket - ₹${place['price'].toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange[700], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> places;

  PlaceSearchDelegate(this.places);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = places.where((place) {
      return place['name'].toLowerCase().contains(query.toLowerCase()) ||
             place['location'].toLowerCase().contains(query.toLowerCase()) ||
             place['category'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (results.isEmpty) {
      return const Center(
        child: Text(
          'No places found',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final place = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.orange[100],
            child: Icon(Icons.place, color: Colors.orange[700]),
          ),
          title: Text(place['name']),
          subtitle: Text('${place['location']} • ${place['category']}'),
          trailing: Text(
            place['price'] == 0 ? 'Free' : '₹${place['price'].toStringAsFixed(0)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange[700],
            ),
          ),
          onTap: () {
            close(context, place);
          },
        );
      },
    );
  }
}