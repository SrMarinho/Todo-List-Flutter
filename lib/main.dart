import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repositories/todo_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Todo List",
      debugShowCheckedModeBanner: false,
      home: TodoApp(),
    );
  }
}

class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  int? selectedTask;

  int numTasks = 0;

  int selectedAddHour = 0;
  int selectedAddMinute = 0;

  final TextEditingController currentTaskTitle = TextEditingController();
  final TextEditingController currentTaskDescription = TextEditingController();

  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todo_list = [];

  DateTime currentDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  List<String> mounths_pt = [
    "Janeiro",
    "Fevereiro",
    "Março",
    "Abril",
    "Maio",
    "Junho",
    "Julho",
    "Agosto",
    "Setembro",
    "Outubro",
    "Novembro",
    "Dezembro"
  ];

  List<String> days_short_pt = [
    "Dom",
    "Seg",
    "Ter",
    "Qua",
    "Qui",
    "Sex",
    "Sáb"
  ];

  void sortTasks() {
    todo_list.sort(
      (a, b) {
        DateTime dt1 = DateTime.parse(a.dateTime.toString());
        DateTime dt2 = DateTime.parse(b.dateTime.toString());
        return dt1.compareTo(dt2);
      },
    );
    todoRepository.saveTodoList(todo_list);
  }

  @override
  void initState(){
    super.initState();

    todoRepository.getTodoList().then((value) {
      setState(() {
        todo_list = value;
      });
    });
  }

  //purple_color = Color(0xff610bd9)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff202020),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Hoje",
                    style: TextStyle(
                        fontSize: 40,
                        color: Color(0xffD0F222),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 10),
                  ),
                  Text(
                    "${DateTime.now().day} de ${mounths_pt[DateTime.now().month - 1]} de ${DateTime.now().year}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xffE2E2E2),
                      fontWeight: FontWeight.normal,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                width: double.maxFinite,
                height: 66,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (int day = -1; day < 20; day++)
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                (DateTime.now().day + day == currentDay.day)
                                    ? const Color(0xff610bd9)
                                    : const Color(0xffE2E2E2),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(
                                  color: (DateTime.now().day + day ==
                                          currentDay.day)
                                      ? const Color(0xffE2E2E2)
                                      : const Color(0xffE2E2E2),
                                  width: (DateTime.now().day + day ==
                                          currentDay.day)
                                      ? 2
                                      : 0),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              currentDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + day);
                            });
                          },
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  days_short_pt[DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day + day + 1)
                                          .weekday -
                                      1],
                                  style: TextStyle(
                                      color: ((DateTime.now().day + day) ==
                                              currentDay.day)
                                          ? const Color(0xffE2E2E2)
                                          : const Color(0xff202020)),
                                ),
                                Text(
                                  (DateTime(
                                              DateTime.now().year,
                                              DateTime.now().month,
                                              DateTime.now().day + day)
                                          .day)
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: ((DateTime.now().day + day) ==
                                            currentDay.day)
                                        ? const Color(0xffE2E2E2)
                                        : const Color(0xff202020),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5.0)),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    for (int i = 0; i < todo_list.length; i++)
                      if(DateFormat("dd/MM/yyyy").format(currentDay) == DateFormat("dd/MM/yyyy").format(todo_list[i].dateTime))
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                selectedTask != null && selectedTask == i
                                    ? const Color(0xff610bd9)
                                    : const Color(0xffE2E2E2),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedTask = i;
                            });
                          },
                          child: SizedBox(
                            height: 100,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  todo_list[i].title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: selectedTask != null &&
                                              selectedTask == i
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                Text(
                                  (DateFormat.Hm().format(todo_list[i].dateTime)),
                                  style: TextStyle(
                                      color: selectedTask != null &&
                                              selectedTask == i
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      todo_list[i].description,
                                      style: TextStyle(
                                          color: selectedTask != null &&
                                                  selectedTask == i
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                    selectedTask != null && selectedTask == i
                                        ? SizedBox(
                                            height: 30,
                                            width: 30,
                                            child: RawMaterialButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return Dialog(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(20.0),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            const Text(
                                                              "Deseja exluir essa tarefa?",
                                                              style: TextStyle(
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 20,
                                                            ),
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      todo_list.removeAt(i);
                                                                      todoRepository.saveTodoList(todo_list);
                                                                    });
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        const Color(
                                                                            0xff610bd9),
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    "Sim",
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                  child:
                                                                      const Text(
                                                                    "Não",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              elevation: 2.0,
                                              fillColor: Colors.white,
                                              shape: const CircleBorder(),
                                              child: const Icon(
                                                Icons.delete,
                                                size: 20.0,
                                                color: Colors.black,
                                              ),
                                            ),
                                          )
                                        : const Text("")
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            RawMaterialButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return Dialog(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppBar(
                                    title: const Text("Criar nova tarefa."),
                                    backgroundColor: const Color(0xff610bd9),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5.0),
                                        topRight: Radius.circular(5.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: TextField(
                                      autofocus: false,
                                      controller: currentTaskTitle,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        labelText: "Título",
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff610bd9),
                                          ),
                                        ),
                                        labelStyle: const TextStyle(
                                          color: Color(0xff610bd9),
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: TextField(
                                      autofocus: false,
                                      controller: currentTaskDescription,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0)),
                                        labelText: "Descrição",
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xff610bd9),
                                          ),
                                        ),
                                        labelStyle: const TextStyle(
                                          color: Color(0xff610bd9),
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        height: 250,
                                        child: ListView(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: false,
                                          children: [
                                            for (int j = 0; j < 24; j++)
                                              ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    selectedAddHour = j;
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      selectedAddHour == j
                                                          ? const Color(
                                                              0xff610bd9)
                                                          : Colors.white,
                                                  shadowColor:
                                                      Colors.transparent,
                                                  foregroundColor: Colors.black,
                                                ),
                                                child: Text(
                                                  j.toString().padLeft(2, '0'),
                                                  style: TextStyle(
                                                    fontSize: 50,
                                                    color: selectedAddHour == j
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                      const Text(
                                        ":",
                                        style: TextStyle(fontSize: 100),
                                      ),
                                      SizedBox(
                                        width: 90,
                                        height: 250,
                                        child: ListView(
                                          scrollDirection: Axis.vertical,
                                          shrinkWrap: false,
                                          children: [
                                            for (int j = 0; j < 60; j++)
                                              ElevatedButton(
                                                onPressed: () {
                                                  setState(() {
                                                    selectedAddMinute = j;
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      selectedAddMinute == j
                                                          ? const Color(
                                                              0xff610bd9)
                                                          : Colors.white,
                                                  shadowColor:
                                                      Colors.transparent,
                                                  foregroundColor: Colors.black,
                                                ),
                                                child: Text(
                                                  j.toString().padLeft(2, '0'),
                                                  style: TextStyle(
                                                    fontSize: 50,
                                                    color:
                                                        selectedAddMinute == j
                                                            ? Colors.white
                                                            : Colors.black,
                                                  ),
                                                ),
                                              )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(
                                            () {
                                              if (currentTaskTitle.text != "") {
                                                Todo newTodo = Todo(
                                                  title: currentTaskTitle.text,
                                                  dateTime: DateTime.parse(
                                                      "${currentDay.year}-${(currentDay.month).toString().padLeft(2, "0")}-${(currentDay.day).toString().padLeft(2, "0")} ${selectedAddHour.toString().padLeft(2, "0")}:${selectedAddMinute.toString().padLeft(2, "0")}:00"),
                                                  description:
                                                      currentTaskDescription
                                                          .text,
                                                );

                                                todo_list.add(newTodo);

                                                todoRepository.saveTodoList(todo_list);

                                                Navigator.pop(context);
                                                numTasks++;
                                              }
                                            },
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xff610bd9),
                                          foregroundColor: Colors.black,
                                        ),
                                        child: const Text(
                                          "Salvar",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black,
                                        ),
                                        child: const Text(
                                          "Cancelar",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).then(
                  (_) => setState(() {
                    selectedAddHour = 0;
                    selectedAddMinute = 0;
                    currentTaskTitle.clear();
                    currentTaskDescription.clear();
                    sortTasks();
                    print(currentDay);
                  }),
                );
              },
              elevation: 2.0,
              fillColor: const Color(0xffD0F222),
              padding: const EdgeInsets.all(10.0),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add,
                size: 35.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
