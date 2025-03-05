import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../../utils/StockageKeys.dart';

class ProfileHeader extends StatelessWidget {
  final GetStorage storage;

  const ProfileHeader({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade300,
                    Colors.blue.shade300,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 65,
                backgroundImage: const AssetImage('assets/icons/me.png'),
                backgroundColor: Colors.transparent,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black, size: 22),
                  onPressed: () {
                    // Action pour éditer le profil
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          "${storage.read(StockageKeys.userKey)?['nom_complet'] ?? 'User'} ",
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          "${storage.read(StockageKeys.userKey)?['phone'] ?? '0000000000'}",
          style: TextStyle(
            fontSize: 17,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 22),
        Divider(
          color: Colors.grey.shade300,
          thickness: 1.5, // Pour une ligne plus visible
        ),
      ],
    );
  }
}
