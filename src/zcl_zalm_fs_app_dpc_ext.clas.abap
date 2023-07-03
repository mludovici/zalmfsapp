class ZCL_ZALM_FS_APP_DPC_EXT definition
  public
  inheriting from ZCL_ZALM_FS_APP_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION
    redefinition .
protected section.

  methods COMPANIESSET_CREATE_ENTITY
    redefinition .
  methods COMPANIESSET_DELETE_ENTITY
    redefinition .
  methods COMPANIESSET_GET_ENTITY
    redefinition .
  methods COMPANIESSET_GET_ENTITYSET
    redefinition .
  methods COMPANIESSET_UPDATE_ENTITY
    redefinition .
  methods PRODUCTSSET_CREATE_ENTITY
    redefinition .
  methods PRODUCTSSET_DELETE_ENTITY
    redefinition .
  methods PRODUCTSSET_GET_ENTITY
    redefinition .
  methods PRODUCTSSET_GET_ENTITYSET
    redefinition .
  methods PRODUCTSSET_UPDATE_ENTITY
    redefinition .
  methods RELTABLEUSERSPRO_DELETE_ENTITY
    redefinition .
  methods RELTABLEUSERSPRO_GET_ENTITY
    redefinition .
  methods RELTABLEUSERSPRO_GET_ENTITYSET
    redefinition .
  methods TODOSSET_CREATE_ENTITY
    redefinition .
  methods TODOSSET_DELETE_ENTITY
    redefinition .
  methods TODOSSET_GET_ENTITY
    redefinition .
  methods TODOSSET_GET_ENTITYSET
    redefinition .
  methods TODOSSET_UPDATE_ENTITY
    redefinition .
  methods USERSSET_CREATE_ENTITY
    redefinition .
  methods USERSSET_GET_ENTITY
    redefinition .
  methods USERSSET_GET_ENTITYSET
    redefinition .
  methods USERSSET_UPDATE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZALM_FS_APP_DPC_EXT IMPLEMENTATION.


  method COMPANIESSET_CREATE_ENTITY.
    DATA ls_data TYPE zcl_zalm_fs_app_mpc=>ts_companies.
    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_data
        ).
      CATCH /iwbep/cx_mgw_tech_exception.

        IF sy-subrc <> 0.

*          mo_context->get_message_container( )->add_message_text_only( iv_msg_type = 'E'
*                                                                       iv_msg_text = |Datensatz nicht erstellt.| ).
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              textid = /iwbep/cx_mgw_busi_exception=>business_error
              message = 'THERE IS A PROBLEM IN CREATING A COMPANY INFORMATION'.
