import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/date_time.dart';
import '../../core/service/database_service.dart';
import '../../core/service/permission_service.dart';

final permissionProvider =
    Provider.autoDispose<PermissionService>((ref) => PermissionService());

final dbServiceProvider = Provider<DatabaseService>((ref) => DatabaseService());

final datetimeHelperProvider =
    Provider.autoDispose<DateTimeHelper>((ref) => DateTimeHelper());
