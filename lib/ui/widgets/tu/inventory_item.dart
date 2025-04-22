                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: onEdit,
                      tooltip: 'Edit',
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.all(8),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: onDelete,
                      tooltip: 'Hapus',
                      constraints: BoxConstraints(),
                      padding: EdgeInsets.all(8),
                    ),
                  ],
                ),
              ],
            ),
            
            // Item name and category
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon based on category
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(category).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getCategoryIcon(category),
                    color: _getCategoryColor(category),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Item details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(category).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 12,
                            color: _getCategoryColor(category),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Quantity and location
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jumlah',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            quantity.toString(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isLowStock ? Colors.red : null,
                            ),
                          ),
                          if (isLowStock)
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Icon(
                                Icons.warning,
                                color: Colors.red,
                                size: 16,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lokasi',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Condition and acquisition date
            Row(
              children: [
                if (condition != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kondisi',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getConditionColor(condition!).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            condition!,
                            style: TextStyle(
                              fontSize: 12,
                              color: _getConditionColor(condition!),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanggal Perolehan',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM yyyy').format(acquisitionDate),
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'furniture':
        return Icons.chair;
      case 'elektronik':
        return Icons.computer;
      case 'alat tulis':
        return Icons.edit;
      case 'buku':
        return Icons.book;
      case 'peralatan olahraga':
        return Icons.sports_soccer;
      case 'peralatan lab':
        return Icons.science;
      default:
        return Icons.inventory_2;
    }
  }
  
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'furniture':
        return Colors.brown;
      case 'elektronik':
        return Colors.blue;
      case 'alat tulis':
        return Colors.green;
      case 'buku':
        return Colors.purple;
      case 'peralatan olahraga':
        return Colors.orange;
      case 'peralatan lab':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
  
  Color _getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'baik':
        return Colors.green;
      case 'rusak ringan':
        return Colors.orange;
      case 'rusak berat':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}