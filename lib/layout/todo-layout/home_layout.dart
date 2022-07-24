import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../shared/componants/componant.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class homeLayoutScreen extends StatelessWidget  {

  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();

  var timeController = TextEditingController();

  var dateController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..CreateDatabase(),
      child: BlocConsumer<AppCubit , CubitStates>(
        listener: (context,state) {
          if(state is AppInsertDatabaseState){
            Navigator.pop(context);
          }
        },
        builder: (context,state){

          AppCubit Cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(Cubit.appBarTitles[Cubit.currentIndex]),
            ),
            body:Cubit.Screens[Cubit.currentIndex],

            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(Cubit.isBottomSheetShown){
                  if(formKey.currentState!.validate()){

                    Cubit.insertIntoDatabase(title: titleController.text, date: dateController.text, time: timeController.text);

                    // insertIntoDatabase(
                    //     title: titleController.text,
                    //     date: dateController.text,
                    //     time: timeController.text
                    // ).then((value) {
                    //   Navigator.pop(context);
                    //   isBottomSheetShown = false;
                    //   // setState(() {
                    //   //   fabIcon = Icons.edit;
                    //   // });
                    // });
                  };

                }
                else {
                  scaffoldKey.currentState?.showBottomSheet(
                        (context) =>
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key :formKey ,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultTextFormField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (value){
                                    if(value!.isEmpty){
                                      return 'this field must not be empty';
                                    }
                                    return null ;
                                  },
                                  label: 'Task Text',
                                  prefix: Icons.title,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultTextFormField(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  validate: (value){
                                    if(value!.isEmpty){
                                      return 'this field must not be empty';
                                    }
                                    return null ;
                                  },
                                  label: 'Task time',
                                  prefix: Icons.watch_later_outlined,
                                  onTap: (){
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value){
                                      timeController.text = value!.format(context).toString() ;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                defaultTextFormField(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  validate: (value){
                                    if(value!.isEmpty){
                                      return 'this field must not be empty';
                                    }
                                    return null ;
                                  },
                                  label: 'Date time',
                                  prefix: Icons.calendar_today,
                                  onTap: (){
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2025),
                                    ).then((value) {
                                      dateController.text=DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                  ).closed.then((value) {
                    Cubit.changeBottomSheet(isShow: false, icon: Icons.edit);
                  });
                  Cubit.changeBottomSheet(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(Cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              unselectedItemColor: Colors.black,
              backgroundColor: Colors.blue,
              fixedColor: Colors.white,
              currentIndex: Cubit.currentIndex,
              onTap: (index){
                Cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.task),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }


}




