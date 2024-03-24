// import 'package:flutter/material.dart';
// import 'package:transcriber/SpeachScreen.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Voice Transcriber',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.deepPurple,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//         // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: SpeachScreen(),
//     );
//   }
// // }
// import 'package:avatar_glow/avatar_glow.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:highlight_text/highlight_text.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:translator/translator.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Voice',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.red,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//
//       ),darkTheme: ThemeData.dark(),
//
//       home: SpeechScreen(),
//     );
//   }
// }
//
// class SpeechScreen extends StatefulWidget {
//   @override
//   _SpeechScreenState createState() => _SpeechScreenState();
// }
//
// class _SpeechScreenState extends State<SpeechScreen> {
//   //
//   // final translator = GoogleTranslator();
//   // String _translatedText = '';
//   // void translateText(String text, String toLanguage) {
//   //   translator.translate(text, to: toLanguage).then((translatedText) {
//   //     setState(() {
//   //       _translatedText = translatedText as String;
//   //     });
//   //   }).catchError((error) {
//   //     print('Translation error: $error');
//   //   });
//   // }
//   //translator
//   final Map<String, HighlightedWord> _highlights = {
//     'flutter': HighlightedWord(
//       onTap: () => print('flutter'),
//       textStyle: const TextStyle(
//         color: Colors.blue,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     'voice': HighlightedWord(
//       onTap: () => print('voice'),
//       textStyle: const TextStyle(
//         color: Colors.green,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     'subscribe': HighlightedWord(
//       onTap: () => print('subscribe'),
//       textStyle: const TextStyle(
//         color: Colors.red,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     'like': HighlightedWord(
//       onTap: () => print('like'),
//       textStyle: const TextStyle(
//         color: Colors.blueAccent,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//     'comment': HighlightedWord(
//       onTap: () => print('comment'),
//       textStyle: const TextStyle(
//         color: Colors.green,
//         fontWeight: FontWeight.bold,
//       ),
//     ),
//   };
//
//   late stt.SpeechToText _speech;
//   bool _isListening = false;
//   String _text = 'Press the button and start speaking ';
//   double _confidence = 1.0;
//
//   @override
//   void initState() {
//     super.initState();
//     _speech = stt.SpeechToText();
//   }
//   Color _TheColor = Colors.pink;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawer(),
//       appBar: AppBar(
//         // leading: ,
//
//         centerTitle: true,
//         actions: <Widget>[IconButton(onPressed: (){}, icon: Icon(Icons.nightlight_round_sharp,))
//         ,IconButton(onPressed: (){}, icon: Icon(Icons.color_lens_rounded,)),
//         ],
//
//         title: Text('Accuracy: ${(_confidence * 100.0).toStringAsFixed(1)}%',),
//
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: AvatarGlow(
//
//         animate: _isListening,
//         glowColor: Theme.of(context).primaryColor,
//         // glowBorderRadius: BorderRadius.circular(75.0),
//         duration: const Duration(milliseconds: 2000),
//         // startDelay: Duration(milliseconds: 2000),
//         // repeatPauseDuration: const Duration(milliseconds: 100),
//         repeat: true,
//         child: FloatingActionButton(
//           onPressed: _listen,
//           child: Icon(_isListening ? Icons.mic : Icons.mic_none),
//           backgroundColor: Color(_isListening ? 233333 : 666666),
//         ),
//       ),
//       body: SingleChildScrollView(
//         reverse: true,
//         child: Container(
//           padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
//           child: TextHighlight(
//             text: _text,
//             words: _highlights,
//             textStyle: const TextStyle(
//               fontSize: 32.0,
//               color: Colors.white,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // void _listen() async {
//   //   if (!_isListening) {
//   //     bool available = await _speech.initialize(
//   //       onStatus: (val) => print('onStatus: $val'),
//   //       onError: (val) => print('onError: $val'),
//   //     );
//   //     if (available) {
//   //       setState(() => _isListening = true);
//   //       _speech.listen(
//   //         onResult: (val) => setState(() {
//   //           if(_text == 'Press the button and start speaking '){
//   //             _text = " ";
//   //           }
//   //           _text += val.recognizedWords;
//   //           if (val.hasConfidenceRating && val.confidence > 0) {
//   //             _confidence = val.confidence;
//   //           }
//   //
//   //         }),
//   //       );
//   //     }
//   //   }
//   //   else {
//   //     setState(() => _isListening = false);
//   //     _speech.stop();
//   //     _listen;
//   //   }
//   // }
//   void _listen() async {
//     if (!_isListening) {
//       bool available = await _speech.initialize(
//         onStatus: (val) {
//           if (val == 'notListening') {
//             _startListening(); // Start listening again when status changes to notListening
//             _text+=" ";
//           }
//         },
//         // onError: (val) => print('onError: $val'),
//       );
//       if (available) {
//         setState(() => _isListening = true);
//         _startListening();
//       }
//     } else {
//       setState(() => _isListening = false);
//       _speech.stop();
//     }
//   }
//
//   void _startListening() {
//     _speech.listen(
//       onResult: (val) => setState(() {
//         if (_text == 'Press the button and start speaking ') {
//           _text = "";
//         }
//         var reco = val.recognizedWords;
//         // _translatedText += translateText(reco , 'en');
//         _text += reco;
//         if (val.hasConfidenceRating && val.confidence > 0) {
//           _confidence = val.confidence;
//         }
//       }),
//     );
//   }
//
// }
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';
import 'package:flutter_mute/flutter_mute.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData.dark(),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {

  // FlutterMute.mute();


  String translatedText='';
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;
  late GoogleTranslator _translator;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _translator = GoogleTranslator();
    // FlutterMute.mute();

  }

  Color _TheColor = Colors.pink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Accuracy: ${(_confidence * 100.0).toStringAsFixed(1)}%'),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.nightlight_round_sharp),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.color_lens_rounded),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        duration: const Duration(milliseconds: 2000),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          backgroundColor: Color(_isListening ? 233333 : 666666),
        ),
      ),
      body:   DefaultTabController(
        length: 20,
        child: TabBarView(children: [
        
        
            Column(children:[
          Expanded (child : Material(
          child: ListView.builder(itemCount:1,itemBuilder: (context, index) {
            return ListTile(
              // tileColor: index.isOdd ? Theme.of(context).colorScheme.primary.withOpacity(0.05) : Theme.of(context).colorScheme.primary.withOpacity(0.15),

              title: Text(_text),
            );
            // child:Text("y3m ${index+1}"),
          },),
            )),
            Expanded (child :Material(
            child: ListView.builder(itemCount:1,itemBuilder: (context, index) {
            return ListTile(
            tileColor: index.isOdd ? Theme.of(context).colorScheme.primary.withOpacity(0.05) : Theme.of(context).colorScheme.primary.withOpacity(0.15),
            title: Text(translatedText),
            );
            // child:Text("y3m ${index+1}"),
            },),
            ))
            ],),
            ],
        
            ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'notListening') {
            _startListening(); // Start listening again when status changes to notListening
            _text += " ";
          }
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _startListening();
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _startListening() {
    _speech.listen(
      onResult: (val) => setState(() async {
        if (_text == 'Press the button and start speaking') {
          _text = "";
        }
        var recognizedWords = val.recognizedWords;
        _text += recognizedWords;
        if (val.hasConfidenceRating && val.confidence > 0) {
          _confidence = val.confidence;
        }

        // Translate recognized text
        await _translateText(recognizedWords);
      }),
    );
  }

  Future<void> _translateText(String text) async {
    // Translate recognized text to English
    Translation translation = await _translator.translate(text, to: 'ar');
    translatedText += translation.text;

    // Update state with translated text
    setState(() {
      // _text += '$translatedText';
    });
  }
}
