import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OwnerManageStoreScreen extends StatefulWidget {
  const OwnerManageStoreScreen({super.key});

  @override
  State<OwnerManageStoreScreen> createState() => _OwnerManageStoreScreenState();
}

class _OwnerManageStoreScreenState extends State<OwnerManageStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  Uint8List? _selectedImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _facilitiesController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  int? _selectedCampusId;
  int? _userId;

  final List<String> _campusList = [
    'ITS', 'UNAIR A', 'UNAIR B', 'UNAIR C', 'UNESA', 'UBAYA', 'UINSA', 'UPN Veteran Jatim', 'Universitas Ciputra', 'Universitas Terbuka', 'Universitas Dr. Soetomo', 'Universitas Wijaya Putra', 'Universitas Muhammadiyah Surabaya', 'Universitas 17 Agustus 1945 (UNTAG)', 'Universitas Wijaya Kusuma Surabaya'
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _addressController.text = prefs.getString('address') ?? '';
      _facilitiesController.text = prefs.getString('facilities') ?? '';
      _capacityController.text = prefs.getString('capacity') ?? '';
      _priceController.text = prefs.getString('price') ?? '';
      _accountNumberController.text = prefs.getString('accountNumber') ?? '';
      _selectedCampusId = prefs.getInt('campus_id');
      _userId = prefs.getInt('user_id');
      print('Loaded user_id: $_userId'); // Tambahkan log ini

      final String? imageData = prefs.getString('image');
      if (imageData != null) {
        _selectedImage = base64Decode(imageData);
      }
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('address', _addressController.text);
    await prefs.setString('facilities', _facilitiesController.text);
    await prefs.setString('capacity', _capacityController.text);
    await prefs.setString('price', _priceController.text);
    await prefs.setString('accountNumber', _accountNumberController.text);
    await prefs.setInt('campus_id', _selectedCampusId ?? 0);

    if (_selectedImage != null) {
      await prefs.setString('image', base64Encode(_selectedImage!));
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImage = bytes;
      });
    }
  }

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      if (_userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User ID is missing. Please log in again.')),
        );
        return;
      }

      final Map<String, dynamic> data = {
        'name': _nameController.text.trim(),
        'address': _addressController.text.trim(),
        'facilities': _facilitiesController.text.trim(),
        'capacity': int.tryParse(_capacityController.text) ?? 0,
        'price': int.tryParse(_priceController.text) ?? 0,
        'account_number': _accountNumberController.text.trim(),
        'campus_id': _selectedCampusId,
        'photo': _selectedImage != null ? base64Encode(_selectedImage!) : '',
        'user_id': _userId,
      };

      // Periksa field kosong secara lokal sebelum mengirim
      if (data.values.any((value) => value == null || value == '' || value == 0)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all the fields.')),
        );
        return;
      }

      try {
        final response = await http.post(
          Uri.parse('http://localhost/rumah-nugas-backend-fix/api/save_place.php'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Data saved successfully!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save data: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Store'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Store Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Store name cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Address cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _facilitiesController,
                  decoration: const InputDecoration(labelText: 'Facilities'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Facilities cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _capacityController,
                  decoration: const InputDecoration(labelText: 'Capacity'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Capacity cannot be empty';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Capacity must be a number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Price cannot be empty';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Price must be a number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _accountNumberController,
                  decoration: const InputDecoration(labelText: 'Account Number'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Account number cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        value: _selectedCampusId,
                        hint: const Text('Select Nearest Campus'),
                        items: _campusList.asMap().entries.map((entry) {
                          int index = entry.key;
                          String campus = entry.value;
                          return DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text(campus),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCampusId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select the nearest campus';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Store Photo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black,
                    ),
                    child: _selectedImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                            ),
                          )
                        : const Center(
                            child: Text(
                              'No image selected',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitData,
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}