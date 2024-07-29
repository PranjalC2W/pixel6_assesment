import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_pixel_demo/EmployeeModel.dart';
import 'package:http/http.dart' as http;

class Employeedata extends StatefulWidget {
  const Employeedata({super.key});

  @override
  State<Employeedata> createState() => _EmployeedataState();
}

class _EmployeedataState extends State<Employeedata> {
  // List to hold employee data fetched from the API
  List<dynamic> empData = [];
  // List to hold the filtered employee data based on selected filters
  List<dynamic> filterdData = [];
  // Selected country and gender filters
  String? selectedCountry;
  String? selectedGender;
  // Flags to control sorting direction
  bool isIdAscending = true;
  bool isNameAscending = true;

  @override
  void initState() {
    super.initState();
    // Fetch employee data when the widget is first created
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text(
                    "Employees",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.filter_alt,
                    color: Colors.red,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  // Dropdown for selecting country filter
                  DropdownButton<String>(
                    hint: const Text("Country"),
                    value: selectedCountry,
                    items: getCountry(),
                    onChanged: (value) {
                      log("country change call");
                      selectedCountry = value;
                      filterData();
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  // Dropdown for selecting gender filter
                  DropdownButton<String>(
                    hint: const Text("Gender"),
                    value: selectedGender,
                    items: getGender(),
                    onChanged: (value) {
                      log(" gender filter change call");
                      selectedGender = value;
                      filterData();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            // DataTable to display employee data
            DataTable(
                columns: [
                  // Column for ID with sorting functionality
                  DataColumn(
                    label: Row(
                      children: [
                        const Text(
                          "ID",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Icon(isIdAscending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward)
                      ],
                    ),
                    onSort: (columnIndex, ascending) {
                      setState(() {
                        isIdAscending = !isIdAscending;
                        filterdData.sort(
                          (a, b) {
                            if (a.id == null && b.id == null) {
                              return 0;
                            } else {
                              if (isIdAscending) {
                                return a.id.compareTo(b.id);
                              } else {
                                return b.id.compareTo(a.id);
                              }
                            }
                          },
                        );
                      });
                    },
                  ),
                  const DataColumn(
                      label: Text("Image",
                          style: TextStyle(fontWeight: FontWeight.w600))),
                  // Column for Full Name with sorting functionality
                  DataColumn(
                    label: Row(
                      children: [
                        const Text("Full Name",
                            style: TextStyle(fontWeight: FontWeight.w600)),
                        Icon(isNameAscending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward)
                      ],
                    ),
                    onSort: (columnIndex, ascending) {
                      isNameAscending = !isNameAscending;
                      filterdData.sort((a, b) {
                        String aName =
                            "${a.firstName ?? ''} ${a.maidenName ?? ''} ${a.lastName ?? ''}"
                                .trim();
                        String bName =
                            "${b.firstName ?? ''} ${b.maidenName ?? ''} ${b.lastName ?? ''}"
                                .trim();

                        if (isNameAscending) {
                          return aName.compareTo(bName);
                        } else {
                          return bName.compareTo(aName);
                        }
                      });
                    },
                  ),
                  const DataColumn(
                      label: Text("Demography",
                          style: TextStyle(fontWeight: FontWeight.w600))),
                  const DataColumn(
                      label: Text("Designation",
                          style: TextStyle(fontWeight: FontWeight.w600))),
                  const DataColumn(
                      label: Text("Location",
                          style: TextStyle(fontWeight: FontWeight.w600))),
                ],
                // Rows of the DataTable filled with employee data
                rows: filterdData.map((employee) {
                  return DataRow(cells: [
                    DataCell(Text("${employee.id}")),
                    DataCell(Image.network(employee.image)),
                    DataCell(Text(
                        "${employee.firstName} ${employee.maidenName} ${employee.lastName}")),
                    DataCell(Text(
                        "${employee.gender == 'female' ? 'F' : 'M'}/${employee.age}")),
                    DataCell(Text("${employee.company.title}")),
                    DataCell(Text(
                        "${employee.address.state}, ${employee.address.country}")),
                  ]);
                }).toList()),
          ],
        ),
      ),
    );
  }

  // Function to fetch employee data from the API
  void getData() async {
    Uri url = Uri.parse("https://dummyjson.com/users");

    http.Response response = await http.get(url);

    var responsedata = json.decode(response.body);

    EmployeeModel empModel = EmployeeModel(responsedata);

    setState(() {
      log("get call");
      empData = empModel.users ?? [];
      filterdData = empData;
    });
  }

  // Function to get unique countries from the employee data
  List<DropdownMenuItem<String>> getCountry() {
    List<dynamic> countries =
        empData.map((emp) => emp.address.country).toSet().toList();
    return countries.map((country) {
      return DropdownMenuItem<String>(
        value: country,
        child: Text(country),
      );
    }).toList();
  }


// Function to provide gender options for the filter
  List<DropdownMenuItem<String>> getGender() {
    List<String> gender = ["male", "female"];
    return gender.map((gender) {
      return DropdownMenuItem<String>(
        value: gender,
        child: Text(gender),
      );
    }).toList();
  }

// Function to filter employee data based on selected filters
  void filterData() {
    log("filterdata call");
    List<dynamic> data = empData;
    if (selectedCountry != null && selectedCountry!.isNotEmpty) {
      data = data
          .where((employee) => employee.address.country == selectedCountry)
          .toList();
    }
    if (selectedGender != null && selectedGender!.isNotEmpty) {
      data =
          data.where((employee) => employee.gender == selectedGender).toList();
    }
    setState(() {
      filterdData = data;
    });
  }
}
