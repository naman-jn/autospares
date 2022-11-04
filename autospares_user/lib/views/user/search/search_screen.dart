import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:autospares_user/configs/constants.dart';
import 'package:autospares_user/shared/widgets/custom_loading.dart';
import 'package:autospares_user/styles/app_colors.dart';
import 'package:autospares_user/views/user/home/widgets/home_search_field.dart';
import 'package:autospares_user/views/user/search/providers/search_notifier_provider.dart';
import 'package:autospares_user/views/user/search/widgets/vendor_listview.dart';
import 'package:autospares_user/views/user/search/widgets/vendor_loc_mapview.dart';

class SearchScreen extends StatefulWidget {
  final String category;

  const SearchScreen({Key? key, required this.category}) : super(key: key);
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final vendorListProvider =
          ref.watch(searchNotifierProvider(widget.category));
      return vendorListProvider.when(
          data: (data) {
            return Scaffold(
              body: Column(
                children: [
                  SearchTopSection(tabController: _tabController),
                  Expanded(
                    flex: 7,
                    child: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        VendorMapView(vendorList: data),
                        VendorListView(vendorList: data),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
          error: (error, stacktrace) {
            return const Text("Some error occurred, we'll get back shortly");
          },
          loading: () => const LoadingScreen());
    });
  }
}

class SearchTopSection extends StatefulWidget {
  final TabController tabController;
  const SearchTopSection({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  State<SearchTopSection> createState() => _SearchTopSectionState();
}

class _SearchTopSectionState extends State<SearchTopSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.darkBlue,
      height: 200,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            const HomeSearchField(),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.grey.shade400,
                          ),
                        ),
                        child: SizedBox(
                          height: 20,
                          child: DropdownButton(
                            dropdownColor: AppColors.darkBlue,
                            isExpanded: true,
                            underline: const SizedBox(),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: Colors.white,
                            ),
                            items: const [
                              DropdownMenuItem<Widget>(
                                child: SizedBox(
                                  child: Text(
                                    'Relevance',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                widget.tabController.animateTo(0);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: widget.tabController.index == 0
                                      ? Colors.grey.shade400
                                      : Colors.transparent,
                                ),
                              ),
                              child: Image.asset(
                                AppAssetsPaths.mapViewIcon3x,
                                height: 20,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                widget.tabController.animateTo(1);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(11),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: widget.tabController.index == 1
                                      ? Colors.grey.shade400
                                      : Colors.transparent,
                                ),
                              ),
                              child: Image.asset(
                                AppAssetsPaths.listViewIcon3x,
                                height: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// DropdownButton<String>(
//         isExpanded: true,
//         hint: Text('Select Faculty'),
//         value: selectedFaculty,
//         underline: Container(
//           height: 0,
//         ),
//         onChanged: (String value) async {
//           selectedFaculty = value;
//         },
//         selectedItemBuilder: (BuildContext context) {
//           return dropFaculty.map<Widget>((String text) {
//             return Text(
//               text,
//               overflow: TextOverflow.ellipsis,
//             );
//           }).toList();
//         },
//         items: disableKeyFields || selectedInstitution == null
//             ? null
//             : dropFaculty.map((String faculty) {
//                 return DropdownMenuItem<String>(
//                   value: faculty,
//                   child: Text(
//                     faculty,
//                     style: TextStyle(color: Colors.black),
//                   ),
//                 );
//               }).toList(),
//       ),