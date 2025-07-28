import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TestPage(),
    );
  }
}

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const TestPage()));
      }),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController _cnt;
  late MultiValueDropDownController _cntMulti;
  String initalValue = "abc";
  @override
  void initState() {
    _cnt = SingleValueDropDownController();
    _cntMulti = MultiValueDropDownController();
    super.initState();
  }

  @override
  void dispose() {
    _cnt.dispose();
    _cntMulti.dispose();
    super.dispose();
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
                  height: 50,
                ),
                const Text(
                  "Single selection dropdown with search option",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropDownTextField(
                  controller: _cnt,
                  clearOption: true,
                  enableSearch: true,
                  clearIconProperty: IconProperty(color: Colors.green),
                  searchTextStyle: const TextStyle(color: Colors.red),
                  searchDecoration: const InputDecoration(
                      hintText: "enter your custom hint text here"),
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
                  onChanged: (val) {},
                ),
                const SizedBox(
                  height: 500,
                ),
                const Text(
                  "Single selection dropdown with search option",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropDownTextField(
                  clearOption: false,
                  textFieldFocusNode: textFieldFocusNode,
                  searchFocusNode: searchFocusNode,
                  // searchAutofocus: true,
                  dropDownItemCount: 8,
                  searchShowCursor: false,
                  enableSearch: true,
                  searchKeyboardType: TextInputType.number,
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
                  onChanged: (val) {},
                ),
                const SizedBox(
                  height: 500,
                ),
                const Text(
                  "multi selection dropdown",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropDownTextField.multiSelection(
                  controller: _cntMulti,
                  // initialValue: const ["name1", "name2", "name8", "name3"],
                  // displayCompleteItem: true,
                  checkBoxProperty: CheckBoxProperty(
                      fillColor: WidgetStateProperty.all<Color>(Colors.red)),
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
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Single selection dropdown",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropDownTextField(
                  // initialValue: "name4",
                  listSpace: 20,
                  listPadding: ListPadding(top: 20),
                  enableSearch: true,
                  validator: (value) {
                    if (value == null) {
                      return "Required field";
                    } else {
                      return null;
                    }
                  },
                  dropDownList: const [
                    DropDownValueModel(name: 'name1', value: "value1"),
                    DropDownValueModel(name: 'name2', value: "value2"),
                    DropDownValueModel(name: 'name3', value: "value3"),
                    DropDownValueModel(name: 'name4', value: "value4"),
                    DropDownValueModel(name: 'name5', value: "value5"),
                    DropDownValueModel(name: 'name6', value: "value6"),
                    DropDownValueModel(name: 'name7', value: "value7"),
                    DropDownValueModel(name: 'name8', value: "value8"),
                  ],
                  listTextStyle: const TextStyle(color: Colors.red),
                  dropDownItemCount: 8,

                  onChanged: (val) {},
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  "Single selection dropdown with prefix widget and custom boxDecoration and boxMargin",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropDownTextField(
                  // initialValue: "name4",
                  listSpace: 20,
                  listPadding: ListPadding(top: 20),
                  enableSearch: true,
                  validator: (value) {
                    if (value == null) {
                      return "Required field";
                    } else {
                      return null;
                    }
                  },
                  boxDecoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  boxMargin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  dropDownList: const [
                    DropDownValueModel(
                        name: 'name1',
                        value: "value1",
                        prefixWidget: Icon(
                          Icons.person,
                          size: 24,
                        )),
                    DropDownValueModel(
                        name: 'name2',
                        value: "value2",
                        prefixWidget: Icon(
                          Icons.person,
                          size: 24,
                        )),
                    DropDownValueModel(
                        name: 'name3',
                        value: "value3",
                        prefixWidget: Icon(
                          Icons.person,
                          size: 24,
                        )),
                    DropDownValueModel(
                        name: 'name4',
                        value: "value4",
                        prefixWidget: Icon(
                          Icons.person,
                          size: 24,
                        )),
                    DropDownValueModel(
                        name: 'name5',
                        value: "value5",
                        prefixWidget: Icon(
                          Icons.person,
                          size: 24,
                        )),
                    DropDownValueModel(
                        name: 'name6',
                        value: "value6",
                        prefixWidget: Icon(
                          Icons.person,
                          size: 24,
                        )),
                    DropDownValueModel(
                        name: 'name7',
                        value: "value7",
                        prefixWidget: Icon(
                          Icons.person,
                          size: 24,
                        )),
                    DropDownValueModel(
                        name: 'name8',
                        value: "value8",
                        prefixWidget: Icon(
                          Icons.person,
                          size: 24,
                        )),
                  ],
                  listTextStyle: const TextStyle(color: Colors.red),
                  dropDownItemCount: 8,

                  onChanged: (val) {},
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _cntMulti.clearDropDown();
        },
        label: const Text("Submit"),
      ),
    );
  }
}
