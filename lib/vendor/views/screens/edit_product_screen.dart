

import 'package:complete_clean_app/vendor/views/screens/edit_products_tabs/published_tab.dart';
import 'package:complete_clean_app/vendor/views/screens/edit_products_tabs/unpublished_tab.dart';
import 'package:flutter/material.dart';

class EditProductScreen extends StatelessWidget {
  const EditProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
      return DefaultTabController(
        length: 2, 
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              'Manage Products', style: 
              TextStyle(
              fontSize: 18, 
              fontWeight: 
              FontWeight.bold,
              ),
              ),
              bottom: TabBar(tabs: [
                Tab(child: Text('PUBLISHED'),), 
                Tab(child: Text('UNPUBLISHED'),),
              ]),
            ),
           body: TabBarView(
            children: [
              PublishedTabScreen(),
              UnPublishedTabScreen(),
           ]), 
        ),  
        );
  }
}