*              message_container = mo_context->get_message_container( ).
         ELSE.
           MOVE-CORRESPONDING ls_data TO er_entity.
           INSERT INTO zalm_fs_company values er_entity.
        ENDIF.

    ENDTRY.
  endmethod.


  method COMPANIESSET_DELETE_ENTITY.
    DATA: lt_keys TYPE /IWBEP/T_MGW_TECH_PAIRS,
          ls_key TYPE /IWBEP/S_MGW_TECH_PAIR.
    lt_keys = IO_TECH_REQUEST_CONTEXT->GET_KEYS( ).
    READ TABLE lt_keys with key name = 'Id' into ls_key.
    DELETE FROM ZALM_FS_COMPANY WHERE id = ls_key-value.
  endmethod.


  METHOD companiesset_get_entity.
    DATA ls_keys TYPE zcl_zalm_fs_app_mpc=>ts_companies.

    DATA(lv_src_entity) = io_tech_request_context->get_source_entity_type_name( ).

    CASE lv_src_entity.
      WHEN ' '.
        io_tech_request_context->get_converted_keys(
          IMPORTING
            es_key_values = ls_keys
        ).
        SELECT SINGLE * FROM zalm_fs_company
          WHERE id = @ls_keys-id INTO CORRESPONDING FIELDS OF @er_entity.
      WHEN 'Users'.
        "Navigation aus Users
        DATA ls_users TYPE zcl_zalm_fs_app_mpc=>ts_users.

        io_tech_request_context->get_converted_source_keys(
          IMPORTING
            es_key_values = ls_users
        ).

        SELECT SINGLE * FROM zalm_fs_users
          WHERE id = @ls_users-id INTO CORRESPONDING FIELDS OF @ls_users.

        SELECT SINGLE * FROM zalm_fs_company
          WHERE id = @ls_users-companyid INTO CORRESPONDING FIELDS OF @er_entity.

      WHEN OTHERS.

    ENDCASE.



  ENDMETHOD.


  method COMPANIESSET_GET_ENTITYSET.
    DATA lt_ergebnis TYPE ZCL_ZALM_FS_APP_MPC=>tt_companies.
    DATA(lr_filter) = io_tech_request_context->get_filter( ).
    DATA(lv_filter_string) = lr_filter->get_filter_string( ).
    DATA(lt_order) = io_tech_request_context->get_orderby( ).
    DATA(lt_select) = io_tech_request_context->get_select( ).
    DATA(lv_count) = io_tech_request_context->has_count(  ).


    DATA lv_select_comma_sep_str TYPE string.

    IF lt_select IS NOT INITIAL.
    LOOP AT lt_select INTO DATA(lv_sel_property).
      CONCATENATE lv_select_comma_sep_str lv_sel_property ',' INTO lv_select_comma_sep_str.
     ENDLOOP.

    SHIFT lv_select_comma_sep_str RIGHT DELETING TRAILING `,`.

    ELSE.
      lv_select_comma_sep_str = '*'.
    ENDIF.


    DATA lv_sort TYPE string.

    IF lt_order IS INITIAL.
*      lt_order = VALUE #( (   order = 'asc'
*                          property = 'LASTNAME'
*                          property_path = 'LASTNAME'  ) ).
    ENDIF.

    LOOP AT lt_order INTO DATA(ls_order).

      IF sy-tabix = 1.
        lv_sort = |{ ls_order-property } { COND #( WHEN ls_order-order = 'desc'
                                                   THEN 'DESCENDING'
                                                   ELSE 'ASCENDING' )
                                        }|.
      ELSE.
        lv_sort = |{ lv_sort },{ ls_order-property } { COND #( WHEN ls_order-order = 'desc'
                                             THEN 'DESCENDING'
                                             ELSE 'ASCENDING' )
                                  }|.
      ENDIF.
    ENDLOOP.

    IF lv_sort IS INITIAL.

      SELECT (lv_select_comma_sep_str) FROM zalm_fs_company
        WHERE (lv_filter_string)
        INTO CORRESPONDING FIELDS OF TABLE @lt_ergebnis.

    ELSE.
      SELECT (lv_select_comma_sep_str) FROM zalm_fs_company
        WHERE (lv_filter_string)
        ORDER BY (lv_sort)
        INTO CORRESPONDING FIELDS OF TABLE @lt_ergebnis.
    ENDIF.

    IF io_tech_request_context->has_inlinecount(  ).
      es_response_context-inlinecount = lines( lt_ergebnis ).
    ENDIF.

    IF lv_count = abap_true.
      es_response_context-count = lines( lt_ergebnis ).
    ENDIF.

    et_entityset = lt_ergebnis.
  endmethod.


  method COMPANIESSET_UPDATE_ENTITY.
    DATA:
      ls_data      TYPE zcl_zalm_fs_app_mpc=>ts_companies.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_data
        ).
      CATCH /iwbep/cx_mgw_tech_exception.

        IF sy-subrc NE 0.
          mo_context->get_message_container( )->add_message_text_only( iv_msg_type = 'E'
                                                                       iv_msg_text = |Datensatz nicht bearbeitet.| ).

          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              message_container = mo_context->get_message_container( ).
        ENDIF.

    ENDTRY.

    IF ls_data IS NOT INITIAL.
      UPDATE ZALM_FS_COMPANY FROM ls_data.
    ENDIF.
    er_entity = ls_data.


  endmethod.


  method PRODUCTSSET_CREATE_ENTITY.
    DATA ls_data TYPE zcl_zalm_fs_app_mpc=>ts_products.
    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_data
        ).
      CATCH /iwbep/cx_mgw_tech_exception.

        IF sy-subrc <> 0.

