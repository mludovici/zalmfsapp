*&---------------------------------------------------------------------*
*& Report ZALM_FS_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zalm_fs_test.
*DATA: lv_ts TYPE timestamp.
*DATA: lv_date TYPE d.
*DATA: lv_time TYPE t.
*
** Timestamp nach Systemdatum (d) und Systemzeit (t)
*GET TIME STAMP FIELD lv_ts.
*
** TIME ZONE sy-zonlo - lokale Timezone
** TIME ZONE 'UTC'    - UTC-Zeit
*CONVERT TIME STAMP lv_ts TIME ZONE sy-zonlo INTO DATE lv_date TIME lv_time.
*
*WRITE: / lv_date, lv_time.


*DATA: tomorrow  TYPE d,
*      next_hour TYPE t.
*
*DATA(today) = sy-datlo.
*DATA(now)   = sy-timlo.
*
*tomorrow  = today + 1.
*next_hour = ( now + 3600 ) / 3600 * 3600.
*
*cl_demo_output=>write( tomorrow ).
*cl_demo_output=>write( next_hour ).
*SELECT * FROM spfli
*  INTO TABLE @DATA(it_spfli).
*
*if ( line_exists( it_spfli[ carrid = 'AA' ] ) ).
*  cl_demo_output=>write( it_spfli[ line_index( it_spfli[ carrid = 'QF' connid = '006' ] ) ] ).
*endif.
*
*cl_demo_output=>write( line_index( it_spfli[ carrid = 'QF' connid = '006' ] ) ).
*cl_demo_output=>write( lines( it_spfli ) ).
*cl_demo_output=>display( it_spfli ).
*DATA(uuid_test) = cl_system_uuid=>if_system_uuid_rfc4122_static~create_uuid_c36_by_version( version = 4 ).
*
*Write: / uuid_test .
*TYPES: BEGIN OF ty_sflight,
*  carrid TYPE s_carr_id,
*  connid TYPE s_conn_id,
*  price type s_price,
*  END OF ty_sflight.
*
*
*DATA: it_sflight TYPE TABLE OF ty_sflight,
*      wa_sflight TYPE ty_sflight.
*
*select carrid connid price
*  from sflight
*  into table it_sflight
*  UP TO 30 ROWS.
*
*sort it_sflight by price descending carrid ascending.
*
**cl_demo_output=>write( it_sflight ).
*
*wa_sflight-carrid = 'BB'.
*wa_sflight-connid = 33.
*wa_sflight-price = 10000.
*append wa_sflight to it_sflight.
*
*wa_sflight-carrid = 'ZZ'.
*wa_sflight-connid = 55.
*wa_sflight-price = 100.
*INSERT wa_sflight into it_sflight index 1. "INSERT= Füge an 1. Stelle der internen Tabelle ein, APPEND= letzte Stelle
*
*
**cl_demo_output=>display( it_sflight ).
*read TABLE it_sflight into wa_sflight with TABLE KEY carrid = 'BB' connid = '33'.
*
**cl_demo_output=>display( wa_sflight ).
*
*DATA: it_sflight2 TYPE TABLE OF ty_sflight.
*
*LOOP AT it_sflight into wa_sflight FROM 1 to 10. "where carrid EQ 'AA'.
*  wa_sflight-price = 0.
*  append wa_sflight to it_sflight2.
*ENDLOOP.
*
**cl_demo_output=>display( it_sflight2 ).
*
*
*DATA: it_sflight3 TYPE TABLE OF ty_sflight.
*
*LOOP at it_sflight into wa_sflight.
**  collect wa_sflight into it_sflight3.
*  "Collect vergleicht nicht-numerische Felder, wenn ein Eintrag in interner Tabelle existiert,
*  "werden numerische Felder addiert, ansonsten ein Eintrag erstellt.
*ENDLOOP.
*
**cl_demo_output=>display( it_sflight3 ).
*
*  LOOP at it_sflight into wa_sflight.
**    wa_sflight-price = 0.
*    modify it_sflight from wa_sflight.
*  "Collect vergleicht nicht-numerische Felder, wenn ein Eintrag in interner Tabelle existiert,
*  "werden numerische Felder addiert, ansonsten ein Eintrag erstellt.
*ENDLOOP.
*
*
**cl_demo_output=>display( it_sflight ).
*
*select carrid connid price
*  from sflight
*  into table it_sflight.
*
*cl_demo_output=>display( it_sflight ).
*
*LOOP at it_sflight into wa_sflight.
*    "at first = im ersten Durchlauf"
*    at first.
*      write at: /05 'Carrid', "an Position 5...
*                15 'Connid',
*                30 'PRICE'.
*      write: / sy-uline.
*      endat.
*
*"Text ausgeben wenn sich carrid ändert:
*  at new carrid.
*  write at: /05 'new carrid'.
*  ENDAT.
*
*  write at : /05 wa_sflight-carrid,
*              15 wa_sflight-connid,
*              40 wa_sflight-price.
*
*at last.
*  write: / sy-uline.
*  write: 'End of Report'.
*  endat.
*  "Collect vergleicht nicht-numerische Felder, wenn ein Eintrag in interner Tabelle existiert,
*  "werden numerische Felder addiert, ansonsten ein Eintrag erstellt.
*ENDLOOP.
*

