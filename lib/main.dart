import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:untitled2/constant.dart';
import 'package:http/http.dart' as http;

import 'model.dart';

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
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState(){
    super.initState();
    isLoading = false;
  }

  Future<String> generateRensponse(String prompt) async{
    final apiKey = apiSecretKey;
    var url = Uri.https("api.openai.com", "v1/completions");
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        "Authorization": "Bearer $apiKey"
      },

      body: json.encode({
        "model": "text-davinci-003",
        "prompt": prompt,
        'temperature': 0,
        'max_tokens': 2000,
        'top_p': 1,
        'frequency_penalty': 0.0,
        'presence_penalty': 0.0,
      }),
    );

    //decode the response
    Map<String, dynamic> newresponse = jsonDecode(response.body);
    return newresponse['choices'][0]['text'];
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
              Expanded(
                  child: _buildList(),
              ),

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

  ListView _buildList(){
    return ListView.builder(
      itemCount: _messages.length,
      controller: _scrollController,
      itemBuilder: ((context, index){
        var message = _messages[index];
          return ChatMessageWidget(
            text: message.text,
            chatMessageType: message.chatMessageType,
          );
      }),
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final String text;
  final ChatMessageType chatMessageType;

  const ChatMessageWidget({super.key, required this.text, required this.chatMessageType});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.all(16.0),
      color: chatMessageType == ChatMessageType.bot ? botBackgroundColor: backgroundColor,
      child: Row(
        children: [
          chatMessageType == ChatMessageType.bot ? Container(
            margin: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              child: Image.asset(
                  'assets/2.jpeg',
                color: Colors.white,
                scale: 1.5,
              ),
            ),
          ): Container(
            margin: EdgeInsets.only(right: 16),
            child: CircleAvatar(
                child: Icon(Icons.person),
            )
          ),
          Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8)
                      ),
                    ),
                    child: Text(
                      text,
                      style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                    ),
                  )
                ],
          ))
        ],
      ),
    );
  }
}



