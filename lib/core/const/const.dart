import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// String accountType = 'Patient';

bool professional = false;

double userLat=0;
double userLong=0;

String testBG = 'bg1';

bool isConnected = false;

String globalName = '';

bool isAnonymous = true;

// File? profile ;

final client = Supabase.instance.client;

final uid = client.auth.currentUser!.id;
final currentUser = client.auth.currentUser;

bool postAssessment = false;

ui.Image? bgCons = null;

Map<String, dynamic> profileConst = {};

final token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiI3ODRiMzQ3NC1jMjJhLTRmZGItYTJkYS03ODg3OWVlNjhhZDgiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTczMjk2NzU1MCwiZXhwIjoxNzQ4NTE5NTUwfQ.qPnbGJaff3HY4RE58iHUwC2LLTyiW3p1dEi9MW_Nixo";
