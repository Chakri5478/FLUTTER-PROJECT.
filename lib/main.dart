import 'package:flutter/material.dart';

void main() {
  runApp(const AccessPlusApp());
}

class AccessPlusApp extends StatefulWidget {
  const AccessPlusApp({super.key});

  @override
  State<AccessPlusApp> createState() => _AccessPlusAppState();
}

class _AccessPlusAppState extends State<AccessPlusApp> {
  ThemeMode themeMode = ThemeMode.light;

  bool highContrast = false;
  bool reduceMotion = false;
  bool textToSpeech = false;

  double textScale = 1.0;

  void changeTextScale(double value) {
    setState(() => textScale = value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AccessPlus',
      themeMode: themeMode,
      theme: buildTheme(false),
      darkTheme: buildTheme(true),

      // Large text scaling
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScale),
          ),
          child: child!,
        );
      },

      home: HomeScreen(
        isDark: themeMode == ThemeMode.dark,
        highContrast: highContrast,
        reduceMotion: reduceMotion,
        textToSpeech: textToSpeech,
        textScale: textScale,
        onThemeChanged: () {
          setState(() {
            themeMode =
                themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
          });
        },
        onContrastChanged: (value) {
          setState(() => highContrast = value);
        },
        onMotionChanged: (value) {
          setState(() => reduceMotion = value);
        },
        onSpeechChanged: (value) {
          setState(() => textToSpeech = value);
        },
        onTextScaleChanged: changeTextScale,
      ),
    );
  }

  ThemeData buildTheme(bool dark) {
    return ThemeData(
      useMaterial3: true,
      brightness: dark ? Brightness.dark : Brightness.light,
      colorSchemeSeed: Colors.indigo,
      scaffoldBackgroundColor:
          dark ? const Color(0xff10131a) : const Color(0xfff5f7fb),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// ============================================================
// HOME SCREEN
// ============================================================

class HomeScreen extends StatefulWidget {
  final bool isDark;
  final bool highContrast;
  final bool reduceMotion;
  final bool textToSpeech;
  final double textScale;

  final VoidCallback onThemeChanged;
  final ValueChanged<bool> onContrastChanged;
  final ValueChanged<bool> onMotionChanged;
  final ValueChanged<bool> onSpeechChanged;
  final ValueChanged<double> onTextScaleChanged;

  const HomeScreen({
    super.key,
    required this.isDark,
    required this.highContrast,
    required this.reduceMotion,
    required this.textToSpeech,
    required this.textScale,
    required this.onThemeChanged,
    required this.onContrastChanged,
    required this.onMotionChanged,
    required this.onSpeechChanged,
    required this.onTextScaleChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedPage = 0;

  final List<String> titles = [
    'Dashboard',
    'Accessibility',
    'Analytics',
    'Notifications',
    'Profile',
    'Help & Support',
  ];

  final List<IconData> icons = [
    Icons.dashboard_rounded,
    Icons.accessibility_new_rounded,
    Icons.analytics_rounded,
    Icons.notifications_rounded,
    Icons.person_rounded,
    Icons.help_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool desktop = constraints.maxWidth >= 900;

        return Scaffold(
          appBar: desktop
              ? null
              : AppBar(
                  title: Text(
                    titles[selectedPage],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    IconButton(
                      tooltip: 'Toggle dark mode',
                      onPressed: widget.onThemeChanged,
                      icon: Icon(
                        widget.isDark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                      ),
                    ),
                  ],
                ),
          drawer: desktop
              ? null
              : Drawer(
                  child: SafeArea(
                    child: buildNavigation(context),
                  ),
                ),
          body: Row(
            children: [
              if (desktop)
                SizedBox(
                  width: 270,
                  child: buildNavigation(context),
                ),
              Expanded(
                child: buildPage(context, desktop),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  Widget buildNavigation(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff4f46e5),
            Color(0xff7c3aed),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          const SizedBox(height: 25),
          Container(
            height: 65,
            width: 65,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .18),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.accessibility_new_rounded,
              size: 36,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'AccessPlus',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: ListView.builder(
              itemCount: titles.length,
              itemBuilder: (context, index) {
                final selected = selectedPage == index;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  child: Semantics(
                    button: true,
                    selected: selected,
                    label: titles[index],
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        setState(() {
                          selectedPage = index;
                        });

                        if (Scaffold.of(context).hasDrawer) {
                          Navigator.pop(context);
                        }
                      },
                      child: AnimatedContainer(
                        duration: widget.reduceMotion
                            ? Duration.zero
                            : const Duration(milliseconds: 250),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: selected
                              ? Colors.white.withValues(alpha: .20)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              icons[index],
                              color: Colors.white,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                titles[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (selected)
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: Colors.white,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Divider(color: Colors.white24),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text(
                    'Dark Mode',
                    style: TextStyle(color: Colors.white),
                  ),
                  secondary: const Icon(
                    Icons.dark_mode_rounded,
                    color: Colors.white,
                  ),
                  value: widget.isDark,
                  onChanged: (_) => widget.onThemeChanged(),
                ),
                const Text(
                  'Accessible for everyone',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PAGE SELECTOR
  // ============================================================

  Widget buildPage(BuildContext context, bool desktop) {
    switch (selectedPage) {
      case 1:
        return accessibilityPage(context);
      case 2:
        return analyticsPage(context);
      case 3:
        return notificationsPage(context);
      case 4:
        return profilePage(context);
      case 5:
        return helpPage(context);
      default:
        return dashboardPage(context, desktop);
    }
  }

  // ============================================================
  // DASHBOARD
  // ============================================================

  Widget dashboardPage(BuildContext context, bool desktop) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(desktop ? 32 : 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(context, desktop),
            const SizedBox(height: 25),
            welcomeCard(context),
            const SizedBox(height: 25),
            statistics(),
            const SizedBox(height: 25),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 800) {
                  return Column(
                    children: [
                      progressCard(context),
                      const SizedBox(height: 18),
                      activityCard(context),
                    ],
                  );
                }

                return Row(
                  children: [
                    Expanded(child: progressCard(context)),
                    const SizedBox(width: 18),
                    Expanded(child: activityCard(context)),
                  ],
                );
              },
            ),
            const SizedBox(height: 25),
            quickActions(),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'AccessPlus • Accessible • Responsive • Inclusive',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: .5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget header(BuildContext context, bool desktop) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Afternoon 👋',
                style: TextStyle(
                  fontSize: desktop ? 30 : 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Your accessible experience at a glance.',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: .65),
                ),
              ),
            ],
          ),
        ),
        if (desktop)
          IconButton.filledTonal(
            tooltip: 'Change theme',
            onPressed: widget.onThemeChanged,
            icon: Icon(
              widget.isDark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded,
            ),
          ),
        const SizedBox(width: 8),
        Stack(
          children: [
            IconButton.filledTonal(
              tooltip: 'Notifications',
              onPressed: () {
                setState(() => selectedPage = 3);
              },
              icon: const Icon(
                Icons.notifications_none_rounded,
              ),
            ),
            Positioned(
              right: 7,
              top: 7,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget welcomeCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff4f46e5),
            Color(0xff9333ea),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            blurRadius: 25,
            offset: const Offset(0, 12),
            color: Colors.indigo.withValues(alpha: .22),
          ),
        ],
      ),
      child: Wrap(
        spacing: 25,
        runSpacing: 20,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const SizedBox(
            width: 520,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Make technology accessible for everyone.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Customize your experience with powerful accessibility features.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.indigo,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
            ),
            onPressed: () {
              setState(() => selectedPage = 1);
            },
            icon: const Icon(Icons.tune_rounded),
            label: const Text('Customize'),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget statistics() {
    final data = [
      ('92%', 'Accessibility', Icons.accessibility_new_rounded, '+8%'),
      ('2,840', 'Active Users', Icons.people_alt_rounded, '+14%'),
      ('1,248', 'Tasks Done', Icons.task_alt_rounded, '+21%'),
      ('4.8/5', 'Satisfaction', Icons.favorite_rounded, '+5%'),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 1;

        if (constraints.maxWidth >= 1100) {
          columns = 4;
        } else if (constraints.maxWidth >= 600) {
          columns = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 145,
          ),
          itemBuilder: (context, index) {
            final item = data[index];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.indigo.withValues(alpha: .10),
                          child: Icon(
                            item.$3,
                            color: Colors.indigo,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          item.$4,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      item.$1,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item.$2,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // PROGRESS
  // ============================================================

  Widget progressCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Accessibility Progress',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 22),
            Row(
              children: [
                SizedBox(
                  width: 110,
                  height: 110,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: .92,
                        strokeWidth: 10,
                        backgroundColor: Colors.indigo.withValues(alpha: .12),
                      ),
                      const Text(
                        '92%',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 22),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Excellent! 🎉',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        'Your accessibility settings are optimized.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ACTIVITY
  // ============================================================

  Widget activityCard(BuildContext context) {
    final activities = [
      ('Large text enabled', Icons.text_fields_rounded),
      ('High contrast checked', Icons.contrast_rounded),
      ('Keyboard navigation', Icons.keyboard_rounded),
      ('Screen reader ready', Icons.record_voice_over_rounded),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...activities.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  child: Icon(item.$2, size: 20),
                ),
                title: Text(item.$1),
                trailing: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ACCESSIBILITY
  // ============================================================

  Widget accessibilityPage(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pageTitle(
              context,
              'Accessibility Center',
              'Personalize the application for your needs.',
            ),
            const SizedBox(height: 22),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [
                    const ListTile(
                      leading: CircleAvatar(
                        child: Icon(Icons.text_fields_rounded),
                      ),
                      title: Text(
                        'Large Text',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Adjust text size throughout the application.',
                      ),
                    ),
                    Row(
                      children: [
                        const Text('80%'),
                        Expanded(
                          child: Slider(
                            value: widget.textScale,
                            min: .8,
                            max: 1.8,
                            divisions: 10,
                            label: '${(widget.textScale * 100).round()}%',
                            onChanged: widget.onTextScaleChanged,
                          ),
                        ),
                        const Text('180%'),
                      ],
                    ),
                    const Divider(),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(
                        Icons.contrast_rounded,
                      ),
                      title: const Text('High Contrast'),
                      subtitle: const Text(
                        'Improve readability with stronger contrast.',
                      ),
                      value: widget.highContrast,
                      onChanged: widget.onContrastChanged,
                    ),
                    const Divider(),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(
                        Icons.record_voice_over_rounded,
                      ),
                      title: const Text('Text to Speech'),
                      subtitle: const Text(
                        'Enable spoken content support.',
                      ),
                      value: widget.textToSpeech,
                      onChanged: widget.onSpeechChanged,
                    ),
                    const Divider(),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      secondary: const Icon(
                        Icons.animation_rounded,
                      ),
                      title: const Text('Reduce Motion'),
                      subtitle: const Text(
                        'Minimize animations and transitions.',
                      ),
                      value: widget.reduceMotion,
                      onChanged: widget.onMotionChanged,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            orientationCard(context),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.keyboard_rounded),
                title: const Text('Keyboard Navigation'),
                subtitle: const Text(
                  'Interactive controls are designed to support keyboard focus.',
                ),
                trailing: const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget orientationCard(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);

    return Card(
      child: ListTile(
        leading: Icon(
          orientation == Orientation.portrait
              ? Icons.stay_current_portrait_rounded
              : Icons.stay_current_landscape_rounded,
          size: 32,
        ),
        title: const Text(
          'Orientation Support',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          orientation == Orientation.portrait
              ? 'Currently using Portrait mode'
              : 'Currently using Landscape mode',
        ),
        trailing: const Icon(
          Icons.check_circle_rounded,
          color: Colors.green,
        ),
      ),
    );
  }

  // ============================================================
  // ANALYTICS
  // ============================================================

  Widget analyticsPage(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pageTitle(
              context,
              'Analytics',
              'Track accessibility and user experience.',
            ),
            const SizedBox(height: 22),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekly Accessibility Score',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 220,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          chartBar('Mon', .60),
                          chartBar('Tue', .70),
                          chartBar('Wed', .75),
                          chartBar('Thu', .82),
                          chartBar('Fri', .88),
                          chartBar('Sat', .92),
                          chartBar('Sun', .96),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: metricCard(
                    '92%',
                    'Accessibility',
                    Icons.accessibility_new,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: metricCard(
                    '87%',
                    'Engagement',
                    Icons.trending_up_rounded,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget chartBar(String day, double value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('${(value * 100).round()}%'),
        const SizedBox(height: 5),
        Container(
          width: 25,
          height: 150 * value,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xff4f46e5),
                Color(0xff9333ea),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 7),
        Text(day),
      ],
    );
  }

  Widget metricCard(
    String value,
    String title,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Icon(
              icon,
              size: 35,
              color: Colors.indigo,
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // NOTIFICATIONS
  // ============================================================

  Widget notificationsPage(BuildContext context) {
    final notifications = [
      (
        'Accessibility score improved',
        'Your score increased to 92%.',
        Icons.trending_up_rounded
      ),
      (
        'Large text is enabled',
        'Your text size is currently ${(widget.textScale * 100).round()}%.',
        Icons.text_fields_rounded
      ),
      (
        'New accessibility tip',
        'Try enabling high contrast for better readability.',
        Icons.lightbulb_outline_rounded
      ),
      (
        'Profile updated',
        'Your accessibility preferences were saved.',
        Icons.person_rounded
      ),
    ];

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pageTitle(
              context,
              'Notifications',
              'Stay updated with accessibility improvements.',
            ),
            const SizedBox(height: 20),
            ...notifications.map(
              (notification) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    child: Icon(notification.$3),
                  ),
                  title: Text(
                    notification.$1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(notification.$2),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE
  // ============================================================

  Widget profilePage(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            pageTitle(
              context,
              'Profile',
              'Manage your account and preferences.',
            ),
            const SizedBox(height: 25),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      child: Icon(
                        Icons.person_rounded,
                        size: 55,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Student User',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'student@example.com',
                    ),
                    const SizedBox(height: 25),
                    profileItem(
                      Icons.accessibility_new_rounded,
                      'Accessibility Score',
                      '92%',
                    ),
                    profileItem(
                      Icons.text_fields_rounded,
                      'Text Size',
                      '${(widget.textScale * 100).round()}%',
                    ),
                    profileItem(
                      Icons.contrast_rounded,
                      'High Contrast',
                      widget.highContrast ? 'Enabled' : 'Disabled',
                    ),
                    profileItem(
                      Icons.dark_mode_rounded,
                      'Dark Mode',
                      widget.isDark ? 'Enabled' : 'Disabled',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileItem(
    IconData icon,
    String title,
    String value,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // HELP
  // ============================================================

  Widget helpPage(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            pageTitle(
              context,
              'Help & Support',
              'Learn how to use AccessPlus.',
            ),
            const SizedBox(height: 20),
            helpCard(
              Icons.text_fields_rounded,
              'How do I increase text size?',
              'Go to Accessibility Center and move the text-size slider.',
            ),
            helpCard(
              Icons.screen_rotation_rounded,
              'Does the app support landscape mode?',
              'Yes. The layout automatically adapts when the device orientation changes.',
            ),
            helpCard(
              Icons.contrast_rounded,
              'What is High Contrast mode?',
              'It improves the visual difference between text, icons and backgrounds.',
            ),
            helpCard(
              Icons.record_voice_over_rounded,
              'What is Text to Speech?',
              'It provides spoken content support for users who prefer audio feedback.',
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.support_agent_rounded,
                  size: 35,
                ),
                title: const Text(
                  'Need more help?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Contact our accessibility support team.',
                ),
                trailing: FilledButton(
                  onPressed: () {},
                  child: const Text('Contact'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget helpCard(
    IconData icon,
    String title,
    String description,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Text(description),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUICK ACTIONS
  // ============================================================

  Widget quickActions() {
    final actions = [
      ('Large Text', Icons.text_increase_rounded),
      ('Contrast', Icons.contrast_rounded),
      ('Speech', Icons.record_voice_over_rounded),
      ('Help', Icons.help_outline_rounded),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: actions.map(
            (action) {
              return ActionChip(
                avatar: Icon(
                  action.$2,
                  size: 19,
                ),
                label: Text(action.$1),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                onPressed: () {
                  if (action.$1 == 'Large Text') {
                    widget.onTextScaleChanged(
                      widget.textScale >= 1.5 ? 1.0 : 1.5,
                    );
                  }

                  if (action.$1 == 'Contrast') {
                    widget.onContrastChanged(
                      !widget.highContrast,
                    );
                  }

                  if (action.$1 == 'Speech') {
                    widget.onSpeechChanged(
                      !widget.textToSpeech,
                    );
                  }
                },
              );
            },
          ).toList(),
        ),
      ],
    );
  }

  // ============================================================
  // COMMON TITLE
  // ============================================================

  Widget pageTitle(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: .65),
          ),
        ),
      ],
    );
  }
}
