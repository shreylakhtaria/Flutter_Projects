import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class GradeEntry {
  int id;
  String courseCode;
  String assessmentType;
  double maxMarks;
  double? obtainedMarks;
  DateTime date;
  String remarks;
  String term;
  DateTime? reevalDeadline;
  GradeEntry({
    required this.id,
    required this.courseCode,
    required this.assessmentType,
    required this.maxMarks,
    this.obtainedMarks,
    required this.date,
    required this.remarks,
    required this.term,
    this.reevalDeadline,
  });
}

class GradeStore extends ChangeNotifier {
  final List<GradeEntry> _entries = [];
  int _nextId = 1;
  List<GradeEntry> get entries => List.unmodifiable(_entries);
  GradeEntry addEntry({
    required String courseCode,
    required String assessmentType,
    required double maxMarks,
    double? obtainedMarks,
    required DateTime date,
    required String remarks,
    required String term,
    DateTime? reevalDeadline,
  }) {
    final e = GradeEntry(
      id: _nextId++,
      courseCode: courseCode,
      assessmentType: assessmentType,
      maxMarks: maxMarks,
      obtainedMarks: obtainedMarks,
      date: date,
      remarks: remarks,
      term: term,
      reevalDeadline: reevalDeadline,
    );
    _entries.add(e);
    notifyListeners();
    return e;
  }
  void updateEntry(GradeEntry updated) {
    final idx = _entries.indexWhere((x) => x.id == updated.id);
    if (idx != -1) {
      _entries[idx] = updated;
      notifyListeners();
    }
  }
  void removeEntry(int id) {
    _entries.removeWhere((x) => x.id == id);
    notifyListeners();
  }
  List<GradeEntry> recentEntries([int limit = 5]) {
    final list = [..._entries];
    list.sort((a, b) => b.date.compareTo(a.date));
    return list.take(limit).toList();
  }
  double _gradePoint(GradeEntry e) {
    if (e.obtainedMarks == null) return 0;
    final pct = e.maxMarks <= 0 ? 0 : (e.obtainedMarks! / e.maxMarks) * 100;
    if (pct >= 90) return 10;
    if (pct >= 80) return 9;
    if (pct >= 70) return 8;
    if (pct >= 60) return 7;
    if (pct >= 50) return 6;
    if (pct >= 40) return 5;
    return 0;
  }
  double computeGPA({String? term}) {
    final list = term == null ? _entries : _entries.where((e) => e.term == term).toList();
    final finals = list.where((e) => e.assessmentType == 'Final' && e.obtainedMarks != null).toList();
    if (finals.isEmpty) return 0;
    final total = finals.fold<double>(0, (sum, e) => sum + _gradePoint(e));
    return double.parse((total / finals.length).toStringAsFixed(2));
  }
  Map<String, List<GradeEntry>> groupByCourse({String? term}) {
    final list = term == null ? _entries : _entries.where((e) => e.term == term).toList();
    final map = <String, List<GradeEntry>>{};
    for (final e in list) {
      map.putIfAbsent(e.courseCode, () => []);
      map[e.courseCode]!.add(e);
    }
    for (final v in map.values) {
      v.sort((a, b) => a.date.compareTo(b.date));
    }
    return map;
  }
  GradeEntry? nearestDeadline() {
    final now = DateTime.now();
    final upcoming = _entries.where((e) => e.reevalDeadline != null && e.reevalDeadline!.isAfter(now)).toList();
    if (upcoming.isEmpty) return null;
    upcoming.sort((a, b) => a.reevalDeadline!.compareTo(b.reevalDeadline!));
    return upcoming.first;
  }
  Set<String> terms() {
    return _entries.map((e) => e.term).toSet();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Result & Grade Tracker',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const GradeApp(),
    );
  }
}

class GradeApp extends StatefulWidget {
  const GradeApp({super.key});
  @override
  State<GradeApp> createState() => _GradeAppState();
}

