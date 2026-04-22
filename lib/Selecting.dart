import 'package:flutter/material.dart';
import 'dashboard.dart';

enum UserType { admin, student }

class Program {
  final String name;
  final List<String> courses;
  const Program({required this.name, required this.courses});
}

class YearLevel {
  final String label;
  final List<Program> programs;
  const YearLevel({required this.label, required this.programs});
}

const _curriculum = [
  YearLevel(label: '1st Year', programs: [
    Program(name: 'BS Information Technology', courses: [
      'IT 101 - IT Fundamentals',
      'IT 102 - Programming Logic',
      'IT 103 - Computer Hardware',
    ]),
    Program(name: 'BS Mechanical Engineering', courses: [
      'ME 101 - Engineering Drawing',
      'ME 102 - Statics',
    ]),
    Program(name: 'BS Industrial Engineering', courses: [
      'IE 101 - Engineering Economy',
      'IE 102 - Work Study',
    ]),
    Program(name: 'BTVTED', courses: [
      'TVT 101 - Technical Drawing',
      'TVT 102 - Basic Electronics',
    ]),
  ]),
  YearLevel(label: '2nd Year', programs: [
    Program(name: 'BS Information Technology', courses: [
      'IT 201 - Data Structures',
      'IT 202 - Web Development',
      'IT 203 - Database Management',
    ]),
    Program(name: 'BS Mechanical Engineering', courses: [
      'ME 201 - Thermodynamics',
      'ME 202 - Fluid Mechanics',
    ]),
    Program(name: 'BS Industrial Engineering', courses: [
      'IE 201 - Operations Research',
      'IE 202 - Quality Management',
    ]),
    Program(name: 'BTVTED', courses: [
      'TVT 201 - Advanced Electronics',
      'TVT 202 - Electrical Installation',
    ]),
  ]),
  YearLevel(label: '3rd Year', programs: [
    Program(name: 'BS Information Technology', courses: [
      'ITFE 302A - IT Free Elective 1',
      'ITFE 302B - IT Free Elective 2',
      'IT 303 - Systems Analysis',
      'IT 304 - Software Engineering',
    ]),
    Program(name: 'BS Mechanical Engineering', courses: [
      'ME 301 - Heat Transfer',
      'ME 302 - Manufacturing Processes',
    ]),
    Program(name: 'BS Industrial Engineering', courses: [
      'IE 301 - Supply Chain Management',
      'IE 302 - Ergonomics',
    ]),
    Program(name: 'BTVTED', courses: [
      'TVT 301 - Robotics',
      'TVT 302 - PLC Programming',
    ]),
  ]),
  YearLevel(label: '4th Year', programs: [
    Program(name: 'BS Information Technology', courses: [
      'IT 401 - Capstone Project 1',
      'IT 402 - Capstone Project 2',
      'ITFE 402A - IT Free Elective 2',
    ]),
    Program(name: 'BS Mechanical Engineering', courses: [
      'ME 401 - Power Plant Engineering',
      'ME 402 - Thesis Writing',
    ]),
    Program(name: 'BS Industrial Engineering', courses: [
      'IE 401 - Industrial Internship',
      'IE 402 - Thesis Writing',
    ]),
    Program(name: 'BTVTED', courses: [
      'TVT 401 - Technical Research',
      'TVT 402 - TVT Internship',
    ]),
  ]),
];

