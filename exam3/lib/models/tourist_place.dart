class TouristPlace {
  final int? id;
  final String name;
  final String location;
  final String description;
  final String imagePath;
  final double entryFee;
  final String category; // 'historical', 'religious', 'natural', 'cultural'
  final String timings;
  final bool isPopular;

  TouristPlace({
    this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.imagePath,
    required this.entryFee,
    required this.category,
    required this.timings,
    this.isPopular = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'description': description,
      'imagePath': imagePath,
      'entryFee': entryFee,
      'category': category,
      'timings': timings,
      'isPopular': isPopular ? 1 : 0,
    };
  }

  factory TouristPlace.fromMap(Map<String, dynamic> map) {
    return TouristPlace(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      description: map['description'] ?? '',
      imagePath: map['imagePath'] ?? '',
      entryFee: map['entryFee']?.toDouble() ?? 0.0,
      category: map['category'] ?? '',
      timings: map['timings'] ?? '',
      isPopular: map['isPopular'] == 1,
    );
  }

  TouristPlace copyWith({
    int? id,
    String? name,
    String? location,
    String? description,
    String? imagePath,
    double? entryFee,
    String? category,
    String? timings,
    bool? isPopular,
  }) {
    return TouristPlace(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      entryFee: entryFee ?? this.entryFee,
      category: category ?? this.category,
      timings: timings ?? this.timings,
      isPopular: isPopular ?? this.isPopular,
    );
  }

  @override
  String toString() {
    return 'TouristPlace(id: $id, name: $name, location: $location, category: $category, entryFee: $entryFee, isPopular: $isPopular)';
  }
}