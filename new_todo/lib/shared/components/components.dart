// ignore_for_file: non_constant_identifier_names

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../presentation/task_cubit/image/imageCubit.dart';
import '../../presentation/task_cubit/task/taskCubit.dart';
import '../../presentation/widgets/dropDownMenu.dart';
import '../../presentation/widgets/network_images_handler.dart';


Widget defaultButton({
  double? fontSize,
  double myWidth=100,
  double myHeight = 50,
  double radius = 10,
  bool isDark = false,
  Color? selfColor,
  Color? contentColor,
  required BuildContext context,
  required String text,
  required Function pressFunc,
}) {
  selfColor ??= Theme.of(context).colorScheme.primary;
  contentColor ??= Theme.of(context).colorScheme.onPrimary;

  return Container(
    width: myWidth,
    height: myHeight,
    decoration: BoxDecoration(
      color: selfColor,
      borderRadius: BorderRadius.circular(radius),
    ),
    child: MaterialButton(
      onPressed: () => pressFunc(),
      child: FittedBox(
        child: Text(
          text,
          style:  GoogleFonts.dmSans(
            fontSize: fontSize ?? myHeight * 0.04,
            color: contentColor,
            textStyle: const TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget phoneFormField(BuildContext context,PhoneController thePhoneController) {
  return PhoneFormField(
    controller: thePhoneController,
    // initialValue: PhoneNumber.parse('+20'),
    validator: PhoneValidator.compose([
      PhoneValidator.required(context),
      PhoneValidator.validMobile(context),
    ]),
    countrySelectorNavigator: const CountrySelectorNavigator.dialog(),
    onChanged: (phoneNumber) {
      thePhoneController.value = PhoneNumber(isoCode: phoneNumber.isoCode, nsn: phoneNumber.nsn);
      // '+${phoneNumber.countryCode}${phoneNumber.nsn}';
      print('changed into +${phoneNumber.countryCode}${phoneNumber.nsn}');
    },
    enabled: true,
    decoration: InputDecoration(
      labelText: '123-456-7890',
      labelStyle: TextStyle(
        color: HexColor('#BABABA'),
      ),
      counterText: '',
      border: OutlineInputBorder(
        borderSide: BorderSide(width: 1,strokeAlign: 5,color: HexColor('#BABABA'),),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: HexColor('#7F7F7F'),width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1,strokeAlign: 5,color: HexColor('#BABABA'),),
        borderRadius: BorderRadius.circular(10),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1,strokeAlign: 5,color: HexColor('#BABABA'),),
        borderRadius: BorderRadius.circular(10),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 1,strokeAlign: 5,color: HexColor('#BABABA'),),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: HexColor('#7F7F7F'),width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    isCountrySelectionEnabled: true,
    isCountryButtonPersistent: true,
    countryButtonStyle: CountryButtonStyle(
        showDialCode: true,
        showIsoCode: false,
        showFlag: true,
        flagSize: 24,
        textStyle: GoogleFonts.dmSans(
            fontSize: 15,
            color: HexColor('#7F7F7F'),
            fontWeight: FontWeight.w500
        ),
        showDropdownIcon: true
    ),
  );
}

Widget defaultFormField({
  required String text,
  required Function? validate,
  required TextEditingController myController,
  required bool isEnglish,
  double myWidth = 400,
  double myHeight = 800,
  double? fontSize = 14,
  double? iconsSize,
  IconData? prefixIcon,
  int linesNum =1,
  bool haveBorder = true,
  IconData? suffix_icon,
  Function? suffix_function,
  bool isPassField = false,
  TextInputType inputType = TextInputType.emailAddress,
  double decorationRadius = 10,
  bool enabled = true,
  String? hint,

}) {

  iconsSize ?? (myWidth*.5+myHeight*.6);

  return Container(
    width: myWidth,
    padding: EdgeInsets.zero,
    child: TextFormField(
      validator: validate ?? validate!(),
      controller: myController,
      obscureText: isPassField,
      keyboardType: inputType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLines: linesNum,
      style: GoogleFonts.dmSans(
        fontSize: fontSize,
        // color: HexColor('#BABABA'),
      ),
      decoration: InputDecoration(
        labelText: text,
        labelStyle: GoogleFonts.dmSans(
          fontSize: fontSize,
          color: HexColor('#BABABA'),
        ),
        hintText: hint,
        hintStyle: GoogleFonts.dmSans(
          fontSize: fontSize,
          color: HexColor('#BABABA'),
          fontWeight: FontWeight.w500
        ),
        errorBorder:haveBorder? OutlineInputBorder(
          borderSide: BorderSide(color: HexColor('#7F7F7F'),width: 1),
          borderRadius: BorderRadius.circular(decorationRadius),
        ): InputBorder.none,
        constraints: const BoxConstraints(minHeight: 50),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        prefixIcon: isEnglish
            ? (prefixIcon != null? Icon(prefixIcon,size: iconsSize,) : null)
            : (suffix_icon != null
            ? IconButton(
          padding: EdgeInsetsDirectional.zero,iconSize: iconsSize,
          icon: Icon(
            suffix_icon,size: iconsSize,
          ),
          onPressed: () =>
          suffix_function != null ? suffix_function() : () {},
        )
            : null),
        suffixIcon: isEnglish
            ? (suffix_icon != null
            ? IconButton(
          padding: EdgeInsetsDirectional.zero,
          iconSize: iconsSize,
          icon: Icon(
            suffix_icon,size: iconsSize,
            color: HexColor('#BABABA'),
          ),
          onPressed: () =>
          suffix_function != null ? suffix_function() : () {},
        )
            : null)
            : prefixIcon != null? Icon(
          prefixIcon,size: iconsSize,
        ) : null,
        border: haveBorder? OutlineInputBorder(
          borderSide: BorderSide(width: 1,strokeAlign: 5,color: HexColor('#BABABA'),),
          borderRadius: BorderRadius.circular(decorationRadius),
        ):InputBorder.none,
        enabledBorder: haveBorder? OutlineInputBorder(
          borderSide: BorderSide(width: 1,strokeAlign: 5,color: HexColor('#BABABA'),),
          borderRadius: BorderRadius.circular(decorationRadius),
        ):InputBorder.none,
        focusedBorder: haveBorder? OutlineInputBorder(
          borderSide: BorderSide(width: 1,strokeAlign: 5,color: HexColor('#BABABA'),),
          borderRadius: BorderRadius.circular(decorationRadius),
        ):InputBorder.none,
        focusedErrorBorder: haveBorder? OutlineInputBorder(
          borderSide: BorderSide(color: HexColor('#7F7F7F'),width: 1),
          borderRadius: BorderRadius.circular(decorationRadius),
        ): InputBorder.none,
      ),
      enabled: enabled,
    ),
  );
}

String formatDate(String dateString) {
  DateTime dateTime = DateFormat('yyyy-MM-dd').parse(dateString);
  return DateFormat('d MMMM, yyyy').format(dateTime);
}

String convertDateFormat(String date) {

  List<String> parts = date.split('-');
  String formattedDate = '${parts[2]}/${int.parse(parts[1])}/${parts[0]}';

  return formattedDate;
}

String formatPhoneNumber(String phoneNumber) {

  String countryCode = phoneNumber.substring(0, 3);
  String restOfNumber = phoneNumber.substring(3);

  String formattedNumber = restOfNumber.replaceAllMapped(
    RegExp(r'(\d{3})(\d{3})(\d{4})'),
        (Match m) => '${m[1]} ${m[2]}-${m[3]}',
  );
  return '$countryCode $formattedNumber';
}

Widget defaultTaskBuilder({
  required Function onTabFunc,
  required Function onOptionsFunc,
  required String imgUrl,
  required String title,
  required String taskStatus,
  required String description,
  required String priority,
  required String dueDate,
  required connectionState,
  required String id,
  bool isDesktop = false,
  double myWidth = 150,
  double myHeight = 100,
  double? fontSize = 14,
  context,
  Color headerColor = Colors.black,
  Color descriptionColor = Colors.grey,
}) {
  return SizedBox(
    width: myWidth,
    height: 120,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NetworkImageHandler(
      imgUrl: 'https://todo.iraqsapp.com/images/$imgUrl',
      onErrAsset: 'assets/images/img.png',
    ),
        SizedBox(
          width: (myWidth*0.02+myHeight*.01),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      style: GoogleFonts.dmSans(
                        fontSize: fontSize,
                        // color: HexColor('#BABABA'),
                          fontWeight: FontWeight.w700,
                          textStyle: const TextStyle(
                            overflow: TextOverflow.ellipsis
                          ),
                      ),
                    ),
                  ),
                  SizedBox(width: (myWidth*0.2),),
                  FittedBox(
                    child: Container(
                      decoration: BoxDecoration(
                          color: (taskStatus == 'waiting' || taskStatus == 'Waiting')
                              ? HexColor('#FFE4F2')
                              : ((taskStatus == 'InProgress'||taskStatus == 'Inprogress'||taskStatus == 'inprogress')
                              ? HexColor('#F0ECFF')
                              : HexColor('#E3F2FF')
                          ),
                          borderRadius: BorderRadius.circular(5)
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(myWidth*0.01+myHeight*0.001),
                        child: Text(
                          (taskStatus == 'waiting' || taskStatus == 'Waiting')?'Waiting':
                          ((taskStatus == 'InProgress'||taskStatus == 'Inprogress'||taskStatus == 'inprogress')
                              ?'Inprogress'
                              :'Finished'),
                          maxLines: 1,
                          style: GoogleFonts.dmSans(
                            fontSize:isDesktop? fontSize!-1 : fontSize!-5,
                            color: (taskStatus == 'waiting' || taskStatus == 'Waiting')
                              ? HexColor('##FF7D53')
                              : ((taskStatus == 'InProgress'||taskStatus == 'Inprogress'||taskStatus == 'inprogress')
                              ? HexColor('#5F33E1')
                              : HexColor('#0087FF')
                          ),
                              fontWeight: FontWeight.w500,
                            textStyle: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              Text(
                description,
                maxLines: 1,
                style:  GoogleFonts.dmSans(
                  fontSize:(fontSize-2),
                  color:  Colors.black45,
                  fontWeight: FontWeight.w400,
                  textStyle: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20,
                    child: IconButton(
                      icon: SvgPicture.asset(
                          'assets/images/flag.svg',
                        color:(priority == 'heigh' || priority == 'Heigh'||priority == 'high' || priority == 'High')
                            ? HexColor('##FF7D53')
                            : ((priority == 'Medium'||priority == 'medium')
                            ? HexColor('#5F33E1')
                            : HexColor('#0087FF')
                        ),
                      ),
                      padding: EdgeInsets.all(0),
                      alignment: Alignment.centerLeft,
                      constraints: BoxConstraints.tight(Size(16, 16)),
                      color: (priority == 'heigh' || priority == 'Heigh'||priority == 'high' || priority == 'High')
                          ? HexColor('##FF7D53')
                          : ((priority == 'Medium'||priority == 'medium')
                          ? HexColor('#5F33E1')
                          : HexColor('#0087FF')
                      ),
                      onPressed: () {  },
                    ),
                  ),
                  Text(
                      (priority == 'heigh' || priority == 'Heigh'||priority == 'high' || priority == 'High')
                    ?'Heigh'
                    :(priority == 'Medium'||priority == 'medium')?
                      'Medium':'Low',


                    style: GoogleFonts.dmSans(
                      fontSize:(fontSize - (fontSize*.2)),
                      color:   (priority == 'heigh' || priority == 'Heigh'||priority == 'high' || priority == 'High')
                          ? HexColor('##FF7D53')
                          : ((priority == 'Medium'||priority == 'medium')
                          ? HexColor('#5F33E1')
                          : HexColor('#0087FF')
                      ),
                      fontWeight: FontWeight.w400,
                      textStyle: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                      ),
                  ),
                  ),
                  const Spacer(),
                  FittedBox(
                    child: Text(
                        dueDate.split(' ')[0].split('T')[0],
                      style: GoogleFonts.dmSans(
                        fontSize:isDesktop? 14:
                        12,
                        color:  Colors.black45,
                        fontWeight: FontWeight.w400,
                        textStyle: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10,top: 10,left: 10),
          child: CustomDropdownButton(items:
          [
            {
              'title': 'Open',
              'color': HexColor('#00060D'),
              'onClick': () {
                onTabFunc();
              }
            },
            {
              'title': 'Delete',
              'color': HexColor('#FF7D53'),
              'onClick': () {

                TaskCubit.get(context).deleteTask(id: id);
              }
            },
            {
              'title': 'Delete',
              'color': HexColor('#FF7D53'),
              'onClick': () {

                TaskCubit.get(context).deleteTask(id: id);
              }
            },
          ],
          ),
        ),
      ],
    ),
  );
}

void navigateAndFinish({required context, required widget}) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) => false,
    );

String? emptyFieldEnglish(value) {
  if (value.isEmpty) {
    return "Field can't be empty!";
  }
  return null;
}

String? emptyFieldArabic(value) {
  if (value.isEmpty) {
    return "لا يمكن ترك هذا الحقل فارغا!";
  }
  return null;
}

Future<String?> showDialogMsg(context){
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Choose Image Source'),
      content: const Text('Do you want to open the Camera ??'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            ImageCubit.openCamera = false;
            Navigator.pop(context, 'No');
          },
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            ImageCubit.openCamera = true;
            Navigator.pop(context, 'Yes');
          },
          child: const Text('Yes'),
        ),
      ],
    ),
  );
}

SizedBox defaultDatePicker({
  required double myWidth,
  required double myHeight,
  required double myFont,
  required DateTime? initDate,
  required Function whenPicked,
  required TextEditingController myController,
  required BuildContext context,
  Color myColor = Colors.white
}){
  return SizedBox(
    width: myWidth,
    height: myHeight,
    child: Container(
      decoration: BoxDecoration(
        // color: myColor,
            borderRadius: BorderRadius.circular(10)
      ),
      child: TextFormField(
        decoration:
        InputDecoration(
            // suffixIcon: IconButton(onPressed: null, icon: Icon(Icons.calendar_month_sharp)),
            suffixIcon: IconButton(onPressed: null, icon: SvgPicture.asset('assets/images/calendar.svg')),
            labelText: 'choose due date...',
            labelStyle: GoogleFonts.dmSans(
              fontSize:(myFont-2),
              color: HexColor('#BABABA'),
              fontWeight: FontWeight.w500,
              textStyle: const TextStyle(
                overflow: TextOverflow.ellipsis,
              ),
            ),
            hintText: 'yyyy-mm-dd',
            hintStyle: TextStyle(fontSize: myFont),
            hintFadeDuration: const Duration(seconds: 2),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 1,strokeAlign: 5,color: HexColor('#BABABA'),),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1,strokeAlign: 5,color: HexColor('#BABABA'),),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1,strokeAlign: 5,color: HexColor('#BABABA'),),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HexColor('#7F7F7F'),width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: initDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            myController.text = pickedDate.toLocal().toString().split(' ')[0].split('T')[0];
            whenPicked();
          }
        },
        readOnly: true,
        controller: myController,
      ),
    ),
  );
}