class SelectionScreen extends StatefulWidget {
  final UserType userType;
  const SelectionScreen({super.key, required this.userType});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen>
    with SingleTickerProviderStateMixin {
  int _step = 0;
  YearLevel? _selectedYear;
  Program? _selectedProgram;
  String? _selectedCourse;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  List<Program> get _programs => _selectedYear?.programs ?? [];
  List<String> get _courses => _selectedProgram?.courses ?? [];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 380));
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
            begin: const Offset(0.06, 0), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _animateToStep(int step) {
    _animController.reset();
    setState(() => _step = step);
    _animController.forward();
  }

  bool get _canProceed => _step == 2 && _selectedCourse != null;

  String get _stepTitle {
    switch (_step) {
      case 0: return 'Choose year level';
      case 1: return 'Choose Program';
      case 2: return 'Choose Course';
      default: return '';
    }
  }

  String get _stepSubtitle {
    switch (_step) {
      case 0: return 'Which year are you handling today?';
      case 1: return 'Select the program or course';
      case 2: return 'Which course are you handling today?';
      default: return '';
    }
  }

  Widget _buildBreadcrumb() {
    final parts = <String>[];
    if (_selectedYear != null) parts.add(_selectedYear!.label);
    if (_selectedProgram != null) {
      final abbr = _selectedProgram!.name
          .split(' ')
          .where((w) => w.isNotEmpty)
          .map((w) => w[0])
          .take(4)
          .join('');
      parts.add(abbr);
    }
    if (parts.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1565C0).withOpacity(0.25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: const Color(0xFF42A5F5).withOpacity(0.4)),
      ),
      child: Text(parts.join(' · '),
          style: const TextStyle(
              color: Color(0xFF90CAF9),
              fontSize: 11,
              fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildStepDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final active = i == _step;
        final done = i < _step;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: done || active
                ? const Color(0xFF1976D2)
                : const Color(0xFF1A3A6B),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _buildOptionList<T>({
    required List<T> items,
    required String Function(T) label,
    required T? selected,
    required ValueChanged<T> onTap,
  }) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final item = items[i];
        final isSelected = item == selected;
        return GestureDetector(
          onTap: () => onTap(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(
                horizontal: 18, vertical: 15),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF1565C0)
                  : const Color(0xFF0D2A50),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF42A5F5)
                    : const Color(0xFF1A3A6B),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(label(item),
                      style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFFB0BEC5),
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500)),
                ),
                if (isSelected)
                  const Icon(Icons.check_circle_rounded,
                      color: Colors.white, size: 18),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0A1628),
              Color(0xFF0D2250),
              Color(0xFF0A1628)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    if (_step > 0)
                      IconButton(
                        onPressed: () => _animateToStep(_step - 1),
                        icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18),
                      )
                    else
                      const SizedBox(width: 40),
                    const Expanded(
                      child: Center(
                        child: Text('Select',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              const Text('Choose your session to continue',
                  style: TextStyle(
                      color: Color(0xFF78909C), fontSize: 12)),
              const SizedBox(height: 10),
              _buildBreadcrumb(),
              const SizedBox(height: 12),
              _buildStepDots(),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SingleChildScrollView(
                      padding:
                          const EdgeInsets.fromLTRB(24, 24, 24, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_stepTitle,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text(_stepSubtitle,
                              style: const TextStyle(
                                  color: Color(0xFF78909C),
                                  fontSize: 13)),
                          const SizedBox(height: 24),
                          if (_step == 0)
                            _buildOptionList<YearLevel>(
                              items: _curriculum,
                              label: (y) => y.label,
                              selected: _selectedYear,
                              onTap: (y) {
                                setState(() {
                                  _selectedYear = y;
                                  _selectedProgram = null;
                                  _selectedCourse = null;
                                });
                                // Auto-advance to step 1 after short delay
                                Future.delayed(
                                  const Duration(milliseconds: 250),
                                  () => _animateToStep(1),
                                );
                              },
                            ),
                          if (_step == 1)
                            _buildOptionList<Program>(
                              items: _programs,
                              label: (p) => p.name,
                              selected: _selectedProgram,
                              onTap: (p) {
                                setState(() {
                                  _selectedProgram = p;
                                  _selectedCourse = null;
                                });
                                // Auto-advance to step 2 after short delay
                                Future.delayed(
                                  const Duration(milliseconds: 250),
                                  () => _animateToStep(2),
                                );
                              },
                            ),
                          if (_step == 2)
                            _buildOptionList<String>(
                              items: _courses,
                              label: (c) => c,
                              selected: _selectedCourse,
                              onTap: (c) =>
                                  setState(() => _selectedCourse = c),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Button only shown on step 2 (course selection)
              if (_step == 2)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _canProceed
                          ? () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AdminDashboard(
                                    yearLevel: _selectedYear!.label,
                                    program: _selectedProgram!.name,
                                    course: _selectedCourse!,
                                  ),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        disabledBackgroundColor:
                            const Color(0xFF1976D2).withOpacity(0.35),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Go to Dashboard',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}