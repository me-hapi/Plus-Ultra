import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String accountType = 'Patient';

String testBG = 'bg1';

String globalName = '';

final client = Supabase.instance.client;

final uid = client.auth.currentUser!.id;

final token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI3ODRiMzQ3NC1jMjJhLTRmZGItYTJkYS03ODg3OWVlNjhhZDgiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTczMjk2NzU1MCwiZXhwIjoxNzQ4NTE5NTUwfQ.qPnbGJaff3HY4RE58iHUwC2LLTyiW3p1dEi9MW_Nixo";
