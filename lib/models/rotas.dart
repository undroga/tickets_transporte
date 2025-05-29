import 'dart:ui';

class rotas {
  final String id;
  final String name;
  final String start;
  final String end;
  final double price;
  final String description;
  final List<String> stops;
  final Color color;
  final RouteType type;
  final List<Schedule> schedule;
  final double distance; // em km
  final int duration; // em minutos

  rotas({
    required this.id,
    required this.name,
    required this.start,
    required this.end,
    required this.price,
    required this.description,
    required this.stops,
    required this.color,
    required this.type,
    required this.schedule,
    required this.distance,
    required this.duration,
    required String transportType,
    required String endPoint,
    required String startPoint,
    required String imageUrl,
    required String operator,
  });

  // Factory para criar uma rota a partir de um mapa JSON
  factory rotas.fromJson(Map<String, dynamic> json) {
    // Conversão de cor de int para Color
    final colorValue = json['color'] as int;
    final color = Color(colorValue);

    // Conversão de tipo de string para enum
    final typeStr = json['type'] as String;
    final type = RouteType.values.firstWhere(
      (e) => e.toString() == 'RouteType.$typeStr',
      orElse: () => RouteType.bus,
    );

    // Parsing dos horários
    final scheduleJson = json['schedule'] as List;
    final schedules = scheduleJson.map((s) => Schedule.fromJson(s)).toList();

    return rotas(
      id: json['id'],
      name: json['name'],
      start: json['start'],
      end: json['end'],
      price: json['price'],
      description: json['description'],
      stops: List<String>.from(json['stops']),
      color: color,
      type: type,
      schedule: schedules,
      distance: json['distance'],
      duration: json['duration'],
      transportType: '',
      endPoint: '',
      startPoint: '',
      imageUrl: '',
      operator: '',
    );
  }

  // Converte a rota para um mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'start': start,
      'end': end,
      'price': price,
      'description': description,
      'stops': stops,
      'color': color.value,
      'type': type.toString().split('.').last,
      'schedule': schedule.map((s) => s.toJson()).toList(),
      'distance': distance,
      'duration': duration,
    };
  }

  // Cria uma cópia com alterações específicas
  rotas copyWith({
    String? id,
    String? name,
    String? start,
    String? end,
    double? price,
    String? description,
    List<String>? stops,
    Color? color,
    RouteType? type,
    List<Schedule>? schedule,
    double? distance,
    int? duration,
  }) {
    return rotas(
      id: id ?? this.id,
      name: name ?? this.name,
      start: start ?? this.start,
      end: end ?? this.end,
      price: price ?? this.price,
      description: description ?? this.description,
      stops: stops ?? this.stops,
      color: color ?? this.color,
      type: type ?? this.type,
      schedule: schedule ?? this.schedule,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      transportType: '',
      endPoint: '',
      startPoint: '',
      imageUrl: '',
      operator: '',
    );
  }
}

class Schedule {
  final String weekday;
  final String startTime;
  final String endTime;
  final int frequency; // em minutos

  Schedule({
    required this.weekday,
    required this.startTime,
    required this.endTime,
    required this.frequency,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      weekday: json['weekday'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      frequency: json['frequency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekday': weekday,
      'startTime': startTime,
      'endTime': endTime,
      'frequency': frequency,
    };
  }
}

enum RouteType {
  bus,
  express,
  circular,
  ferry,
  shuttle,
}
