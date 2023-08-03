import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
   int _selectedOption = 1; // Default is 1 for Dashboard

  void _selectOption(int option) {
    setState(() {
      _selectedOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      color: Colors.grey.shade100,
      child: Column(
        children: [
          
          UserAccountsDrawerHeader(
            accountName: Text('Triple H'),
            accountEmail: Text('test@gmail.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('lib/assets/images/person.jpg'),
            ),
          ),
          Divider(),
          SidebarOption(
            
            optionText: 'Dashboard',
            optionIcon: Icons.dashboard,
            isSelected: _selectedOption == 1,
            onTap: () => _selectOption(1),
          ),
           Divider(),
          SidebarOption(
            optionText: 'Settings',
            optionIcon: Icons.settings,
            isSelected: _selectedOption == 2,
            onTap: () => _selectOption(2),
          ),
          
          SidebarOption(
            optionText: 'Profile',
            optionIcon: Icons.person,
            isSelected: _selectedOption == 3,
            onTap: () => _selectOption(3),
          ),
           
                    SidebarOption(
            optionText: 'About Us',
            optionIcon: Icons.info,
            isSelected: _selectedOption == 4,
            onTap: () => _selectOption(4),
          ),       
        ],
      ),
    );
  }
}

class SidebarOption extends StatelessWidget {
  final String optionText;
  final IconData optionIcon;
  final bool isSelected;
  final VoidCallback onTap;

  SidebarOption({
    required this.optionText,
    required this.optionIcon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: isSelected ? Colors.grey.shade200 : Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              optionIcon,
              color: isSelected ? Colors.blue : Colors.black,
            ),
            SizedBox(width: 8),
            Text(
              optionText,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}