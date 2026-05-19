import '../../domain/entities/experience.dart';
import '../../domain/repository/i_home_repository.dart';
import '../datasource/home_local_datasource.dart';

class HomeRepositoryImpl implements IHomeRepository {
  final HomeLocalDatasource localDatasource;

  HomeRepositoryImpl(this.localDatasource);

  @override
  Future<List<Experience>> getFeaturedExperiences() async {
    return await localDatasource.getFeaturedExperiences();
  }
}