*cl_demo_output=>display( it_sflight ).

*TYPES:
*  itab1 TYPE SORTED TABLE OF string WITH UNIQUE KEY table_line,
*  BEGIN OF struct,
*    col1 TYPE c LENGTH 2,
*    col2 TYPE c LENGTH 2,
*    col3 TYPE c LENGTH 2,
*  END OF struct,
*  itab2 TYPE SORTED TABLE OF struct WITH UNIQUE KEY col1 col2 col3.
*
*DATA(base1) = VALUE itab1(
*                ( `x1y1z1` )
*                ( `x2y2z2` )
*                ( `x3y3z3` ) ).
*DATA(base2) = VALUE itab2(
*                ( col1 = 'x1' col2 = 'y1' col3 = 'z1' )
*                ( col1 = 'x2' col2 = 'y2' col3 = 'z2' )
*                ( col1 = 'x3' col2 = 'y3' col3 = 'z3' ) ).
*
*DATA(tab1) = VALUE #( BASE base1
*               ( `A1B1B1` )
*               ( `A2B2B2` ) ).
*
*DATA(tab2)  = VALUE #(
*                BASE base2
*                ( col1 = 'A1' col2 = 'B1' col3 = 'C1' )
*                ( col1 = 'A2' col2 = 'B2' col3 = 'C2' ) ).
*
*DATA(tab3) = VALUE itab2( BASE base1
*               ( col1 = 'A1' col2 = 'B1' col3 = 'C1' )
*               ( col1 = 'A2' col2 = 'B2' col3 = 'C2' ) ).
*
*cl_demo_output=>write(   tab1  ).
*cl_demo_output=>write(   tab2 ).
*cl_demo_output=>display( tab3 ).

*DATA itab TYPE TABLE OF i WITH EMPTY KEY.
*
*DO 10 TIMES.
*  itab = VALUE #( BASE itab ( ipow( base = sy-index exp = 2 ) ) ).
*ENDDO.
*
*cl_demo_output=>display( itab ).
*
*DATA jtab LIKE itab.
*jtab = VALUE #( FOR j = 1 UNTIL j > 10
*                ( ipow( base = j exp = 2 ) ) ).
*ASSERT jtab = itab.
*
*
*cl_demo_output=>display( jtab ).

**********************************************************************
*https://blogs.sap.com/2017/09/05/dynamic-programming-in-abap-part-1-introduction-to-field-symbols/
*FIELD-Symbols:
*DATA: lt_mara TYPE STANDARD TABLE OF mara.
*FIELD-SYMBOLS: <fs_mara> TYPE mara.
*SELECT * FROM mara INTO TABLE lt_mara UP TO 10 ROWS.
*LOOP AT lt_mara ASSIGNING <fs_mara>.
*  <fs_mara>-matkl = 'DEMO'.
*ENDLOOP.

*DATA: lt_mara TYPE STANDARD TABLE OF mara.
*FIELD-SYMBOLS: <fs_mara> TYPE mara.
*
*APPEND INITIAL LINE TO lt_mara ASSIGNING <fs_mara>.
*IF <fs_mara> IS ASSIGNED.
*  <fs_mara>-matnr = 'MAT1'.
*  <fs_mara>-matkl = '001'.
*  UNASSIGN <fs_mara>.
*ENDIF.
*
*APPEND INITIAL LINE TO lt_mara ASSIGNING <fs_mara>.
*IF <fs_mara> IS ASSIGNED.
*  <fs_mara>-matnr = 'MAT2'.
*  <fs_mara>-matkl = '001'.
*  UNASSIGN <fs_mara>.
*ENDIF.
*cl_demo_output=>display( lt_mara ).

*READ TABLE lt_mara ASSIGNING <fs_mara> WITH KEY matnr = 'MAT1'.

*FIELD-SYMBOLS: <fs_tab> TYPE ANY TABLE.
*FIELD-SYMBOLS: <fs_str> TYPE any.
*FIELD-SYMBOLS: <fs_data> TYPE any.
*DATA: lt_mara TYPE STANDARD TABLE OF mara.
*DATA: lw_mara TYPE mara.
*
*ASSIGN lt_mara TO <fs_tab>.
*SELECT * FROM mara INTO TABLE lt_mara UP TO 10 ROWS.
*
*LOOP AT <fs_tab> ASSIGNING <fs_str>.
*  IF <fs_str> IS ASSIGNED.
*    ASSIGN COMPONENT 'MATKL' OF STRUCTURE <fs_str> TO <fs_data>.
*    IF <fs_data> IS ASSIGNED.
*      IF <fs_data> EQ '01'.
************ Do some processing *********
*      ENDIF.
*      UNASSIGN <fs_data>.
*    ENDIF.
*  ENDIF.
*ENDLOOP.

