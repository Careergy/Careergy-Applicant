import 'package:careergy_mobile/providers/keywords_provider.dart';
import 'package:flutter/material.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:flutter_autocomplete_label/autocomplete_label.dart';

class BriefCVField extends StatefulWidget {
  BriefCVField({
    super.key,
    required this.label,
    required this.controller,
    this.separaters = const [],
    this.keysName,
    this.initialTags,
    this.helper,
    this.mode = true,
  });

  final String label;
  final String? keysName;
  List<String>? initialTags;
  List<String> separaters;
  TextfieldTagsController controller;
  final String? helper;
  final bool mode;

  @override
  State<BriefCVField> createState() => _BriefCVFieldState();
}

class _BriefCVFieldState extends State<BriefCVField> {
  late double _distanceToField;
  List<String> keyWords = [];

  final bool _keepAutofocus = false;

  final AutocompleteLabelController _autocompleteLabelController =
      AutocompleteLabelController<String>(source: [
    "Android",
    "iOS",
    "Flutter",
    "Windows",
    "Web",
    "Fuchsia",
    "Dart",
    "Golang",
    "Java",
    "Python",
    "Ruby",
    "c/c++",
    "Kotlin",
    "Swift",
    "HTML",
    "CSS",
    "JavaScript",
    "PHP",
    "GitHub",
    "Google",
    "Facebook",
    "KnowlGraph",
    "Twitter",
    "Tiktok",
    "StackOverflow",
    "WeiXin",
    "Alibaba",
    "youtube",
  ]);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }

  @override
  void initState() {
    // widget.controller = TextfieldTagsController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return widget.mode
        ? TextFieldTags(
            textfieldTagsController: widget.controller,
            // textEditingController: textEditingController,
            initialTags: widget.initialTags,
            textSeparators: widget.separaters,
            letterCase: LetterCase.normal,
            validator: (String tag) {
              // return null;
            },
            inputfieldBuilder:
                (context, tec, fn, error, onChanged, onSubmitted) {
              return (context, sc, tags, onDeleteTag) {
                return Autocomplete(
                  optionsBuilder: (text) async {
                    if (widget.mode) {
                      keyWords = await Keywords().getKeywords(widget.keysName??'');
                    }
                    // print('it works');
                    if (tec.text.isEmpty && text.text.isEmpty) {
                      // print(text.text);
                      return const Iterable<String>.empty();
                    }
                    return keyWords.where((String option) {
                      return option.contains(text.text.toLowerCase()) &&
                          !tags.contains(option);
                    });
                  },
                  onSelected: (option) {
                    tags.add(option);
                    setState(() {});
                  },
                  displayStringForOption: (option) => '',
                  optionsMaxHeight: 300,
                  optionsViewBuilder: (context, onSelected, options) => Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 200,
                      height: deviceSize.height * 0.3,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(3),
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final option = options.elementAt(index);
                          // print('object');
                          return Material(
                            child: InkWell(
                              onTap: () => onSelected(option),
                              child: ListTile(
                                mouseCursor: MouseCursor.defer,
                                hoverColor: Colors.white,
                                title: Text(option
                                        .toString()
                                        .substring(0, 1)
                                        .toUpperCase() +
                                    option.toString().substring(1)),
                                tileColor:
                                    const Color.fromARGB(255, 165, 183, 192),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  fieldViewBuilder: (context, textEditingController, focusNode,
                      onFieldSubmitted) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        isDense: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 58, 105, 186),
                            width: 3.0,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 58, 105, 186),
                            width: 3.0,
                          ),
                        ),
                        helperText: widget.helper,
                        helperStyle: const TextStyle(
                          color: Color.fromARGB(255, 58, 105, 186),
                        ),
                        hintText:
                            widget.controller.hasTags ? '' : "Enter tag...",
                        errorText: error,
                        prefixIconConstraints:
                            BoxConstraints(maxWidth: _distanceToField * 0.74),
                        prefixIcon: tags.isNotEmpty
                            ? SingleChildScrollView(
                                controller: sc,
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: tags.map((String tag) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                      color: Color.fromARGB(255, 58, 105, 186),
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          child: Text(
                                            tag,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          onTap: () {
                                            print("$tag selected");
                                          },
                                        ),
                                        const SizedBox(width: 4.0),
                                        InkWell(
                                          child: const Icon(
                                            Icons.cancel,
                                            size: 14.0,
                                            color: Color.fromARGB(
                                                255, 233, 233, 233),
                                          ),
                                          onTap: () {
                                            tags.remove(tag);
                                            widget.controller.onTagDelete(tag);
                                            setState(() {});
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                }).toList()),
                              )
                            : null,
                      ),
                      onChanged: onChanged,
                      onSubmitted: onSubmitted,
                    );
                  },
                );
              };
            },
          )
        : TextFieldTags(
            textfieldTagsController: widget.controller,
            initialTags: widget.initialTags,
            letterCase: LetterCase.normal,
            textSeparators: widget.separaters,
            validator: (tag) {
              //
            },
            inputfieldBuilder:
                (context, tec, fn, error, onChanged, onSubmitted) {
              return (context, sc, tags, onDeleteTag) {
                return TextField(
                  controller: tec,
                  focusNode: fn,
                  decoration: InputDecoration(
                    isDense: true,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 58, 105, 186),
                        width: 3.0,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 58, 105, 186),
                        width: 3.0,
                      ),
                    ),
                    helperText: widget.helper,
                    helperStyle: const TextStyle(
                      color: Color.fromARGB(255, 58, 105, 186),
                    ),
                    hintText: widget.controller.hasTags ? '' : "Enter tag...",
                    errorText: error,
                    prefixIconConstraints:
                        BoxConstraints(maxWidth: _distanceToField * 0.74),
                    prefixIcon: tags.isNotEmpty
                        ? SingleChildScrollView(
                            controller: sc,
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                children: tags.map((String tag) {
                              return Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20.0),
                                  ),
                                  color: Color.fromARGB(255, 58, 105, 186),
                                ),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: Text(
                                        tag,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      onTap: () {
                                        print("$tag selected");
                                      },
                                    ),
                                    const SizedBox(width: 4.0),
                                    InkWell(
                                      child: const Icon(
                                        Icons.cancel,
                                        size: 14.0,
                                        color:
                                            Color.fromARGB(255, 233, 233, 233),
                                      ),
                                      onTap: () {
                                        tags.remove(tag);
                                        widget.controller.onTagDelete(tag);
                                        setState(() {});
                                      },
                                    )
                                  ],
                                ),
                              );
                            }).toList()),
                          )
                        : null,
                  ),
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                );
              };
            },
          );
  }
}
