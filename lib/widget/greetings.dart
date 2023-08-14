import 'dart:math';

String getGreetings() {
  List<String> greetings = [
    'Im so proud of you!'
        'Thanks for all your hard work.'
        'You are amazing!'
  ];
  var randomIndex = new Random().nextInt(greetings.length);
  return greetings[randomIndex];
}
