import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseCredentials{
  static const String APIKEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJub3dsdXp6enh0emVlaXJ1ZGNqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDE3NzAxOTgsImV4cCI6MjAxNzM0NjE5OH0.NnkDsDd-gigpd-L7LhU7WuIEQc8o_f83zvq6Nnb2Yos";
  static const String APIURL = "https://rnowluzzzxtzeeirudcj.supabase.co";

  static SupabaseClient supabaseClient = SupabaseClient(APIURL, APIKEY);
}