import 'package:flutter/material.dart';
import 'login.dart';

enum AttendanceStatus { present, absent, late }

class StudentRecord {
  final String id;
  final String name;
  final String program;
  final String yearLevel;
  final AttendanceStatus status;
  const StudentRecord({
    required this.id,
    required this.name,
    required this.program,
    required this.yearLevel,
    required this.status,
  });
}

const _students = [
  StudentRecord(id: '2026-0000004', name: 'Piloga, Bonna Mae L.', program: 'BSIT', yearLevel: '4th Year', status: AttendanceStatus.present),
  StudentRecord(id: '2026-0000005', name: 'Malate, Jownie Ann D.', program: 'BSIT', yearLevel: '4th Year', status: AttendanceStatus.present),
  StudentRecord(id: '2026-0000003', name: 'Celecia, Niel Jhon E.', program: 'BSIT', yearLevel: '4th Year', status: AttendanceStatus.present),
  StudentRecord(id: '2026-0000007', name: 'Sitjar, Seth', program: 'BSIT', yearLevel: '3rd Year', status: AttendanceStatus.late),
  StudentRecord(id: '2026-0000008', name: 'Reyes, Maria Santos', program: 'BSIT', yearLevel: '3th Year', status: AttendanceStatus.absent),
  StudentRecord(id: '2026-0000009', name: 'Cruz, Juan Dela', program: 'BSIT', yearLevel: '3rd Year', status: AttendanceStatus.present),
];

class AdminDashboard extends StatefulWidget {
  final String yearLevel;
  final String program;
  final String course;
  const AdminDashboard({
    super.key,
    required this.yearLevel,
    required this.program,
    required this.course,
  });

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedNavIndex = 2;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  List<StudentRecord> get _filtered => _searchQuery.isEmpty
      ? _students
      : _students
          .where((s) =>
              s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              s.id.contains(_searchQuery))
          .toList();

  int get _presentCount =>
      _students.where((s) => s.status == AttendanceStatus.present).length;
  int get _absentCount =>
      _students.where((s) => s.status == AttendanceStatus.absent).length;
  int get _lateCount =>
      _students.where((s) => s.status == AttendanceStatus.late).length;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Color _statusColor(AttendanceStatus s) {
    switch (s) {
      case AttendanceStatus.present: return const Color(0xFF00C853);
      case AttendanceStatus.absent:  return const Color(0xFFEF5350);
      case AttendanceStatus.late:    return const Color(0xFFFFB300);
    }
  }

  String _statusLabel(AttendanceStatus s) {
    switch (s) {
      case AttendanceStatus.present: return 'Present';
      case AttendanceStatus.absent:  return 'Absent';
      case AttendanceStatus.late:    return 'Late';
    }
  }

  String _avatarLetter(String name) {
    final parts = name.split(',');
    return parts.length < 2 ? name[0].toUpperCase() : parts[1].trim()[0].toUpperCase();
  }

  Color _avatarColor(String name) {
    const colors = [
      Color(0xFF7B1FA2), Color(0xFF1976D2), Color(0xFF00796B),
      Color(0xFFF57C00), Color(0xFFC62828), Color(0xFF2E7D32),
    ];
    return colors[name.codeUnitAt(0) % colors.length];
  }

  void _showSnack(String msg) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: const Color(0xFF1565C0),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

