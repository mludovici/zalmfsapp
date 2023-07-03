*&---------------------------------------------------------------------*
*& Report ZALM_FS_JSON
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zalm_fs_json.
*https://codezentrale.de/tag/cl_sxml_string_writer/
*https://blogs.sap.com/2013/01/07/abap-and-json/
*https://software-heroes.com/en/blog/abap-quick-convert-json-to-internal


*data : lv_dauer type i,
*       lt_vbak type standard table of vbak,
*       wa_vbak type vbak.
*
*field -symbols: <fs_vbak> type  vbak.
*
*parameters : r_fs radiobutton group radi,
*             r_wa radiobutton group radi.
*
***********************
** start-of-selection *
***********************
*start-of-selection.
*
*  select *
*    from vbak
*    into table  lt_vbak.
*
*  get run time field lv_dauer.           "Beginn Laufzeitmessung
*
*  if r_wa = 'X' .
*    loop at lt_vbak into wa_vbak.        "Loop in Workarea
*       "wa_vbak-vbeln = ...
*    endloop.
*  endif.
*
* if r_fs = 'X' .
*   loop at lt_vbak assigning <fs_vbak>.  "Loop mit Field-Symbol
*      "<fs_vbak>-vbeln = ...
*   endloop.
* endif.
*
* get run time field lv_dauer.            "Ende Laufzeitmessung
*
* write lv_dauer.
*

*INSERT zalm_fs_todos CLIENT SPECIFIED FROM TABLE lt_todo.
*CALL TRANSFORMATION id SOURCE XML json RESULT values = it_todos.
*
*IF lines( it_todos ) > 0.
*  WRITE: / it_todos[ 1 ]-todo.
*ENDIF.

*DATA: gt_tab TYPE STANDARD TABLE OF string,
*      g_string TYPE string.
*
*START-OF-SELECTION.
*
*  g_string = '[{"id":10,"todo":"Do something nice for someone I care about","completed":"TRUE","USERID":32},{"id":11,"todo":"Memorize the fifty states and their capitals","completed":"FALSE","USERID":80}]'.
*  APPEND g_string TO gt_tab.
*
*  CALL METHOD cl_gui_frontend_services=>gui_download
*    EXPORTING
*      filename                = 'C:/Users/ludovici/Desktop/test.json'
*    CHANGING
*      data_tab                = gt_tab
*    EXCEPTIONS
*      file_write_error        = 1
*      no_batch                = 2
*      gui_refuse_filetransfer = 3
*      invalid_type            = 4
*      no_authority            = 5
*      unknown_error           = 6
*      header_not_allowed      = 7
*      separator_not_allowed   = 8
*      filesize_not_allowed    = 9
*      header_too_long         = 10
*      dp_error_create         = 11
*      dp_error_send           = 12
*      dp_error_write          = 13
*      unknown_dp_error        = 14
*      access_denied           = 15
*      dp_out_of_memory        = 16
*      disk_full               = 17
*      dp_timeout              = 18
*      file_not_found          = 19
*      dataprovider_exception  = 20
*      control_flush_error     = 21
*      not_supported_by_gui    = 22
*      error_no_gui            = 23
*      OTHERS                  = 24.
*
*  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.

*DATA: text TYPE string VALUE 'Hello world!'.
*
** ABAP (string) -> JSON
*DATA(o_writer_json) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
*CALL TRANSFORMATION id SOURCE text = text RESULT XML o_writer_json.
*DATA(json) = cl_abap_codepage=>convert_from( o_writer_json->get_output( ) ).
*
*WRITE: / json.

* Variante 1 (CALL TRANSFORMATION)
*TYPES: BEGIN OF s_person,
*         name  TYPE string,
*         title TYPE string,
*         age   TYPE i,
*       END OF s_person.
*
*TYPES: t_person TYPE STANDARD TABLE OF s_person WITH DEFAULT KEY.
*
*DATA(it_persons) = VALUE t_person( ( name = 'Horst' title = 'Herr' age = 30 )
*                                   ( name = 'Jutta' title = 'Frau' age = 35 )
*                                   ( name = 'Ingo' title = 'Herr' age = 31 ) ).
*
** ABAP (iTab) -> JSON
*DATA(o_writer_itab) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).
*CALL TRANSFORMATION id SOURCE values = it_persons RESULT XML o_writer_itab.
*DATA: json TYPE string.
*cl_abap_conv_in_ce=>create( )->convert( EXPORTING
*                                          input = o_writer_itab->get_output( )
*                                        IMPORTING
*                                          data = json ).
*
*WRITE: / json.

* Variante 2 (/ui2/cl_abap2json)
*SELECT matnr, mtart, meins, pstat
*  INTO TABLE @DATA(it_mara)
*  FROM mara
*  UP TO 10 ROWS.
*
** ABAP (iTab) -> JSON
*DATA(o_conv) = NEW /ui2/cl_abap2json( ).
*DATA(lv_str) = o_conv->table2json( it_data = it_mara ).
*
*WRITE: / lv_str.

*DATA: lt_mara TYPE STANDARD TABLE OF mara.
*FIELD-SYMBOLS: <fs_mara> TYPE mara.
*SELECT * FROM mara INTO TABLE lt_mara UP TO 10 ROWS.
*LOOP AT lt_mara ASSIGNING <fs_mara>.
*   <fs_mara>-matkl = 'DEMO'.
*ENDLOOP.

*DATA: lr_mara TYPE REF TO mara.
*DATA: lt_mara TYPE TABLE OF mara.
*
*SELECT * FROM mara INTO TABLE lt_mara UP TO 10 ROWS.
*
*LOOP AT lt_mara REFERENCE INTO lr_mara.
*  WRITE: / lr_mara->matnr.
*ENDLOOP.

*PARAMETERS: p_tname TYPE tabname.
*DATA: lr_tab TYPE REF TO data.
*FIELD-SYMBOLS: <tab> TYPE ANY TABLE.
*
*CREATE DATA lr_tab TYPE TABLE OF (p_tname).
*ASSIGN lr_tab->* TO <tab>.
*IF sy-subrc EQ 0.
*  SELECT * FROM (p_tname) INTO TABLE <tab> UP TO 10 ROWS.
*  cl_demo_output=>display( <tab> ).
*ENDIF.
