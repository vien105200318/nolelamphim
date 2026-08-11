import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/api_endpoints.dart';
import '../../../core/models/data_list_response.dart';
import '../../home/providers/home_provider.dart';
import '../models/actor.dart';

final actorsProvider = FutureProvider<List<Actor>>((ref) async {
  final api = ref.read(apiClientProvider);
  final response = await api.get(ApiEndpoints.actors);
  final data = DataListResponse<Actor>.fromJson(
    response.data as Map<String, dynamic>,
    (json) => Actor.fromJson(json),
  );
  return data.items;
});
