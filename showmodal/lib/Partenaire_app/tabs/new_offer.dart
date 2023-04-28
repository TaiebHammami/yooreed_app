import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../main.dart';
import '../../theme/app_theme.dart';
import '../Models/create_offre.dart';
import '../provider/partenaire_offre.dart';

class NewOffer extends StatefulWidget {
  const NewOffer({Key? key}) : super(key: key);

  @override
  _NewOfferState createState() => _NewOfferState();
}

class _NewOfferState extends State<NewOffer>
    with SingleTickerProviderStateMixin {
  /// type OFFER
  int type = 2;

  int fullYearType = 2;
  int chooseDateType = 3;

  late AnimationController loadingController;
  late DateTimeRange date;
  File? _file;
  PlatformFile? _platformFile;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _promoController;
  late DateTime _selectedDate = DateTime(1999);

  late CreateOffer createOffer;

  selectFile() async {
    final file = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg']);

    if (file != null) {
      setState(() {
        _file = File(file.files.single.path!);
        _platformFile = file.files.first;
      });
    }

    loadingController.forward();
  }

  DateTime startOffer = DateTime.now();
  DateTime endOffer = DateTime.now().add(const Duration(days: 365));

  var key = GlobalKey<FormState>();

  void _presentDatePicker() {
    var date = DateTime.now().year;
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(Duration(days: 365)))
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        startOffer = value;
        endOffer = startOffer.add(Duration(days: 365));
        showpicker = 1;
      });
    });
  }

  late PartenaireOffre partenaireOffer;

  @override
  void initState() {
    partenaireOffer = PartenaireOffre();
    createOffer = CreateOffer(
        typeId: type,
        title: '',
        description: '',
        image: _file as File,
        dateDebut: '',
        dateFin: '',
        price: '',
        promo: '');
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _promoController = TextEditingController();
    date = DateTimeRange(start: DateTime.now(), end: DateTime.now());
    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {});
      });

    super.initState();
  }

  DateTime picker = DateTime.now();
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  int showpicker = 0;
  int showRange = 0;
  int _radioValue = 0;
  DateTime dateDebut = DateTime.now();

  save() async {
    var valid = key.currentState?.validate();
    if (!valid!) {
      return;
    }
    key.currentState!.save();
    setState(() {
      createOffer.dateFin = DateFormat.yMMMd().format(endOffer).toString();
      createOffer.typeId = type;
      createOffer.image = _file as File;
      createOffer.dateDebut = DateFormat.yMMMd().format(startOffer).toString();
    });

    await partenaireOffer.createOffre(createOffer, context).then((value) {
      if (value == 1) {
        key.currentState!.reset();
        _titleController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _promoController.clear();
        setState(() {
          _platformFile = null;
          showpicker = 0;
          showRange = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    partenaireOffer = Provider.of<PartenaireOffre>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).bottomAppBarColor,
        elevation: 0.5,
        title: Text('New Offer'),
        titleTextStyle:
            Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 27),
        actions: [
          IconButton(
              onPressed: selectFile, icon: Icon(FontAwesomeIcons.image,color: HexColor('#E9564B'),))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              _platformFile != null
                  ? Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Selected Image',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SimpleShadow(
                            color: Theme.of(context).shadowColor,
                            opacity: 0.05,
                            child: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Theme.of(context).bottomAppBarColor,
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          _file!,
                                          width: 70,
                                        )),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _platformFile!.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1!
                                                .copyWith(
                                                    fontWeight: FontWeight.w100,
                                                    fontSize: 14),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '${(_platformFile!.size / 1024).ceil()} KB',
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey.shade500),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                              height: 5,
                                              clipBehavior: Clip.hardEdge,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Colors.blue.shade50,
                                              ),
                                              child: LinearProgressIndicator(
                                                value: loadingController.value,
                                              )),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ))
                  : Container(),

                    RadioListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      activeColor:
                          Get.isDarkMode ? Colors.grey : HexColor('#E9564B'),
                      tileColor: Theme.of(context).scaffoldBackgroundColor,
                      title: Text(
                        'Full Year',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      selectedTileColor: Theme.of(context).bottomAppBarColor,
                      value: 0,
                      selected: _radioValue == 0,
                      groupValue: _radioValue,
                      onChanged: (value) {
                        setState(() {
                          type = fullYearType;
                          _radioValue = value!;
                          showpicker = 0;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RadioListTile(
                      activeColor:
                          Get.isDarkMode ? Colors.grey : HexColor('#E9564B'),
                      selected: _radioValue == 1,
                      selectedTileColor: Theme.of(context).bottomAppBarColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      tileColor: Theme.of(context).scaffoldBackgroundColor,
                      title: Text(
                        'Choose Date',
                        style:
                            Theme.of(context).textTheme.subtitle1!.copyWith(),
                      ),
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: (value) {
                        setState(() {
                          type = chooseDateType;
                          _radioValue = value!;
                          showRange = 0;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _radioValue == 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Please choose the starting date of the offer:',
                                style: Theme.of(context).textTheme.subtitle1,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              SimpleShadow(
                                offset: Offset(0, 0),
                                color: Theme.of(context).shadowColor,
                                opacity: 0.05,
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  tileColor:
                                      Theme.of(context).bottomAppBarColor,
                                  onTap: _presentDatePicker,
                                  leading: Text(
                                    'Choose Date',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  trailing: Icon(CupertinoIcons.calendar_today),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              showpicker == 1
                                  ? Column(
                                      children: [
                                        SimpleShadow(
                                          offset: Offset(0, 0),
                                          color: Theme.of(context).shadowColor,
                                          opacity: 0.01,
                                          child: ListTile(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            tileColor: Theme.of(context)
                                                .bottomAppBarColor,
                                            title: Text(DateFormat.yMMMd()
                                                .format(startOffer)
                                                .toString()),
                                            leading: Text(
                                              'DATE_START',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                            // trailing: Icon(CupertinoIcons.calendar_today),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SimpleShadow(
                                          offset: Offset(0, 0),
                                          color: Theme.of(context).shadowColor,
                                          opacity: 0.01,
                                          child: ListTile(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            tileColor: Theme.of(context)
                                                .bottomAppBarColor,
                                            title: Text(DateFormat.yMMMd()
                                                .format(startOffer
                                                    .add(Duration(days: 365)))
                                                .toString()),
                                            leading: Text(
                                              'DATE_END',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                            //  trailing: Icon(CupertinoIcons.calendar_today),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox()
                            ],
                          )
                        : const SizedBox(),
                    _radioValue == 1
                        ? Column(children: [
                            Text(
                              'Please choose the starting and ending dates of the offer:',
                              style: Theme.of(context).textTheme.subtitle1,
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            SimpleShadow(
                              offset: Offset(0, 0),
                              color: Theme.of(context).shadowColor,
                              opacity: 0.05,
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                                tileColor: Theme.of(context).bottomAppBarColor,
                                onTap: () async {
                                  final result = await showDateRangePicker(
                                      context: context,
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.now()
                                          .add(const Duration(days: 365)));
                                  if (result != null) {
                                    setState(() {
                                      showRange = 1;
                                      endOffer = result.end;
                                      startOffer = result.start;
                                    });
                                  }
                                },
                                leading: Text(
                                  'Choose Date',
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                                trailing: Icon(CupertinoIcons.calendar_today),
                              ),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            showRange == 1
                                ? Column(
                                    children: [
                                      SimpleShadow(
                                        offset: Offset(0, 0),
                                        color: Theme.of(context).shadowColor,
                                        opacity: 0.01,
                                        child: ListTile(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          tileColor: Theme.of(context)
                                              .bottomAppBarColor,
                                          title: Text(DateFormat.yMMMd()
                                              .format(start)
                                              .toString()),
                                          leading: Text(
                                            'DATE_START',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                          // trailing: Icon(CupertinoIcons.calendar_today),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SimpleShadow(
                                        offset: Offset(0, 0),
                                        color: Theme.of(context).shadowColor,
                                        opacity: 0.01,
                                        child: ListTile(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          tileColor: Theme.of(context)
                                              .bottomAppBarColor,
                                          title: Text(DateFormat.yMMMd()
                                              .format(end)
                                              .toString()),
                                          leading: Text(
                                            'DATE_END',
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle1,
                                          ),
                                          //  trailing: Icon(CupertinoIcons.calendar_today),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox()
                          ])
                        : const SizedBox(),
                    const SizedBox(
                      height: 8,
                    ),
                    Form(
                      key: key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SimpleShadow(
                            offset: Offset(0, 0),
                            color: Theme.of(context).shadowColor,
                            opacity: 0.04,
                            child: Text(
                              'TITLE'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 16,
                                  ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          /// title
                          SimpleShadow(
                            offset: Offset(0, 0),
                            color: Theme.of(context).shadowColor,
                            opacity: 0.2,
                            child: TextFormField(
                              onSaved: (title) {
                                createOffer = CreateOffer(
                                    typeId: 0,
                                    title: title.toString(),
                                    description: _descriptionController.text,
                                    image: _file as File,
                                    dateDebut: '',
                                    dateFin: '',
                                    price: _priceController.text,
                                    promo: _promoController.text);
                              },
                              controller: _titleController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context).bottomAppBarColor,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                        width: 0,
                                        color: Theme.of(context)
                                            .bottomAppBarColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                        width: 0,
                                        color: Theme.of(context)
                                            .bottomAppBarColor)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                        width: 0,
                                        color: Theme.of(context)
                                            .bottomAppBarColor)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SimpleShadow(
                            offset: Offset(0, 0),
                            color: Theme.of(context).shadowColor,
                            opacity: 0.04,
                            child: Text(
                              'DESCRIPTION'.tr,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 16,
                                  ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),

                          /// description
                          SimpleShadow(
                            offset: Offset(0, 0),
                            color: Theme.of(context).shadowColor,
                            opacity: 0.2,
                            child: TextFormField(
                              onSaved: (description) {
                                createOffer = CreateOffer(
                                    typeId: 0,
                                    title: _titleController.text,
                                    description: description.toString(),
                                    image: _file as File,
                                    dateDebut: '',
                                    dateFin: '',
                                    price: _priceController.text,
                                    promo: _promoController.text);
                              },
                              controller: _descriptionController,
                              maxLines: 5,
                              minLines: 1,
                              textInputAction: TextInputAction.newline,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Theme.of(context).bottomAppBarColor,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                        width: 0,
                                        color: Theme.of(context)
                                            .bottomAppBarColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                        width: 0,
                                        color: Theme.of(context)
                                            .bottomAppBarColor)),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6),
                                    borderSide: BorderSide(
                                        width: 0,
                                        color: Theme.of(context)
                                            .bottomAppBarColor)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  SimpleShadow(
                                    offset: Offset(0, 0),
                                    color: Theme.of(context).shadowColor,
                                    opacity: 0.04,
                                    child: Text(
                                      'PRICE'.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontSize: 16,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SimpleShadow(
                                    offset: Offset(0, 0),
                                    color: Theme.of(context).shadowColor,
                                    opacity: 0.2,
                                    child: TextFormField(
                                      onSaved: (price) {
                                        createOffer = CreateOffer(
                                            typeId: 0,
                                            title: _titleController.text,
                                            description:
                                                _descriptionController.text,
                                            image: _file as File,
                                            dateDebut: '',
                                            dateFin: '',
                                            price: price.toString(),
                                            promo: _promoController.text);
                                      },
                                      controller: _priceController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor:
                                            Theme.of(context).bottomAppBarColor,
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            borderSide: BorderSide(
                                                width: 0,
                                                color: Theme.of(context)
                                                    .bottomAppBarColor)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            borderSide: BorderSide(
                                                width: 0,
                                                color: Theme.of(context)
                                                    .bottomAppBarColor)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            borderSide: BorderSide(
                                                width: 0,
                                                color: Theme.of(context)
                                                    .bottomAppBarColor)),
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Column(
                                children: [
                                  SimpleShadow(
                                    offset: Offset(0, 0),
                                    color: Theme.of(context).shadowColor,
                                    opacity: 0.04,
                                    child: Text(
                                      'PROMO'.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                            fontSize: 16,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SimpleShadow(
                                    offset: Offset(0, 0),
                                    color: Theme.of(context).shadowColor,
                                    opacity: 0.2,
                                    child: TextFormField(
                                      onSaved: (promo) {
                                        createOffer = CreateOffer(
                                            typeId: 0,
                                            title: _titleController.text,
                                            description:
                                                _descriptionController.text,
                                            image: _file as File,
                                            dateDebut: '',
                                            dateFin: '',
                                            price: _priceController.text,
                                            promo: promo.toString());
                                      },
                                      controller: _promoController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor:
                                            Theme.of(context).bottomAppBarColor,
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            borderSide: BorderSide(
                                                width: 0,
                                                color: Theme.of(context)
                                                    .bottomAppBarColor)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            borderSide: BorderSide(
                                                width: 0,
                                                color: Theme.of(context)
                                                    .bottomAppBarColor)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            borderSide: BorderSide(
                                                width: 0,
                                                color: Theme.of(context)
                                                    .bottomAppBarColor)),
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                            ],
                          )
                        ],
                      ),
                    ),

                                        SizedBox(height: 10,),

                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Get.isDarkMode
                              ? Colors.grey
                              : HexColor('#E9564B'),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                            topRight: Radius.circular(26),
                            bottomRight: Radius.circular(26),
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(26),
                          )),
                          maximumSize:
                              Size(MediaQuery.of(context).size.width, 65),
                          minimumSize:
                              Size(MediaQuery.of(context).size.width, 55),
                        ),
                        onPressed: () {
                          save();
                        },
                        child: Text(
                          'SAVE'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: Get.isDarkMode
                                      ? Colors.black
                                      : Colors.white),
                        )),


            ],
          ),
        ),
      ),
    );
  }
}