class _GradeAppState extends State<GradeApp> {
  final GradeStore store = GradeStore();
  int index = 0;
  String? selectedTerm;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Result & Grade Tracker')),
          body: IndexedStack(
            index: index,
            children: [
              DashboardPage(store: store, selectedTerm: selectedTerm, onTermChanged: (t) => setState(() => selectedTerm = t)),
              CourseGradesPage(store: store),
              AddEditGradePage(store: store),
            ],
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (v) => setState(() => index = v),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
              NavigationDestination(icon: Icon(Icons.list_alt_outlined), selectedIcon: Icon(Icons.list_alt), label: 'Course Grades'),
              NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: 'Add Grade'),
            ],
          ),
          floatingActionButton: index == 0
              ? FloatingActionButton.extended(
                  onPressed: () => _showForecast(context),
                  icon: const Icon(Icons.auto_graph),
                  label: const Text('Forecast GPA'),
                )
              : null,
        );
      },
    );
  }

  void _showForecast(BuildContext context) {
    final courseGroups = store.groupByCourse(term: selectedTerm);
    final courses = courseGroups.keys.toList();
    final gpCtrls = {for (final c in courses) c: TextEditingController(text: '')};
    double? result;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: StatefulBuilder(
            builder: (ctx, setS) {
              double gpFromPct(double pct) {
                if (pct >= 90) return 10;
                if (pct >= 80) return 9;
                if (pct >= 70) return 8;
                if (pct >= 60) return 7;
                if (pct >= 50) return 6;
                if (pct >= 40) return 5;
                return 0;
              }
              List<Widget> rows = [];
              for (final c in courses) {
                final entries = courseGroups[c]!;
                entries.sort((a, b) => a.date.compareTo(b.date));
                final mid = entries.where((e) => e.assessmentType == 'Midterm' && e.obtainedMarks != null).toList();
                final midPct = mid.isNotEmpty && mid.last.maxMarks > 0 ? (mid.last.obtainedMarks! / mid.last.maxMarks) * 100 : null;
                final suggestedGp = midPct == null ? null : gpFromPct(midPct);
                rows.add(Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(c, style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(midPct == null ? 'Midterm: not available' : 'Midterm: ${midPct.toStringAsFixed(1)}% • Suggest GP ${suggestedGp!.toStringAsFixed(1)}'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: gpCtrls[c],
                          decoration: const InputDecoration(labelText: 'Expected Grade Points (0-10)'),
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ));
              }
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...rows,
                    const SizedBox(height: 8),
                    if (result != null) Text('Forecast GPA: ${result!.toStringAsFixed(2)}'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            double total = 0;
                            int count = 0;
                            for (final c in courses) {
                              final v = double.tryParse(gpCtrls[c]!.text);
                              if (v != null) {
                                total += v.clamp(0, 10);
                                count++;
                              }
                            }
                            setS(() => result = count == 0 ? 0 : double.parse((total / count).toStringAsFixed(2)));
                          },
                          child: const Text('Calculate'),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final buf = StringBuffer();
                            buf.writeln('Transcript Forecast');
                            for (final c in courses) {
                              final v = double.tryParse(gpCtrls[c]!.text);
                              buf.writeln('$c • Expected GP: ${v?.toStringAsFixed(2) ?? 'N/A'}');
                            }
                            buf.writeln('Forecast GPA: ${result?.toStringAsFixed(2) ?? 'N/A'}');
                            final text = buf.toString();
                            await Clipboard.setData(ClipboardData(text: text));
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Transcript copied')));
                            }
                          },
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text('Export Transcript'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class DashboardPage extends StatelessWidget {
  final GradeStore store;
  final String? selectedTerm;
  final ValueChanged<String?> onTermChanged;
  const DashboardPage({super.key, required this.store, required this.selectedTerm, required this.onTermChanged});
  @override
  Widget build(BuildContext context) {
    final gpa = store.computeGPA(term: selectedTerm);
    final deadline = store.nearestDeadline();
    final recent = store.recentEntries(5);
    final terms = store.terms().toList();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('GPA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        Text(gpa.toStringAsFixed(2), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            const Text('Term'),
                            const SizedBox(width: 12),
                            DropdownButton<String?>(
                              value: selectedTerm,
                              hint: const Text('All'),
                              items: [
                                const DropdownMenuItem<String?>(value: null, child: Text('All')),
                                ...terms.map((t) => DropdownMenuItem<String?>(value: t, child: Text(t))),
                              ],
                              onChanged: onTermChanged,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Next Deadline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        if (deadline == null)
                          const Text('None')
                        else
                          Text(_deadlineText(deadline.reevalDeadline!)),
                        if (deadline != null)
                          Text('${deadline.courseCode} • ${deadline.assessmentType}', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Per-course trend', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...store.groupByCourse(term: selectedTerm).entries.map((e) {
            final course = e.key;
            final list = e.value;
            final trend = _buildTrend(list);
            final improved = trend.improved;
            return Card(
              child: ListTile(
                title: Text(course),
                subtitle: SizedBox(height: 28, child: trend.widget),
                trailing: Icon(improved ? Icons.trending_up : Icons.trending_down, color: improved ? Colors.green : Colors.red),
              ),
            );
          }),
          const SizedBox(height: 16),
          const Text('Recent entries', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          ...recent.map((e) => Card(
                child: ListTile(
                  title: Text('${e.courseCode} • ${e.assessmentType}'),
                  subtitle: Text(e.obtainedMarks == null
                      ? 'Max ${e.maxMarks.toStringAsFixed(1)} • ${_date(e.date)}'
                      : '${e.obtainedMarks!.toStringAsFixed(1)} / ${e.maxMarks.toStringAsFixed(1)} • ${_date(e.date)}'),
                ),
              )),
        ],
      ),
    );
  }
  static String _deadlineText(DateTime d) {
    final now = DateTime.now();
    final diff = d.difference(now);
    if (diff.inDays >= 1) return '${diff.inDays} days left';
    if (diff.inHours >= 1) return '${diff.inHours} hours left';
    if (diff.inMinutes >= 1) return '${diff.inMinutes} minutes left';
    return 'Due soon';
  }
}

class TrendInfo {
  final Widget widget;
  final bool improved;
  TrendInfo(this.widget, this.improved);
}

TrendInfo _buildTrend(List<GradeEntry> list) {
  final percents = list
      .map((e) => e.obtainedMarks == null
          ? null
          : (e.maxMarks <= 0 ? 0.0 : (e.obtainedMarks! / e.maxMarks) * 100))
      .toList();
  final widgets = <Widget>[];
  double? last;
  double? first;
  for (var i = 0; i < percents.length; i++) {
    final p = percents[i];
    Color color;
    double h;
    if (p == null) {
      color = Colors.grey;
      h = 10;
    } else {
      h = 8 + (p.clamp(0, 100) / 100) * 20;
      if (last == null) {
        color = Colors.blue;
        first = p;
      } else {
        color = p >= last ? Colors.green : Colors.red;
      }
      last = p;
    }
    widgets.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(width: 8, height: h, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
    ));
  }
  final improved = first != null && last != null && last >= first;
  return TrendInfo(Row(children: widgets), improved);
}

class CourseGradesPage extends StatefulWidget {
  final GradeStore store;
  const CourseGradesPage({super.key, required this.store});
  @override
  State<CourseGradesPage> createState() => _CourseGradesPageState();
}

class _CourseGradesPageState extends State<CourseGradesPage> {
  String query = '';
  String? typeFilter;
  String? termFilter;
  @override
  Widget build(BuildContext context) {
    final entries = widget.store.entries.where((e) {
      final matchesQuery = query.isEmpty || e.courseCode.toLowerCase().contains(query.toLowerCase()) || e.assessmentType.toLowerCase().contains(query.toLowerCase());
      final matchesType = typeFilter == null || e.assessmentType == typeFilter;
      final matchesTerm = termFilter == null || e.term == termFilter;
      return matchesQuery && matchesType && matchesTerm;
    }).toList();
    final grouped = <String, List<GradeEntry>>{};
    for (final e in entries) {
      grouped.putIfAbsent(e.courseCode, () => []);
      grouped[e.courseCode]!.add(e);
    }
    for (final v in grouped.values) {
      v.sort((a, b) => a.date.compareTo(b.date));
    }
    final types = widget.store.entries.map((e) => e.assessmentType).toSet().toList();
    final terms = widget.store.terms().toList();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search by course or type'),
                  onChanged: (v) => setState(() => query = v),
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<String?>(
                value: typeFilter,
                hint: const Text('Type'),
                items: [
                  const DropdownMenuItem<String?>(value: null, child: Text('All')),
                  ...types.map((t) => DropdownMenuItem<String?>(value: t, child: Text(t))),
                ],
                onChanged: (v) => setState(() => typeFilter = v),
              ),
              const SizedBox(width: 12),
              DropdownButton<String?>(
                value: termFilter,
                hint: const Text('Term'),
                items: [
                  const DropdownMenuItem<String?>(value: null, child: Text('All')),
                  ...terms.map((t) => DropdownMenuItem<String?>(value: t, child: Text(t))),
                ],
                onChanged: (v) => setState(() => termFilter = v),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: grouped.entries.map((entry) {
                final course = entry.key;
                final list = entry.value;
                final withObt = list.where((e) => e.obtainedMarks != null).toList();
                final avg = withObt.isEmpty
                    ? 0
                    : withObt
                        .map((e) => e.maxMarks <= 0 ? 0.0 : (e.obtainedMarks! / e.maxMarks) * 100)
                        .reduce((a, b) => a + b) /
                        withObt.length;
                return Card(
                  child: ExpansionTile(
                    title: Text('$course • ${avg.toStringAsFixed(1)}%'),
                    children: list.map((e) {
                      return ListTile(
                        title: Text('${e.assessmentType} • ${_date(e.date)}'),
                        subtitle: Text(e.obtainedMarks == null
                            ? 'Max ${e.maxMarks.toStringAsFixed(1)} • ${e.term}'
                            : '${e.obtainedMarks!.toStringAsFixed(1)} / ${e.maxMarks.toStringAsFixed(1)} • ${e.term}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            await Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddEditGradePage(store: widget.store, existing: e)));
                          },
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class AddEditGradePage extends StatefulWidget {
  final GradeStore store;
  final GradeEntry? existing;
  const AddEditGradePage({super.key, required this.store, this.existing});
  @override
  State<AddEditGradePage> createState() => _AddEditGradePageState();
}

class _AddEditGradePageState extends State<AddEditGradePage> {
  final formKey = GlobalKey<FormState>();
  final courseCtrl = TextEditingController();
  final maxCtrl = TextEditingController();
  final obtainedCtrl = TextEditingController();
  final gradePointsCtrl = TextEditingController();
  final remarksCtrl = TextEditingController();
  final termCtrl = TextEditingController();
  String assessmentType = 'Midterm';
  bool useGradePoints = false;
  DateTime? date;
  DateTime? deadline;
  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      courseCtrl.text = e.courseCode;
      maxCtrl.text = e.maxMarks.toString();
      obtainedCtrl.text = e.obtainedMarks?.toString() ?? '';
      remarksCtrl.text = e.remarks;
      termCtrl.text = e.term;
      assessmentType = e.assessmentType;
      date = e.date;
      deadline = e.reevalDeadline;
    }
  }
  @override
  void dispose() {
    courseCtrl.dispose();
    maxCtrl.dispose();
    obtainedCtrl.dispose();
    gradePointsCtrl.dispose();
    remarksCtrl.dispose();
    termCtrl.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? 'Add Grade' : 'Edit Grade')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: courseCtrl,
                decoration: const InputDecoration(labelText: 'Course Code'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: assessmentType,
                items: const [
                  DropdownMenuItem(value: 'Midterm', child: Text('Midterm')),
                  DropdownMenuItem(value: 'Final', child: Text('Final')),
                  DropdownMenuItem(value: 'Assignment', child: Text('Assignment')),
                ],
                onChanged: (v) => setState(() => assessmentType = v ?? 'Midterm'),
                decoration: const InputDecoration(labelText: 'Assessment Type'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: maxCtrl,
                decoration: const InputDecoration(labelText: 'Max Marks'),
                keyboardType: TextInputType.number,
                validator: (v) {
                  final d = double.tryParse(v ?? '');
                  if (d == null || d <= 0) return 'Enter valid';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              assessmentType == 'Final'
                  ? Column(
                      children: [
                        SwitchListTile(
                          value: useGradePoints,
                          onChanged: (v) => setState(() => useGradePoints = v),
                          title: const Text('Enter Grade Points (0-10)')
                        ),
                        if (!useGradePoints)
                          TextFormField(
                            controller: obtainedCtrl,
                            decoration: const InputDecoration(labelText: 'Obtained Marks'),
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              final d = double.tryParse(v ?? '');
                              final m = double.tryParse(maxCtrl.text);
                              if (d == null || d < 0) return 'Enter valid';
                              if (m != null && d > m) return 'Cannot exceed max';
                              return null;
                            },
                          )
                        else
                          TextFormField(
                            controller: gradePointsCtrl,
                            decoration: const InputDecoration(labelText: 'Grade Points (0-10)'),
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              final gp = double.tryParse(v ?? '');
                              if (gp == null || gp < 0 || gp > 10) return 'Enter 0-10';
                              return null;
                            },
                          ),
                      ],
                    )
                  : TextFormField(
                      controller: obtainedCtrl,
                      decoration: const InputDecoration(labelText: 'Obtained Marks (optional)'),
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return null;
                        final d = double.tryParse(v);
                        final m = double.tryParse(maxCtrl.text);
                        if (d == null || d < 0) return 'Enter valid';
                        if (m != null && d > m) return 'Cannot exceed max';
                        return null;
                      },
                    ),
              const SizedBox(height: 8),
              TextFormField(
                controller: termCtrl,
                decoration: const InputDecoration(labelText: 'Term/Semester'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Date'),
                      child: Row(
                        children: [
                          Text(date == null ? 'Select' : _date(date!)),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.event),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: date ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) setState(() => date = picked);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: remarksCtrl,
                decoration: const InputDecoration(labelText: 'Remarks'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Re-evaluation Deadline'),
                      child: Row(
                        children: [
                          Text(deadline == null ? 'Optional' : _date(deadline!)),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.timer),
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: deadline ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) setState(() => deadline = picked);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate() || date == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill required fields')));
                      return;
                    }
                    final max = double.parse(maxCtrl.text);
                    double? obt;
                    if (assessmentType == 'Final') {
                      if (useGradePoints) {
                        final gp = double.tryParse(gradePointsCtrl.text);
                        obt = gp == null ? null : (gp / 10.0) * max;
                      } else {
                        obt = double.tryParse(obtainedCtrl.text);
                      }
                    } else {
                      obt = obtainedCtrl.text.trim().isEmpty ? null : double.tryParse(obtainedCtrl.text);
                    }
                    if (widget.existing == null) {
                      widget.store.addEntry(
                        courseCode: courseCtrl.text,
                        assessmentType: assessmentType,
                        maxMarks: max,
                        obtainedMarks: obt,
                        date: date!,
                        remarks: remarksCtrl.text,
                        term: termCtrl.text,
                        reevalDeadline: deadline,
                      );
                    } else {
                      final e = GradeEntry(
                        id: widget.existing!.id,
                        courseCode: courseCtrl.text,
                        assessmentType: assessmentType,
                        maxMarks: max,
                        obtainedMarks: obt,
                        date: date!,
                        remarks: remarksCtrl.text,
                        term: termCtrl.text,
                        reevalDeadline: deadline,
                      );
                      widget.store.updateEntry(e);
                    }
                    if (Navigator.of(context).canPop()) {
                      Navigator.of(context).pop();
                    } else {
                      courseCtrl.clear();
                      maxCtrl.clear();
                      obtainedCtrl.clear();
                      gradePointsCtrl.clear();
                      remarksCtrl.clear();
                      termCtrl.clear();
                      assessmentType = 'Midterm';
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


String _date(DateTime d) {
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}