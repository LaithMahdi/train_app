class DestinationModel {
  final String? id;
  final DateTime? createdAt;
  final String? startStation;
  final String? endStation;
  final String? startTime;
  final String? endTime;
  final String? trainId;

  DestinationModel({
    this.id,
    this.createdAt,
    this.startStation,
    this.endStation,
    this.startTime,
    this.endTime,
    this.trainId,
  });

  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      startStation: json['start_station'],
      endStation: json['end_station'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      trainId: json['train_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'start_station': startStation,
      'end_station': endStation,
      // 'start_time':
      //     startTime != null ? '${startTime!.hour}:${startTime!.minute}' : null,
      // 'end_time':
      //     endTime != null ? '${endTime!.hour}:${endTime!.minute}' : null,
      'train_id': trainId,
    };
  }
}
