import 'package:flutter/material.dart';

class CustomScrollView extends StatelessWidget {
  final List<Widget> listWidget;
  final VoidCallback updateMethode;
  final ScrollController scrollController;

  CustomScrollView({
    @required this.listWidget,
    @required this.updateMethode,
    this.scrollController
  });

  @override
  Widget build(BuildContext context) {
    return new RefreshIndicator(
      onRefresh: this.updateMethode,
      displacement: 30,
      child: new SingleChildScrollView(
        controller: scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: this.listWidget,
        ),
      ),
    );
  }

}