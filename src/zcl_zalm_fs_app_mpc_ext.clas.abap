class ZCL_ZALM_FS_APP_MPC_EXT definition
  public
  inheriting from ZCL_ZALM_FS_APP_MPC
  create public .

public section.
  METHODS define REDEFINITION.

  types: BEGIN OF TY_USERPRODUCTS ,
    INCLUDE TYPE ZCL_ZALM_FS_APP_MPC_EXT=>ts_users,
    toproducts TYPE STANDARD TABLE OF ZCL_ZALM_FS_APP_MPC_EXT=>ts_products WITH DEFAULT KEY,
    END OF TY_USERPRODUCTS.

      types: TT_USERPRODUCTS TYPE STANDARD TABLE OF TY_USERPRODUCTS.
protected section.
private section.
ENDCLASS.



CLASS ZCL_ZALM_FS_APP_MPC_EXT IMPLEMENTATION.


  METHOD define.
    "https://blogs.sap.com/2017/04/21/how-to-add-annotations-to-an-odata-service-using-code-based-implementation/
    super->define( ).

    DATA: lo_ann_target  TYPE REF TO /iwbep/if_mgw_vocan_ann_target.   " Vocabulary Annotation Target
    DATA: lo_ann_target2 TYPE REF TO /iwbep/if_mgw_vocan_ann_target.   " Vocabulary Annotation Target
    DATA: lo_annotation  TYPE REF TO /iwbep/if_mgw_vocan_annotation.   " Vocabulary Annotation
    DATA: lo_collection  TYPE REF TO /iwbep/if_mgw_vocan_collection.   " Vocabulary Annotation Collection
    DATA: lo_function    TYPE REF TO /iwbep/if_mgw_vocan_function.     " Vocabulary Annotation Function
    DATA: lo_fun_param   TYPE REF TO /iwbep/if_mgw_vocan_fun_param.    " Vocabulary Annotation Function Parameter
    DATA: lo_property    TYPE REF TO /iwbep/if_mgw_vocan_property.     " Vocabulary Annotation Property
    DATA: lo_record      TYPE REF TO /iwbep/if_mgw_vocan_record.       " Vocabulary Annotation Record
    DATA: lo_simp_value  TYPE REF TO /iwbep/if_mgw_vocan_simple_val.   " Vocabulary Annotation Simple Value
    DATA: lo_url         TYPE REF TO /iwbep/if_mgw_vocan_url.          " Vocabulary Annotation URL
    DATA: lo_label_elem  TYPE REF TO /iwbep/if_mgw_vocan_label_elem.   " Vocabulary Annotation Labeled Element
    DATA: lo_reference   TYPE REF TO /iwbep/if_mgw_vocan_reference.    " Vocabulary Annotation Reference



    lo_reference = vocab_anno_model->create_vocabulary_reference( iv_vocab_id = '/IWBEP/VOC_UI' iv_vocab_version = '0001').
    lo_reference->create_include( iv_namespace = 'com.sap.vocabularies.UI.v1' iv_alias = 'UI' ).

        "annotations for entity type Sales Order
    lo_ann_target = vocab_anno_model->create_annotations_target( 'Todos' ).
    lo_ann_target->set_namespace_qualifier( 'ZALM_FS_APP_SRV' ).    "change the namespace to the SRV namespace

    " Header Info
    lo_annotation = lo_ann_target->create_annotation( iv_term = 'UI.HeaderInfo' ).
    lo_record = lo_annotation->create_record( ).
    lo_record->create_property( 'TypeName' )->create_simple_value( )->set_string('Todo').
    lo_record->create_property( 'TypeNamePlural' )->create_simple_value( )->set_string( 'Todos').

    " Columns to be displayed by default
    lo_annotation = lo_ann_target->create_annotation( iv_term = 'UI.LineItem' ).
    lo_collection = lo_annotation->create_collection( ).

    lo_record = lo_collection->create_record( iv_record_type = 'UI.DataField' ).
    lo_property = lo_record->create_property( 'Label' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_string( 'Salesorder' ).
    lo_property = lo_record->create_property( 'Value' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_path( 'Salesorder' ).

    lo_record = lo_collection->create_record( iv_record_type = 'UI.DataField' ).
    lo_property = lo_record->create_property( 'Label' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_string( 'Customer' ).
    lo_property = lo_record->create_property( 'Value' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_path( 'Customer' ).

    lo_record = lo_collection->create_record( iv_record_type = 'UI.DataField' ).
    lo_property = lo_record->create_property( 'Label' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_string( 'Gross amount' ).
    lo_property = lo_record->create_property( 'Value' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_path( 'Grossamountintransaccurrency' ).

    lo_record = lo_collection->create_record( iv_record_type = 'UI.DataField' ).
    lo_property = lo_record->create_property( 'Label' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_string( 'Currency' ).
    lo_property = lo_record->create_property( 'Value' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_path( 'Transactioncurrency' ).



    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""2
      " The columns that are displayed in the header of the object page
      " are annotated using the ‘UI.Identification’ annotation
      " Columns to be displayed in the object page
    lo_annotation = lo_ann_target->create_annotation(
          EXPORTING
            iv_term       = 'UI.Identification' ).
    lo_collection = lo_annotation->create_collection( ).

    lo_record = lo_collection->create_record( iv_record_type = 'UI.DataField' ).
    lo_property = lo_record->create_property( 'Label' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_string( 'Salesorder' ).
    lo_property = lo_record->create_property( 'Value' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_path( 'Salesorder' ).

    lo_record = lo_collection->create_record( iv_record_type = 'UI.DataField' ).
    lo_property = lo_record->create_property( 'Label' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_string( 'Customer' ).
    lo_property = lo_record->create_property( 'Value' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_path( 'Customer' ).

    lo_record = lo_collection->create_record( iv_record_type = 'UI.DataField' ).
    lo_property = lo_record->create_property( 'Label' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_string( 'Lifecycle status' ).
    lo_property = lo_record->create_property( 'Value' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_path( 'Salesorderlifecyclestatus' ).

    lo_record = lo_collection->create_record( iv_record_type = 'UI.DataField' ).
    lo_property = lo_record->create_property( 'Label' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_string( 'Last changed at' ).
    lo_property = lo_record->create_property( 'Value' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_path( 'Lastchangeddatetime' ).

      " Gross amount to be displayed as a data point
    lo_annotation = lo_ann_target->create_annotation(
          EXPORTING
            iv_term      = 'UI.DataPoint'
            iv_qualifier = 'Grossamountintransaccurrency' ).
    lo_record = lo_annotation->create_record( iv_record_type = 'UI.DataField' ).
    lo_record->create_property( 'Value' )->create_simple_value( )->set_path('Grossamountintransaccurrency').
    lo_record->create_property( 'Title' )->create_simple_value( )->set_string( 'Gross amount' ).

     "Header Facets
    lo_collection = lo_ann_target->create_annotation( iv_term = 'UI.HeaderFacets' )->create_collection( ).

    "Facet for Sales Order Header Details on object page
    lo_record = lo_collection->create_record( iv_record_type = 'UI.ReferenceFacet' ).
    lo_record->create_property( 'ID' )->create_simple_value( )->set_string( 'GeneralInformation' ).
    lo_record->create_property( 'Label' )->create_simple_value( )->set_string( 'General Information' ).
    lo_record->create_property( 'Target')->create_simple_value( )->set_annotation_path( '@UI.Identification' ).

    "Facet for Gross amount
    lo_record = lo_collection->create_record( iv_record_type = 'UI.ReferenceFacet' ).
    lo_record->create_property( 'ID' )->create_simple_value( )->set_string( 'GrossAmount' ).
    lo_record->create_property( 'Label' )->create_simple_value( )->set_string( 'Gross amount' ).
    lo_record->create_property( 'Target')->create_simple_value( )->set_annotation_path( '@UI.DataPoint#Grossamountintransaccurrency' ).

    "Facet for Sales Order Header Details on object page
    lo_collection = lo_ann_target->create_annotation( iv_term = 'UI.Facets' )->create_collection( ).

    lo_record = lo_collection->create_record( iv_record_type = 'UI.ReferenceFacet' ).
    lo_record->create_property( 'ID' )->create_simple_value( )->set_string( 'ItemList' ).
    lo_record->create_property( 'Label' )->create_simple_value( )->set_string( 'Item List' ).
    lo_record->create_property( 'Target')->create_simple_value( )->set_annotation_path( 'ToItems/@UI.LineItem' ).

    "Add the columns headers of the object detail page
      "add annotations for sales order line items
    lo_ann_target2 = vocab_anno_model->create_annotations_target( 'SalesOrderItem' ).
    lo_ann_target2->set_namespace_qualifier( 'ZE2E100_XX_3_SRV' ).    "change the namespace to the SRV namespace

    " Columns to be displayed by default
    lo_annotation = lo_ann_target2->create_annotation( iv_term = 'UI.LineItem' ).
    lo_collection = lo_annotation->create_collection( ).

    lo_record = lo_collection->create_record( iv_record_type = 'UI.DataField' ).
    lo_property = lo_record->create_property( 'Label' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_string( 'Salesorder' ).
    lo_property = lo_record->create_property( 'Value' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_path( 'Salesorder' ).

    lo_record = lo_collection->create_record( iv_record_type = 'UI.DataField' ).
    lo_property = lo_record->create_property( 'Label' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_string( 'Item' ).
    lo_property = lo_record->create_property( 'Value' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_path( 'Salesorderitem' ).

    lo_record = lo_collection->create_record( iv_record_type = 'UI.DataField' ).
    lo_property = lo_record->create_property( 'Label' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_string( 'Gross amount' ).
    lo_property = lo_record->create_property( 'Value' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_path( 'Grossamountintransaccurrency' ).

    lo_record = lo_collection->create_record( iv_record_type = 'UI.DataField' ).
    lo_property = lo_record->create_property( 'Label' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_string( 'Currency' ).
    lo_property = lo_record->create_property( 'Value' ).
    lo_simp_value = lo_property->create_simple_value( ).
    lo_simp_value->set_path( 'Transactioncurrency' ).

  ENDMETHOD.
ENDCLASS.
