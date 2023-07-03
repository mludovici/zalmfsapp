*&---------------------------------------------------------------------*
*& Report ZALM_FS_INS_COMPANIES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZALM_FS_INS_COMPANIES.

TYPES: BEGIN OF ls_company,
         mandt     TYPE mandt,
         id        TYPE num05_kk2,
         uuid       TYPE SYSUUID_C36,
         companyName      TYPE char50,
         catchPhrase TYPE string,
         sector TYPE char30,
         buzz type string,
         maybe type string,
         companyLogo type string,
       END OF ls_company.


DATA lv_dauer TYPE i.
DATA lt_company TYPE STANDARD TABLE OF ls_company WITH DEFAULT KEY.
DATA wa_todo TYPE ls_company.
DATA: lv_json TYPE string.

lv_json = `[{"id":1,"uuid":"6223f187-4116-45a7-adbe-608e991bd78c","companyName":"Cleem, Gruber und Grimm","catchPhrase":"Seamless needs-based success","sector":"Craft","buzz":"visualize B2B web-readiness","maybe":"Our company has 20 employees!","com` &&
`panyLogo":"https://loremflickr.com/800/600/logo"},{"id":2,"uuid":"29891045-e83c-4e0f-b968-dcb93b5dd0f6","companyName":"Linnenbaum Gruppe","catchPhrase":"Implemented 24 hour help-desk","sector":"Construction","buzz":"generate B2B portals","maybe":"O` &&
`ur company has 20 employees!","companyLogo":"https://loremflickr.com/800/600/logo"},{"id":3,"uuid":"d9657720-b7ad-45e9-b51a-de2222278ed3","companyName":"Dingelstedt-Keutel","catchPhrase":"Profound zero tolerance methodology","sector":"Agriculture",` &&
`"buzz":"target revolutionary experiences","companyLogo":"https://loremflickr.com/800/600/logo"},{"id":4,"uuid":"da61ac8e-40fc-4f90-b1d5-58cae4c197d3","companyName":"Freigang UG","catchPhrase":"Pre-emptive scalable website","sector":"IT","buzz":"uti` &&
`lize innovative markets","companyLogo":"https://loremflickr.com/800/600/logo"},{"id":5,"uuid":"227b9875-e4e4-4f52-be27-e4f97afe809b","companyName":"Simon-Engel","catchPhrase":"Polarised asynchronous data-warehouse","sector":"Retail","buzz":"grow on` &&
`e-to-one channels","companyLogo":"https://loremflickr.com/800/600/logo"},{"id":6,"uuid":"1a33e744-c20f-4d6f-ae1f-18a58ce8dca9","companyName":"Börner, Dahm und Mockenhaupt","catchPhrase":"Distributed neutral workforce","sector":"Tourism","buzz":"str` &&
`ategize strategic applications","companyLogo":"https://loremflickr.com/800/600/logo"},{"id":7,"uuid":"e1dc676f-839f-4ac3-a11e-21bb99d9ed19","companyName":"Wiebe GmbH & Co. KG","catchPhrase":"Vision-oriented solution-oriented application","sector":"` &&
`IT","buzz":"deploy clicks-and-mortar metrics","companyLogo":"https://loremflickr.com/800/600/logo"},{"id":8,"uuid":"0cefdf7f-6533-411f-84ac-7a529c44c411","companyName":"Paesler, Timmermann und Krohn","catchPhrase":"Reverse-engineered 4th generation` &&
` definition","sector":"Finance","buzz":"scale granular systems","companyLogo":"https://loremflickr.com/800/600/logo"},{"id":9,"uuid":"8207c933-6940-4615-8a1c-a9ed3640b665","companyName":"Vey-Prey","catchPhrase":"Virtual transitional structure","sec` &&
`tor":"Tourism","buzz":"unleash vertical interfaces","maybe":"Our company has 20 employees!","companyLogo":"https://loremflickr.com/800/600/logo"},{"id":10,"uuid":"c14deae6-1942-49db-ad18-e250070f0861","companyName":"Saile, Mensing und Uhlig","catch` &&
`Phrase":"Cross-platform empowering productivity","sector":"IT","buzz":"facilitate ubiquitous convergence","companyLogo":"https://loremflickr.com/800/600/logo"},{"id":11,"uuid":"41079efc-43a0-4a46-8391-e70f1a51ccf5","companyName":"Cleem, Auer und Kn` &&
`ippel","catchPhrase":"Centralized encompassing budgetary management","sector":"Agriculture","buzz":"aggregate mission-critical experiences","maybe":"Our company has 20 employees!","companyLogo":"https://loremflickr.com/800/600/logo"},{"id":12,"uuid` &&
`":"b131f244-4522-4f74-84e7-8381fca9e85a","companyName":"Rau KG","catchPhrase":"Future-proofed regional complexity","sector":"Tourism","buzz":"scale innovative e-markets","companyLogo":"https://loremflickr.com/800/600/logo"},{"id":13,"uuid":"6aa8e16` &&
`9-aa1e-4e8e-80ad-052f54dd8e4c","companyName":"Rokossa, Kluge und Kustermann","catchPhrase":"Decentralized mission-critical task-force","sector":"Construction","buzz":"benchmark cross-platform relationships","companyLogo":"https://loremflickr.com/80` &&
`0/600/logo"},{"id":14,"uuid":"c9b048e8-bdb9-4d6d-9df0-a21109cdaae7","companyName":"Dienel, Merseburg und Kick","catchPhrase":"User-centric background protocol","sector":"IT","buzz":"monetize leading-edge e-services","companyLogo":"https://loremflic` &&
`kr.com/800/600/logo"},{"id":15,"uuid":"fbcee1ec-30d8-4dcf-8ec3-ef879f05757a","companyName":"Riethmüller Gruppe","catchPhrase":"Customizable encompassing toolset","sector":"IT","buzz":"brand robust models","maybe":"Our company has 20 employees!","co` &&
`mpanyLogo":"https://loremflickr.com/800/600/logo"},{"id":16,"uuid":"75017c05-c7b2-420d-bf96-f04683dd8aec","companyName":"Hennes KG","catchPhrase":"Total zero defect moderator","sector":"Finance","buzz":"brand turn-key models","maybe":"Our company h` &&
`as 20 employees!","companyLogo":"https://loremflickr.com/800/600/logo"},{"id":17,"uuid":"9c79eb3e-991f-4492-8686-b23223cadd83","companyName":"Leschnik, Knobel und Leitheim","catchPhrase":"Synergistic regional firmware","sector":"Tourism","buzz":"re` &&
`purpose user-centric applications","companyLogo":"https://loremflickr.com/800/600/logo"},{"id":18,"uuid":"36232f25-04b6-4e46-82c4-08401db58db8","companyName":"Rose Gruppe","catchPhrase":"Synergized cohesive open architecture","sector":"Tourism","bu` &&
`zz":"implement mission-critical infrastructures","companyLogo":"https://loremflickr.com/800/600/logo"},{"id":19,"uuid":"11960658-0399-4da8-baef-78c2257c2cc1","companyName":"Heist AG","catchPhrase":"Optional mobile local area network","sector":"Cons` &&
`truction","buzz":"e-enable web-enabled metrics","companyLogo":"https://loremflickr.com/800/600/logo"},{"id":20,"uuid":"75853702-b707-4301-b742-94da20d36735","companyName":"Birkemeyer-Rosenbauer","catchPhrase":"Reduced coherent system engine","secto` &&
`r":"Agriculture","buzz":"scale virtual platforms","companyLogo":"https://loremflickr.com/800/600/logo"}]`.


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
    data             = lt_company
).

*cl_demo_output=>write_data( lv_json ).
*cl_demo_output=>write_data( lt_company[ 4 ]-buzz ).
*
*cl_demo_output=>write_data( lt_company[ 5 ]-catchphrase ).
*cl_demo_output=>display( lt_company[ 6 ] ).
*
DELETE FROM zalm_fs_company.
*
get run time field lv_dauer.
*
*
INSERT zalm_fs_company FROM TABLE lt_company. "ACCEPTING DUPLICATE KEYS.
*
**LOOP AT lt_todo into DATA(lv_todo).
**  INSERT zalm_fs_todos from lv_todo. "Loop in Workarea
**ENDLOOP.
*
** loop at lt_todo assigning <fs_todo>.  "Loop mit Field-Symbol
**      INSERT zalm_fs_todos from <fs_todo>.
**endloop.
*
*
get run time field lv_dauer.
Write lv_dauer.
