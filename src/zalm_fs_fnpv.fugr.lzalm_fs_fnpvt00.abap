*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZALM_FS_TODOS...................................*
DATA:  BEGIN OF STATUS_ZALM_FS_TODOS                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZALM_FS_TODOS                 .
CONTROLS: TCTRL_ZALM_FS_TODOS
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZALM_FS_TODOS                 .
TABLES: ZALM_FS_TODOS                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