*          mo_context->get_message_container( )->add_message_text_only( iv_msg_type = 'E'
*                                                                       iv_msg_text = |Datensatz nicht erstellt.| ).
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              textid = /iwbep/cx_mgw_busi_exception=>business_error
              message = 'THERE IS A PROBLEM IN CREATING A PODUCT INFORMATION'.
*              message_container = mo_context->get_message_container( ).
         ELSE.
           MOVE-CORRESPONDING ls_data TO er_entity.
           INSERT INTO zalm_fs_products values er_entity.
        ENDIF.

    ENDTRY.
  endmethod.


  method PRODUCTSSET_DELETE_ENTITY.
    DATA ls_key TYPE zcl_zalm_fs_app_mpc=>ts_products.

    io_tech_request_context->get_converted_keys(
      IMPORTING
        es_key_values = ls_key
    ).

    DELETE FROM zalm_fs_products
    WHERE id = @ls_key-id.
  endmethod.


  method PRODUCTSSET_GET_ENTITY.
    DATA ls_key TYPE zcl_zalm_fs_app_mpc=>ts_products.

    io_tech_request_context->get_converted_keys(
      IMPORTING
        es_key_values = ls_key
    ).

    SELECT SINGLE * FROM zalm_fs_products
    WHERE id = @ls_key-id
    INTO CORRESPONDING FIELDS OF @er_entity.
  endmethod.


  METHOD productsset_get_entityset.
    DATA lt_ergebnis TYPE zcl_zalm_fs_app_mpc=>tt_products.
    DATA(lt_select) = io_tech_request_context->get_select( ).
    DATA lv_select_comma_sep_str TYPE string.

    DATA(lt_order) = io_tech_request_context->get_orderby( ).
    DATA(lv_count) = io_tech_request_context->has_count( ).
    DATA(lr_filter) = io_tech_request_context->get_filter( ).
    DATA(lv_filter_string) = lr_filter->get_filter_string( ).

    DATA(lv_top) = io_tech_request_context->get_top( ).
    DATA(lv_skip) = io_tech_request_context->get_skip( ).
    DATA numTop TYPE int8.
    numTop = lv_top.
    DATA numSkip TYPE int8.
    numSkip = lv_skip.
    "https://codezentrale.de/tag/io_tech_request_context/
    """"
    "READ TABLE lt_order INDEX 1 INTO DATA(ls_torder).
    "DATA lv_sort_alternative TYPE string.
    "lv_sort_alternative = | { ls_torder-property } { COND #(WHEN ls_torder-order = 'desc' THEN 'DESCENDING' ELSE 'ASCENDING' ) } |.
    """"

    IF lt_select IS NOT INITIAL.
      LOOP AT lt_select INTO DATA(lv_sel_property).
        CONCATENATE lv_select_comma_sep_str lv_sel_property ',' INTO lv_select_comma_sep_str.
      ENDLOOP.

      SHIFT lv_select_comma_sep_str RIGHT DELETING TRAILING `,`.

    ELSE.
      lv_select_comma_sep_str = '*'.
    ENDIF.


    DATA(lv_src) = io_tech_request_context->get_source_entity_type_name( ).
    CASE lv_src.
      WHEN ' '.
    DATA lv_sort TYPE string.
    IF lt_order IS INITIAL.
      " no default values
      " lt_order = VALUE #( (   order = 'asc'
      "                      property =  'TITLE'
      "                      property_path = 'TITLE'  ) ).
    ELSE.



      LOOP AT lt_order INTO DATA(ls_order).
        IF sy-tabix = 1.
          lv_sort = |{ ls_order-property } { COND #( WHEN ls_order-order = 'desc'
                                                     THEN 'DESCENDING'
                                                     ELSE 'ASCENDING' )
                                          }|.
        ELSE.
          lv_sort = |{ lv_sort },{ ls_order-property } { COND #( WHEN ls_order-order = 'desc'
                                               THEN 'DESCENDING'
                                               ELSE 'ASCENDING' )
                                    }|.
        ENDIF.
      ENDLOOP.

    ENDIF.

    IF lv_sort IS INITIAL.
      SELECT (lv_select_comma_sep_str) FROM zalm_fs_products
        WHERE (lv_filter_string)
        INTO CORRESPONDING FIELDS OF TABLE @lt_ergebnis
        UP TO @numTop ROWS.

    ELSE.


      SELECT (lv_select_comma_sep_str) FROM zalm_fs_products
        WHERE (lv_filter_string)

        ORDER BY (lv_sort)
        INTO CORRESPONDING FIELDS OF TABLE @lt_ergebnis
        UP TO @numTop ROWS
        OFFSET @numSkip.

    ENDIF.

    IF io_tech_request_context->has_inlinecount(  ).
      es_response_context-inlinecount = lines( lt_ergebnis ).
    ENDIF.

    IF lv_count = abap_true.
      es_response_context-count = lines( lt_ergebnis ).
    ENDIF.

    et_entityset = lt_ergebnis.
      WHEN 'Users'.
        DATA ls_user TYPE zcl_zalm_fs_app_mpc=>ts_companies.
        DATA lt_reluprod TYPE zcl_zalm_fs_app_mpc=>tt_reltableusersproducts.
        DATA lt_productsByUser TYPE zcl_zalm_fs_app_mpc=>tt_products.

        io_tech_request_context->get_converted_source_keys(
          IMPORTING
            es_key_values = ls_user
        ).

        SELECT * FROM zalm_fs_reluprod
          WHERE userid = @ls_user-id INTO CORRESPONDING FIELDS OF TABLE @lt_reluprod.

        LOOP AT lt_reluprod INTO DATA(ls_reluprod).
          SELECT * FROM zalm_fs_products
            WHERE id = @ls_reluprod-productid INTO @DATA(ls_singleProdByUser).

          COLLECT ls_singleprodbyuser INTO lt_productsbyuser.
          ENDSELECT.
        ENDLOOP.

        et_entityset = lt_productsbyuser.


      WHEN OTHERS.
    ENDCASE.






  ENDMETHOD.


  method PRODUCTSSET_UPDATE_ENTITY.
    DATA ls_key TYPE zcl_zalm_fs_app_mpc=>ts_products.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_key
    ).

    SELECT SINGLE * FROM zalm_fs_products
    WHERE id = @ls_key-id
    INTO @DATA(ls_update).

      UPDATE zalm_fs_products from ls_update.

      er_entity = ls_update.
  endmethod.


  method RELTABLEUSERSPRO_DELETE_ENTITY.
    DATA ls_key TYPE zcl_zalm_fs_app_mpc=>ts_reltableusersproducts.

    io_tech_request_context->get_converted_keys(
      IMPORTING
        es_key_values = ls_key
    ).

    DELETE FROM zalm_fs_reluprod
    WHERE userid = @ls_key-userid.
  endmethod.


  method RELTABLEUSERSPRO_GET_ENTITY.
