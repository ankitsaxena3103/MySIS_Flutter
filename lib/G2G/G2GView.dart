import 'package:flutter/material.dart';
import 'package:mysis/CommonViews/CalendarView.dart';
import 'package:mysis/CommonViews/SuccessAlertView.dart';
import 'package:mysis/CommonViews/Utility.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:mysis/G2G/BranchHierarchy.dart';

import '../CommonViews/LoaderView.dart';
import '../CommonViews/ToastMessageView.dart';
import '../SharedClasses/APIHelper.dart';

class G2GView extends StatefulWidget {
  const G2GView({super.key});

  @override
  G2GViewState createState() => G2GViewState();
}

class G2GViewState extends State<G2GView>{


  bool showToastMessageView = false;
  String toastMessage = '';
  TextEditingController txtName = TextEditingController(text: "");

  TextEditingController txtMobile = TextEditingController(text: "");

  TextEditingController txtDOB = TextEditingController(text: "");
  TextEditingController txtFname = TextEditingController(text: "");
  TextEditingController txtAadharNo = TextEditingController(text: "");

  TextEditingController txtPreferredUnit = TextEditingController(text: "");

  bool isCalendarView = false;
  bool isSucces = false;

  bool showLoaderView = false;

  Color nextBgColor = isDarkMode ? greyColorDark : greyColor2;
  Color nextFontColor = isDarkMode ? greyColor6 : greyColor3;

  Color nextShadowColor = Colors.transparent;
  String btnNext = 'submit_referral'.tr();
  bool isTapEnabled = false;

  final mobileNoRegExp = RegExp(r'^[6789]\d{9}$');
  final aadharRegExp = RegExp(r'^[2-9]\d{11}$');

  List<BranchHierarchy> branchHierarchyData = [];
  List<Map<String,String>> regionData = [];
  List<Map<String,String>> branchData = [];

  String selectedRegionCode = '';

  String selectedBranchCode = '';

