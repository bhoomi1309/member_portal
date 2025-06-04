import '../api/api_support.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  final Map<String, dynamic>? user;

  const AddUser({Key? key, this.user}) : super(key: key);

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _userApi = UserApi();
  final _formKey = GlobalKey<FormState>();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _username = TextEditingController();
  final _birthDate = TextEditingController();
  final _gender = TextEditingController();
  final _bloodGroup = TextEditingController();
  final _eyeColor = TextEditingController();
  final _hairColor = TextEditingController();
  final _hairType = TextEditingController();
  final _height = TextEditingController();
  final _weight = TextEditingController();
  final _university = TextEditingController();
  final _role = TextEditingController();

  final _address = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _postalCode = TextEditingController();
  final _country = TextEditingController();

  final _companyName = TextEditingController();
  final _companyDepartment = TextEditingController();
  final _companyTitle = TextEditingController();

  final _cryptoCoin = TextEditingController();
  final _cryptoWallet = TextEditingController();
  final _cryptoNetwork = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.user != null) {
      final u = widget.user!;
      _firstName.text = u['firstName'] ?? '';
      _lastName.text = u['lastName'] ?? '';
      _email.text = u['email'] ?? '';
      _phone.text = u['phone'] ?? '';
      _username.text = u['username'] ?? '';
      _birthDate.text = u['birthDate'] ?? '';
      _gender.text = u['gender'] ?? '';
      _bloodGroup.text = u['bloodGroup'] ?? '';
      _eyeColor.text = u['eyeColor'] ?? '';
      _hairColor.text = u['hair']?['color'] ?? '';
      _hairType.text = u['hair']?['type'] ?? '';
      _height.text = u['height']?.toString() ?? '';
      _weight.text = u['weight']?.toString() ?? '';
      _university.text = u['university'] ?? '';
      _role.text = u['role'] ?? '';
      _address.text = u['address']?['address'] ?? '';
      _city.text = u['address']?['city'] ?? '';
      _state.text = u['address']?['state'] ?? '';
      _postalCode.text = u['address']?['postalCode'] ?? '';
      _country.text = u['address']?['country'] ?? '';
      _companyName.text = u['company']?['name'] ?? '';
      _companyDepartment.text = u['company']?['department'] ?? '';
      _companyTitle.text = u['company']?['title'] ?? '';
      _cryptoCoin.text = u['crypto']?['coin'] ?? '';
      _cryptoWallet.text = u['crypto']?['wallet'] ?? '';
      _cryptoNetwork.text = u['crypto']?['network'] ?? '';
    }
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator: (value) =>
        value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user == null ? 'Add User' : 'Edit User', style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Personal Information"),
              _buildTextField('First Name', _firstName),
              _buildTextField('Last Name', _lastName),
              _buildTextField('Email', _email,
                  keyboardType: TextInputType.emailAddress),
              _buildTextField('Phone', _phone,
                  keyboardType: TextInputType.phone),
              _buildTextField('Username', _username),
              _buildTextField('Birth Date (YYYY-MM-DD)', _birthDate),
              _buildTextField('Gender', _gender),
              _buildTextField('Blood Group', _bloodGroup),
              _buildTextField('Eye Color', _eyeColor),
              _buildTextField('Hair Color', _hairColor),
              _buildTextField('Hair Type', _hairType),
              _buildTextField('Height', _height,
                  keyboardType: TextInputType.number),
              _buildTextField('Weight', _weight,
                  keyboardType: TextInputType.number),
              _buildTextField('University', _university),
              _buildTextField('Role', _role),

              _sectionTitle("Address"),
              _buildTextField('Address Line', _address),
              _buildTextField('City', _city),
              _buildTextField('State', _state),
              _buildTextField('Postal Code', _postalCode),
              _buildTextField('Country', _country),

              _sectionTitle("Company Info"),
              _buildTextField('Company Name', _companyName),
              _buildTextField('Company Department', _companyDepartment),
              _buildTextField('Company Title', _companyTitle),

              _sectionTitle("Crypto Info"),
              _buildTextField('Crypto Coin', _cryptoCoin),
              _buildTextField('Crypto Wallet', _cryptoWallet),
              _buildTextField('Crypto Network', _cryptoNetwork),

              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save, color: Colors.white,),
                  label: const Text('Submit', style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final user = {
                        'firstName': _firstName.text,
                        'lastName': _lastName.text,
                        'email': _email.text,
                        'phone': _phone.text,
                        'username': _username.text,
                        'birthDate': _birthDate.text,
                        'gender': _gender.text,
                        'bloodGroup': _bloodGroup.text,
                        'eyeColor': _eyeColor.text,
                        'hair': {
                          'color': _hairColor.text,
                          'type': _hairType.text,
                        },
                        'height': double.tryParse(_height.text) ?? 0,
                        'weight': double.tryParse(_weight.text) ?? 0,
                        'university': _university.text,
                        'role': _role.text,
                        'address': {
                          'address': _address.text,
                          'city': _city.text,
                          'state': _state.text,
                          'postalCode': _postalCode.text,
                          'country': _country.text,
                        },
                        'company': {
                          'name': _companyName.text,
                          'department': _companyDepartment.text,
                          'title': _companyTitle.text,
                        },
                        'crypto': {
                          'coin': _cryptoCoin.text,
                          'wallet': _cryptoWallet.text,
                          'network': _cryptoNetwork.text,
                        },
                      };

                      if (widget.user != null) {
                        user['id'] = widget.user!['id'];
                        await _userApi.updateUser(
                            newUser: user, index: user['id'] as int);
                      } else {
                        await _userApi.addUser(newUser: user);
                      }
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}