DATA ls_key TYPE zcl_zalm_fs_app_mpc=>ts_reltableusersproducts.

    io_tech_request_context->get_converted_keys(
      IMPORTING
        es_key_values = ls_key
    ).

    SELECT SINGLE * FROM zalm_fs_reluprod
    WHERE productid = @ls_key-productid
      INTO @Data(ls_prod).

      er_entity = ls_prod.
  endmethod.


  method RELTABLEUSERSPRO_GET_ENTITYSET.

    SELECT * FROM zalm_fs_reluprod INTO TABLE et_entityset.
  endmethod.


  METHOD todosset_create_entity.
    DATA ls_data TYPE zcl_zalm_fs_app_mpc=>ts_todos.

    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_data
        ).
      CATCH /iwbep/cx_mgw_tech_exception.
        IF sy-subrc <> 0.
          mo_context->get_message_container( )->add_message_text_only( iv_msg_type = 'E'
                                                                       iv_msg_text = |Datensatz nicht erstellt.| ).
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              textid            = /iwbep/cx_mgw_busi_exception=>business_error
*             message           = 'THERE IS A PROBLEM IN CREATING A TODO INFORMATION'.
              message_container = mo_context->get_message_container( ).
        ENDIF.
    ENDTRY.
    DATA: next_todo_nr TYPE numc10.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'               " Nummernkreisnummer
        object                  = 'ZALM_NR_TO'                " Name des Nummernkreisobjects
