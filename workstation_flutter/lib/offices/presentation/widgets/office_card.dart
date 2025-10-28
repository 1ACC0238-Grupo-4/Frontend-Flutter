import 'package:flutter/material.dart';
import 'package:workstation_flutter/offices/domain/office.dart';


class OfficeCard extends StatelessWidget {
  final Office office;
  final VoidCallback onTap;
  final bool showButton;

  const OfficeCard({
    super.key,
    required this.office,
    required this.onTap,
    this.showButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F48C), // Light yellow
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: office.imageUrl != null
                    ? Image.network(
                        office.imageUrl!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage();
                        },
                      )
                    : _buildPlaceholderImage(),
              ),
              const SizedBox(width: 12),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          office.location,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (office.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            office.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black.withOpacity(0.6),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 16,
                              color: Colors.black.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Hasta ${office.capacity}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'S/ ${office.costPerDay}/día',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    if (showButton) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: onTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8BC34A),
                            foregroundColor: Colors.black87,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                            'Ver mas',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(
        Icons.business,
        size: 50,
        color: Colors.grey,
      ),
    );
  }
}