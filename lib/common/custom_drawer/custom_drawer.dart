import 'package:flutter/material.dart';
import 'package:lojavirtual/common/custom_drawer/custom_drawer_header.dart';
import 'package:lojavirtual/common/custom_drawer/drawer_tile.dart';
import 'package:lojavirtual/models/user_manager.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          CustomDrawerHeader(),
          const DrawerTile(
            iconData: Icons.home,
            title: 'Inicio',
            page: 0,
          ),
          const DrawerTile(
            iconData: Icons.list,
            title: 'Produtos',
            page: 1,
          ),
          const DrawerTile(
            iconData: Icons.playlist_add_check,
            title: 'Meus Pedidos',
            page: 2,
          ),
          const DrawerTile(
            iconData: Icons.location_on,
            title: 'Lojas',
            page: 3,
          ),
          Consumer<UserManager>(
            builder: (_, userManager, __) {
              if (userManager.adminEnabled) {
                return Column(
                  children: const [
                    Divider(),
                    DrawerTile(
                      iconData: Icons.supervised_user_circle_outlined,
                      title: 'Usuarios',
                      page: 4,
                    ),
                    DrawerTile(
                      iconData: Icons.settings,
                      title: 'Pedidos',
                      page: 5,
                    ),
                  ],
                );
              } return Container();
            },
          ),
        ],
      ),
    );
  }
}
