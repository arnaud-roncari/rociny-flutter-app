import 'package:flutter/material.dart';
import 'package:rociny/core/constants/colors.dart';
import 'package:rociny/core/constants/paddings.dart';
import 'package:rociny/core/constants/radius.dart';
import 'package:rociny/core/constants/text_styles.dart';
import 'package:rociny/shared/decorations/textfield_decoration.dart';

class TagsField extends StatefulWidget {
  final String hint;
  final List<String> initialValues;
  final List<String> values;
  final Function(List<String>) onUpdated;

  const TagsField({
    super.key,
    required this.initialValues,
    required this.values,
    required this.onUpdated,
    required this.hint,
  });

  @override
  State<TagsField> createState() => _TagsFieldState();
}

class _TagsFieldState extends State<TagsField> {
  List<String> filteredTags = [];
  List<String> selectedTags = [];
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedTags = [...widget.initialValues];
    filteredTags = [...widget.values];
    sortTags();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: kTextFieldDecoration.copyWith(
            hintText: widget.hint,
          ),
          style: kBody,
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                filteredTags = widget.values;
                sortTags();
              });
              return;
            }

            setState(() {
              filteredTags = widget.values.where((tag) => tag.toLowerCase().contains(value.toLowerCase())).toList();
            });
          },
        ),
        const SizedBox(height: kPadding10),
        SizedBox(
          height: 70,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: filteredTags
                      .asMap()
                      .entries
                      .where((e) => e.key.isEven)
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(right: kPadding10),
                            child: buildTag(e.value),
                          ))
                      .toList(),
                ),
                const SizedBox(height: kPadding10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: filteredTags
                      .asMap()
                      .entries
                      .where((e) => e.key.isOdd)
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(right: kPadding10),
                            child: buildTag(e.value),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTag(String tag) {
    bool isSelected = selectedTags.contains(tag);

    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: isSelected ? kPrimary500 : kWhite,
        borderRadius: BorderRadius.circular(kRadius100),
        border: isSelected
            ? null
            : Border.all(
                color: kGrey100,
                width: 0.5,
              ),
      ),
      child: InkWell(
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        borderRadius: BorderRadius.circular(kRadius100),
        onTap: () {
          setState(() {
            controller.clear();
            if (selectedTags.contains(tag)) {
              selectedTags.remove(tag);
            } else {
              selectedTags.add(tag);
            }
            sortTags();
            widget.onUpdated(selectedTags);
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPadding15),
          child: Center(
            child: Text(
              tag,
              style: isSelected ? kCaptionBold.copyWith(color: kWhite) : kCaption,
            ),
          ),
        ),
      ),
    );
  }

  sortTags() {
    final selected = widget.values.where((tag) => selectedTags.contains(tag)).toList();
    final unselected = widget.values.where((tag) => !selectedTags.contains(tag)).toList();
    filteredTags = [...selected, ...unselected];
  }
}
