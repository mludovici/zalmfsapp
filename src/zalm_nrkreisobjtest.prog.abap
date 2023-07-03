*&---------------------------------------------------------------------*
*& Report ZALM_NRKREISOBJTEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZALM_NRKREISOBJTEST.

DATA: lv_number type NUMC10.


CALL FUNCTION 'NUMBER_GET_NEXT'
 EXPORTING
   nr_range_nr             =    '01'              " Nummernkreisnummer
   object                  =    'ZALM_NR_TO'              " Name des Nummernkreisobjects
*    quantity                = '1'              " Anzahl der Nummern
*    subobject               = space            " Wert des Unterobjekts
*    toyear                  = '0000'           " Wert des Bis-Geschäftsjahres
*    ignore_buffer           = space            " Objekt-Pufferung ignorieren
  IMPORTING
    number                  =   lv_number               " freie Nummer
*    quantity                =                  " Anzahl der Nummern
*    returncode              =                  " Returncode
  EXCEPTIONS
    interval_not_found      = 1                " Intervall nicht gefunden
    number_range_not_intern = 2                " Nummernkreis ist nicht intern
    object_not_found        = 3                " Objekt nicht in TNRO definiert
    quantity_is_0           = 4                " Anzahl der verlangten Nummern muß größer 0 sein
    quantity_is_not_1       = 5                " Anzahl der verlangten Nummern muß 1 sein
    interval_overflow       = 6                " Intervall aufgebraucht, kein Umschlag möglich
    buffer_overflow         = 7                " Buffer ist voll
    others                  = 8
  .
IF SY-SUBRC <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
   WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
 ELSE.
   Write: |Nächste Zahl: { lv_number }|.
ENDIF.
