import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  // Make sure this is imported
import 'package:nutricare/widgets/food_type_card.dart';


class DietPlanner extends StatefulWidget {
  const DietPlanner({Key? key}) : super(key: key);

  @override
  _DietPlannerState createState() => _DietPlannerState();
}

class _DietPlannerState extends State<DietPlanner> {
  List<String> meals = ['1 meal', '2 meals', '3 meals', '4 meals'];
  String selected = '4 meals';

  bool isAnythingSelected = false;
  bool isVegSelected = false;
  bool isMedSelected = false;
  bool isPaleoSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light, // Updated this line
        elevation: 0.0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.8),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 22.0,
                    backgroundColor: Colors.green,
                    backgroundImage: NetworkImage('https://t3.ftcdn.net/jpg/05/11/52/90/360_F_511529094_PISGWTmlfmBu1g4nocqdVKaHBnzMDWrN.jpg'),
                  ),
                  SizedBox(width: 5.0),
                  Text(
                    'Hi Gavina!',
                    style: TextStyle(
                      color: Colors.green[800],
                      fontSize: 21.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.green[800],
                size: 25.0,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 10.0,
          left: 10.0,
          right: 10.0,
          bottom: 10.0,
        ),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Let us know your diet.',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.0),
                Container(
                  height: 500.0,
                  child: GridView(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                    ),
                    children: <Widget>[
                      FoodTypeCard(
                        image: 'https://static.vecteezy.com/system/resources/thumbnails/000/585/705/small/5-08.jpg',
                        title: 'Pregnant Women',
                        isSelected: isAnythingSelected,
                        onPress: () {
                          setState(() {
                            isAnythingSelected = !isAnythingSelected;
                          });
                        },
                      ),
                      FoodTypeCard(
                        image: 'https://thumbs.dreamstime.com/b/female-olympic-athlete-running-marathon-person-celebrate-summer-games-athletics-medal-sportive-people-celebrating-track-field-174309058.jpg',
                        title: 'athletes',
                        isSelected: isVegSelected,
                        onPress: () {
                          setState(() {
                            isVegSelected = !isVegSelected;
                          });
                        },
                      ),
                      FoodTypeCard(
                        image: 'https://static.vecteezy.com/system/resources/previews/001/879/424/non_2x/doctor-and-people-check-blood-sugar-level-with-glucose-meter-diabetes-type-two-check-up-diet-for-non-communicable-diseases-checking-insulin-illustration-for-business-card-banner-brochure-flyer-free-vector.jpg',
                        title: 'Diabetic patients',
                        isSelected: isMedSelected,
                        onPress: () {
                          setState(() {
                            isMedSelected = !isMedSelected;
                          });
                        },
                      ),
                      FoodTypeCard(
                        image: 'https://static.vecteezy.com/system/resources/thumbnails/002/226/928/small/kawaii-heart-versus-high-cholesterol-levels-vector.jpg',
                        title: 'Cholesterol patients',
                        isSelected: isPaleoSelected,
                        onPress: () {
                          setState(() {
                            isPaleoSelected = !isPaleoSelected;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.0),
                Text(
                  'I want to eat',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 19.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.green[200],
                    hintText: '1500 Calories',
                    hintStyle: TextStyle(
                      color: Colors.green[500],
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                    suffixText: 'Not sure?',
                    suffixStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Text(
                  'in how many meals?',
                  style: TextStyle(
                    color: Colors.green[800],
                    fontSize: 19.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.0),
                DropdownButton<String>(
                  value: selected,
                  onChanged: (String? newValue) {
                    setState(() {
                      selected = newValue!;
                    });
                  },
                  items: meals.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0.0,
        child: Padding(
          padding: EdgeInsets.only(right: 30.0, left: 30.0, bottom: 28.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 38.0, vertical: 10.0),
              backgroundColor: Colors.green[800], // Corrected this line
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {},
            child: Text(
              'Generate',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
