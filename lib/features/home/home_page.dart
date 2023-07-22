import 'package:dark_typer/core/components/button.dart';
import 'package:dark_typer/features/multiplayer_mode/ui/multiplayer_settings.dart';
import 'package:dark_typer/features/solo_mode/ui/solo_mode_page.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title:  Padding(
            padding: EdgeInsets.symmetric(horizontal: width*0.05),
            child: const Text("Dark Type"),
          ),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/dark_type.png'),
                //SizedBox(height: 30,),
                const Text(
                  "Welcome to Dark Type",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Choose a mode below",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                ),
                SizedBox(height: height * 0.05),
                Button(title: "Solo / Practice Mode", onTap: onClickSoloMode),
                SizedBox(height: height * 0.05),
                Button(title: "Multiplayer Mode", onTap: onClickMultiplayerMode)
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onClickSoloMode(BuildContext context) {
    TextEditingController soloModeTimeController = TextEditingController();
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text("Enter typing time duration in seconds"),
              content: TextField(
                controller: soloModeTimeController,
                decoration: const InputDecoration(hintText: "60"),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: (){
                      Navigator.of(ctx).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: const Text("Cancel"),
                    ),
                ),
                TextButton(
                  onPressed: () {
                    if (int.tryParse(soloModeTimeController.text) != null && int.parse(soloModeTimeController.text)<=600) {
                      int time = int.parse(soloModeTimeController.text);
                      Navigator.of(ctx).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SoloModePage(gameTime: time)),
                      );
                    } else {
                      var snackBar = const SnackBar(content: Text('Enter a valid value!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    child: const Text("Done"),
                  ),
                ),
              ],
            ));
  }

  void onClickMultiplayerMode(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const MultiplayerSettings()),
    );
  }
}
