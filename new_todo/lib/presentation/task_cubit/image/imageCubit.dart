import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/repositories/image_repository.dart';
import 'image_state.dart';

class ImageCubit extends Cubit<ImageState> {

  ImageCubit() : super(ImageInitial());
  static ImageCubit get(context) => BlocProvider.of(context);


  final ImagePicker _picker = ImagePicker();

  static String? imgPath = null;

  static bool openCamera = false;

    void restImage() async{
      try {
        emit(ImageInitial());
      } catch (e) {
        emit(ImageError('Failed to pick image'));
      }
    }

    Future<bool> pickImage(ImageSource imgSrc) async {
      try {
        final pickedFile = await _picker.pickImage(source: imgSrc);
        if (pickedFile != null) {
          final File imageFile = File(pickedFile.path);
          ImageRepository().uploadImage(imageFile).then(
            (value) {
              if(value == 'Failed'){
                return false;
              }else{
                imgPath = value;
                emit(ImagePicked(imageFile));
                return true;
              }
            },
          );
          // emit(ImagePicked(imageFile));
        } else {
          emit(ImageInitial());
        }
      } catch (e) {
        emit(ImageError('Failed to pick image'));
        return false;
      }
      return false;
    }

    void uploadImageFile(){

    }
}

