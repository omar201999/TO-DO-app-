
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../layout/todo-layout/cubit/cubit.dart';


Widget defualtBottun({
  double width = double.infinity,
  Color background = Colors.blue,
  double height = 50,
  Color textColor = Colors.white,
  required VoidCallback function,
  required String text,
}) => Container(
  width: width,
  color: background,
  height: height,
  child: MaterialButton(
    onPressed: function,
    child: Text(
      '$text',
      style: TextStyle(
        color: textColor,
        fontSize: 20,
      ),
    ) ,
  ),
);

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  void Function(String)? onSubmit,
  void Function(String)? onChange,
  void Function()? onTap ,
  void Function()? suffixPressed,
  bool isPassword = false ,
  required String? Function(String?)? validate ,
  required String label,
  required IconData prefix,
  IconData? suffix,
}) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8),
  child:   TextFormField(
    controller: controller,
    keyboardType: type,
    onFieldSubmitted: onSubmit,
    validator: validate,
    onTap: onTap,
    obscureText: isPassword,
    onChanged: onChange,

    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(),
      prefixIcon: Icon(prefix),
      suffixIcon: IconButton(
          onPressed: suffixPressed,
          icon: Icon(suffix)
      ),

    ),
  ),
);

Widget buildTaskItem(Map model,context)
=> Dismissible(
  key: Key(model['id'].toString()),
  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        CircleAvatar(

        radius: 40,

        child: Text(

        '${model['time']}',

        ),

        ),

        SizedBox(

        width: 20,

        ),

        Expanded(

          child: Column(

          mainAxisSize : MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

          Text(

          '${model['title']}',

          style: TextStyle(

          fontSize: 18,

          ),

          ),

          Text(

          '${model['data']}',

          style: TextStyle(

          fontSize: 16,

          color: Colors.grey

          ),

          ),

          ],

          ),

        ),

        SizedBox(

          width: 20,

        ),

        IconButton(

            onPressed: (){

              AppCubit.get(context).updateData(status: 'done', id: model['id']);

            },

            icon: Icon(

              Icons.done,

            ),

          color: Colors.green,



        ),

        IconButton(

          onPressed: (){

            AppCubit.get(context).updateData(status: 'archived', id: model['id']);

          },

          icon: Icon(

            Icons.archive,

          ),

          color: Colors.black54,



        )

    ],

    ),

  ),
  onDismissed: (direction){
    AppCubit.get(context).deleteData(id: model['id']);
  },
);

Widget taskBuilder ({required List <Map> tasks}) => ConditionalBuilder(
  condition: tasks.length > 0 ,
  builder: (context) => ListView.separated(
    itemBuilder:(context,index)=> buildTaskItem(tasks[index],context),
    separatorBuilder: (context,index) => MyDivider (),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
        ),
        Text(
            'No Tasks Yet , Please Add Some Tasks'
        ),
      ],
    ),
  ),);




Widget MyDivider () => Container(
  height: 1,
  width: double.infinity,
  color: Colors.grey[300],
);



void navigateTo (context , widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
        builder: (context) => widget  ,
    ),(route){
      return false;
}
);

void navigateToAndReplace (context , widget) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget  ,
    ),
);
