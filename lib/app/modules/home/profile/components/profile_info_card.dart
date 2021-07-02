import 'package:aluno_uepb/app/shared/models/models.dart';
import 'package:flutter/material.dart';

class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({
    Key? key,
    required this.profile,
  }) : super(key: key);

  final ProfileModel? profile;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(
              '${profile?.name ?? ''}',
              textAlign: TextAlign.center,
            ),
          ),
          Divider(height: 1.0),
          ListTile(
            title: Text('Matrícula'),
            trailing: Text('${profile?.register ?? ''}'),
          ),
          Divider(height: 1.0),
          ListTile(
            title: Text('C.R.A'),
            trailing: Text('${profile?.cra ?? ''}'),
          ),
          Divider(height: 1.0),
          ListTile(
            title: Text('C.H. Acumulada'),
            trailing: Text('${profile?.cumulativeCh ?? 0}'),
          ),
          Divider(height: 1.0),
          ListTile(
            title: Text('Curso'),
            trailing: Text('${profile?.program ?? ''}'),
          ),
        ],
      ),
    );
  }
}
