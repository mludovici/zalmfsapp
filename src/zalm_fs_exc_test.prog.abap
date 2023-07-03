*&---------------------------------------------------------------------*
*& Report ZALM_FS_EXC_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZALM_FS_EXC_TEST.

CLASS cx_demo DEFINITION INHERITING FROM cx_static_check.
  public section.
  METHODS get_message IMPORTING iv_msg TYPE string.
ENDCLASS.

CLASS cx_demo IMPLEMENTATION.
  METHOD get_message.
    cl_demo_output=>display( iv_msg ).
  ENDMETHOD.
ENDCLASS.

CLASS cls DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS meth RAISING RESUMABLE(cx_demo).
ENDCLASS.

CLASS cls IMPLEMENTATION.
  METHOD meth.

    RAISE RESUMABLE EXCEPTION TYPE cx_demo.
    cl_demo_output=>display( 'Resumed ...' ).

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  TRY.
      cls=>meth( ).
    CATCH BEFORE UNWIND cx_demo.
      RESUME.
  ENDTRY.
