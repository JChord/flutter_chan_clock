import 'dart:async';

import 'package:chan_clock/over_circle.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'dart:math' as math;

import 'drawn_hand.dart';
import 'dial.dart';
import 'circle_point.dart';
import 'utils.dart';

enum _Element {
  background,
  text,
  hand,
}

final _lightTheme = {
  _Element.background: Color(0xFFB05030),
  _Element.text: Color(0xFFFBF2E2),
  _Element.hand: Color(0xFFFAF3E3),
};

final _dartTheme = {
  _Element.background: Color(0xFF120C24),
  _Element.text: Color(0xFFFBF2E2),
  _Element.hand: Color(0xFFFAF3E3),
};

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

class ChanClock extends StatefulWidget {
  const ChanClock(this.model);
  final ClockModel model;

  @override
  _ChanClockState createState() => _ChanClockState();
}

class _ChanClockState extends State<ChanClock>
    with SingleTickerProviderStateMixin {
  DateTime _now = DateTime.now();

  String _temperatureRange = '';
  WeatherCondition _condition = WeatherCondition.sunny;
  String _location = '';

  Timer _timer;
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    final Animation curve =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animation = Tween(begin: -1.0, end: 1.0).animate(curve);
    _animationController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(ChanClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperatureRange =
          '${widget.model.low.floor()}-${widget.model.high.floor()}${widget.model.unitString}';
      _condition = widget.model.weatherCondition;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per minute.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _now.second) -
            Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  IconData get weatherIcon {
    int codePoint;
    switch (_condition) {
      case WeatherCondition.cloudy:
        codePoint = 0xf033;
        break;
      case WeatherCondition.foggy:
        codePoint = 0xf030;
        break;
      case WeatherCondition.rainy:
        codePoint = 0xf02d;
        break;
      case WeatherCondition.snowy:
        codePoint = 0xf032;
        break;
      case WeatherCondition.sunny:
        codePoint = 0xf02f;
        break;
      case WeatherCondition.thunderstorm:
        codePoint = 0xf02e;
        break;
      case WeatherCondition.windy:
        codePoint = 0xf031;
        break;
      default:
        // unknown weather
        codePoint = 0xf034;
        break;
    }
    return IconData(codePoint, fontFamily: 'iconfont');
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtils.init(context);

    final isLight = Theme.of(context).brightness == Brightness.light;
    final currentTheme = isLight ? _lightTheme : _dartTheme;

    final time = DateFormat.Hms().format(_now);

    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Container(
        color: currentTheme[_Element.background],
        child: Stack(
          children: <Widget>[
            Positioned(
              left: ScreenUtils.size(490),
              child: Image.asset(
                'assets/images/leaf.png',
                width: ScreenUtils.size(168),
                fit: BoxFit.fitWidth,
              ),
            ),
            Container(
                child: CustomPaint(
              painter: DialPaint(),
            )),
            // minuete hand
            DrawnHand(
              color: currentTheme[_Element.hand],
              thickness: ScreenUtils.size(14),
              size: 0.32,
              angleRadians: _now.minute * radiansPerTick,
            ),
            // hour hand
            DrawnHand(
              color: currentTheme[_Element.hand],
              thickness: ScreenUtils.size(14),
              size: 0.22,
              angleRadians: _now.hour * radiansPerHour +
                  (_now.minute / 60) * radiansPerHour,
            ),
            Container(
              child: CustomPaint(
                painter: CirclePoint(),
              ),
            ),
            Positioned(
                left: ScreenUtils.size(610),
                top: ScreenUtils.size(352),
                child: PivotTransition(
                    turns: _animation,
                    alignment: FractionalOffset.topCenter,
                    child: Image.asset(
                      'assets/images/ticker.png',
                      width: ScreenUtils.size(80),
                      fit: BoxFit.fitWidth,
                    ))),
            Container(
              child: CustomPaint(
                painter: OverCirclePaint(),
              ),
            ),
            isLight
                ? SizedBox(
                    width: 0,
                    height: 0,
                  )
                : Positioned(
                    top: ScreenUtils.size(30),
                    right: ScreenUtils.size(100),
                    child: Icon(
                      IconData(0xe639, fontFamily: 'iconfont'),
                      color: Color(0xFFFBF4E4),
                      size: ScreenUtils.size(50),
                    ),
                  ),
            Positioned(
              right: 0,
              child: Image.asset('assets/images/bird.png',
                  width: ScreenUtils.size(968), fit: BoxFit.fitWidth),
            ),
            Positioned(
                left: ScreenUtils.size(46),
                top: ScreenUtils.size(84),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      DateFormat('EEEE').format(_now),
                      style: TextStyle(
                          color: currentTheme[_Element.text],
                          fontSize: ScreenUtils.size(90),
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    ),
                    SizedBox(height: ScreenUtils.size(20)),
                    Row(
                      children: <Widget>[
                        Icon(
                          weatherIcon,
                          color: currentTheme[_Element.text],
                          size: ScreenUtils.size(32),
                        ),
                        SizedBox(width: ScreenUtils.size(10)),
                        Text(_temperatureRange,
                            style: TextStyle(
                                color: currentTheme[_Element.text],
                                fontSize: ScreenUtils.size(32)))
                      ],
                    )
                  ],
                )),
            Positioned(
              left: ScreenUtils.size(46),
              bottom: ScreenUtils.size(50),
              child: Text(
                _location,
                style: TextStyle(
                    color: currentTheme[_Element.text],
                    fontSize: ScreenUtils.size(32),
                    fontWeight: FontWeight.w100),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PivotTransition extends AnimatedWidget {
  PivotTransition({
    Key key,
    this.alignment: FractionalOffset.center,
    @required Animation<double> turns,
    this.child,
  }) : super(key: key, listenable: turns);

  /// The animation that controls the rotation of the child.
  ///
  /// If the current value of the turns animation is v, the child will be
  /// rotated v * 2 * pi radians before being painted.
  Animation<double> get turns => listenable;

  final FractionalOffset alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double turnsValue = turns.value;
    final Matrix4 transform = Matrix4.rotationZ(turnsValue * math.pi * 0.14);
    return Transform(
      transform: transform,
      alignment: alignment,
      child: child,
    );
  }
}