*FIELD-SYMBOLS: <fs_tab> TYPE ANY TABLE.
*FIELD-SYMBOLS: <fs_str> TYPE any.
*DATA: lt_mar2 TYPE STANDARD TABLE OF mara.
*
*ASSIGN lt_mar2 TO <fs_tab>.
*SELECT * FROM mara INTO TABLE lt_mara UP TO 10 ROWS.
*
*READ TABLE <fs_tab> ASSIGNING <fs_str> WITH KEY ('MATNR') = 'MAT1'.
*   IF <fs_str> IS ASSIGNED.
*  cl_demo_output=>display( <fs_tab> ).
*  ENDIF.
*
**CLASS refs
*DATA: lr_sf TYPE REF TO sflight.
**CREATE DATA lr_sf.
**lr_sf->carrid = 'LOL'.
*
*DATA: lt_sf TYPE TABLE OF sflight.
*
*SELECT * FROM sflight INTO TABLE lt_sf UP TO 10 ROWS.
*
*  LOOP AT lt_sf REFERENCE INTO lr_sf.
*    Write: / lr_sf->fldate.
*    ENDLOOP.

*DATA: lr_num TYPE REF TO DATA.
*    CREATE DATA lr_num TYPE i.
*lr_num->* = 4.
*WRITE: / lr_num.

* DATA REFS
*DATA: lr_num TYPE REF TO DATA.
*FIELD-SYMBOLS: <fs> TYPE any.
*
*CREATE DATA lr_num TYPE string.
*ASSIGN lr_num->* TO <fs>.
*<fs> = 'Hallö Welt'.
*
*WRITE: / <fs>.
*
*
** Structures
*DATA: lr_mtr TYPE REF TO data.
*FIELD-SYMBOLS: <str> TYPE any.
*FIELD-SYMBOLS: <data> TYPE any.
*CREATE DATA lr_mtr TYPE mara.
*
*ASSIGN lr_mtr->* TO <str>.
*
*
*ASSIGN COMPONENT 'MATNR' OF STRUCTURE <str> TO <data>.
*<data> = '112'.
*
*
**Dynamically create data objectsa
*
*WRITE: 'HELLO WORLD!'.
*PARAMETERS: p_tname TYPE tabname.
*DATA: lr_tab TYPE REF TO data.
*FIELD-SYMBOLS: <tab> TYPE ANY TABLE.
*
*IF p_tname is not initial.
*CREATE DATA lr_tab TYPE TABLE OF (p_tname).
*ASSIGN lr_tab->* TO <tab>.
*ENDIF.
*IF sy-subrc EQ 0.
*  SELECT * FROM (p_tname) INTO TABLE <tab> UP TO 10 ROWS.
*  cl_demo_output=>display( <tab> ).
*ENDIF.

*DATA:
*  BEGIN OF src,
*    a TYPE i VALUE 1,
*    b TYPE i VALUE 2,
*  END OF src,
*  BEGIN OF target1,
*    b TYPE i VALUE 11,
*    c TYPE i VALUE 12,
*  END OF target1.
*DATA(target2) = target1.
*
*target1 = CORRESPONDING #( src ).
*target2 = CORRESPONDING #( BASE ( target2 ) src ).
*
*cl_demo_output=>new( )->write( target1 )->display( target2 ).

*
*    DATA: type1 TYPE c LENGTH 30 VALUE 'SCARR',
*          type2 TYPE c LENGTH 30 VALUE 'SPFLI'.
*
*    DATA: dref1 TYPE REF TO data,
*          dref2 TYPE REF TO data.
*
*    FIELD-SYMBOLS: <data1> TYPE any,
*                   <data2> TYPE any.
*
*    DATA: descr_ref1 TYPE REF TO cl_abap_typedescr,
*          descr_ref2 TYPE REF TO cl_abap_typedescr.
*
*    cl_demo_input=>add_field( CHANGING field = type1 ).
*    cl_demo_input=>request(   CHANGING field = type2 ).
*
*    TRY.
*        CREATE DATA: dref1 TYPE (type1),
*                     dref2 TYPE (type2).
*
*        ASSIGN: dref1->* TO <data1>,
*                dref2->* TO <data2>.
*
*      CATCH cx_sy_create_data_error.
*        cl_demo_output=>display( 'Create data error!' ).
*        LEAVE PROGRAM.
*    ENDTRY.
*
*    descr_ref1 = cl_abap_typedescr=>describe_by_data( <data1> ).
*    descr_ref2 = cl_abap_typedescr=>describe_by_data( <data2> ).
*
*    TRY.
*        IF descr_ref1 <> descr_ref2.
*          RAISE EXCEPTION TYPE CX_SY_MOVE_CAST_ERROR.
*        ELSE.
*          <data2> = <data1>.
*        ENDIF.
*      CATCH CX_SY_MOVE_CAST_ERROR.
*        cl_demo_output=>display(
*          `Assignment from type `    &&
*          descr_ref2->absolute_name  &&
*          ` to `                     &&
*          descr_ref1->absolute_name  &&
*          ` not allowed!` ).
*    ENDTRY.