*       quantity                = '1'              " Anzahl der Nummern
*       subobject               = space            " Wert des Unterobjekts
*       toyear                  = '0000'           " Wert des Bis-Geschäftsjahres
*       ignore_buffer           = space            " Objekt-Pufferung ignorieren
      IMPORTING
        number                  = next_todo_nr             " freie Nummer
*       quantity                =                  " Anzahl der Nummern
*       returncode              =                  " Returncode
      EXCEPTIONS
        interval_not_found      = 1                " Intervall nicht gefunden
        number_range_not_intern = 2                " Nummernkreis ist nicht intern
        object_not_found        = 3                " Objekt nicht in TNRO definiert
        quantity_is_0           = 4                " Anzahl der verlangten Nummern muß größer 0 sein
        quantity_is_not_1       = 5                " Anzahl der verlangten Nummern muß 1 sein
        interval_overflow       = 6                " Intervall aufgebraucht, kein Umschlag möglich
        buffer_overflow         = 7                " Buffer ist voll
        OTHERS                  = 8.
    IF sy-subrc <> 0.
      mo_context->get_message_container( )->add_message_text_only( iv_msg_type = 'E'
                                                                   iv_msg_text = |Keine neue ID erhalten!| ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = mo_context->get_message_container( ).
    ENDIF.

    ls_data-id = next_todo_nr.

    CALL FUNCTION 'ENQUEUE_EZALM_TODO'
      EXPORTING
        mode_zalm_fs_todos = 'E'              " Sperrmodus zur Tabelle ZALM_FS_TODOS
        mandt              = sy-mandt         " 01. Enqueue Argument
        id                 = ls_data-id                 " 02. Enqueue Argument
        userid             = ls_data-userid               " 03. Enqueue Argument
        _scope             = '2'
      EXCEPTIONS
        foreign_lock       = 1                " Objekt ist bereits gesperrt
        system_failure     = 2                " Interner Fehler vom Enqueue-Server
        OTHERS             = 3.
    IF sy-subrc <> 0.
      mo_context->get_message_container( )->add_message_text_only( iv_msg_type = 'E'
                                                             iv_msg_text = |Kein Zugriff auf Tabelle Todos mit ID { ls_data-id } und User { ls_data-userid } möglich!| ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = mo_context->get_message_container( ).
    ELSE.

      DATA ls_todo TYPE zcl_zalm_fs_app_mpc=>ts_todos.

      ls_todo = VALUE #( mandt = sy-mandt
                         id = ls_data-id
                         userid = ls_data-userid
                         todo = ls_data-todo
                         completed = ls_data-completed ).


      INSERT INTO zalm_fs_todos VALUES ls_todo.
      IF sy-subrc <> 0.
        mo_context->get_message_container( )->add_message_text_only( iv_msg_type = 'E'
                                                               iv_msg_text = |Insert fehlgeschlagen!| ).

        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = mo_context->get_message_container( ).

      ENDIF.
    ENDIF.

**********************************************************************
* OPTIONAL
*
*    CALL FUNCTION 'DEQUEUE_EZALM_TODO'
*      EXPORTING
*        mode_zalm_fs_todos = 'E'              " Sperrmodus zur Tabelle ZALM_FS_TODOS
*        mandt              = sy-mandt         " 01. Enqueue Argument
*        id                 = ls_data-id                 " 02. Enqueue Argument
*        userid             = ls_data-userid                 " 03. Enqueue Argument
*       x_id               = space            " Argument 02 mit Initialwert belegen?
*       x_userid           = space            " Argument 03 mit Initialwert belegen?
*       _scope             = '3'
*       _synchron          = space            " Synchron entsperren
*       _collect           = ' '              " Sperre zunächst nur Sammeln
*      .
*    IF sy-subrc <> 0.
*      mo_context->get_message_container( )->add_message_text_only( iv_msg_type = 'E'
*                                                             iv_msg_text = |Entsperren fehlgeschlagen!| ).
*
*      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
*        EXPORTING
*          message_container = mo_context->get_message_container( ).
*    ENDIF.

**********************************************************************
*** VERBUCHUNG

  CALL FUNCTION 'ZALM_AF_TODO_WRITE_DOCUMENT'
    EXPORTING
      objectid                = CONV char90( sy-mandt && ls_data-id )
      tcode                   = sy-tcode
      utime                   = sy-uzeit
      udate                   = sy-datum
      username                = sy-uname
*      planned_change_number   = space
      object_change_indicator = 'I'
*      planned_or_real_changes = space
*      no_change_pointers      = space
*      upd_icdtxt_zalm_af_todo = space
      n_zalm_fs_todos         = ls_todo
*      o_zalm_fs_todos         =
      upd_zalm_fs_todos       = 'I'
*    TABLES
*      icdtxt_zalm_af_todo     =
    .







    er_entity = ls_data.

  ENDMETHOD.


  METHOD todosset_delete_entity.
    READ TABLE it_key_tab INTO DATA(ls_keys) INDEX 1.
    DELETE FROM zalm_fs_todos WHERE id = ls_keys-value.

    IF ( sy-subrc NE 0 ).
      mo_context->get_message_container( )->add_message_text_only(
      iv_msg_type = 'E'
      iv_msg_text = |Löschen fehlgeschlagen. Datensatz mit id { ls_keys-value } nicht gefunden!| ).

      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
        EXPORTING
          message_container = mo_context->get_message_container( ).
    ELSE.
      mo_context->get_message_container( )->add_message_text_only(
        iv_msg_type               =  'S'
        iv_msg_text               = |Product with id { ls_keys-value } successfully deleted!|
*        iv_error_category         =
*        iv_is_leading_message     = abap_true
*        iv_entity_type            =
*        it_key_tab                =
        iv_add_to_response_header = abap_true
*        iv_message_target         =
*        it_message_target         =
*        iv_omit_target            = abap_false
*        iv_is_transition_message  = abap_false
*        iv_content_id             =
      ).
    ENDIF.
  ENDMETHOD.


  METHOD todosset_get_entity.

*    AUTHORITY-CHECK OBJECT 'ZZALM'
*    ID 'TABLE' FIELD 'ZALM_FS_TODOS'
*    ID 'ACTVT' FIELD '03'
*    ID 'ZTBL' FIELD 'BLA01'.


    IF sy-subrc <> 0.
      MESSAGE |No Authorization access! | TYPE 'E'.
*     Implement a suitable exception handling here
    ENDIF.

    DATA ls_key TYPE zcl_zalm_fs_app_mpc=>ts_todos.

    io_tech_request_context->get_converted_keys(
      IMPORTING
        es_key_values = ls_key
    ).



    SELECT SINGLE * FROM zalm_fs_todos
    INTO CORRESPONDING FIELDS OF @er_entity
    WHERE userid = @ls_key-userid.


  ENDMETHOD.


  method TODOSSET_GET_ENTITYSET.


    SELECT * from ZALM_FS_TODOS into TABLE et_entityset.


  endmethod.


  method TODOSSET_UPDATE_ENTITY.
DATA ls_key TYPE zcl_zalm_fs_app_mpc=>ts_todos.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_key
    ).

    SELECT SINGLE * FROM zalm_fs_todos
    WHERE id = @ls_key-id
    INTO @DATA(ls_update).

      UPDATE zalm_fs_todos from ls_update.

      er_entity = ls_update.
  endmethod.


  method USERSSET_CREATE_ENTITY.
