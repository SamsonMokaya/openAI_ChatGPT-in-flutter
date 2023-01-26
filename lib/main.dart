import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat GPT',
      home: ChatPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

const backgroundColor = Color(0xff343541);
const botBackgroundColor = Color(0xff444654);
const botBackgroundColor2 = Color(0xff404d4d);

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {

  late bool isLoading;
  TextEditingController _textController = TextEditingController();

  @override
  void initState(){
    super.initState();
    isLoading = false;
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "OpenAi's ChatGPT",
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
          backgroundColor: botBackgroundColor,
        ),

       backgroundColor: backgroundColor,

        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              //chat body

              // Loads or rotates to show that the bot is thinking
              Visibility(
                visible: isLoading,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
              ),

              Row(
                children: [

                  //input filed
                  _builtInput(),

                  //submit button
                  _buildSubmit(),
                ],
              ),
            ],
          ),
        ),

      ),
    );
  }

  Expanded _builtInput(){
    return Expanded(
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        style: TextStyle(color: Colors.white),
        controller: _textController,
        decoration: InputDecoration(
          fillColor: botBackgroundColor,
          filled: true,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSubmit(){
    return Visibility(
      visible: !isLoading,
      child: Container(
        color: botBackgroundColor,
        child: IconButton(
          icon: Icon(
              Icons.send_rounded,
            color: Color.fromRGBO(142, 142, 160, 1),
          ),
          onPressed: (){},
        ),
      ),
    );
  }
}



