import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/models/service_model.dart';
import '../../../../shared/models/barber_model.dart';
import '../repositories/booking_repository.dart';

class GetServices {
  final BookingRepository repository;
  
  GetServices(this.repository);
  
  Future<Either<Failure, List<ServiceModel>>> call() async {
    return await repository.getServices();
  }
}

class GetServiceById {
  final BookingRepository repository;
  
  GetServiceById(this.repository);
  
  Future<Either<Failure, ServiceModel>> call(String serviceId) async {
    return await repository.getServiceById(serviceId);
  }
}

class GetAvailableBarbers {
  final BookingRepository repository;
  
  GetAvailableBarbers(this.repository);
  
  Future<Either<Failure, List<BarberModel>>> call() async {
    return await repository.getAvailableBarbers();
  }
}

class GetBarbersByService {
  final BookingRepository repository;
  
  GetBarbersByService(this.repository);
  
  Future<Either<Failure, List<BarberModel>>> call(String serviceId) async {
    return await repository.getBarbersByService(serviceId);
  }
}

class GetBarberById {
  final BookingRepository repository;
  
  GetBarberById(this.repository);
  
  Future<Either<Failure, BarberModel>> call(String barberId) async {
    return await repository.getBarberById(barberId);
  }
}