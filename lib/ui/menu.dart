import 'package:flutter/material.dart';
import 'package:untitled/model.dart';
import 'package:untitled/response.dart';
import 'package:untitled/service.dart';
import 'package:untitled/ui/detail_page.dart';
import 'package:untitled/ui/tambah_data.dart';

class MenuMakanan extends StatefulWidget {
  const MenuMakanan({Key? key}) : super(key: key);

  @override
  State<MenuMakanan> createState() => _MenuMakananState();
}

class _MenuMakananState extends State<MenuMakanan> {
  final apiService = ApiService();
  late Future<ResponseMakanan> futureMakanan = ApiService().getapi();
  List<ModelMakanan> searchResults = [];
  final TextEditingController searchController = TextEditingController();



  void fetchData() async {
    try {
      ResponseMakanan response = await apiService.getapi();
      setState(() {
        futureMakanan = Future.value(response);
      });
    } catch (error) {
      // Handle error
      debugPrint('Error fetching data: $error');
    }
  }

  void searchMakanan(String query) async {
    print('Search Query: $query');

    try {
      // Panggil metode pencarian dari ApiService
      List<ModelMakanan> results = await apiService.searchMakanan(query);

      setState(() {
        if (results.isNotEmpty) {
          // Jika terdapat hasil pencarian, gunakan hasil tersebut
          searchResults = results;
          print('Search Results: $searchResults');
        } else {
          // Jika tidak ada hasil pencarian
          print('Tidak ada hasil pencarian');
          searchResults = [];
        }
      });
    } catch (error) {
      // Handle kesalahan lainnya
      print('Error: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFC6736),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                fetchData();
              },
              icon: Icon(
                Icons.refresh,
                color: Colors.white70,
              ))
        ],
        title: Center(
          child: Text(
            '        Lagoods',
            style: TextStyle(color: Color(0xffFFB0B0)),
          ),
        ),
        backgroundColor: Color(0xFF0C2D57),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF454545)),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: 'Cari Makanan',
                              hintStyle: TextStyle(
                                  color: Color(
                                0xFF454545,
                              )),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              searchMakanan(searchController.text);
                            },
                            icon: Icon(Icons.search, color: Color(0xffFFA559)))
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                height: 520,
                child: FutureBuilder(
                  future: futureMakanan,
                  builder: (BuildContext context,
                      AsyncSnapshot<ResponseMakanan> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else if (snapshot.hasData) {
                      final data = snapshot.data!;
                      if (searchResults.isEmpty &&
                          snapshot.data!.makananList.isEmpty) {
                        return Center(
                          child: Text('Tidak ada data makanan.'),
                        );
                      }
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Jumlah kolom dalam grid
                          crossAxisSpacing: 8.0, // Spasi antar kolom
                          mainAxisSpacing: 8.0, // Spasi antar baris
                        ),
                        itemCount: searchResults.isEmpty
                            ? snapshot.data!.makananList.length
                            : searchResults.length,
                        itemBuilder: (context, index) {
                          if (searchResults.isEmpty &&
                              snapshot.data!.makananList.isEmpty) {
                            return Center(
                              child: Text('Tidak ada data makanan.'),
                            );
                          }
                          ModelMakanan makanan = searchResults.isEmpty
                              ? snapshot.data!.makananList[index]
                              : searchResults[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPage(makanan: makanan),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              color: Color(0xff0C2D57),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 110,
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(8.0),
                                      ),
                                      child: Image.network(
                                        '${makanan.link}',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${makanan.nama}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                              color: Color(0xffFFB0B0)),
                                        ),
                                        SizedBox(height: 4.0),
                                        Text(
                                          'Rp${makanan.harga?.replaceAllMapped(
                                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                (Match match) => '${match[1]},',
                                          ) ?? '0.00'}',
                                          style: TextStyle(color: Color(0xffFFB0B0)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return Container(); // Return widget default jika tidak ada data
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddMakananPage(),
                    ),
                  ).then((value) {
                    // Check apakah perlu refresh
                    if (value != null && value == true) {
                      // Lakukan refresh data di sini
                      fetchData();
                    }
                  });
                },
                child: Text(
                  'Tambah Data',
                  style: TextStyle(color: Color(0xffFFB0B0)),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xff0C2D57))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
