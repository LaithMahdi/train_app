class TrainModel {
  final String? id;
  final String? name;
  final String? image;
  final int? nbPlace;
  final String? createdAt;

  TrainModel({
    this.id,
    this.name,
    this.image,
    this.nbPlace,
    this.createdAt,
  });

  factory TrainModel.fromJson(Map<String, dynamic> json) {
    return TrainModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      nbPlace: json['nb_place'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'nb_place': nbPlace,
      'created_at': createdAt,
    };
  }
}
