import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    
    return Scaffold(
      appBar: AppBar(title: Text('Profil')),
      body: Center(
        child: FutureBuilder(
          future: _getUsername(supabase),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Terjadi kesalahan');
            } else {
              final username = snapshot.data ?? 'Pengguna';
              return Text(
                'Halo, $username',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              );
            }
          },
        ),
      ),
    );
  }

  Future<String?> _getUsername(SupabaseClient supabase) async {
    final user = supabase.auth.currentUser;
    if (user == null) return null;

    final response = await supabase
        .from('users')
        .select('username')
        .eq('id', user.id)
        .single();
    
    return response['username'] as String?;
  }
}
