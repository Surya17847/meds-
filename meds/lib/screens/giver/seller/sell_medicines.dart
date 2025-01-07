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
  String? medicineImage;
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
    "Satalol", "Katadol", "Teniva"  ];

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
        medicineImage = image.path;
      });
    }
  }

  void _fetchPredictedPrice() async {
    try {
      final response = await http.post(
        Uri.parse("https://ml-model-brnb.onrender.com/predict"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'medicine_name': _medicineNameController.text,
          'composition_mg': double.parse(_compositionMgController.text),
          'quantity': int.parse(_quantityController.text),
          'price': double.parse(_priceController.text),
          'remaining_quantity': int.parse(_remainingQuantityController.text),
          'expiry_date': _dateController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          _predictedPriceController.text = responseData['predicted_price'].toString();
        });
      } else {
        throw Exception('Failed to fetch prediction');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sell Medicine'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SellConfirmationPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: _pickImage,
                child: medicineImage == null
                    ? Container(
                  width: double.infinity,
                  height: 150,
                  color: AppColors.lightGrey,
                  child: Icon(Icons.add_a_photo, size: 50, color: AppColors.primary),
                )
                    : Image.file(
                  File(medicineImage!),
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Medicine Name'),
                items: medicines
                    .map((medicine) => DropdownMenuItem<String>(
                  value: medicine,
                  child: Text(medicine),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _medicineNameController.text = value!;
                  });
                },
              ),
              TextFormField(
                controller: _compositionMgController,
                decoration: InputDecoration(labelText: 'Composition (mg)'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _remainingQuantityController,
                decoration: InputDecoration(labelText: 'Remaining Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Expiry Date (yyyy-mm-dd)'),
              ),
              TextFormField(
                controller: _predictedPriceController,
                decoration: InputDecoration(labelText: 'Predicted Price'),
                enabled: false,
              ),
              ElevatedButton(
                onPressed: _fetchPredictedPrice,
                child: Text('Get Prediction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SellConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Confirmation Page",
          style: AppFonts.headlineLarge,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DonorOptionsPage()),
                    );
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
