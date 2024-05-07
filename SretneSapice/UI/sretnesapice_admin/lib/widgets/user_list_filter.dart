import 'package:flutter/material.dart';
import 'package:flutter/src/material/checkbox.dart';

class UserListFilter extends StatefulWidget {
  final void Function(List<String> selectedRoles, bool? isActive)
      onFilterChanged;

  const UserListFilter({Key? key, required this.onFilterChanged})
      : super(key: key);

  @override
  _UserListFilterState createState() => _UserListFilterState();
}

class _UserListFilterState extends State<UserListFilter> {
  List<String> _selectedRoles = [];
  bool? _isActive = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Filtriranje po ulogama:', style: TextStyle(fontSize: 18),),
              SizedBox(
                width: 8,
              ),
              FilterChip(
                label: Text('Administrator'),
                selected: _selectedRoles.contains('Administrator'),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedRoles.add('Administrator');
                    } else {
                      _selectedRoles.remove('Administrator');
                    }
                  });
                  widget.onFilterChanged(_selectedRoles, _isActive);
                },
              ),
              SizedBox(
                width: 8,
              ),
              FilterChip(
                label: Text('User'),
                selected: _selectedRoles.contains('User'),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedRoles.add('User');
                    } else {
                      _selectedRoles.remove('User');
                    }
                  });
                  widget.onFilterChanged(_selectedRoles, _isActive);
                },
              ),
              SizedBox(
                width: 8,
              ),
              FilterChip(
                label: Text('Dog Walker'),
                selected: _selectedRoles.contains('DogWalker'),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedRoles.add('DogWalker');
                    } else {
                      _selectedRoles.remove('DogWalker');
                    }
                  });
                  widget.onFilterChanged(_selectedRoles, _isActive);
                },
              ),
              SizedBox(
                width: 8,
              ),
              FilterChip(
                label: Text('Dog Walker Verifier'),
                selected: _selectedRoles.contains('DogWalkerVerifier'),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedRoles.add('DogWalkerVerifier');
                    } else {
                      _selectedRoles.remove('DogWalkerVerifier');
                    }
                  });
                  widget.onFilterChanged(_selectedRoles, _isActive);
                },
              ),
            ],
          ),
          SizedBox(
                height: 8,
              ),
          Row(
            children: [
              Checkbox(
                value: _isActive,
                onChanged: (newValue) {
                  setState(() {
                    _isActive = newValue;
                  });
                  widget.onFilterChanged(_selectedRoles, _isActive);
                },
              ),
              Text('Aktivan korisnički račun?'),
            ],
          ),
        ],
      ),
    );
  }
}
