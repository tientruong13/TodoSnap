import 'package:hive/hive.dart';
import 'package:task_app/widget/utils.dart';

class NotificationTypeAdapter extends TypeAdapter<NotificationType> {
  @override
  final int typeId = 5; // Assuming 3 is not used by another adapter.

  @override
  NotificationType read(BinaryReader reader) {
    final int enumIndex = reader.readByte();
    return NotificationType.values[enumIndex];
  }

  @override
  void write(BinaryWriter writer, NotificationType obj) {
    writer.writeByte(obj.index);
  }
}
