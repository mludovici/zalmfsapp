*&---------------------------------------------------------------------*
*& Report ZALM_DYN_PROG
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZALM_DYN_PROG.

DATA lv_i type I VALUE 5.
FIELD-SYMBOLS <fs_i> TYPE i.
ASSIGN lv_i TO <fs_i>.

<fs_i> = 20.

WRITE lv_i.
*UNASSIGN <fs_i>.
*IF <fs_i> IS ( NOT ) ASSIGNED.

TYPES: BEGIN OF lty_person,
    name TYPE string,
    age TYPE i,
  END OF lty_person.

  DATA ls_person TYPE lty_person.
  DATA lt_person TYPE TABLE OF lty_person.
  FIELD-SYMBOLS <fs_person> TYPE lty_person.

ASSIGN ls_person TO <fs_person>.
  <fs_person>-name = 'Marc'.
  <fs_person>-age = 37.
APPEND <fs_person> TO lt_person.

  <fs_person>-name = 'Test'.
  <fs_person>-age = 20.
APPEND <fs_person> TO lt_person.


  LOOP AT lt_person ASSIGNING <fs_person>.
    WRITE: / <fs_person>-name, <fs_person>-age.
  ENDLOOP.


  Write: / sy-datum.
  TYPES: BEGIN OF dat_ger,
      jahr(4) type n,
      monat(2) type n,
      tag(2) type n,
    END OF dat_ger.

    FIELD-SYMBOLS <fs_dat> TYPE dat_ger.

    ASSIGN sy-datum to <fs_dat> CASTING.

    WRITE: / <fs_dat>-tag,  <fs_dat>-monat, <fs_dat>-jahr .




************************************************************************
*  Datenreferenzen *
************************************************************************
  DATA personRef type REF TO lty_person.
  DATA lv_pers TYPE lty_person.

  lv_pers-age = 20.
  lv_pers-name = 'Hans'.

  GET REFERENCE OF lv_pers INTO personRef.
  APPEND personRef->* to lt_person.

  lv_pers-age = 33.
  lv_pers-name = 'Wurst'.

  APPEND personRef->* to lt_person.
  Write personRef->name.

  personRef->age = 100.
  personRef->name = 'Grotßzmutter'.
  APPEND personRef->* TO lt_person.

  LOOP AT lt_person ASSIGNING <fs_person>.
    WRITE: / <fs_person>-name, <fs_person>-age.
  ENDLOOP.


**** SAME LOOP WITH DATA REFERENCE*******
  LOOP AT lt_person INTO personRef->*.
    WRITE: / personRef->name, personRef->age.
    ENDLOOP.


    TYPES: BEGIN OF lty_dino,
      name type string,
      dangerous type abap_bool,
      END OF lty_dino.

      TYPES: BEGIN OF lty_kino,
        movie type string,
        size type int8,
        END OF lty_kino.

PARAMETERS pa_name type string.
DATA lo_struktur TYPE REF TO cl_abap_structdescr.
DATA ls_components TYPE abap_compdescr.

lo_struktur ?= cl_abap_typedescr=>describe_by_name( p_name =  pa_name ).

LOOP AT lo_struktur->components INTO ls_components.
  WRITE / ls_components-name.
  ENDLOOP.


TYPES: BEGIN OF lty_person2,
    name type string,
    age type int8,
END OF lty_person2.

DATA lo_strukt TYPE REF TO cl_abap_structdescr.
DATA lo_tabelle TYPE REF TO cl_abap_tabledescr.
DATA lr_tabelle TYPE REF TO data.
FIELD-SYMBOLS <feldsymbol> TYPE STANDARD TABLE.

lo_strukt ?= cl_abap_typedescr=>describe_by_name( 'lty_person2' ).

lo_tabelle = cl_abap_tabledescr=>create( p_line_type = lo_strukt ).

CREATE DATA lr_tabelle TYPE HANDLE lo_tabelle.