DATA ls_data TYPE zcl_zalm_fs_app_mpc=>ts_users.
    TRY.
        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_data
        ).
      CATCH /iwbep/cx_mgw_tech_exception.

        IF sy-subrc <> 0.

*          mo_context->get_message_container( )->add_message_text_only( iv_msg_type = 'E'
*                                                                       iv_msg_text = |Datensatz nicht erstellt.| ).
          RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
            EXPORTING
              textid = /iwbep/cx_mgw_busi_exception=>business_error
              message = 'THERE IS A PROBLEM IN CREATING A PODUCT INFORMATION'.
*              message_container = mo_context->get_message_container( ).
         ELSE.
           MOVE-CORRESPONDING ls_data TO er_entity.
           TRY.
           ls_data-uuid = CL_UUID_FACTORY=>create_system_uuid( )->create_uuid_c32( ).
           CATCH cx_uuid_error INTO DATA(e_text).
                MESSAGE e_text->get_text( ) TYPE 'I'.
           ENDTRY.
           INSERT INTO zalm_fs_users values er_entity.

        ENDIF.

    ENDTRY.
  endmethod.


  method USERSSET_GET_ENTITY.
    "Obsolete method...
*    READ TABLE it_key_tab into data(ls_key) INDEX 1.
*
*    data: lv_userId type char32.
*    lv_userId = ls_key-value.
*
*    SELECT SINGLE * FROM zalm_fs_users INTO CORRESPONDING FIELDS OF ER_ENTITY
*      WHERE id = lv_userid.

    DATA ls_key TYPE zcl_zalm_fs_app_mpc=>ts_users.

    io_tech_request_context->get_converted_keys(
      IMPORTING
        es_key_values = ls_key
    ).

    SELECT SINGLE * FROM zalm_fs_users
    WHERE id = @ls_key-id
    INTO CORRESPONDING FIELDS OF @er_entity.

  endmethod.


  method USERSSET_GET_ENTITYSET.

  DATA(gv_result) = io_tech_request_context->get_expand( ).


  DATA lt_ergebnis TYPE zcl_zalm_fs_app_mpc=>TT_USERS.
    DATA(lt_select) = io_tech_request_context->get_select( ).
    DATA(lt_order) = io_tech_request_context->get_orderby(  ).
    DATA(lv_count) = io_tech_request_context->has_count(  ).

    DATA(lr_filter) = io_tech_request_context->get_filter(  ).
    DATA(lv_filter_string) = lr_filter->get_filter_string( ).


    DATA lv_select_comma_sep_str TYPE string.

    IF lt_select IS NOT INITIAL.
    LOOP AT lt_select INTO DATA(lv_sel_property).
      CONCATENATE lv_select_comma_sep_str lv_sel_property ',' INTO lv_select_comma_sep_str.
     ENDLOOP.

    SHIFT lv_select_comma_sep_str RIGHT DELETING TRAILING `,`.

    ELSE.
      lv_select_comma_sep_str = '*'.
    ENDIF.


    DATA lv_sort TYPE string.

    IF lt_order IS INITIAL.
