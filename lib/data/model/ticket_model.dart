class TicketModel {
  final String? id;
  final String? userId;
  final String? trainId;
  final String? destinationId;
  final double? price;
  final int? nbPlace;
  final int? nbPersonHond;
  final bool? isHandicap;

  TicketModel({
    this.id,
    this.userId,
    this.trainId,
    this.destinationId,
    this.price,
    this.nbPlace,
    this.nbPersonHond,
    this.isHandicap,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'],
      userId: json['user_id'],
      trainId: json['train_id'],
      destinationId: json['destination_id'],
      price: json['price'],
      nbPlace: json['nb_place'],
      nbPersonHond: json['nb_person_hond'],
      isHandicap: json['is_handicap'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'user_id': userId,
      'train_id': trainId,
      'destination_id': destinationId,
      'price': price,
      'nb_place': nbPlace,
      'nb_person_hond': nbPersonHond,
      'is_handicap': isHandicap,
    };
  }
}
