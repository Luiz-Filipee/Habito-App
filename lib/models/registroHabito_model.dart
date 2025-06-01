import 'package:cloud_firestore/cloud_firestore.dart';

class RegistroHabito {
  final String id;
  final DateTime data;
  final bool concluido;

  RegistroHabito({
    required this.id,
    required this.data,
    required this.concluido,
  });

  factory RegistroHabito.fromMap(Map<String, dynamic> map, String id) {
    final timestamp = map['data'];
    DateTime data = DateTime.now();

    if (timestamp is Timestamp) {
      data = timestamp.toDate();
    } else if (timestamp is DateTime) {
      data = timestamp;
    } else if (timestamp is String) {
      data = DateTime.parse(timestamp);
    }

    return RegistroHabito(
      id: id,
      data: data,
      concluido: map['concluido'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': Timestamp.fromDate(data), 
      'concluido': concluido,
    };
  }
}
