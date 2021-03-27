import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/custom_drawer.dart';
import 'package:lojavirtual/models/home_manager.dart';
import 'package:lojavirtual/screens/home/components/section_list.dart';
import 'package:lojavirtual/screens/home/components/section_staggered.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 211, 118, 130),
                Color.fromARGB(255, 253, 181, 168),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                actions: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    color: Colors.white,
                    onPressed: () => Navigator.of(context).pushNamed('/cart'),
                  ),
                ],
                backgroundColor: Colors.transparent,
                snap: true,
                floating: true,
                elevation: 0,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('Loja do Isaac'),
                  centerTitle: true,
                ),
              ),
              Consumer<HomeManager>(
                builder: (_, homeManager, __) {
                  final List<Widget> children =
                      homeManager.section.map<Widget>((section) {
                    switch (section.type) {
                      case 'List':
                        return SectionList(section);
                      case 'Staggered':
                        return SectionStaggered(section);
                        break;
                      default:
                        return Container();
                    }
                  }).toList();
                  return SliverList(
                      delegate: SliverChildListDelegate(children));
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
