import 'package:flutter/material.dart';

class MyOrdersPage2 extends StatefulWidget {
  @override
  _MyOrdersPage2State createState() => _MyOrdersPage2State();
}

class _MyOrdersPage2State extends State<MyOrdersPage2> {
  String selectedFilter = 'Delivered';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Orders',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter tabs section
          Container(
            color: Colors.pink[50],
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFilterChip('Booked', selectedFilter == 'Booked'),
                SizedBox(width: 12),
                _buildFilterChip('Delivered', selectedFilter == 'Delivered'),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.pink[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Today',
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.calendar_today, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Orders list
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: ListView(
                children: [
                  // First order card
                  _buildOrderCard(
                    orderNumber: '#1524',
                    date: '13/05/2023',
                    trackingNumber: 'IK287368838',
                    kitId: 'YUJ005',
                    quantity: '2',
                    subtotal: '₹2,121.64',
                    status: 'DELIVERED',
                    statusColor: Colors.green,
                    actionText: 'Request Return',
                    actionColor: Colors.pink[300]!,
                  ),
                  SizedBox(height: 16),

                  // Second order card
                  _buildOrderCard(
                    orderNumber: '#1524',
                    date: '13/05/2023',
                    trackingNumber: 'IK287368838',
                    kitId: 'YUJ005',
                    quantity: '2',
                    subtotal: '₹2,121.64',
                    status: 'DELIVERED',
                    statusColor: Colors.green,
                    actionText: 'Testing',
                    actionColor: Colors.orange,
                    hasTestingIcon: true,
                  ),
                  SizedBox(height: 16),

                  // Third order card
                  _buildOrderCard(
                    orderNumber: '#1524',
                    date: '13/05/2023',
                    trackingNumber: 'IK287368838',
                    kitId: 'YUJ005',
                    quantity: '2',
                    subtotal: '₹2,121.64',
                    status: 'DELIVERED',
                    statusColor: Colors.green,
                    actionText: 'View Report',
                    actionColor: Colors.pink[100]!,
                    actionTextColor: Colors.pink[300]!,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.pink[300] : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.pink[300]! : Colors.grey[400]!,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard({
    required String orderNumber,
    required String date,
    required String trackingNumber,
    required String kitId,
    required String quantity,
    required String subtotal,
    required String status,
    required Color statusColor,
    required String actionText,
    required Color actionColor,
    Color? actionTextColor,
    bool hasTestingIcon = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order $orderNumber',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.pink[400],
                ),
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),

          // Order details
          _buildOrderDetail('Tracking number:', trackingNumber),
          SizedBox(height: 4),
          _buildOrderDetail('Kit ID:', kitId),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildOrderDetail('Quantity:', quantity),
              ),
              Expanded(
                child: _buildOrderDetail('Subtotal:', subtotal),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Status and action section
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: actionColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasTestingIcon) ...[
                      Icon(
                        Icons.science,
                        size: 14,
                        color: actionColor,
                      ),
                      SizedBox(width: 4),
                    ],
                    Text(
                      actionText,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: actionTextColor ?? actionColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetail(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}