Widget defaultDropDownMenu({
  required List<String> list,
  String? dropdownValue,
  required void Function(String?)? onChanged,
  required double myWidth,
  double myHeight=50,
  double myFontSize = 16,
  Color? myTextColor = Colors.black,
  Color? myBackColor = Colors.white,
  String hint = 'Select an option', // Add a hint parameter,
  Color? hintColor,
  String svgPath = 'assets/images/downButton.svg',
  double svgSize = 24
}) {
  return Padding(
    padding: const EdgeInsets.all(1.0),
    child: SizedBox(
      width: myWidth,
      child: DropdownButtonFormField<String>(
        icon: SvgPicture.asset(
          svgPath,
        color: HexColor('#5F33E1'),
          width: svgSize,
        ),
        value: dropdownValue!.isNotEmpty ? dropdownValue : null,
        hint: Text(
          hint,
          style:  GoogleFonts.dmSans(
            fontSize:myFontSize - 2,
            color:hintColor??myTextColor,
            fontWeight: FontWeight.w700,
            textStyle: const TextStyle(
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        style: GoogleFonts.dmSans(
          fontSize:myFontSize - 2,
          color: myTextColor,
          fontWeight: FontWeight.w400,
          textStyle: const TextStyle(
            overflow: TextOverflow.ellipsis,
          ),
        ),
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style:  GoogleFonts.dmSans(
                fontSize:myFontSize - 2,
                color: myTextColor,
                fontWeight: FontWeight.w700,
                textStyle: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          fillColor: myBackColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: HexColor('#BABABA'), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: HexColor('#BABABA'), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: HexColor('#BABABA'), width: 1),
          ),
        ),
      ),
    ),
  );
}