*      lt_order = VALUE #( (   order = 'asc'
*                          property = 'LASTNAME'
*                          property_path = 'LASTNAME'  ) ).
    ENDIF.

    LOOP AT lt_order INTO DATA(ls_order).

      IF sy-tabix = 1.
        lv_sort = |{ ls_order-property } { COND #( WHEN ls_order-order = 'desc'
                                                   THEN 'DESCENDING'
                                                   ELSE 'ASCENDING' )
                                        }|.
      ELSE.
        lv_sort = |{ lv_sort },{ ls_order-property } { COND #( WHEN ls_order-order = 'desc'
                                             THEN 'DESCENDING'
                                             ELSE 'ASCENDING' )
                                  }|.
      ENDIF.
    ENDLOOP.

    IF lv_sort IS INITIAL.

      SELECT (lv_select_comma_sep_str) FROM zalm_fs_users
        WHERE (lv_filter_string)
        INTO CORRESPONDING FIELDS OF TABLE @lt_ergebnis.

    ELSE.
      SELECT (lv_select_comma_sep_str) FROM zalm_fs_users
        WHERE (lv_filter_string)
        ORDER BY (lv_sort)
        INTO CORRESPONDING FIELDS OF TABLE @lt_ergebnis.
    ENDIF.

    IF io_tech_request_context->has_inlinecount(  ).
      es_response_context-inlinecount = lines( lt_ergebnis ).
    ENDIF.

    IF lv_count = abap_true.
      es_response_context-count = lines( lt_ergebnis ).
    ENDIF.

    et_entityset = lt_ergebnis.
  endmethod.


  method USERSSET_UPDATE_ENTITY.
 DATA ls_key TYPE zcl_zalm_fs_app_mpc=>ts_users.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_key
    ).

    SELECT SINGLE * FROM zalm_fs_users
    WHERE id = @ls_key-id
    INTO @DATA(ls_update).

