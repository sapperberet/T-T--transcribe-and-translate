import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:transcriber/Info.dart';
import 'package:translator/translator.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //await dotenv.load(fileName: ".env");
  MobileAds.instance.initialize();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Flutter Voice',
          debugShowCheckedModeBanner: false,
          theme: themeProvider.getTheme(),
          home: SpeechScreen(),
        );
      },
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  void _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  String translatedText = '';
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;
  late GoogleTranslator _translator;
  String _selectedTranscribedLanguage = 'en';
  String _selectedTranslatedLanguage = 'ar';
  TextEditingController _searchController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _flutterTts = FlutterTts();
  bool _showAccuracy = false;



  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English'},
    {'code': 'zh', 'name': 'Chinese'},
    {'code': 'es', 'name': 'Spanish'},
    {'code': 'ar', 'name': 'Arabic'},
    {'code': 'fr', 'name': 'French'},
    {'code': 'de', 'name': 'German'},
    {'code': 'ja', 'name': 'Japanese'},
    {'code': 'ru', 'name': 'Russian'},
    {'code': 'pt', 'name': 'Portuguese'},
    {'code': 'hi', 'name': 'Hindi'},
    {'code': 'bn', 'name': 'Bengali'},
    {'code': 'pa', 'name': 'Punjabi'},
    {'code': 'jv', 'name': 'Javanese'},
    {'code': 'ko', 'name': 'Korean'},
    {'code': 'vi', 'name': 'Vietnamese'},
    {'code': 'te', 'name': 'Telugu'},
    {'code': 'mr', 'name': 'Marathi'},
    {'code': 'ta', 'name': 'Tamil'},
    {'code': 'ur', 'name': 'Urdu'},
    {'code': 'tr', 'name': 'Turkish'},
    {'code': 'fa', 'name': 'Persian'},
    {'code': 'it', 'name': 'Italian'},
    {'code': 'th', 'name': 'Thai'},
    {'code': 'gu', 'name': 'Gujarati'},
    {'code': 'kn', 'name': 'Kannada'},
    {'code': 'ml', 'name': 'Malayalam'},
    {'code': 'or', 'name': 'Odia'},
    {'code': 'as', 'name': 'Assamese'},
    {'code': 'si', 'name': 'Sinhala'},
    {'code': 'my', 'name': 'Burmese'},
    {'code': 'km', 'name': 'Khmer'},
    {'code': 'lo', 'name': 'Lao'},
    {'code': 'am', 'name': 'Amharic'},
    {'code': 'sw', 'name': 'Swahili'},
    {'code': 'yo', 'name': 'Yoruba'},
    {'code': 'ig', 'name': 'Igbo'},
    {'code': 'ha', 'name': 'Hausa'},
    {'code': 'zu', 'name': 'Zulu'},
    {'code': 'xh', 'name': 'Xhosa'},
    {'code': 'af', 'name': 'Afrikaans'},
    {'code': 'st', 'name': 'Sesotho'},
    {'code': 'tn', 'name': 'Setswana'},
    {'code': 'ts', 'name': 'Xitsonga'},
    {'code': 've', 'name': 'Tshivenda'},
    {'code': 'nr', 'name': 'Ndebele'},
    {'code': 'ss', 'name': 'Swati'},
    {'code': 'ny', 'name': 'Chichewa'},
    {'code': 'rw', 'name': 'Kinyarwanda'},
    {'code': 'ln', 'name': 'Lingala'},
    {'code': 'kg', 'name': 'Kongo'},
    {'code': 'sn', 'name': 'Shona'},
    {'code': 'om', 'name': 'Oromo'},
    {'code': 'so', 'name': 'Somali'},
    {'code': 'ti', 'name': 'Tigrinya'},
    {'code': 'aa', 'name': 'Afar'},
    {'code': 'ab', 'name': 'Abkhazian'},
    {'code': 'ae', 'name': 'Avestan'},
    {'code': 'ak', 'name': 'Akan'},
    {'code': 'an', 'name': 'Aragonese'},
    {'code': 'av', 'name': 'Avaric'},
    {'code': 'ay', 'name': 'Aymara'},
    {'code': 'az', 'name': 'Azerbaijani'},
    {'code': 'ba', 'name': 'Bashkir'},
    {'code': 'be', 'name': 'Belarusian'},
    {'code': 'bg', 'name': 'Bulgarian'},
    {'code': 'bi', 'name': 'Bislama'},
    {'code': 'bm', 'name': 'Bambara'},
    {'code': 'bo', 'name': 'Tibetan'},
    {'code': 'br', 'name': 'Breton'},
    {'code': 'bs', 'name': 'Bosnian'},
    {'code': 'ca', 'name': 'Catalan'},
    {'code': 'ce', 'name': 'Chechen'},
    {'code': 'ch', 'name': 'Chamorro'},
    {'code': 'co', 'name': 'Corsican'},
    {'code': 'cr', 'name': 'Cree'},
    {'code': 'cs', 'name': 'Czech'},
    {'code': 'cv', 'name': 'Chuvash'},
    {'code': 'cy', 'name': 'Welsh'},
    {'code': 'da', 'name': 'Danish'},
    {'code': 'dv', 'name': 'Divehi'},
    {'code': 'dz', 'name': 'Dzongkha'},
    {'code': 'ee', 'name': 'Ewe'},
    {'code': 'el', 'name': 'Greek'},
    {'code': 'eo', 'name': 'Esperanto'},
    {'code': 'et', 'name': 'Estonian'},
    {'code': 'eu', 'name': 'Basque'},
    {'code': 'ff', 'name': 'Fulah'},
    {'code': 'fi', 'name': 'Finnish'},
    {'code': 'fj', 'name': 'Fijian'},
    {'code': 'fo', 'name': 'Faroese'},
    {'code': 'fy', 'name': 'Western Frisian'},
    {'code': 'ga', 'name': 'Irish'},
    {'code': 'gd', 'name': 'Gaelic'},
    {'code': 'gl', 'name': 'Galician'},
    {'code': 'gn', 'name': 'Guarani'},
    {'code': 'gv', 'name': 'Manx'},
    {'code': 'he', 'name': 'Hebrew'},
    {'code': 'ho', 'name': 'Hiri Motu'},
    {'code': 'ht', 'name': 'Haitian'},
    {'code': 'hu', 'name': 'Hungarian'},
    {'code': 'hy', 'name': 'Armenian'},
    {'code': 'ia', 'name': 'Interlingua'},
    {'code': 'id', 'name': 'Indonesian'},
    {'code': 'ie', 'name': 'Interlingue'},
    {'code': 'ik', 'name': 'Inupiaq'},
    {'code': 'io', 'name': 'Ido'},
    {'code': 'is', 'name': 'Icelandic'},
    {'code': 'iu', 'name': 'Inuktitut'},
    {'code': 'ka', 'name': 'Georgian'},
    {'code': 'ki', 'name': 'Kikuyu'},
    {'code': 'kk', 'name': 'Kazakh'},
    {'code': 'kl', 'name': 'Kalaallisut'},
    {'code': 'kr', 'name': 'Kanuri'},
    {'code': 'ks', 'name': 'Kashmiri'},
    {'code': 'ku', 'name': 'Kurdish'},
    {'code': 'kv', 'name': 'Komi'},
    {'code': 'kw', 'name': 'Cornish'},
    {'code': 'ky', 'name': 'Kirghiz'},
    {'code': 'la', 'name': 'Latin'},
    {'code': 'lb', 'name': 'Luxembourgish'},
    {'code': 'lg', 'name': 'Ganda'},
    {'code': 'li', 'name': 'Limburgan'},
    {'code': 'lt', 'name': 'Lithuanian'},
    {'code': 'lu', 'name': 'Luba-Katanga'},
    {'code': 'lv', 'name': 'Latvian'},
    {'code': 'mg', 'name': 'Malagasy'},
    {'code': 'mh', 'name': 'Marshallese'},
    {'code': 'mi', 'name': 'Maori'},
    {'code': 'mk', 'name': 'Macedonian'},
    {'code': 'mn', 'name': 'Mongolian'},
    {'code': 'mo', 'name': 'Moldavian'},
    {'code': 'mt', 'name': 'Maltese'},
    {'code': 'na', 'name': 'Nauru'},
    {'code': 'nd', 'name': 'North Ndebele'},
    {'code': 'ne', 'name': 'Nepali'},
    {'code': 'ng', 'name': 'Ndonga'},
    {'code': 'nl', 'name': 'Dutch'},
    {'code': 'no', 'name': 'Norwegian'},
    {'code': 'nv', 'name': 'Navajo'},
    {'code': 'oc', 'name': 'Occitan'},
    {'code': 'oj', 'name': 'Ojibwa'},
    {'code': 'os', 'name': 'Ossetian'},
    {'code': 'pi', 'name': 'Pali'},
    {'code': 'pl', 'name': 'Polish'},
    {'code': 'ps', 'name': 'Pashto'},
    {'code': 'qu', 'name': 'Quechua'},
    {'code': 'rm', 'name': 'Romansh'},
    {'code': 'rn', 'name': 'Rundi'},
    {'code': 'ro', 'name': 'Romanian'},
    {'code': 'sa', 'name': 'Sanskrit'},
    {'code': 'sc', 'name': 'Sardinian'},
    {'code': 'sd', 'name': 'Sindhi'},
    {'code': 'se', 'name': 'Northern Sami'},
    {'code': 'sg', 'name': 'Sango'},
    {'code': 'sh', 'name': 'Serbo-Croatian'},
    {'code': 'sk', 'name': 'Slovak'},
    {'code': 'sl', 'name': 'Slovenian'},
    {'code': 'sm', 'name': 'Samoan'},
    {'code': 'sq', 'name': 'Albanian'},
    {'code': 'sr', 'name': 'Serbian'},
    {'code': 'ss', 'name': 'Swati'},
    {'code': 'st', 'name': 'Southern Sotho'},
    {'code': 'su', 'name': 'Sundanese'},
    {'code': 'sv', 'name': 'Swedish'},
    {'code': 'ta', 'name': 'Tamil'},
    {'code': 'te', 'name': 'Telugu'},
    {'code': 'tg', 'name': 'Tajik'},
    {'code': 'th', 'name': 'Thai'},
    {'code': 'tk', 'name': 'Turkmen'},
    {'code': 'tl', 'name': 'Tagalog'},
    {'code': 'tn', 'name': 'Tswana'},
    {'code': 'to', 'name': 'Tonga'},
    {'code': 'tr', 'name': 'Turkish'},
    {'code': 'ts', 'name': 'Tsonga'},
    {'code': 'tt', 'name': 'Tatar'},
    {'code': 'tw', 'name': 'Twi'},
    {'code': 'ug', 'name': 'Uighur'},
    {'code': 'uk', 'name': 'Ukrainian'},
    {'code': 'ur', 'name': 'Urdu'},
    {'code': 'uz', 'name': 'Uzbek'},
    {'code': 've', 'name': 'Venda'},
    {'code': 'vi', 'name': 'Vietnamese'},
    {'code': 'vo', 'name': 'Volapük'},
    {'code': 'wa', 'name': 'Walloon'},
    {'code': 'wo', 'name': 'Wolof'},
    {'code': 'xh', 'name': 'Xhosa'},
    {'code': 'yi', 'name': 'Yiddish'},
    {'code': 'yo', 'name': 'Yoruba'},
    {'code': 'za', 'name': 'Zhuang'},
    {'code': 'zu', 'name': 'Zulu'},
  ];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _translator = GoogleTranslator();

    _bannerAd = BannerAd(
      adUnitId: '<YOUR_BANNER_AD_UNIT_ID>',
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad failed to load: $error');
        },
      ),
    );

    _bannerAd.load();
  }


  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Center(
                child: Text(
                  'Options',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                _openSettingsDialog();
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Info'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InfoPage()),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Donate'),
              onTap: () {
                _launchUrl('https://www.paypal.com/paypalme/sapperberet');
              },
            ),
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return ListTile(
                  leading: Icon(
                      themeProvider.getTheme() == ThemeData.dark() ? Icons
                          .brightness_3 : Icons.brightness_6),
                  title: Text(themeProvider.getTheme() == ThemeData.dark()
                      ? 'Dark Theme'
                      : 'Light Theme'),
                  onTap: () {
                    themeProvider.toggleTheme();
                  },
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: _showAccuracy ? Text(
            'Accuracy: ${(_confidence * 100.0).toStringAsFixed(1)}%') : null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildLanguageDropdown(
                _selectedTranscribedLanguage, (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedTranscribedLanguage = newValue;
                });
              }
            }, 'From'),
            AvatarGlow(
              animate: _isListening,
              glowColor: Theme
                  .of(context)
                  .primaryColor,
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              child: FloatingActionButton(
                onPressed: _listen,
                child: Icon(_isListening ? Icons.stop : Icons.mic_none),
                backgroundColor: _isListening ? Colors.red : Colors.blue,
              ),
            ),
            _buildLanguageDropdown(
                _selectedTranslatedLanguage, (String? newValue) {
              if (newValue != null) {
                _showAdAndSelectLanguage(newValue);
              }
            }, 'To'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_isBannerAdReady)
            Container(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: TabBarView(
                children: [
                  Column(
                    children: [
                      Expanded(
                        child: Material(
                          child: ListView.builder(
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_text),
                                trailing: IconButton(
                                  icon: Icon(Icons.volume_up),
                                  onPressed: _text.isNotEmpty ? () => _speak(_text) : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Material(
                          child: ListView.builder(
                            itemCount: 1,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(translatedText),
                                trailing: IconButton(
                                  icon: Icon(Icons.volume_up),
                                  onPressed: translatedText.isNotEmpty ? () => _speak(translatedText) : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildLanguageDropdown(String selectedLanguage,
      ValueChanged<String?> onChanged, String label) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.white)),
        DropdownButton<String>(
          value: selectedLanguage,
          icon: Icon(Icons.arrow_drop_down, color: Colors.white),
          dropdownColor: Colors.red,
          onChanged: onChanged,
          items: _languages.map<DropdownMenuItem<String>>((
              Map<String, String> language) {
            return DropdownMenuItem<String>(
              value: language['code'],
              child: Text(language['name']!),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showAdAndSelectLanguage(String language) {
    if (language == 'ru') {
      // Show ad here
      InterstitialAd.load(
        adUnitId: '<YOUR_INTERSTITIAL_AD_UNIT_ID>',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            ad.show();
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (InterstitialAd ad) {
                ad.dispose();
                setState(() {
                  _selectedTranslatedLanguage = language;
                });
              },
              onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                ad.dispose();
                setState(() {
                  _selectedTranslatedLanguage = language;
                });
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('Interstitial ad failed to load: $error');
            setState(() {
              _selectedTranslatedLanguage = language;
            });
          },
        ),
      );
    } else {
      setState(() {
        _selectedTranslatedLanguage = language;
      });
    }
  }
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          if (val == 'notListening') {
            setState(() => _isListening = false);
            _playSound('assets/mic_off.mp3');
          }
        },
      );
      if (available) {
        setState(() => _isListening = true);
        _playSound('assets/mic_off.mp3');
        _startListening();
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      _playSound('assets/mic_off.mp3');
    }
  }

  void _startListening() {
    _speech.listen(
      localeId: _selectedTranscribedLanguage,
      onResult: (val) =>
          setState(() async {
            if (_text == 'Press the button and start speaking') {
              _text = "";
            }
            var recognizedWords = val.recognizedWords;
            _text = recognizedWords;
            await _translateText(recognizedWords);
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
    );
  }

  Future<void> _translateText(String text) async {
    Translation translation = await _translator.translate(
        text, to: _selectedTranslatedLanguage);
    setState(() {
      translatedText = translation.text;
    });
  }

  void _playSound(String path) async {
    await _audioPlayer.play(AssetSource(path));
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  void _openSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Settings'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SwitchListTile(
                title: Text('Show Accuracy'),
                value: _showAccuracy,
                onChanged: (bool value) {
                  setState(() {
                    _showAccuracy = value;
                  });
                  // Update the main state
                  this.setState(() {});
                },
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider() : _themeData = ThemeData.dark();

  getTheme() => _themeData;

  toggleTheme() {
    if (_themeData == ThemeData.dark()) {
      _themeData = ThemeData.light();
    } else {
      _themeData = ThemeData.dark();
    }
    notifyListeners();
  }
}