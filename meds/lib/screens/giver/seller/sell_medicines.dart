import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meds/screens/giver/donor_options_page.dart';
import 'package:meds/utils/ui_helper/app_colors.dart';
import 'package:meds/utils/ui_helper/app_fonts.dart';

class SellMedicinePage extends StatefulWidget {
  @override
  State<SellMedicinePage> createState() => _SellMedicinePageState();
}

class _SellMedicinePageState extends State<SellMedicinePage> {
  String? Medicine_Image;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _compositionMgController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _remainingQuantityController = TextEditingController();
  final TextEditingController _predictedPriceController = TextEditingController();
  final List<String> medicines = [
    "Ibuprofen", "Metformin", "Simvastatin", "Captopril", "Enalapril", "Omeprazole",
    "Lisinopril", "Atorvastatin", "Losartan", "Doxazosin", "Furosemide", "Veramil",
    "Nifedipine", "Cetirizine", "Amlodipine", "Loratin", "Pantoprazole", "Paracetamol",
    "Aspirin", "Ecosprin-AV", "Ecosprin", "Ativan", "Lorazam", "Valium", "Chlorpheniramine",
    "Doxylamine", "Famotidine", "Labetalol", "Prazosin", "Minipress XL", "Telmisartan",
    "Valsartan", "Olmesartan", "Candesar", "Loratadine", "Ivermectin", "Cilostazol",
    "Bisoprolol", "Hydrochlorothiazide", "Ramipril", "Doxycycline", "Levothyroxine",
    "Prednisolone", "Methotrexate", "Sulfasalazine", "Cyclosporin", "Esomeprazole",
    "Warfarin", "Cyclophosamide", "Methylprednisolone", "Tacrolimus", "Rosuvastatin",
    "Lansoprazole", "Lanzole", "Pravastatin", "Celecoxib", "Ezedoc", "Fenofibrate",
    "Lovastatin", "Hydrocortisone", "Amoxicillin", "Moxpic", "Gabapentin", "Citalopram",
    "Fluoxetine", "Allopurinol", "Alprazolam", "Atenolol", "Cefuroxime", "Clonazepam",
    "Digoxin", "Doxepin", "Enalapril maleate", "Hydroxyzine", "Ibuprofen lysine",
    "Mirtazapine", "Omeprazole sodi", "Quetiapine", "Sotatol", "Tamsulosin", "Terazosin",
    "Tetracycline", "Trazodone", "Go-Urea", "Venlafaxine", "Xanax", "Zolpidem",
    "Zopiclone", "Amitriptyline", "Aripiprazole", "Benzepril", "Cyclobenzaprine",
    "Diazepam", "Risperidone", "Naproxen", "Sildenafil", "Viagra Slidenafil",
    "Sumatripan", "Tadalafil", "Cialis", "Cephalexin", "Ciprofloxacin", "Augmentin",
    "Ceftriaxone", "Propranolol", "Clopidogrel", "Glipizide", "Glibenclamide",
    "Candesartan", "Indapamide", "Bromhexine", "Flutamide", "Piroxicam", "Torsemide",
    "Levetiracetam", "Pilocarpine", "Norethindrone", "Mifepristone", "Hyponosed",
    "Bromazepam", "Clobazam", "Lamictal", "Olanzapine", "Lithium", "Inthalith",
    "Topiramate", "Valproate", "Flunarizine", "Tramadol", "Methocarbamol", "Carbamazepine",
    "Pregabalin", "Voriconazole", "Escitalopram", "Haloperidol", "Oxcarbazepine",
    "Asenapine", "Bupropion", "Zolmitriptan", "Triazolam", "Ticagrelor", "Syncapone",
    "Paroxetine", "Nortriptyline", "Duloxetine", "Ceritinib", "Vardenafil",
    "Fexofenadine", "Montelukast", "Gliclazide", "Amlodipine besyl", "Glyboral",
    "Glimepride", "Niacin", "Alphadopa", "Toradol", "Cilnidipine", "Perindopril",
    "Satalol", "Katadol", "Teniva"
  ];


  @override
  void initState() {
    super.initState();
    _priceController.addListener(_fetchPredictedPrice);
  }

  @override
  void dispose() {
    _priceController.dispose();
    _predictedPriceController.dispose();
    _dateController.dispose();
    _medicineNameController.dispose();
    _compositionMgController.dispose();
    _quantityController.dispose();
    _remainingQuantityController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        Medicine_Image = image.path;
      });
    }
  }

  Future<void> _fetchPredictedPrice() async {
    if (_medicineNameController.text.isEmpty ||
        _compositionMgController.text.isEmpty ||
        _quantityController.text.isEmpty ||
        _remainingQuantityController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _dateController.text.isEmpty) {
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.0.107:5000/predict'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'medicine_name': _medicineNameController.text,
        'composition_mg': double.tryParse(_compositionMgController.text) ?? 0,
        'quantity': int.tryParse(_quantityController.text) ?? 0,
        'price': double.tryParse(_priceController.text) ?? 0,
        'remaining_quantity': int.tryParse(_remainingQuantityController.text) ?? 0,
        'expiry_date': _dateController.text,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _predictedPriceController.text = data['predicted_price'].toString();
      });
    } else {
      throw Exception('Failed to load predicted price');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = pickedDate.toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sell Medicines', style: Theme.of(context).textTheme.headlineLarge),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return medicines.where((String medicine) {
                    return medicine.toLowerCase().contains(textEditingValue.text.toLowerCase());
                  });
                },
                onSelected: (String selection) {
                  _medicineNameController.text = selection;
                },
                fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    decoration: InputDecoration(labelText: 'Medicine Name', border: OutlineInputBorder()),
                  );
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: _compositionMgController,
                decoration: InputDecoration(
                  labelText: 'Composition Mg (e.g., 500 mg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _remainingQuantityController,
                decoration: InputDecoration(
                  labelText: 'Remaining Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Expiration Date (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: 'Actual Price',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _predictedPriceController,
                decoration: InputDecoration(
                  labelText: 'Predicted Price for Reselling',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                readOnly: true,
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Medicine_Image == null
                    ? Center(child: Text('No image selected'))
                    : Image.file(File(Medicine_Image!), fit: BoxFit.cover),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Upload Image'),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Sell_Confirmation_page()));
                },
                child: Text('Submit for Sale'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Sell_Confirmation_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirmation Page", style: Theme.of(context).textTheme.headlineLarge),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.greenAccent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Thanks for reselling to us!",
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.w800),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DonorOptionsPage()));
                  },
                  child: Text("Go to Home"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
