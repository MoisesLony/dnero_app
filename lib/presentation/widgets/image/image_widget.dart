import 'dart:typed_data';
import 'package:dnero_app_prueba/presentation/providers/provider_barril.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ✅ Profile image widget with circular border and shadow
class ProfileImageWidget extends ConsumerWidget {
  final Uint8List? imageData;

  const ProfileImageWidget({super.key, this.imageData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cachedImage = ref.watch(imageCacheProvider)["user_profile"];

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Subtle shadow effect
            blurRadius: 10, // Softens the shadow
            spreadRadius: 2, // Expands the shadow
            offset: const Offset(0, 4), // Moves shadow downward
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 72, // Profile image size
        backgroundColor: Colors.transparent, // Transparent background for the border
        child: CircleAvatar(
          radius: 68, // Slightly smaller radius to create a border effect
          backgroundImage: (imageData != null && imageData!.isNotEmpty)
              ? MemoryImage(imageData!) // ✅ If API loads image, use it
              : (cachedImage != null
                  ? MemoryImage(cachedImage) // ✅ Use cached image if available
                  : const AssetImage("assets/images/default_profile.png") as ImageProvider), // ✅ Default while loading
        ),
      ),
    );
  }
}
