class ZCL_ZALM_AF1_TODO_CHDO definition
  public
  create public .

public section.

  interfaces IF_CHDO_ENHANCEMENTS .

  class-data OBJECTCLASS type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDOBJECTCL read-only value 'ZALM_AF1_TODO' ##NO_TEXT.

  class-methods WRITE
    importing
      !OBJECTID type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDOBJECTV
      !TCODE type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDTCODE
      !UTIME type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDUZEIT
      !UDATE type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDDATUM
      !USERNAME type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDUSERNAME
      !PLANNED_CHANGE_NUMBER type IF_CHDO_OBJECT_TOOLS_REL=>TY_PLANCHNGNR default SPACE
      !OBJECT_CHANGE_INDICATOR type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDCHNGINDH default 'U'
      !PLANNED_OR_REAL_CHANGES type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDFLAG default SPACE
      !NO_CHANGE_POINTERS type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDFLAG default SPACE
      !O_ZALM_FS_TODOS type ZALM_FS_TODOS optional
      !N_ZALM_FS_TODOS type ZALM_FS_TODOS optional
      !UPD_ZALM_FS_TODOS type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDCHNGINDH default SPACE
    exporting
      value(CHANGENUMBER) type IF_CHDO_OBJECT_TOOLS_REL=>TY_CDCHANGENR
    raising
      CX_CHDO_WRITE_ERROR .
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZALM_AF1_TODO_CHDO IMPLEMENTATION.


  method WRITE.
*"----------------------------------------------------------------------
*"         this WRITE method is generated for object ZALM_AF1_TODO
*"         never change it manually, please!        :15.05.2023
*"         All changes will be overwritten without a warning!
*"
*"         CX_CHDO_WRITE_ERROR is used for error handling
*"----------------------------------------------------------------------

    DATA: l_upd        TYPE if_chdo_object_tools_rel=>ty_cdchngind.

    CALL METHOD cl_chdo_write_tools=>changedocument_open
      EXPORTING
        objectclass             = objectclass
        objectid                = objectid
        planned_change_number   = planned_change_number
        planned_or_real_changes = planned_or_real_changes.

     IF ( N_ZALM_FS_TODOS IS INITIAL ) AND
        ( O_ZALM_FS_TODOS IS INITIAL ).
       l_upd  = space.
     ELSE.
       l_upd = UPD_ZALM_FS_TODOS.
     ENDIF.

     IF  l_upd  NE space.
       CALL METHOD CL_CHDO_WRITE_TOOLS=>changedocument_single_case
         EXPORTING
           tablename              = 'ZALM_FS_TODOS'
           workarea_old           = O_ZALM_FS_TODOS
           workarea_new           = N_ZALM_FS_TODOS
           change_indicator       = UPD_ZALM_FS_TODOS
           docu_delete            = 'X'
           docu_insert            = 'X'
           docu_delete_if         = 'X'
           docu_insert_if         = 'X'
                  .
     ENDIF.

    CALL METHOD cl_chdo_write_tools=>changedocument_close
      EXPORTING
        objectclass             = objectclass
        objectid                = objectid
        date_of_change          = udate
        time_of_change          = utime
        tcode                   = tcode
        username                = username
        object_change_indicator = object_change_indicator
        no_change_pointers      = no_change_pointers
      IMPORTING
        changenumber            = changenumber.


*"  Code snippets to be used with COPY+PASTE
*"  uncomment the needed parts
*"  change names if needed

*"  Start of default parameter part
* DATA: objectid                TYPE cdhdr-objectid,
*       tcode                   TYPE cdhdr-tcode,
*       planned_change_number   TYPE cdhdr-planchngnr,
*       utime                   TYPE cdhdr-utime,
*       udate                   TYPE cdhdr-udate,
*       username                TYPE cdhdr-username,
*       cdoc_planned_or_real    TYPE cdhdr-change_ind,
*       cdoc_upd_object         TYPE cdhdr-change_ind VALUE 'U',
*       cdoc_no_change_pointers TYPE cdhdr-change_ind.
* DATA: cdchangenumber          TYPE cdhdr-changenr.
*"  End of default parameter part

*" Begin of dynamic DATA part for class ZCL_ZALM_AF1_TODO_CHDO
*"   workaera_old of ZALM_FS_TODOS
* DATA OS_ZALM_FS_TODOS TYPE ZALM_FS_TODOS.
*"   workaera_new of ZALM_FS_TODOS
* DATA NS_ZALM_FS_TODOS TYPE ZALM_FS_TODOS.
*"   change indicator for ZALM_FS_TODOS
* DATA UPD_ZALM_FS_TODOS TYPE IF_CHDO_OBJECT_TOOLS_REL=>TY_CDCHNGINDH.

*"     Change Number of Document
* DATA CHANGENUMBER TYPE IF_CHDO_OBJECT_TOOLS_REL=>TY_CDCHANGENR.

*" End of dynamic DATA part for class ZCL_ZALM_AF1_TODO_CHDO


*"  Begin of method call part
*"  define needed DATA for error handling
* DATA err_ref TYPE REF TO cx_chdo_write_error.
* DATA err_action TYPE string.

*    TRY.
*        CALL METHOD ZCL_ZALM_AF1_TODO_CHDO=>write
*          EXPORTING
*            objectid                = objectid
*            tcode                   = tcode
*            utime                   = utime
*            udate                   = udate
*            username                = username
*            planned_change_number   = planned_change_number
*            object_change_indicator = cdoc_upd_object
*            planned_or_real_changes = cdoc_planned_or_real
*            no_change_pointers      = cdoc_no_change_pointers
*"  End of default method call part

*" Begin of dynamic part for method call
*"   workaera_old of ZALM_FS_TODOS
*   O_ZALM_FS_TODOS = OS_ZALM_FS_TODOS
*"   workaera_new of ZALM_FS_TODOS
*   N_ZALM_FS_TODOS = NS_ZALM_FS_TODOS
*"   change indicator for ZALM_FS_TODOS
*   UPD_ZALM_FS_TODOS = UPD_ZALM_FS_TODOS

*"     Change Number of Document
*           IMPORTING
*             changenumber            = cdchangenumber.
*      CATCH cx_chdo_write_error INTO err_ref.
*"        MESSAGE err_ref TYPE 'A'.
*"   error information could be determined with default GET_TEXT, GET_LONGTEXT, GET_SOURCE_POSITION methds

*    ENDTRY.
*" End of dynamic part for method call
  endmethod.
ENDCLASS.
