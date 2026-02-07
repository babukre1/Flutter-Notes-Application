// import 'package:flutter/material.dart';

// void main() {
//   runApp(const NotesApp());
// }

// class NotesApp extends StatelessWidget {
//   const NotesApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         fontFamily: 'Inter', // Ensure Inter is added to pubspec.yaml
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color(0xFFE96A25),
//           primary: const Color(0xFFE96A25),
//         ),
//       ),
//       home: const NotesDashboard(),
//     );
//   }
// }

// class NotesDashboard extends StatelessWidget {
//   const NotesDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final List<NoteItem> notes = [
//       NoteItem("Project Ideas", "Explore new UI trends and dark mode interactions...", "OCT 24", true),
//       NoteItem("Grocery List", "Milk, eggs, organic bread, coffee beans, avocado...", "OCT 23", false),
//       NoteItem("Book Summary", "Key takeaways from 'Atomic Habits' and systems...", "OCT 20", true),
//       NoteItem("Travel List", "Visit Kyoto, Iceland glaciers, and Patagonia peaks...", "OCT 15", false),
//       NoteItem("Meeting Notes", "Discuss the upcoming Q4 roadmap and hiring plans...", "OCT 12", false),
//       NoteItem("Gym Routine", "Monday: Chest/Tri, Wednesday: Back/Bi, Friday: Legs...", "OCT 10", true),
//     ];

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         scrolledUnderElevation: 0,
//         title: const Text(
//           'Notes',
//           style: TextStyle(
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF111827),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.more_vert, color: Color(0xFF374151)),
//             onPressed: () {},
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Search Bar
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
//             child: Container(
//               height: 44,
//               decoration: BoxDecoration(
//                 color: const Color(0xFFF3F4F6),
//                 borderRadius: BorderRadius.circular(22),
//               ),
//               child: const TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Search',
//                   hintStyle: TextStyle(color: Color(0xFF6B7280)),
//                   prefixIcon: Icon(Icons.search, color: Color(0xFF6B7280), size: 20),
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.symmetric(vertical: 10),
//                 ),
//               ),
//             ),
//           ),
//           // Notes List
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               itemCount: notes.length,
//               itemBuilder: (context, index) {
//                 return NoteCard(note: notes[index]);
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {},
//         backgroundColor: const Color(0xFFE96A25),
//         shape: const CircleBorder(),
//         elevation: 4,
//         child: const Icon(Icons.add, color: Colors.white, size: 30),
//       ),
//       bottomNavigationBar: Container(
//         height: 80,
//         decoration: BoxDecoration(
//           border: Border(top: BorderSide(color: Colors.grey.shade100)),
//           color: Colors.white.withOpacity(0.95),
//         ),
//         child: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           selectedItemColor: const Color(0xFFE96A25),
//           unselectedItemColor: const Color(0xFF9CA3AF),
//           selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
//           unselectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
//           currentIndex: 0,
//           items: const [
//             BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Notes'),
//             BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
//             BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
//             BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class NoteCard extends StatelessWidget {
//   final NoteItem note;

//   const NoteCard({super.key, required this.note});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Colors.transparent),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   note.title,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF111827),
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//               if (note.isStarred)
//                 const Icon(Icons.star, color: Color(0xFFE96A25), size: 20),
//             ],
//           ),
//           const SizedBox(height: 2),
//           Text(
//             note.preview,
//             style: const TextStyle(
//               fontSize: 14,
//               color: Color(0xFF6B7280),
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(height: 4),
//           Text(
//             note.date,
//             style: const TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w500,
//               color: Color(0xFF9CA3AF),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class NoteItem {
//   final String title;
//   final String preview;
//   final String date;
//   final bool isStarred;

//   NoteItem(this.title, this.preview, this.date, this.isStarred);
// }