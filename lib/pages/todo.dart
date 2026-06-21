import 'package:basic_2/pages/tododata.dart';
import 'package:flutter/material.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final searchtodo = TextEditingController();
  final addtodo = TextEditingController();
  void addNewTodo(String title) {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      return;
    }

    todoList.add(Todolist(title: trimmedTitle, isCompleted: false));
  }

  List<Todolist> get filteredTodoList {
    final query = searchtodo.text.trim().toLowerCase();
    if (query.isEmpty) {
      return todoList;
    }

    return todoList
        .where((todo) => todo.title.toLowerCase().contains(query))
        .toList();
  }
  @override
  Widget build(BuildContext context) {
    final visibleTodos = filteredTodoList;
    final totaltodos = visibleTodos.length;
    final completedCount = todoList.where((todo) => todo.isCompleted).length;
    final pendingCount = todoList.length - completedCount;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 13, 13, 13),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "My Todos",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // stats
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7A5CFF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Total"),
                          Text(
                            "$totaltodos",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF2DD4BF), Color(0xFF0F766E)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Done"),
                          Text(
                            "$completedCount",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFFFB347), Color(0xFFB45309)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("pending"),
                          Text(
                            "$pendingCount",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              // search bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 25, 25, 25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextField(
                  controller: searchtodo,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    prefixIconConstraints: BoxConstraints(minWidth: 40),
                    suffixIcon: searchtodo.text.isEmpty
                        ? null
                        : IconButton(
                            icon: Icon(
                              Icons.clear_rounded,
                              color: Colors.white.withValues(alpha: 0.65),
                            ),
                            onPressed: () {
                              setState(() {
                                searchtodo.clear();
                              });
                            },
                          ),
                    hintText: "Search Todos",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              SizedBox(height: 20),
              // todo list
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 25, 25, 25),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView.builder(
                    itemCount: visibleTodos.length,
                    itemBuilder: (context, index) {
                      final todo = visibleTodos[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 40, 40, 40),
                          ),
                          child: ListTile(
                            title: Text("${todo.title}"),
                            leading: InkWell(
                              onTap: () {
                                setState(() {
                                  todo.isCompleted = !todo.isCompleted;
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                child: todo.isCompleted
                                    ? Icon(Icons.check)
                                    : Icon(Icons.radio_button_unchecked),
                              ),
                            ),
                            trailing: InkWell(
                              onTap: () {
                                setState(() {
                                  todoList.remove(todo);
                                });
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.red,
                                ),
                                child: Icon(Icons.delete, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: 20),
              // add todo
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 25, 25, 25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: addtodo,
                        decoration: InputDecoration(
                          hintText: "Add Todos",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 33, 154, 138),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        addNewTodo(addtodo.text);
                        addtodo.clear();
                        setState(() {});
                      },
                      child: Text("Add Todo"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
