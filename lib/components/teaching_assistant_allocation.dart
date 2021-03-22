import 'package:coe_attendance/models/teaching_assistant_model.dart';
import 'package:coe_attendance/service/database_service.dart';

class TeachingAssistantAllocation {
  DatabaseService _databaseService;

  TeachingAssistantAllocation(DatabaseService databaseService) {
    _databaseService = databaseService;
  }

  Future<Map<String, List<String>>> getAllocations() async {
    List<TeachingAssistantModel> listOfTeachingAssistants =
        await _databaseService.getAllTeachingAssistants();

    Map<String, List<String>> allocations = {};

    for (var taRoom in listOfTeachingAssistants) {
      if (allocations.containsKey(taRoom.taRoomAlloc)) {
        allocations[taRoom.taRoomAlloc].add(taRoom.taName);
      } else {
        allocations[taRoom.taRoomAlloc] = [taRoom.taName];
      }
    }
    return allocations;
  }
}
