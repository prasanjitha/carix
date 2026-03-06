// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VehicleModelAdapter extends TypeAdapter<VehicleModel> {
  @override
  final int typeId = 0;

  @override
  VehicleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VehicleModel(
      vehicleNumber: fields[0] as String,
      brand: fields[1] as String,
      modelName: fields[2] as String,
      fuelType: fields[3] as String,
      odometer: fields[4] as int,
      avgKml: fields[5] as double,
      nickname: fields[6] as String,
      colorHex: fields[7] as String,
      lastServiceDate: fields[8] as DateTime?,
      odometerAtLastService: fields[9] as int?,
      serviceCycleKm: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, VehicleModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.vehicleNumber)
      ..writeByte(1)
      ..write(obj.brand)
      ..writeByte(2)
      ..write(obj.modelName)
      ..writeByte(3)
      ..write(obj.fuelType)
      ..writeByte(4)
      ..write(obj.odometer)
      ..writeByte(5)
      ..write(obj.avgKml)
      ..writeByte(6)
      ..write(obj.nickname)
      ..writeByte(7)
      ..write(obj.colorHex)
      ..writeByte(8)
      ..write(obj.lastServiceDate)
      ..writeByte(9)
      ..write(obj.odometerAtLastService)
      ..writeByte(10)
      ..write(obj.serviceCycleKm);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
