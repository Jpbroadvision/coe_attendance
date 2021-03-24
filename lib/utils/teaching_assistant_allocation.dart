import 'package:coe_attendance/models/teaching_assistant_model.dart';
import 'package:coe_attendance/service/database_service.dart';

class TeachingAssistantAllocation {
  DatabaseService _databaseService;

  TeachingAssistantAllocation(DatabaseService databaseService) {
    _databaseService = databaseService;
  }

  Future<Map<String, List<TeachingAssistantModel>>> getAllocations() async {
    List<TeachingAssistantModel> listOfTeachingAssistants =
        await _databaseService.getAllTeachingAssistants();

    Map<String, List<TeachingAssistantModel>> allocations = {};

    for (var taRoom in listOfTeachingAssistants) {
      if (allocations.containsKey(taRoom.taRoomAlloc)) {
        allocations[taRoom.taRoomAlloc].add(taRoom);
      } else {
        allocations[taRoom.taRoomAlloc] = [taRoom];
      }
    }
    return allocations;
  }
}
