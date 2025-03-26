CLASS lhc_zi_employee_pg DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_employee_pg RESULT result.
    METHODS checkemployeid FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_employee_pg~checkemployeid.

ENDCLASS.

CLASS lhc_zi_employee_pg IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD checkemployeid.


*      LOOP AT keys INTO DATA(key).
*      SELECT * FROM zdt_employee_pg INTO TABLE @DATA(lt_emp).
*      LOOP AT lt_emp INTO DATA(wa_emp).
*        SELECT SINGLE * FROM zdt_employee_pg WHERE employee_id = @wa_emp-employee_id INTO @DATA(lwa_employee).
*      ENDLOOP.
*    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
