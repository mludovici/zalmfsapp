*&---------------------------------------------------------------------*
*& Report ZALM_FS_INS_UPRODRELATION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZALM_FS_INS_UPRODRELATION.

DATA lv_dauer TYPE i.
DATA: lt_reluprod TYPE STANDARD TABLE OF zalm_fs_reluprod.

DATA: lv_json TYPE string.

lv_json = `[{"userId":1,"productId":85},{"userId":1,"productId":8},{"userId":1,"productId":15},{"userId":2,"productId":29},{"userId":2,"productId":52},{"userId":2,"productId":16},{"userId":2,"productId":53},{"userId":2,"productId":7},{"userId":3,"pr` &&
`oductId":37},{"userId":3,"productId":60},{"userId":3,"productId":25},{"userId":3,"productId":52},{"userId":3,"productId":49},{"userId":4,"productId":66},{"userId":4,"productId":65},{"userId":4,"productId":24},{"userId":4,"productId":44},{"userId":5` &&
`,"productId":27},{"userId":5,"productId":61},{"userId":6,"productId":73},{"userId":6,"productId":67},{"userId":6,"productId":30},{"userId":6,"productId":93},{"userId":7,"productId":31},{"userId":7,"productId":85},{"userId":7,"productId":25},{"userI` &&
`d":8,"productId":37},{"userId":9,"productId":80},{"userId":9,"productId":72},{"userId":9,"productId":64},{"userId":10,"productId":49},{"userId":10,"productId":34},{"userId":10,"productId":97},{"userId":10,"productId":44},{"userId":10,"productId":56` &&
`},{"userId":11,"productId":69},{"userId":11,"productId":68},{"userId":12,"productId":84},{"userId":12,"productId":21},{"userId":12,"productId":87},{"userId":12,"productId":22},{"userId":12,"productId":90},{"userId":13,"productId":98},{"userId":13,"` &&
`productId":21},{"userId":13,"productId":76},{"userId":14,"productId":61},{"userId":15,"productId":6},{"userId":15,"productId":51},{"userId":15,"productId":25},{"userId":15,"productId":80},{"userId":15,"productId":72},{"userId":16,"productId":66},{"` &&
`userId":17,"productId":83},{"userId":17,"productId":14},{"userId":18,"productId":14},{"userId":18,"productId":19},{"userId":18,"productId":48},{"userId":19,"productId":48},{"userId":19,"productId":19},{"userId":20,"productId":44},{"userId":20,"prod` &&
`uctId":86},{"userId":20,"productId":66},{"userId":21,"productId":97},{"userId":21,"productId":87},{"userId":21,"productId":98},{"userId":22,"productId":72},{"userId":22,"productId":73},{"userId":22,"productId":92},{"userId":22,"productId":14},{"use` &&
`rId":23,"productId":28},{"userId":23,"productId":22},{"userId":24,"productId":66},{"userId":24,"productId":64},{"userId":25,"productId":12},{"userId":25,"productId":92},{"userId":25,"productId":34},{"userId":25,"productId":88},{"userId":25,"product` &&
`Id":26},{"userId":26,"productId":23},{"userId":26,"productId":86},{"userId":26,"productId":65},{"userId":26,"productId":7},{"userId":26,"productId":18},{"userId":27,"productId":73},{"userId":28,"productId":49},{"userId":29,"productId":50},{"userId"` &&
`:30,"productId":60},{"userId":30,"productId":12},{"userId":30,"productId":23},{"userId":30,"productId":42},{"userId":30,"productId":98},{"userId":31,"productId":9},{"userId":31,"productId":98},{"userId":31,"productId":23},{"userId":32,"productId":7` &&
`1},{"userId":33,"productId":82},{"userId":34,"productId":26},{"userId":34,"productId":41},{"userId":34,"productId":85},{"userId":34,"productId":81},{"userId":34,"productId":67},{"userId":35,"productId":94},{"userId":35,"productId":36},{"userId":36,` &&
`"productId":55},{"userId":36,"productId":1},{"userId":37,"productId":8},{"userId":38,"productId":43},{"userId":38,"productId":37},{"userId":38,"productId":75},{"userId":38,"productId":52},{"userId":39,"productId":47},{"userId":39,"productId":60},{"` &&
`userId":40,"productId":58},{"userId":40,"productId":54},{"userId":40,"productId":74},{"userId":40,"productId":80},{"userId":41,"productId":49},{"userId":41,"productId":91},{"userId":41,"productId":43},{"userId":41,"productId":5},{"userId":41,"produ` &&
`ctId":47},{"userId":42,"productId":70},{"userId":42,"productId":85},{"userId":42,"productId":11},{"userId":42,"productId":48},{"userId":43,"productId":55},{"userId":43,"productId":62},{"userId":43,"productId":4},{"userId":43,"productId":81},{"userI` &&
`d":43,"productId":25},{"userId":44,"productId":74},{"userId":44,"productId":86},{"userId":44,"productId":84},{"userId":45,"productId":7},{"userId":45,"productId":95},{"userId":45,"productId":53},{"userId":45,"productId":75},{"userId":46,"productId"` &&
`:61},{"userId":47,"productId":55},{"userId":47,"productId":16},{"userId":47,"productId":34},{"userId":47,"productId":41},{"userId":48,"productId":31},{"userId":48,"productId":20},{"userId":49,"productId":99},{"userId":49,"productId":50},{"userId":5` &&
`0,"productId":77},{"userId":50,"productId":96},{"userId":50,"productId":70}]`.

* JSON -> ABAP (iTab)
/ui2/cl_json=>deserialize(
  EXPORTING
    json             = lv_json
*    jsonx            =
    pretty_name      = /ui2/cl_json=>pretty_mode-camel_case
*    assoc_arrays     =
*    assoc_arrays_opt =
*    name_mappings    =
*    conversion_exits =
*    hex_as_base64    =
  CHANGING
    data             = lt_reluprod
).

DELETE FROM zalm_fs_reluprod.

get run time field lv_dauer.

INSERT zalm_fs_reluprod FROM TABLE lt_reluprod. "ACCEPTING DUPLICATE KEYS.

IF sy-subrc <> 0.
    MESSAGE 'Etwas ist schiefgelaufen!' TYPE 'E' DISPLAY LIKE 'S'.
ELSE.
    get run time field lv_dauer.
    DATA(rt) = lv_dauer DIV 1000.

    MESSAGE  `Insert Success! It took ` && rt  && ' microseconds ' TYPE 'I' DISPLAY LIKE 'S'.
ENDIF.


Write lv_dauer.
