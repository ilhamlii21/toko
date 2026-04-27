import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase/supabase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi Supabase SDK
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.anonKey,
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase SDK Key-Value',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const KeyValuePage(),
    );
  }
}

class KeyValuePage extends StatefulWidget {
  const KeyValuePage({super.key});

  @override
  State<KeyValuePage> createState() => _KeyValuePageState();
}

class _KeyValuePageState extends State<KeyValuePage> {
  // Mendapatkan instance supabase client
  final _supabase = Supabase.instance.client;

  List<dynamic> items = [];
  bool isLoading = false;

  final TextEditingController keyController = TextEditingController();
  final TextEditingController valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // 1. FITUR MENAMPILKAN DATA (GET) menggunakan SDK
  Future<void> fetchData() async {
    setState(() => isLoading = true);
    try {
      final response = await _supabase.from('app_cache').select('*');
      setState(() {
        items = response;
      });
    } catch (e) {
      showError('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  // 2 & 3. FITUR MENAMBAHKAN (POST) DAN UPDATE (PATCH) DATA menggunakan SDK
  Future<void> addOrUpdateData({required bool isUpdate}) async {
    final key = keyController.text.trim();
    final valueString = valueController.text.trim();

    if (key.isEmpty || valueString.isEmpty) {
      showError('Key dan Value tidak boleh kosong');
      return;
    }

    dynamic parsedValue;
    try {
      parsedValue = json.decode(valueString);
    } catch (_) {
      parsedValue = valueString;
    }

    setState(() => isLoading = true);
    try {
      if (isUpdate) {
        // UPDATE
        await _supabase.from('app_cache').update({
          'value': parsedValue,
          'update_at': DateTime.now().toIso8601String(),
        }).eq('key', key);
      } else {
        // INSERT
        await _supabase.from('app_cache').insert({
          'key': key,
          'value': parsedValue,
          'update_at': DateTime.now().toIso8601String(),
        });
      }

      fetchData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isUpdate ? 'Berhasil mengupdate data!' : 'Berhasil menambahkan data!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      showError('Error jaringan: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  void showFormDialog({String? existingKey, String? existingValue}) {
    bool isUpdate = existingKey != null;
    
    if (isUpdate) {
      keyController.text = existingKey;
      valueController.text = existingValue ?? '';
    } else {
      keyController.clear();
      valueController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isUpdate ? 'Update Data' : 'Tambah Data Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: keyController,
              decoration: const InputDecoration(labelText: 'Key (Unique)'),
              enabled: !isUpdate,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(
                labelText: 'Value',
                hintText: 'Bisa teks biasa atau {"json": "format"}',
              ),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              addOrUpdateData(isUpdate: isUpdate);
            },
            child: Text(isUpdate ? 'Update' : 'Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Flutter SDK'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: fetchData),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? const Center(child: Text('Data kosong, silakan tambah data.'))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final key = item['key'] ?? 'N/A';
                    
                    final value = item['value'];
                    final valueStr = (value is Map || value is List)
                        ? const JsonEncoder.withIndent('  ').convert(value)
                        : value.toString();
                    
                    String updateAtStr = '-';
                    if (item['update_at'] != null) {
                      try {
                         final date = DateTime.parse(item['update_at']).toLocal();
                         updateAtStr = '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
                      } catch (_) {}
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        title: Text(key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              width: double.infinity,
                              child: Text(valueStr, style: const TextStyle(fontFamily: 'monospace')),
                            ),
                            const SizedBox(height: 8),
                            Text('Updated: $updateAtStr', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.teal),
                          onPressed: () => showFormDialog(existingKey: key, existingValue: valueStr),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showFormDialog(),
        tooltip: 'Tambah Data',
        child: const Icon(Icons.add),
      ),
    );
  }
}
