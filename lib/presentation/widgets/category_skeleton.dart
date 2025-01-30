import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategorySkeleton extends StatelessWidget {
  final Size screenSize;

  const CategorySkeleton({super.key, required this.screenSize});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 0,),
          _buildSkeletonCategoryRows(screenSize),
          SizedBox(height: screenSize.height * 0.05),
          _buildButtonPlaceholder(screenSize),
        ],
      ),
    );
  }


  // Skeleton para las categorías, respetando filas y posiciones originales
  Widget _buildSkeletonCategoryRows(Size screenSize) {
    return Column(
      children: [
        _buildRow([
          _circlePlaceholder(size: screenSize.width * (102 / 400), padding: const EdgeInsets.fromLTRB(20, 30, 3, 0)),
          _circlePlaceholder(size: screenSize.width * (135 / 400)),
        ]),
        _buildRow([
          _circlePlaceholder(size: screenSize.width * (85 / 400), padding: const EdgeInsets.fromLTRB(0, 5, 3, 0)),
          _circlePlaceholder(size: screenSize.width * (104 / 400)),
          _circlePlaceholder(size: screenSize.width * (97 / 400)),
        ]),
        _buildRow([
          _circlePlaceholder(size: screenSize.width * (67 / 400), padding: const EdgeInsets.fromLTRB(2, 0, 0, 18)),
          _circlePlaceholder(size: screenSize.width * (86 / 400)),
          _circlePlaceholder(size: screenSize.width * (87 / 400)),
          _circlePlaceholder(size: screenSize.width * (63 / 400)),
        ]),
        _buildRow([
          _circlePlaceholder(size: screenSize.width * (112 / 400)),
          _circlePlaceholder(size: screenSize.width * (97 / 400)),
          _circlePlaceholder(size: screenSize.width * (82 / 400), padding: const EdgeInsets.only(bottom: 5)),
        ]),
        _buildRow([
          _circlePlaceholder(size: screenSize.width * (75 / 400)),
          _circlePlaceholder(size: screenSize.width * (91 / 400)),
        ]),
      ],
    );
  }

  // Skeleton para los círculos de categorías
  Widget _circlePlaceholder({required double size, EdgeInsetsGeometry? padding}) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 0, horizontal: 4.5),
      child: Container(
          width: size,
          height: size,
          decoration:  BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.withOpacity(0.2),
          ),
      ),
    );
  }

  // Construcción dinámica de filas
  Widget _buildRow(List<Widget> children) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  // Skeleton para el botón "Siguiente"
  Widget _buildButtonPlaceholder(Size screenSize) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: screenSize.width * 0.6,
        height: screenSize.height * 0.06,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
