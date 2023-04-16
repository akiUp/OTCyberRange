PROGRAM Tank_control
  VAR
    Level AT %IW100 : INT;
    Flow AT %IW101 : INT;
    Overflow_lamp1 AT %QX100.3 : BOOL;
  END_VAR
  VAR
    Maxlvl : INT := 800;
    MinFlow : INT := 100;
    MaxFlow : INT := 900;
    AlarmLvl : INT := 750;
    Minlvl : INT := 200;
    Zero : INT := 0;
  END_VAR
  VAR
    SP AT %IW102 : INT;
    DiscValve AT %QW100 : INT := 500;
    FillValve AT %QW101 : INT := 900;
    Remotedisp AT %QW102 : INT := 333;
  END_VAR
  VAR
    _TMP_GT8_OUT : BOOL;
    _TMP_LE12_OUT : BOOL;
    _TMP_MOVE18_ENO : BOOL;
    _TMP_MOVE18_OUT : INT;
    _TMP_MOVE1_ENO : BOOL;
    _TMP_MOVE1_OUT : INT;
    _TMP_GT2_OUT : BOOL;
    _TMP_MOVE3_ENO : BOOL;
    _TMP_MOVE3_OUT : INT;
    _TMP_MOVE7_ENO : BOOL;
    _TMP_MOVE7_OUT : INT;
  END_VAR

  _TMP_GT8_OUT := GT(Level, AlarmLvl);
  Overflow_lamp1 := _TMP_GT8_OUT;
  _TMP_LE12_OUT := LE(Level, Minlvl);
  _TMP_MOVE18_OUT := MOVE(EN := _TMP_LE12_OUT, IN := MinFlow, ENO => _TMP_MOVE18_ENO);
  _TMP_MOVE1_OUT := MOVE(EN := _TMP_MOVE18_ENO, IN := MaxFlow, ENO => _TMP_MOVE1_ENO);
  IF _TMP_MOVE1_ENO THEN
      FillValve := _TMP_MOVE1_OUT;
  END_IF;
  IF _TMP_MOVE18_ENO THEN
      DiscValve := _TMP_MOVE18_OUT;
  END_IF;
  _TMP_GT2_OUT := GT(Level, Maxlvl);
  _TMP_MOVE3_OUT := MOVE(EN := _TMP_GT2_OUT, IN := MinFlow, ENO => _TMP_MOVE3_ENO);
  _TMP_MOVE7_OUT := MOVE(EN := _TMP_MOVE3_ENO, IN := MaxFlow, ENO => _TMP_MOVE7_ENO);
  IF _TMP_MOVE7_ENO THEN
      DiscValve := _TMP_MOVE7_OUT;
  END_IF;
  IF _TMP_MOVE3_ENO THEN
      FillValve := _TMP_MOVE3_OUT;
  END_IF;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 0);
    PROGRAM instance0 WITH task0 : Tank_control;
  END_RESOURCE
END_CONFIGURATION
