import '../src/core/models/teaching_assistant_model.dart';
import '../src/core/service/database_service.dart';

class TeachingAssistantAllocation {
  DatabaseService _databaseService;

  TeachingAssistantAllocation(DatabaseService dbService) {
    _databaseService = dbService;
  }

  Future<Map<String, List<TeachingAssistantModel>>> getAllocations() async {
    List<TeachingAssistantModel> listOfTeachingAssistants =
        await _databaseService.getTeachingAssistants();

    Map<String, List<TeachingAssistantModel>> allocations = {};

    for (var taRoom in listOfTeachingAssistants) {
      if (allocations.containsKey(taRoom.room)) {
        allocations[taRoom.room].add(taRoom);
      } else {
        allocations[taRoom.room] = [taRoom];
      }
    }
    return allocations;
  }
}
