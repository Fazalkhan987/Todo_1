/lib/pages/Todo.png





import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Calculator'),
    );
  }
}

enum CalculatorMode { basic, scientific }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var expcontroller = TextEditingController();
  String exp = "";
  String res = "";
  List<String> _items = [
    'AC',
    '()',
    '%',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '-',
    '0',
    '.',
    '⌫',
    '=',
  ];

  static const int crossAxisCount = 4;
  static const double spacing = 10;

  void _addContainers() {
    final List<String> newItems = [
      "a",
      "sin",
      "cos",
      "tan",
      "log",
      "ln",
      "xʸ",
      "y√x",
      "hypot",
      "sinh",
      "cosh",
      "tanh",
    ];

    setState(() {
      _items = [...newItems, ..._items];
    });
  }

  CalculatorMode currentMode = CalculatorMode.basic;
  void toggleMode() {
    setState(() {
      currentMode = currentMode == CalculatorMode.basic
          ? CalculatorMode.scientific
          : CalculatorMode.basic;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              toggleMode();
              _addContainers;
            },
            icon: Icon(
              currentMode == CalculatorMode.basic
                  ? Icons.expand_more
                  : Icons.expand_less,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.red),
        child: Column(
          children: [
            Container(child: TextField(controller: expcontroller)),
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              color: Colors.white.withOpacity(0.2),
              child: Text(
                res,
                textAlign: TextAlign.end,
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 460,
                      height: 520,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final itemCount = _items.length;
                          final rows = (itemCount / crossAxisCount).ceil();
                          final cellWidth =
                              (constraints.maxWidth -
                                  spacing * (crossAxisCount - 1)) /
                              crossAxisCount;
                          final cellHeight =
                              (constraints.maxHeight - spacing * (rows - 1)) /
                              rows;
                          final aspectRatio = cellWidth / cellHeight;

                          return GridView.builder(
                            physics:
                                const NeverScrollableScrollPhysics(), // no scroll
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  mainAxisSpacing: spacing,
                                  crossAxisSpacing: spacing,
                                  childAspectRatio: aspectRatio,
                                ),
                            itemCount: itemCount,
                            itemBuilder: (context, index) {
                              final id = _items[index];
                              return Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 89, 67, 3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$id',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.55),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
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
}





























cw
import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: 
      const MyHomePage(title: 'Calculator'),
    );
  }
}

enum CalculatorMode { basic, scientific }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ---- expression state ----
  String exp = '';
  String res = '';
  bool _justEvaluated = false;

  // ---- button layouts ----
  static const List<String> _basicItems = [
    'AC', '()', '%', '÷',
    '7', '8', '9', '×',
    '4', '5', '6', '+',
    '1', '2', '3', '-',
    '0', '.', '⌫', '=',
  ];

  // 12 extra buttons shown on top of the basic ones in scientific mode
  static const List<String> _scientificItems = [
    'sin', 'cos', 'tan', 'xʸ',
    'log', 'ln', 'y√x', ',',
    'sinh', 'cosh', 'tanh', 'hypot',
  ];

  List<String> _items = List.of(_basicItems);

  static const int crossAxisCount = 4;
  static const double spacing = 10;

  CalculatorMode currentMode = CalculatorMode.basic;

  void toggleMode() {
    setState(() {
      if (currentMode == CalculatorMode.basic) {
        currentMode = CalculatorMode.scientific;
        _items = [..._scientificItems, ..._basicItems];
      } else {
        currentMode = CalculatorMode.basic;
        _items = List.of(_basicItems);
      }
    });
  }

  // ===================== BUTTON HANDLING =====================

  void _onButtonPressed(String label) {
    setState(() {
      switch (label) {
        case 'AC':
          exp = '';
          res = '';
          _justEvaluated = false;
          break;

        case '⌫':
          if (exp.isNotEmpty) exp = exp.substring(0, exp.length - 1);
          _justEvaluated = false;
          _updatePreview();
          break;

        case '=':
          _evaluateFinal();
          break;

        case '()':
          _insertSmartParen();
          break;

        case '.':
          _insertDecimal();
          break;

        case 'xʸ':
          _appendOperator('^');
          break;

        case 'y√x':
          _appendOperator('√');
          break;

        case '+':
        case '-':
        case '×':
        case '÷':
        case '%':
          _appendOperator(label);
          break;

        case 'sin':
        case 'cos':
        case 'tan':
        case 'log':
        case 'ln':
        case 'sinh':
        case 'cosh':
        case 'tanh':
          exp += '$label(';
          _justEvaluated = false;
          _updatePreview();
          break;

        case 'hypot':
          exp += 'hypot(';
          _justEvaluated = false;
          _updatePreview();
          break;

        case ',':
          exp += ',';
          _justEvaluated = false;
          _updatePreview();
          break;

        default: // digits 0-9
          if (_justEvaluated) {
            exp = label;
            _justEvaluated = false;
          } else {
            exp += label;
          }
          _updatePreview();
          break;
      }
    });
  }

  void _appendOperator(String op) {
    if (exp.isEmpty) {
      if (op == '-') exp = '-'; // allow starting with a negative number
      _justEvaluated = false;
      _updatePreview();
      return;
    }

    final lastChar = exp[exp.length - 1];
    const replaceable = {'+', '-', '×', '÷', '^', '√'};

    if (replaceable.contains(lastChar)) {
      if (op == '-') {
        exp += op; // e.g. "5×-3" — unary minus after an operator is fine
      } else {
        exp = exp.substring(0, exp.length - 1) + op; // swap "5+" -> "5×"
      }
    } else {
      exp += op;
    }
    _justEvaluated = false;
    _updatePreview();
  }

  void _insertDecimal() {
    final segment = _currentNumberSegment();
    if (!segment.contains('.')) {
      final lastChar = exp.isNotEmpty ? exp[exp.length - 1] : '';
      exp += (segment.isEmpty || _isOperatorChar(lastChar)) ? '0.' : '.';
    }
    _justEvaluated = false;
    _updatePreview();
  }

  String _currentNumberSegment() {
    int i = exp.length - 1;
    while (i >= 0 && !_isBreakChar(exp[i])) {
      i--;
    }
    return exp.substring(i + 1);
  }

  bool _isBreakChar(String ch) =>
      _isOperatorChar(ch) || ch == '(' || ch == ')' || ch == ',';

  bool _isOperatorChar(String ch) =>
      ['+', '-', '×', '÷', '%', '^', '√'].contains(ch);

  void _insertSmartParen() {
    final opens = exp.split('(').length - 1;
    final closes = exp.split(')').length - 1;
    final lastChar = exp.isNotEmpty ? exp[exp.length - 1] : '';

    final canClose =
        opens > closes && lastChar != '(' && !_isOperatorChar(lastChar);

    if (canClose) {
      exp += ')';
    } else if (RegExp(r'[0-9)]$').hasMatch(exp)) {
      exp += '×('; // implicit multiplication, e.g. "5(" -> "5×("
    } else {
      exp += '(';
    }
    _justEvaluated = false;
    _updatePreview();
  }

  void _updatePreview() {
    if (exp.isEmpty) {
      res = '';
      return;
    }
    try {
      final value = _evaluate(_balanceParens(exp));
      res = _formatNumber(value);
    } catch (_) {
      res = ''; // expression incomplete mid-typing — stay quiet, not an error
    }
  }

  void _evaluateFinal() {
    if (exp.isEmpty) return;
    try {
      final value = _evaluate(_balanceParens(exp));
      res = _formatNumber(value);
      exp = res; // result becomes the new starting point, ready to chain
      _justEvaluated = true;
    } catch (_) {
      res = 'Error';
    }
  }

  String _balanceParens(String input) {
    final opens = input.split('(').length - 1;
    final closes = input.split(')').length - 1;
    return opens > closes ? input + ')' * (opens - closes) : input;
  }

  String _formatNumber(double value) {
    if (value.isNaN || value.isInfinite) return 'Error';
    if (value == value.roundToDouble() && value.abs() < 1e15) {
      return value.toInt().toString();
    }
    String s = value.toStringAsFixed(10);
    s = s.replaceFirst(RegExp(r'0+$'), '');
    s = s.replaceFirst(RegExp(r'\.$'), '');
    return s;
  }

  double _evaluate(String input) {
    final parser = _ExpressionParser(input);
    final result = parser.parseExpression();
    parser.expectEnd();
    return result;
  }

  // ===================== UI =====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: currentMode == CalculatorMode.basic
                ? 'Switch to scientific'
                : 'Switch to basic',
            onPressed: toggleMode,
            icon: Icon(
              currentMode == CalculatorMode.basic
                  ? Icons.functions
                  : Icons.calculate_outlined,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  exp.isEmpty ? '0' : exp,
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 24),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  res,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final itemCount = _items.length;
                    final rows = (itemCount / crossAxisCount).ceil();
                    final cellWidth =
                        (constraints.maxWidth - spacing * (crossAxisCount - 1)) /
                            crossAxisCount;
                    final cellHeight =
                        (constraints.maxHeight - spacing * (rows - 1)) / rows;
                    final aspectRatio = cellWidth / cellHeight;

                    return GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: spacing,
                        crossAxisSpacing: spacing,
                        childAspectRatio: aspectRatio,
                      ),
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        final label = _items[index];
                        return _CalcButton(
                          label: label,
                          color: _buttonColor(label),
                          onTap: () => _onButtonPressed(label),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _buttonColor(String label) {
    if (label == 'AC' || label == '⌫') return const Color(0xFFD64545);
    if (label == '=') return Theme.of(context).colorScheme.primary;
    const operators = {'+', '-', '×', '÷', '%', '()', '^', '√'};
    if (operators.contains(label)) return const Color(0xFF5B4B8A);
    if (_scientificItems.contains(label)) return const Color(0xFF2E3B4E);
    return const Color(0xFF2A2A2E); // digits / decimal
  }
}

class _CalcButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _CalcButton({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =================================================================
//  EXPRESSION PARSER — plain Dart, no extra packages required.
//
//  Grammar (highest precedence at the bottom):
//    expression := term (('+' | '-') term)*
//    term       := unary (('×' | '÷') unary)*
//    unary      := '-' unary | power
//    power      := postfix (('^' | '√') unary)?      (right-associative)
//    postfix    := primary ('%')*
//    primary    := number | '(' expression ')' | name '(' expr (',' expr)? ')'
// =================================================================

class _ExpressionParser {
  final String input;
  int pos = 0;

  _ExpressionParser(this.input);

  void _skipSpaces() {
    while (pos < input.length && input[pos] == ' ') pos++;
  }

  String? _peek() {
    _skipSpaces();
    return pos < input.length ? input[pos] : null;
  }

  double parseExpression() {
    double value = _parseTerm();
    while (true) {
      final c = _peek();
      if (c == '+') {
        pos++;
        value += _parseTerm();
      } else if (c == '-') {
        pos++;
        value -= _parseTerm();
      } else {
        break;
      }
    }
    return value;
  }

  double _parseTerm() {
    double value = _parseUnary();
    while (true) {
      final c = _peek();
      if (c == '×') {
        pos++;
        value *= _parseUnary();
      } else if (c == '÷') {
        pos++;
        final divisor = _parseUnary();
        if (divisor == 0) throw const FormatException('Divide by zero');
        value /= divisor;
      } else {
        break;
      }
    }
    return value;
  }

  double _parseUnary() {
    if (_peek() == '-') {
      pos++;
      return -_parseUnary();
    }
    return _parsePower();
  }

  double _parsePower() {
    final value = _parsePostfix();
    final c = _peek();
    if (c == '^') {
      pos++;
      return math.pow(value, _parseUnary()).toDouble();
    } else if (c == '√') {
      pos++;
      final x = _parseUnary();
      return math.pow(x, 1 / value).toDouble(); // "y√x" -> x ^ (1/y)
    }
    return value;
  }

  double _parsePostfix() {
    double value = _parsePrimary();
    while (_peek() == '%') {
      pos++;
      value /= 100;
    }
    return value;
  }

  double _parsePrimary() {
    final c = _peek();
    if (c == null) throw const FormatException('Unexpected end of input');

    if (c == '(') {
      pos++;
      final value = parseExpression();
      _expectChar(')');
      return value;
    }
    if (RegExp(r'[0-9.]').hasMatch(c)) return _parseNumber();
    if (RegExp(r'[a-z]').hasMatch(c)) return _parseFunction();

    throw FormatException('Unexpected character "$c"');
  }

  double _parseNumber() {
    _skipSpaces();
    final start = pos;
    while (pos < input.length && RegExp(r'[0-9.]').hasMatch(input[pos])) {
      pos++;
    }
    final text = input.substring(start, pos);
    if (text.isEmpty || text == '.') throw const FormatException('Invalid number');
    return double.parse(text);
  }

  double _parseFunction() {
    _skipSpaces();
    final start = pos;
    while (pos < input.length && RegExp(r'[a-z]').hasMatch(input[pos])) {
      pos++;
    }
    final name = input.substring(start, pos);
    _expectChar('(');
    final arg1 = parseExpression();

    if (name == 'hypot') {
      _expectChar(',');
      final arg2 = parseExpression();
      _expectChar(')');
      return math.sqrt(arg1 * arg1 + arg2 * arg2);
    }

    double result;
    switch (name) {
      case 'sin':
        result = math.sin(arg1 * math.pi / 180); // degrees
        break;
      case 'cos':
        result = math.cos(arg1 * math.pi / 180);
        break;
      case 'tan':
        result = math.tan(arg1 * math.pi / 180);
        break;
      case 'sinh':
        result = (math.exp(arg1) - math.exp(-arg1)) / 2;
        break;
      case 'cosh':
        result = (math.exp(arg1) + math.exp(-arg1)) / 2;
        break;
      case 'tanh':
        final e2 = math.exp(2 * arg1);
        result = (e2 - 1) / (e2 + 1);
        break;
      case 'log':
        result = math.log(arg1) / math.ln10; // base-10
        break;
      case 'ln':
        result = math.log(arg1);
        break;
      case 'sqrt':
        result = math.sqrt(arg1);
        break;
      default:
        throw FormatException('Unknown function "$name"');
    }
    _expectChar(')');
    return result;
  }

  void _expectChar(String expected) {
    _skipSpaces();
    if (pos >= input.length || input[pos] != expected) {
      throw FormatException('Expected "$expected"');
    }
    pos++;
  }

  void expectEnd() {
    _skipSpaces();
    if (pos != input.length) throw const FormatException('Unexpected trailing input');
  }
}





































// ─── Calculator Logic ────────────────────────────────────────────────────────

class CalcEngine {
  /// Evaluate a plain expression string like "3+4*2-sin(30)"
  static double evaluate(String expr) {
    // Replace display symbols
    expr = expr
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('π', pi.toString())
        .replaceAll('e', e.toString());

    return _parseExpr(expr.trim());
  }

  // Recursive-descent parser
  static double _parseExpr(String s) => _addSub(s.trim(), [0]);

  static double _addSub(String s, List<int> pos) {
    double result = _mulDiv(s, pos);
    while (pos[0] < s.length &&
        (s[pos[0]] == '+' || s[pos[0]] == '-')) {
      final op = s[pos[0]++];
      final right = _mulDiv(s, pos);
      result = op == '+' ? result + right : result - right;
    }
    return result;
  }

  static double _mulDiv(String s, List<int> pos) {
    double result = _power(s, pos);
    while (pos[0] < s.length &&
        (s[pos[0]] == '*' || s[pos[0]] == '/')) {
      final op = s[pos[0]++];
      final right = _power(s, pos);
      result = op == '*' ? result * right : result / right;
    }
    return result;
  }

  static double _power(String s, List<int> pos) {
    double base = _unary(s, pos);
    if (pos[0] < s.length && s[pos[0]] == '^') {
      pos[0]++;
      final exp = _unary(s, pos);
      return pow(base, exp).toDouble();
    }
    return base;
  }

  static double _unary(String s, List<int> pos) {
    if (pos[0] < s.length && s[pos[0]] == '-') {
      pos[0]++;
      return -_primary(s, pos);
    }
    if (pos[0] < s.length && s[pos[0]] == '+') {
      pos[0]++;
    }
    return _primary(s, pos);
  }

  static double _primary(String s, List<int> pos) {
    // Parentheses
    if (pos[0] < s.length && s[pos[0]] == '(') {
      pos[0]++;
      final val = _addSub(s, pos);
      if (pos[0] < s.length && s[pos[0]] == ')') pos[0]++;
      return val;
    }

    // Functions
    final funcs = [
      'sinh', 'cosh', 'tanh', 'sin', 'cos', 'tan',
      'log', 'ln', 'sqrt', 'abs'
    ];
    for (final fn in funcs) {
      if (s.substring(pos[0]).startsWith(fn)) {
        pos[0] += fn.length;
        if (pos[0] < s.length && s[pos[0]] == '(') {
          pos[0]++;
          final arg = _addSub(s, pos);
          if (pos[0] < s.length && s[pos[0]] == ')') pos[0]++;
          return _applyFn(fn, arg);
        }
      }
    }

    // Number
    int start = pos[0];
    while (pos[0] < s.length &&
        (RegExp(r'[0-9.]').hasMatch(s[pos[0]]))) {
      pos[0]++;
    }
    if (pos[0] == start) throw FormatException('Unexpected: ${s.substring(pos[0])}');
    return double.parse(s.substring(start, pos[0]));
  }

  static double _applyFn(String fn, double x) {
    // trig functions: work in degrees
    switch (fn) {
      case 'sin':   return sin(x * pi / 180);
      case 'cos':   return cos(x * pi / 180);
      case 'tan':   return tan(x * pi / 180);
      case 'sinh':  return sinh(x);
      case 'cosh':  return cosh(x);
      case 'tanh':  return tanh(x);
      case 'log':   return log(x) / ln10;
      case 'ln':    return log(x);
      case 'sqrt':  return sqrt(x);
      case 'abs':   return x.abs();
      default:      return x;
    }
  }

  static double sinh(double x) => (exp(x) - exp(-x)) / 2;
  static double cosh(double x) => (exp(x) + exp(-x)) / 2;
  static double tanh(double x) => sinh(x) / cosh(x);
}

// ─── Formatting helper ───────────────────────────────────────────────────────
String formatResult(double v) {
  if (v.isNaN) return 'Error';
  if (v.isInfinite) return v > 0 ? '∞' : '-∞';
  // If integer, show without decimals
  if (v == v.truncateToDouble() && v.abs() < 1e15) {
    return v.toInt().toString();
  }
  // Otherwise up to 10 sig figs, strip trailing zeros
  String s = v.toStringAsPrecision(10);
  if (s.contains('.')) {
    s = s.replaceAll(RegExp(r'0+$'), '');
    s = s.replaceAll(RegExp(r'\.$'), '');
  }
  return s;
}

// ─── Page ────────────────────────────────────────────────────────────────────

enum CalcMode { basic, scientific }

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage>
    with SingleTickerProviderStateMixin {
  CalcMode _mode = CalcMode.basic;
  String _expression = '';
  String _result = '';
  bool _justEvaluated = false;
  late AnimationController _modeAnim;

  // ── button definitions ──────────────────────────────────────────────────

  static const List<Map<String, dynamic>> _scientificButtons = [
    {'label': 'sin',  'type': 'fn'},
    {'label': 'cos',  'type': 'fn'},
    {'label': 'tan',  'type': 'fn'},
    {'label': 'log',  'type': 'fn'},
    {'label': 'ln',   'type': 'fn'},
    {'label': 'sinh', 'type': 'fn'},
    {'label': 'cosh', 'type': 'fn'},
    {'label': 'tanh', 'type': 'fn'},
    {'label': '√',    'type': 'fn'},
    {'label': 'xʸ',   'type': 'op'},
    {'label': 'π',    'type': 'const'},
    {'label': 'e',    'type': 'const'},
  ];

  static const List<Map<String, dynamic>> _basicButtons = [
    {'label': 'AC',  'type': 'action'},
    {'label': '()',  'type': 'bracket'},
    {'label': '%',   'type': 'op'},
    {'label': '÷',   'type': 'op'},
    {'label': '7',   'type': 'num'},
    {'label': '8',   'type': 'num'},
    {'label': '9',   'type': 'num'},
    {'label': '×',   'type': 'op'},
    {'label': '4',   'type': 'num'},
    {'label': '5',   'type': 'num'},
    {'label': '6',   'type': 'num'},
    {'label': '+',   'type': 'op'},
    {'label': '1',   'type': 'num'},
    {'label': '2',   'type': 'num'},
    {'label': '3',   'type': 'num'},
    {'label': '-',   'type': 'op'},
    {'label': '0',   'type': 'num'},
    {'label': '.',   'type': 'num'},
    {'label': '⌫',   'type': 'action'},
    {'label': '=',   'type': 'equals'},
  ];

  @override
  void initState() {
    super.initState();
    _modeAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _modeAnim.dispose();
    super.dispose();
  }

  // ── button press logic ──────────────────────────────────────────────────

  void _onButton(String label, String type) {
    setState(() {
      switch (label) {
        // ─── Clear ───────────────────────────────────────────────────────
        case 'AC':
          _expression = '';
          _result = '';
          _justEvaluated = false;
          break;

        // ─── Backspace ───────────────────────────────────────────────────
        case '⌫':
          if (_expression.isNotEmpty) {
            // Remove multi-char functions gracefully
            final fns = ['sinh', 'cosh', 'tanh', 'sin', 'cos', 'tan', 'log', 'ln'];
            bool removed = false;
            for (final fn in fns) {
              if (_expression.endsWith(fn + '(')) {
                _expression = _expression.substring(0, _expression.length - fn.length - 1);
                removed = true;
                break;
              }
            }
            if (!removed) _expression = _expression.substring(0, _expression.length - 1);
          }
          _justEvaluated = false;
          break;

        // ─── Equals ──────────────────────────────────────────────────────
        case '=':
          if (_expression.isEmpty) break;
          try {
            final val = CalcEngine.evaluate(_expression);
            _result = formatResult(val);
            _expression = _result;
            _justEvaluated = true;
          } catch (_) {
            _result = 'Error';
          }
          break;

        // ─── Bracket toggle ───────────────────────────────────────────────
        case '()':
          final open  = '('.allMatches(_expression).length;
          final close = ')'.allMatches(_expression).length;
          _expression += (open > close) ? ')' : '(';
          _justEvaluated = false;
          break;

        // ─── Percent ─────────────────────────────────────────────────────
        case '%':
          if (_expression.isNotEmpty) {
            _expression += '/100';
          }
          _justEvaluated = false;
          break;

        // ─── Power ───────────────────────────────────────────────────────
        case 'xʸ':
          _expression += '^';
          _justEvaluated = false;
          break;

        // ─── Square root ─────────────────────────────────────────────────
        case '√':
          if (_justEvaluated) _expression = '';
          _expression += 'sqrt(';
          _justEvaluated = false;
          break;

        // ─── Constants ───────────────────────────────────────────────────
        case 'π':
        case 'e':
          if (_justEvaluated) _expression = '';
          _expression += label;
          _justEvaluated = false;
          break;

        // ─── Trig & log functions ─────────────────────────────────────────
        default:
          if (type == 'fn') {
            if (_justEvaluated) _expression = '';
            _expression += '$label(';
            _justEvaluated = false;
            break;
          }

          // ─── Operator ────────────────────────────────────────────────
          if (type == 'op') {
            // Prevent leading operator (except minus)
            if (_expression.isEmpty && label != '-') break;
            // Replace trailing operator
            if (_expression.isNotEmpty &&
                '÷×+-'.contains(_expression[_expression.length - 1])) {
              _expression = _expression.substring(0, _expression.length - 1);
            }
            _expression += label;
            _justEvaluated = false;
            break;
          }

          // ─── Number / decimal ─────────────────────────────────────────
          if (_justEvaluated && type == 'num') {
            // Start fresh after evaluation
            _expression = '';
            _justEvaluated = false;
          }
          _expression += label;
      }

      // Live preview while typing
      if (!_justEvaluated && _expression.isNotEmpty && label != '=') {
        try {
          final v = CalcEngine.evaluate(_expression);
          _result = formatResult(v);
        } catch (_) {
          // don't show error while mid-type
        }
      }
    });
  }

  void _toggleMode() {
    setState(() {
      _mode = _mode == CalcMode.basic ? CalcMode.scientific : CalcMode.basic;
    });
    if (_mode == CalcMode.scientific) {
      _modeAnim.forward();
    } else {
      _modeAnim.reverse();
    }
  }

  // ── button colors ───────────────────────────────────────────────────────

  Color _buttonColor(String type) {
    switch (type) {
      case 'equals':  return const Color(0xFF00C27A);      // green accent
      case 'action':  return const Color(0xFF2A2A2A);      // dark gray
      case 'op':      return const Color(0xFF1E1E1E);      // slightly darker
      case 'fn':      return const Color(0xFF1A2A3A);      // blue-dark
      case 'const':   return const Color(0xFF1A2A3A);
      default:        return const Color(0xFF1E1E1E);       // num default
    }
  }

  Color _labelColor(String type) {
    switch (type) {
      case 'equals':  return Colors.white;
      case 'op':      return const Color(0xFF00C27A);
      case 'fn':      return const Color(0xFF5BC8F5);
      case 'const':   return const Color(0xFF5BC8F5);
      case 'action':  return const Color(0xFFFF6B6B);
      default:        return Colors.white;
    }
  }

  // ── build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isScientific = _mode == CalcMode.scientific;
    final buttons = isScientific
        ? [..._scientificButtons, ..._basicButtons]
        : _basicButtons;
    final crossCount = isScientific ? 4 : 4;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Calculator',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: _toggleMode,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: isScientific
                            ? const Color(0xFF00C27A).withOpacity(0.15)
                            : const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isScientific
                              ? const Color(0xFF00C27A).withOpacity(0.6)
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isScientific
                                ? Icons.science
                                : Icons.calculate_outlined,
                            color: isScientific
                                ? const Color(0xFF00C27A)
                                : Colors.white54,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isScientific ? 'Scientific' : 'Basic',
                            style: TextStyle(
                              color: isScientific
                                  ? const Color(0xFF00C27A)
                                  : Colors.white54,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Display ──────────────────────────────────────────────────
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Expression
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      child: Text(
                        _expression.isEmpty ? '0' : _expression,
                        style: TextStyle(
                          color: _expression.isEmpty
                              ? Colors.white24
                              : Colors.white,
                          fontSize: _expression.length > 16 ? 28 : 40,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Live result preview
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Text(
                        _result,
                        key: ValueKey(_result),
                        style: TextStyle(
                          color: _justEvaluated
                              ? const Color(0xFF00C27A)
                              : Colors.white38,
                          fontSize: _justEvaluated ? 36 : 24,
                          fontWeight: _justEvaluated
                              ? FontWeight.w400
                              : FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Divider ──────────────────────────────────────────────────
            Container(
              height: 1,
              color: Colors.white.withOpacity(0.06),
              margin: const EdgeInsets.symmetric(horizontal: 20),
            ),

            // ── Button grid ───────────────────────────────────────────────
            Expanded(
              flex: isScientific ? 5 : 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossCount,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: buttons.length,
                  itemBuilder: (context, index) {
                    final btn = buttons[index];
                    final label = btn['label'] as String;
                    final type  = btn['type'] as String;
                    return _CalcButton(
                      label: label,
                      bgColor: _buttonColor(type),
                      labelColor: _labelColor(type),
                      onTap: () => _onButton(label, type),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Button Widget ────────────────────────────────────────────────────────────

class _CalcButton extends StatefulWidget {
  final String label;
  final Color bgColor;
  final Color labelColor;
  final VoidCallback onTap;

  const _CalcButton({
    required this.label,
    required this.bgColor,
    required this.labelColor,
    required this.onTap,
  });

  @override
  State<_CalcButton> createState() => _CalcButtonState();
}

class _CalcButtonState extends State<_CalcButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        decoration: BoxDecoration(
          color: _pressed
              ? widget.bgColor.withOpacity(0.5)
              : widget.bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _pressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.labelColor,
              fontSize: widget.label.length > 3 ? 14 : 22,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}













