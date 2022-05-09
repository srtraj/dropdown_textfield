import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

class TestPage2 extends StatefulWidget {
  const TestPage2({Key? key}) : super(key: key);

  @override
  State<TestPage2> createState() => _TestPage2State();
}

class _TestPage2State extends State<TestPage2> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController _cnt;
  late MultiValueDropDownController _cntMulti;
  late FocusNode _fn;
  late ScrollController _scrollCnt;

  @override
  void initState() {
    _fn = FocusNode();
    _cnt = SingleValueDropDownController();
    _cntMulti = MultiValueDropDownController();
    _scrollCnt = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollCnt,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 450,
                ),
                DropDownTextField(
                  // initialValue: "name4",
                  clearOption: true,
                  searchAutofocus: true,
                  enableSearch: true,
                  searchFocusNode: _fn,
                  validator: (value) {
                    if (value == null) {
                      return "Required field";
                    } else {
                      return null;
                    }
                  },
                  dropDownItemCount: 1,
                  dropDownList: const [
                    DropDownValueModel(name: 'name1', value: "value1"),
                    DropDownValueModel(name: 'name2', value: "value2"),
                    DropDownValueModel(name: 'name3', value: "value3"),
                    DropDownValueModel(name: 'name4', value: "value4"),
                    DropDownValueModel(name: 'name5', value: "value5"),
                    DropDownValueModel(name: 'name6', value: "value6"),
                    DropDownValueModel(name: 'name7', value: "value7"),
                    DropDownValueModel(name: 'name8', value: "value8"),
                    DropDownValueModel(name: 'name1', value: "value1"),
                    DropDownValueModel(name: 'name2', value: "value2"),
                    DropDownValueModel(name: 'name3', value: "value3"),
                    DropDownValueModel(name: 'name4', value: "value4"),
                    DropDownValueModel(name: 'name5', value: "value5"),
                    DropDownValueModel(name: 'name6', value: "value6"),
                    DropDownValueModel(name: 'name7', value: "value7"),
                    DropDownValueModel(name: 'name8', value: "value8"),
                    DropDownValueModel(name: 'name1', value: "value1"),
                    DropDownValueModel(name: 'name2', value: "value2"),
                    DropDownValueModel(name: 'name3', value: "value3"),
                    DropDownValueModel(name: 'name4', value: "value4"),
                    DropDownValueModel(name: 'name5', value: "value5"),
                    DropDownValueModel(name: 'name6', value: "value6"),
                    DropDownValueModel(name: 'name7', value: "value7"),
                    DropDownValueModel(name: 'name8', value: "value8"),
                  ],
                  onChanged: (val) {},
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _scrollCnt.animateTo(MediaQuery.of(context).size.height,
              duration: const Duration(milliseconds: 100), curve: Curves.ease);
        },
        label: const Text("Submit"),
      ),
    );
  }
}