*    CALL FUNCTION 'ENQUEUE_EZAF1_ITEM'
*      EXPORTING
*        id_i           = ls_update-id_i
*        _scope         = '2'
*      EXCEPTIONS
*        foreign_lock   = 1
*        system_failure = 2
*        OTHERS         = 3.
*    IF sy-subrc <> 0.
*      mo_context->get_message_container( )->add_message_text_only( iv_msg_type = 'E'
*                                                                   iv_msg_text = |Kein Zugriff auf Datenbank möglich!| ).
*
*      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
*        EXPORTING
*          message_container = mo_context->get_message_container( ).
*    ENDIF.
*    DATA(ls_old) = ls_update.
*    IF ls_update-amount + ls_key-amount < 1000000 OR ls_key-amount > 0.
*      ls_update-amount = ls_key-amount.
*    ELSE.
*      mo_context->get_message_container( )->add_message_text_only( iv_msg_type = 'E'
*                                                                      iv_msg_text = |Lagerkapazität überschritten.| ).
*
*      RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
*        EXPORTING
*          message_container = mo_context->get_message_container( ).
*    ENDIF.
    UPDATE zalm_fs_users FROM ls_update.

*    CALL FUNCTION 'Z_AF1_ITEM_WRITE_DOCUMENT'
*      EXPORTING
*        objectid                = CONV char90( sy-mandt && ls_update-id_i )
*        tcode                   = sy-tcode
*        utime                   = sy-uzeit
*        udate                   = sy-datum
*        username                = sy-uname
*        object_change_indicator = 'U'
*        n_zaf1_item             = ls_update
*        o_zaf1_item             = ls_old
*        upd_zaf1_item_bike      = 'U'.


    er_entity = ls_update.
  endmethod.


  method /IWBEP/IF_MGW_APPL_SRV_RUNTIME~EXECUTE_ACTION.

    DATA lt_todosCompleted  TYPE zcl_zalm_fs_app_mpc=>tt_todos.

    IF iv_action_name = 'completedTodos'. " Check what action is being requested
*      IF it_parameter IS NOT INITIAL.
      SELECT * FROM ZALM_FS_TODOS
        where completed = @abap_true
        INTO CORRESPONDING FIELDS OF TABLE @lt_todosCompleted  .
    ENDIF.

copy_data_to_ref( EXPORTING is_data = lt_todosCompleted
                  CHANGING cr_data = er_data ).
  endmethod.
ENDCLASS.
