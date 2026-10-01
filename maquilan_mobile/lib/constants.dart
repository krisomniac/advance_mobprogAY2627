import 'package:flutter_dotenv/flutter_dotenv.dart';

var host = dotenv.env['HOST'];

// Enhancement 3 (Lab Activity 3): dummyjson has no real auth, so we hardcode
// a demo user id to scope the cart to "one user" as the activity asks.
const int currentUserId = 1;