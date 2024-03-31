import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs/repository/auth_repository.dart';
import 'package:google_docs/widgets/loader.dart';
import 'package:routemaster/routemaster.dart';
import '../colors.dart';
import '../models/document_model.dart';
import '../repository/document_repository.dart';



class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

void signOut(WidgetRef ref) {
  ref.read(authRepositoryProvider).signOut();
  ref.read(userProvider.notifier).update((state) => null);
}

void createDocument(WidgetRef ref, BuildContext context) async{
 String token = ref.read(userProvider)!.token;
 final navigator = Routemaster.of(context);
 final snackbar = ScaffoldMessenger.of(context);
 final errorModel = await ref.read(documentRepositoryProvider).createDocument(token);

 if(errorModel.data != null){
  navigator.push('/document/${errorModel.data.id}');

 }else{
   snackbar.showSnackBar(
     SnackBar(
       content: Text(errorModel.error!),
     ),
   );
 }
}

void navigateToDocument(BuildContext context, String documentId) {
    Routemaster.of(context).push('/document/$documentId');
}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: (){
              createDocument(ref, context);
            },
            icon: const Icon(
              Icons.add,
              color: kBlackColor,
            ),
          ),
          IconButton(
            onPressed: () {
              signOut(ref);
            },
            icon: const Icon(
              Icons.logout,
              color: kRedColor,
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: ref.watch(documentRepositoryProvider).getDocuments(ref.watch(userProvider)!.token),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.data == null || snapshot.data!.data == null) {
            return Text('No data available');
          }
          return Center(
            child: Container(
              width: 600,
              margin: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                itemCount: snapshot.data!.data.length,
                itemBuilder: (context, index) {
                  DocumentModel document = snapshot.data!.data[index];

                  return InkWell(
                    onTap: () => {
                      navigateToDocument(context, document.id)
                    },
                    child: SizedBox(
                      height: 50,
                      child: Card(
                        child: Center(
                          child: Text(
                            document.title,
                            style: const TextStyle(
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      )

    );
  }
}