import 'package:image_picker/image_picker.dart';

class Story{
  final userId;
  final XFile storyImage;
  final String description;
  final DateTime createdAt;
  final DateTime expiresAt;

  Story({
    required this.userId,
    required this.storyImage,
    required this.description,
    required this.createdAt,
    required this.expiresAt,
  });
}