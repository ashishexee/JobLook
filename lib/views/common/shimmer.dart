import 'package:flutter/material.dart';
import 'package:job_look/views/common/vertical_shimmer.dart';


class SearchShimmer extends StatelessWidget {
  const SearchShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        scrollDirection: Axis.vertical,
        itemCount: 3,
        itemBuilder: (_, index) {
          return const Padding(
            padding:  EdgeInsets.all(12),
            child:  VerticalShimmer(),
          );
        });
  }
}
