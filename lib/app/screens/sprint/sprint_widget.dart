import 'package:cad_sprint/app/screens/sprint/shared/models/sprint.dart';
import 'package:cad_sprint/app/screens/sprint/sprint_bloc.dart';
import 'package:cad_sprint/app/screens/sprint/sprint_module.dart';
import 'package:flutter/material.dart';

class SprintWidget extends StatelessWidget {
  late final SprintBloc _bloc = SprintModule.to.getBloc<SprintBloc>();
  void _inserirSprint() {

  }

  @override
  Widget build(BuildContext context) {
    _bloc.doFetch();

    return Scaffold(
      appBar: AppBar(
        title: Text('Sprints'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SprintCad()),
                );
              },
              icon: Icon(Icons.add),
          )
        ],
      ),
      body: StreamBuilder(
        stream: _bloc.sprints,
        builder: (_, AsyncSnapshot<List<Sprint>>snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                  final sprint = snapshot.data![index];
                  return ListTile(
                    title: Text(sprint.nome),
                    subtitle: Text(sprint.link),
                    trailing: Container(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              color: Colors.orange,
                              icon: Icon(Icons.edit)
                          ),
                          IconButton(
                              onPressed: () {
                                {
                                  showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('Deseja excluir esta Sprint?'),
                                        content: Text('Isso não poderá ser desfeito'),
                                        actions: [
                                          TextButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: Text('Não')
                                          ),
                                          TextButton(
                                              onPressed: () => Navigator.of(context).pop(true),
                                              child: Text('Sim')
                                          ),
                                        ],
                                      )
                                  ).then((confirmed) => {
                                    if(confirmed) {
                                      _bloc.doDelete(sprint.id).then(
                                              (_) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(content: Text('Apagado!'))
                                            );
                                            _bloc.doFetch();
                                          }).catchError(
                                              (_) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text('BipBup...Error, tente novamente!', style: TextStyle(color: Colors.red),)
                                                )
                                            );
                                          }
                                      )
                                    }
                                  });
                                }
                              },
                              color: Colors.red,
                              icon: Icon(Icons.delete)
                          )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => Divider(),
            );
          }
          return StreamBuilder(
            stream: _bloc.loading,
            builder: (_, AsyncSnapshot<bool> snapshot) {
              final loading = snapshot.data ?? false;
              if (loading) {
                return Center(child: CircularProgressIndicator());
              }
              return Container();
            },
          );
        },
      ),
    );
  }
}

class SprintCad extends StatelessWidget {
  late final SprintBloc _bloc = SprintModule.to.getBloc<SprintBloc>();

  var newPostName = TextEditingController();
  var newPostLink = TextEditingController();

  _textField({required String labelText, onChanged, required String Function() errorText}) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        errorText: errorText == null ? null : errorText(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de Sprint"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget> [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: newPostName,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Insira o nome da sprint',

                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: TextFormField(
                controller: newPostLink,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Insira o link da sprint',
                ),
              ),
            ),
            Center(
              child:
              Padding(

                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    _bloc.doPost(Sprint(nome: newPostName.text, link: newPostLink.text));
                    // print(newPostName.text);
                    // print(newPostLink.text);
                  },
                  child: Text('Cadastrar'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }
}