  Widget _buildStatCard(String label, int count, String sub, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF0D2A50),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
          const SizedBox(height: 4),
          Text('$count', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 1)),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(color: Color(0xFF546E7A), fontSize: 10)),
        ]),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String title, String sub, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF0D2A50),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF1A3A6B)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF1565C0).withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF42A5F5), size: 17),
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(sub, style: const TextStyle(color: Color(0xFF546E7A), fontSize: 10)),
          ]),
        ),
      ),
    );
  }

  Widget _buildStudentRow(StudentRecord s) {
    final sc = _statusColor(s.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2A50),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1A3A6B)),
      ),
      child: Row(children: [
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(color: _avatarColor(s.name), borderRadius: BorderRadius.circular(10)),
          child: Center(child: Text(_avatarLetter(s.name), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(s.name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 3),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFF1565C0).withOpacity(0.25), borderRadius: BorderRadius.circular(4)),
                child: Text(s.program, style: const TextStyle(color: Color(0xFF90CAF9), fontSize: 9, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 6),
              Text(s.id, style: const TextStyle(color: Color(0xFF546E7A), fontSize: 10)),
              const SizedBox(width: 6),
              Text(s.yearLevel, style: const TextStyle(color: Color(0xFF546E7A), fontSize: 10)),
            ]),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
          decoration: BoxDecoration(
            color: sc.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: sc.withOpacity(0.5)),
          ),
          child: Text(_statusLabel(s.status), style: TextStyle(color: sc, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shortCourse = widget.course.split(' - ').first;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A1628), Color(0xFF0D2250), Color(0xFF0A1628)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Column(children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        const Text('Instr. Bo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
                        const SizedBox(width: 8),
                        _iconBtn(Icons.refresh_rounded, () => _showSnack('Refreshed')),
                        const SizedBox(width: 4),
                        _iconBtn(Icons.add_rounded, () => _showSnack('Add session')),
                      ]),
                      const Text('Administrator', style: TextStyle(color: Color(0xFF42A5F5), fontSize: 11)),
                    ]),
                  ),
                  GestureDetector(
                    onTap: () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: const Color(0xFF0D2A50),
                        title: const Text('Sign Out', style: TextStyle(color: Colors.white)),
                        content: const Text('Are you sure you want to sign out?', style: TextStyle(color: Color(0xFFB0BEC5))),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Color(0xFF42A5F5)))),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginScreen()), (_) => false);
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1976D2)),
                            child: const Text('Sign Out'),
                          ),
                        ],
                      ),
                    ),
                    child: Container(
                      width: 36, height: 36,
                      decoration: BoxDecoration(color: const Color(0xFF1565C0), borderRadius: BorderRadius.circular(10)),
                      child: const Center(child: Text('C', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
                    ),
                  ),
                ]),
              ),
              // Course title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(shortCourse, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13), overflow: TextOverflow.ellipsis)),
                    GestureDetector(onTap: () => _showSnack('View all'), child: const Text('View all', style: TextStyle(color: Color(0xFF42A5F5), fontSize: 12, fontWeight: FontWeight.w600))),
                  ],
                ),
              ),
              // Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  _buildStatCard('PRESENT', _presentCount, 'Today', const Color(0xFF00C853)),
                  const SizedBox(width: 8),
                  _buildStatCard('ABSENT', _absentCount, 'Unexcused', const Color(0xFFEF5350)),
                  const SizedBox(width: 8),
                  _buildStatCard('LATE', _lateCount, 'Today', const Color(0xFFFFB300)),
                ]),
              ),
              const SizedBox(height: 16),
              // Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Quick Actions', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(children: [
                    _buildQuickAction(Icons.person_add_alt_1_rounded, 'Add Student', 'Enroll a new student', () => _showSnack('Add Student')),
                    const SizedBox(width: 10),
                    _buildQuickAction(Icons.checklist_rounded, 'Take Attendance', "Mark today's session", () => _showSnack('Take Attendance')),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    _buildQuickAction(Icons.download_rounded, 'Export Report', 'CSV / PDF', () => _showSnack('Export Report')),
                    const SizedBox(width: 10),
                    _buildQuickAction(Icons.book_outlined, 'Manage Subjects', 'Courses & Schedules', () => _showSnack('Manage Subjects')),
                  ]),
                ]),
              ),
              const SizedBox(height: 16),
              // Students header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Students', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                    Text('${_students.length} total', style: const TextStyle(color: Color(0xFF546E7A), fontSize: 11)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search by name or ID...',
                    hintStyle: const TextStyle(color: Color(0xFF546E7A), fontSize: 13),
                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF546E7A), size: 20),
                    filled: true,
                    fillColor: const Color(0xFF0D2A50),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1A3A6B))),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF1A3A6B))),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF42A5F5), width: 1.5)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Student list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: _filtered.length,
                  itemBuilder: (_, i) => _buildStudentRow(_filtered[i]),
                ),
              ),
            ]),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0A1628),
          border: Border(top: BorderSide(color: Color(0xFF1A3A6B), width: 0.8)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.filter_list_rounded, 0),
              _navItem(Icons.check_circle_outline_rounded, 1),
              _navItem(Icons.home_rounded, 2),
              _navItem(Icons.notifications_none_rounded, 3),
              _navItem(Icons.person_outline_rounded, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28, height: 28,
          decoration: BoxDecoration(color: const Color(0xFF1A3A6B), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: Colors.white, size: 15),
        ),
      );

  Widget _navItem(IconData icon, int index) {
    final isSelected = _selectedNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedNavIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1565C0).withOpacity(0.25) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: isSelected ? const Color(0xFF42A5F5) : const Color(0xFF546E7A), size: 22),
      ),
    );
  }
}