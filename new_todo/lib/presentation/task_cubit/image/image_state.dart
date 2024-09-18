import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class ImageState {

}

class ImageInitial extends ImageState {}

class ImagePicked extends ImageState {
  final File imageFile;

  ImagePicked(this.imageFile);

}
class ImageUploading extends ImageState {}

class ImageUploaded extends ImageState {

}

class ImageReset extends ImageState {

  ImageReset();

}

class ImageError extends ImageState {
  final String message;

  ImageError(this.message);

}
