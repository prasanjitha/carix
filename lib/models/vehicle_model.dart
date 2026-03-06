import 'package:hive/hive.dart';

part 'vehicle_model.g.dart';

@HiveType(typeId: 0)
class VehicleModel extends HiveObject {
  @HiveField(0)
  String vehicleNumber;

  @HiveField(1)
  String brand;

  @HiveField(2)
  String modelName;

  @HiveField(3)
  String fuelType;

  @HiveField(4)
  int odometer;

  @HiveField(5)
  double avgKml;

  @HiveField(6)
  String nickname;

  @HiveField(7)
  String colorHex;

  @HiveField(8)
  DateTime? lastServiceDate;

  @HiveField(9)
  int? odometerAtLastService;

  @HiveField(10)
  int? serviceCycleKm;

  VehicleModel({
    required this.vehicleNumber,
    required this.brand,
    required this.modelName,
    required this.fuelType,
    required this.odometer,
    required this.avgKml,
    required this.nickname,
    required this.colorHex,
    this.lastServiceDate,
    this.odometerAtLastService,
    this.serviceCycleKm,
  });
}
