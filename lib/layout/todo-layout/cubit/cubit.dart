import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/layout/todo-layout/cubit/states.dart';

import '../../../modules/todo_app/archive.dart';
import '../../../modules/todo_app/done.dart';
import '../../../modules/todo_app/tasks.dart';


class AppCubit extends Cubit<CubitStates>{
  int currentIndex = 0;

  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
  List<String> appBarTitles =
  [
    'Tasks',
    'Done',
    'Archives'
  ];

  List <Widget> Screens =
  [
    task(),
    done(),
    archive(),
  ];

  late Database database ;

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void changeIndex(int index){
    currentIndex = index ;
    emit(AppChangeBottomNavBarState());
  }

  void CreateDatabase() async {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database , version){
        database.execute('CREATE TABLE marketing (id INTEGER PRIMARY KEY, title TEXT , data TEXT , time TEXT , status TEXT)').then((value){
          print('table is created') ;
        }).catchError((error){
          print('error when create table ${error.toString()}');
        });
      },
      onOpen: (database){
        getDataFromDatabase(database);
        print('database opened');
      },
    ).then((value){
      database = value ;
      emit(AppCreateDatabaseState());
    });
  }

  insertIntoDatabase({
    required String title,
    required String date,
    required String time,
    //required String status,
  }) async {
    await database.transaction((txn) {
      return txn.rawInsert(
          'INSERT INTO marketing (title , data , time , status) VALUES ("$title","$date","$time","new")')
          .then((value) {
        print('$value insert successfully');
        emit(AppInsertDatabaseState());

        getDataFromDatabase(database);

      }).catchError((error) {
        print('some error is happend ${error.toString()}');
      });
    },

    );
  }

  void getDataFromDatabase (database)  {

    newTasks=[];
    doneTasks=[];
    archivedTasks=[];

    database.rawQuery('SELECT * FROM marketing').then((value){

      value.forEach((element) {
        if(element['status'] == 'new'){
          newTasks.add(element);
        }
        else if(element['status'] == 'done'){
          doneTasks.add(element);
        }
        else{
          archivedTasks.add(element);
        }
      });

      emit(AppGetDatabaseState());
    });
  }


  void updateData({
    required String status,
    required int id,
  }){
    database.rawUpdate(
      'UPDATE marketing SET status = ? WHERE id = ?',
      ['$status' , id]
    ).then((value) {
      emit(AppUpdateDatabaseState());
      getDataFromDatabase(database);
    });
  }

  void deleteData({
    required int id,
  }){
    database.rawDelete(
        'DELETE FROM marketing WHERE id = ?',
        [id]
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDatabaseState());

    });
  }



  bool isBottomSheetShown = false;

  IconData fabIcon = Icons.edit;

  void changeBottomSheet({
  required bool isShow,
    required IconData icon,
}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  bool isDark = false ;



}