  @override
  void initState() {
    onLoadData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    calculateSizes(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [

          Container(
            width: logicalWidth,
            height: logicalHeight,
            decoration:  BoxDecoration(
              shape: BoxShape.rectangle,
              gradient: isDarkMode ? backgroundGradientDark : backgroundGradient,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: MediaQuery.of(context).padding.top+pathS/12,
                  left: paddingLeft +pathS/3,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Container(
                          width: pathS/5,
                          height: pathS/2,
                          child: Image.asset(
                            'assets/images/dashboard-icons/left-arrow.png',
                            color: isDarkMode ?  whiteColor:greyColor6,

                          ),

                        ),
                        SizedBox(width: pathS/8),
                        Text(
                          'G2G_referral'.tr(),
                          style: TextStyle(
                            color: isDarkMode ?  whiteColor:greyColor6,
                            fontSize: pathS / 5.5,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Roboto',
                          ),
                          textAlign: TextAlign.left,
                        ),

                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: screenHeight - pathS - paddingTop - paddingBottom,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        SizedBox(height: pathS/1.5),

                        Container(
                          alignment: Alignment.center,
                          width: screenWidth - 2.5 * marginValue,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(pathS / 8),
                            color: isDarkMode ? greyColor6 : whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // Shadow color
                                blurRadius: pathS / 10, // Spread of the shadow
                                offset: Offset(-pathS / 12, pathS / 12),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: pathS / 4, top: pathS / 4, bottom: pathS / 2,right: pathS/4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [


                                Container(
                                    // width: pathL*1.5,
                                    height: pathS/2,
                                    alignment:Alignment.bottomLeft,
                                    child: TextField(
                                      onChanged: (value) {
                                        if(txtName.text.length > 2){
                                          onChangeData();
                                        }
                                      },
                                      controller: txtName,
                                      decoration:  InputDecoration(
                                        hintText: '${'name'.tr()}*', // Placeholder text
                                        contentPadding: EdgeInsets.fromLTRB(0, 0, 8, 0),

                                        hintStyle: TextStyle(
                                          color: isDarkMode ? greyColor1 : greyColor3,
                                          fontSize: pathS/5,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Roboto',
                                        ),
                                        border: InputBorder.none,
                                      ),
                                      style: TextStyle(
                                        color: isDarkMode ? whiteColor : greyColor6,
                                        fontSize: pathS/4,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                ),
                                SizedBox(height: pathS / 8),
                                Padding(
                                  padding: EdgeInsets.only(right: 0),
                                  child: Container(
                                    height: 1,
                                    color: isDarkMode ? greyColorDark : greyColor2,
                                  ),
                                ),

                                SizedBox(height: pathS/5),

                                Container(
                                  // width: pathL*1.5,
                                  height: pathS/2,
                                  alignment:Alignment.bottomLeft,
                                  child: TextField(
                                    onChanged: (value) {
                                      if(txtMobile.text.length == 10 && mobileNoRegExp.hasMatch(txtMobile.text)){
                                        onChangeData();
                                        FocusScope.of(context).unfocus();
                                      }

                                    },
                                    controller: txtMobile,
                                    maxLength: 10,
                                    keyboardType: TextInputType.number,
                                    decoration:  InputDecoration(
                                      hintText: '${'mobile'.tr()}*', // Placeholder text
                                      contentPadding: EdgeInsets.fromLTRB(0, 0, 8, 0),

                                      hintStyle: TextStyle(
                                        color: isDarkMode ? greyColor1 : greyColor3,
                                        fontSize: pathS/5,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Roboto',
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(
                                      color: isDarkMode ? whiteColor : greyColor6,
                                      fontSize: pathS/4,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                                SizedBox(height: pathS / 8),
                                Padding(
                                  padding: EdgeInsets.only(right: 0),
                                  child: Container(
                                    height: 1,
                                    color: isDarkMode ? greyColorDark : greyColor2,
                                  ),
                                ),

                                SizedBox(height: pathS/5),

                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isCalendarView = true;
                                    });
                                  },
                                  child: Row(
                                    children: [

                                      Container(
                                        width: pathL*1.5,
                                        height: pathS/2,
                                        alignment:Alignment.bottomLeft,
                                        child: TextField(
                                          onChanged: (value) {
                                            if(txtDOB.text.isNotEmpty){
                                              onChangeData();
                                            }

                                          },
                                          readOnly: true,
                                          controller: txtDOB,
                                          decoration:  InputDecoration(
                                            hintText: '${'dob'.tr()}', // Placeholder text
                                            contentPadding: EdgeInsets.fromLTRB(0, 0, 8, 0),

                                            hintStyle: TextStyle(
                                              color: isDarkMode ? greyColor1 : greyColor3,
                                              fontSize: pathS/5,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Roboto',
                                            ),
                                            border: InputBorder.none,
                                          ),
                                          style: TextStyle(
                                            color: isDarkMode ? whiteColor : greyColor6,
                                            fontSize: pathS/4,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Icon(
                                        Icons.calendar_month,
                                        color: isDarkMode ? whiteColor : redColor3,
                                        size: pathS / 2.8,
                                      ),



                                    ],
                                  ),
                                ),
                                SizedBox(height: pathS / 8),
                                Padding(
                                  padding: EdgeInsets.only(right: 0),
                                  child: Container(
                                    height: 1,
                                    color: isDarkMode ? greyColorDark : greyColor2,
                                  ),
                                ),

                                SizedBox(height: pathS/5),

                                Container(
                                  height: pathS/2,
                                  alignment:Alignment.bottomLeft,
                                  child: TextField(
                                    onChanged: (value) {
                                      if(txtFname.text.length > 2){
                                        onChangeData();
                                      }

                                    },
                                    controller: txtFname,
                                    decoration:  InputDecoration(
                                      hintText: '${'father_name'.tr()}', // Placeholder text
                                      contentPadding: EdgeInsets.fromLTRB(0, 0, 8, 0),

                                      hintStyle: TextStyle(
                                        color: isDarkMode ? greyColor1 : greyColor3,
                                        fontSize: pathS/5,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Roboto',
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(
                                      color: isDarkMode ? whiteColor : greyColor6,
                                      fontSize: pathS/4,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                                SizedBox(height: pathS / 8),
                                Padding(
                                  padding: EdgeInsets.only(right: 0),
                                  child: Container(
                                    height: 1,
                                    color: isDarkMode ? greyColorDark : greyColor2,
                                  ),
                                ),

                                SizedBox(height: pathS/5),

                                Container(
                                  height: pathS/2,
                                  alignment:Alignment.bottomLeft,
                                  child: TextField(
                                    onChanged: (value) {
                                      if(aadharRegExp.hasMatch(txtAadharNo.text)){
                                        onChangeData();
                                        FocusScope.of(context).unfocus();
                                      }

                                    },
                                    controller: txtAadharNo,
                                    maxLength: 12,
                                    keyboardType: TextInputType.number,
                                    decoration:  InputDecoration(
                                      hintText: '${'aadhar_no'.tr()}', // Placeholder text
                                      contentPadding: EdgeInsets.fromLTRB(0, 0, 8, 0),

                                      hintStyle: TextStyle(
                                        color: isDarkMode ? greyColor1 : greyColor3,
                                        fontSize: pathS/5,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Roboto',
                                      ),
                                      border: InputBorder.none,
                                    ),
                                    style: TextStyle(
                                      color: isDarkMode ? whiteColor : greyColor6,
                                      fontSize: pathS/4,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                                SizedBox(height: pathS / 8),
                                Padding(
                                  padding: EdgeInsets.only(right: 0),
                                  child: Container(
                                    height: 1,
                                    color: isDarkMode ? greyColorDark : greyColor2,
                                  ),
                                ),

                                SizedBox(height: pathS/5),

                                CustomDropdown(
                                  items: regionData,
                                  placeholder: 'Select Region',
                                  onSelected: (selectedRegion) {
                                    setState(() {
                                      selectedRegionCode = selectedRegion;
                                      selectedBranchCode = ''; // Reset branch selection
                                      branchData.clear(); // Clear existing branches before fetching new data
                                    });
                                    onChangeData();
                                    extractBranchData(branchHierarchyData);
                                    print("Selected Region: $selectedRegion"); // Handle selection
                                  },
                                ),

                                SizedBox(height: pathS/5),
                                CustomDropdown(
                                  items: branchData,
                                  placeholder: 'Select Branch',
                                  selectedValue: selectedBranchCode, // Ensure reset happens
                                  onSelected: (selectedBranch) {
                                    setState(() {
                                      selectedBranchCode = selectedBranch;
                                    });
                                    onChangeData();
                                    print("Selected Branch: $selectedBranch"); // Handle selection
                                  },
                                ),





                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),



                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom,

                  child: Container(
                    width: screenWidth,
                    height: pathS / 1.2,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDarkMode ? greyColor8:whiteColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                      // borderRadius: BorderRadius.circular(pathS/3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // Shadow color
                          blurRadius: pathS/10, // Spread of the shadow
                          spreadRadius: pathS/8,
                          offset:  Offset(-pathS/12, pathS/12),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: isTapEnabled ? onTapSubmit : null, // Disable tap if isTapEnabled is false
                      child: Container(
                        width: pathL*1.5,
                        height: pathS / 2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: nextBgColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                          borderRadius: BorderRadius.circular(pathS/3),
                          boxShadow: [
                            BoxShadow(
                              color: nextShadowColor, // Shadow color
                              blurRadius: pathS/10, // Spread of the shadow
                              // spreadRadius: pathS/15, // How far the shadow extends
                              offset:  Offset(-pathS/12, pathS/12),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            btnNext,
                            style: TextStyle(
                              color: nextFontColor,
                              fontSize: pathS / 5,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Roboto',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,

                  child: Container(
                    width: screenWidth,
                    height: MediaQuery.of(context).padding.bottom,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDarkMode ? greyColor8:whiteColor,                          // border: Border.all(color: Colors.yellow, width: pathS/18),
                      // borderRadius: BorderRadius.circular(pathS/3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1), // Shadow color
                          blurRadius: pathS/10, // Spread of the shadow
                          // spreadRadius: pathS/15, // How far the shadow extends
                          offset:  Offset(-pathS/12, pathS/12),
                        ),
                      ],
                    ),

                  ),
                ),

                Visibility(
                  visible: isCalendarView,
                  child: CalendarView(
                      callBack: (int val, String data) {
                        setState(() {
                          isCalendarView = false;
                          if(val == 1){

                            txtDOB.text = getFormattedDateTime(data, "dd-MMM-yyyy", "yyyy-MM-dd");

                          }
                        });


                      },

                      cancelButtonTitle: 'Cancel'.tr(),
                      okButtonTitle: 'done'.tr()),
                ),
                Visibility(
                  visible: isSucces,
                  child: SuccessAlertView(
                      callBack: (int val) {
                        setState(() {
                          isSucces = false;

                        });
                        Navigator.pop(context);
                      },

                    message: 'submitted_referral_success'.tr(),),
                ),
                ToastMessageView(isVisible: showToastMessageView, message: toastMessage),
                LoaderView(isVisible: showLoaderView, message: ''),

              ],
            ),
          ),



        ],
      ),
    );
  }

  void extractRegionData(List<BranchHierarchy> branchHierarchyData) {
    Map<String, String> regionMap = {};

    for (var item in branchHierarchyData) {
      regionMap[item.regionCode] = item.regionName; // Ensure uniqueness
    }

    setState(() {
      regionData = regionMap.entries
          .map((e) => {'id': e.key, 'name': e.value})
          .toList();

      // Sort by name (ascending)
      regionData.sort((a, b) => a['name']!.compareTo(b['name']!));
    });
  }

  void extractBranchData(List<BranchHierarchy> branchHierarchyData) {
    Map<String, String> branchMap = {};

    for (var item in branchHierarchyData) {
      if (selectedRegionCode == item.regionCode) {
        branchMap[item.branchCode] = item.branchName; // Ensure uniqueness
      }
    }

    setState(() {
      branchData = branchMap.entries.map((e) => {'id': e.key, 'name': e.value}).toList();
      branchData.sort((a, b) => a['name']!.compareTo(b['name']!));

    });
  }

  void onLoadData() {

    setState(() {
      showLoaderView = true;
    });
    Map <String,String> inputData = {

    };

    APIHelper.instance.getData(branchHierarchyApi,inputData, (data) {

      setState(() {
        showLoaderView = false;
      });

      if(data.isNotEmpty){
        print(data);
        List<BranchHierarchy> hierarchyData = data.map((json) => BranchHierarchy.fromJson(json)).toList();

          branchHierarchyData = hierarchyData;

          extractRegionData(branchHierarchyData);
      }

    },(error){
      setState(() {
        showLoaderView = false;
      });
    }
    );

  }


  void showToast(String message) {
    setState(() {
      showToastMessageView = true;
      toastMessage = message;
    });

    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        showToastMessageView = false;
      });
    });
  }
  void onChangeData() {

    setState(() {
      nextBgColor =   isDarkMode ? greyColorDark : greyColor2;

      nextFontColor = isDarkMode ? greyColor6 : greyColor3;
      nextShadowColor = Colors.transparent;
      isTapEnabled = false; // Disable tap
    });



    if(txtName.text.length < 3){
      return;
    }
    if(!mobileNoRegExp.hasMatch(txtMobile.text)){
      return;
    }
    if(txtDOB.text.isEmpty){
      return;
    }
    if(txtFname.text.length < 3){
      return;
    }
    if(txtAadharNo.text.isEmpty && !aadharRegExp.hasMatch(txtAadharNo.text)){
      return;
    }
    if(selectedRegionCode.isEmpty){
      return;
    }

    if(selectedBranchCode.isEmpty){
      return;
    }


      setState(() {
        nextBgColor = redColor3;
        nextFontColor = Colors.white;
        nextShadowColor = Colors.black.withOpacity(0.2);
        isTapEnabled = true; // Enable tap
      });



  }
  void onTapSubmit(){
    final mobileNoRegExp = RegExp(r'^[6789]\d{9}$');
    final aadharRegExp = RegExp(r'^[2-9]\d{11}$');


    if(txtName.text.length < 3){
      showToast('please_enter_name'.tr());
      return;
    }
    if(!mobileNoRegExp.hasMatch(txtMobile.text)){
      showToast('inValid_Number'.tr());
      return;
    }
    if(txtDOB.text.isEmpty){
      showToast('please_enter_DOB'.tr());
      return;
    }
    if(txtFname.text.length < 3){
      showToast('please_enter_fatherName'.tr());
      return;
    }
    if(txtAadharNo.text.isEmpty && !aadharRegExp.hasMatch(txtAadharNo.text)){
      showToast('please_enter_adharnumber'.tr());
      return;
    }
    if(selectedRegionCode.isEmpty || selectedBranchCode.isEmpty){
      showToast('please_enter_preferunit'.tr());
      return;
    }





    setState(() {
      showLoaderView = true;
    });
    Map <String,String> inputData = {
      "RegionCode": selectedRegionCode,
      "BranchCode": selectedBranchCode,
      "CandidateName": txtName.text,
      "MobileNo": txtMobile.text,
      "DateOfBirth": txtDOB.text,
      "FatherName": txtFname.text,
      "AadharNo": txtAadharNo.text,

    };

    APIHelper.instance.postData(postGuardReferalApi,inputData, (data) {

      setState(() {
        showLoaderView = false;
      });
      if(data.isNotEmpty){

        setState(() {
          isSucces = true;
        });


      }

    },(error){
      setState(() {
        showLoaderView = false;
      });
      printInDebug('error received');

    }
    );

  }


}


class CustomDropdown extends StatefulWidget {
  final List<Map<String, String>> items; // List of data (Region, Branch, etc.)
  final Function(String) onSelected; // Callback function
  final String placeholder; // Placeholder text
  final String? selectedValue; // Selected value (optional)

  const CustomDropdown({
    super.key,
    required this.items,
    required this.onSelected,
    required this.placeholder,
    this.selectedValue, // Make it optional
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: widget.selectedValue?.isNotEmpty == true ? widget.selectedValue : null, // Ensure null if no selection
      decoration: InputDecoration(
        hintText: widget.placeholder, // Placeholder text
        hintStyle: TextStyle(
          color: isDarkMode ? greyColor1 : greyColor3,
          fontSize: pathS/5,
          fontWeight: FontWeight.w500,
          fontFamily: 'Roboto',
        ), // Customize placeholder
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: isDarkMode ? greyColorDark : greyColor2,

          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: isDarkMode ? greyColorDark : greyColor2,
          ),
        ),
      ),
      items: widget.items.map((item) {
        return DropdownMenuItem(
          value: item['id'],
          child: SizedBox(
            width: screenWidth-2.5*marginValue-pathS, // Limit width
            child: Text(
              item['name']!,
              overflow: TextOverflow.ellipsis, // Prevent text from overflowing
              style: TextStyle(
                color: isDarkMode ? whiteColor : greyColor6,
                fontSize: pathS/4.2,
                fontWeight: FontWeight.w500,
                fontFamily: 'Roboto',
              ), // Customize text
            ),
          ),
        );
      }).toList(),
      onChanged: (value) {
        widget.onSelected(value!); // Pass the selected value
      },
      style: TextStyle(
        color: isDarkMode ? whiteColor : greyColor6,
        fontSize: pathS/5,
        fontWeight: FontWeight.w500,
        fontFamily: 'Roboto',
      ), // Selected item text color
      dropdownColor: isDarkMode ? greyColorDark :Colors.white, // Dropdown background color
        menuMaxHeight:screenWidth,
    );
  }

}
