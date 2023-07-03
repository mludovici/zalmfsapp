*&---------------------------------------------------------------------*
*& Report ZALM_ELOCKOBJ
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZALM_ELOCKOBJ.

CALL FUNCTION 'ENQUEUE_EZALM_TODO'
  EXPORTING
*    mode_zalm_fs_todos = 'E'              " Sperrmodus zur Tabelle ZALM_FS_TODOS
*    mandt              = SY-MANDT         " 01. Enqueue Argument
    id                 =  '138'                " 02. Enqueue Argument
    userid             =   '1'               " 03. Enqueue Argument
*    x_id               = space            " Argument 02 mit Initialwert belegen?
*    x_userid           = space            " Argument 03 mit Initialwert belegen?
    _scope             = '2'
*    _wait              = space
*    _collect           = ' '              " Sperre zunächst nur Sammeln
  EXCEPTIONS
    foreign_lock       = 1                " Objekt ist bereits gesperrt
    system_failure     = 2                " Interner Fehler vom Enqueue-Server
    others             = 3
  .
IF SY-SUBRC <> 0.
 MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
   WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
 WRITE: |OBJECT LOCK FAILED!|.
 ELSE.

 WRITE: |OBJECT LOCKED!|.
ENDIF.
