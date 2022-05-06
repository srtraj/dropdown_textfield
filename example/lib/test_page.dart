import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController _cnt;
  late MultiValueDropDownController _cntMulti;
  late String initValue;

  @override
  void initState() {
    _cnt = SingleValueDropDownController(
        data: const DropDownValueModel(name: 'name2', value: "value2"));
    _cntMulti = MultiValueDropDownController(data: [
      const DropDownValueModel(
          name: 'name1', value: "value1", toolTipMsg: "fdsfgfsdgf"),
      const DropDownValueModel(name: 'name5', value: "value5"),
    ]);
    initValue = "name1";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 600,
                ),
                const Text(
                  "Single selection dropdown",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropDownTextField(
                  enableSearch: true,
                  // initialValue: "name1",
                  // listTileHeight: 40,
                  singleController: _cnt,
                  clearOption: false,
                  validator: (value) {
                    if (value == null) {
                      return "Required field";
                    } else {
                      return null;
                    }
                  },
                  dropDownItemCount: 6,
                  dropDownList: const [
                    DropDownValueModel(name: 'name1', value: "value1"),
                    DropDownValueModel(name: 'name2', value: "value2"),
                    DropDownValueModel(name: 'name3', value: "value3"),
                    DropDownValueModel(name: 'name5', value: "value5"),
                    DropDownValueModel(name: 'name6', value: "value6"),
                    DropDownValueModel(name: 'name7', value: "value7"),
                    DropDownValueModel(name: 'name8', value: "value8"),
                  ],
                  onChanged: (val) {
                    setState(() {});
                  },
                ),
                // const SizedBox(
                //   height: 50,
                // ),
                // const Text(
                //   "Single selection dropdown with search option",
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                // DropDownTextField(
                //   clearOption: false,
                //   textFieldFocusNode: textFieldFocusNode,
                //   searchFocusNode: searchFocusNode,
                //   // searchAutofocus: true,
                //   searchShowCursor: false,
                //   enableSearch: true,
                //   searchKeyboardType: TextInputType.number,
                //   dropDownList: [
                //     DropDownValueModel(name: 'aaa', value: "aaa"),
                //     DropDownValueModel(name: 'bbb', value: "bbb"),
                //     DropDownValueModel(name: 'acc', value: "acc"),
                //     DropDownValueModel(name: 'dbb', value: "dbb"),
                //   ],
                //   onChanged: (val) {},
                // ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "multi selection dropdown",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropDownTextField.multiSelection(
                  buttonColor: Colors.red,
                  buttonText: "gghds",
                  buttonTextStyle: const TextStyle(color: Colors.white),
                  multiController: _cntMulti,
                  clearOption: false,
                  dropDownList: const [
                    DropDownValueModel(name: 'name1', value: "value1"),
                    DropDownValueModel(
                        name: 'name2',
                        value: "value2",
                        toolTipMsg:
                            "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                    DropDownValueModel(name: 'name3', value: "value3"),
                    DropDownValueModel(
                        name: 'name4',
                        value: "value4",
                        toolTipMsg:
                            "DropDownButton is a widget that we can use to select one unique value from a set of values"),
                    DropDownValueModel(name: 'name5', value: "value5"),
                    DropDownValueModel(name: 'name6', value: "value6"),
                    DropDownValueModel(name: 'name7', value: "value7"),
                    DropDownValueModel(name: 'name8', value: "value8"),
                  ],
                  onChanged: (val) {
                    print(val);
                    setState(() {});
                  },
                ),
                // const SizedBox(
                //   height: 30,
                // ),
                // const Text(
                //   "Single selection dropdown",
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                // DropDownTextField(
                //   // initialValue: "name4",
                //   validator: (value) {
                //     if (value == null) {
                //       return "Required field";
                //     } else {
                //       return null;
                //     }
                //   },
                //   dropDownList: [
                //     DropDownValueModel(name: 'name1', value: "value1"),
                //     DropDownValueModel(name: 'name2', value: "value2"),
                //     DropDownValueModel(name: 'name3', value: "value3"),
                //     DropDownValueModel(name: 'name4', value: "value4"),
                //     DropDownValueModel(name: 'name5', value: "value5"),
                //     DropDownValueModel(name: 'name6', value: "value6"),
                //     DropDownValueModel(name: 'name7', value: "value7"),
                //     DropDownValueModel(name: 'name8', value: "value8"),
                //   ],
                //   dropDownItemCount: 6,
                //   onChanged: (val) {},
                // ),
                const SizedBox(
                  height: 1000,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {});
        },
        label: const Text("Submit"),
      ),
    );
  }
}
