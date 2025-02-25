CLASS lhc_zi_order_pg DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_order_pg RESULT result.

    METHODS Set_Status_Approved FOR MODIFY
      IMPORTING keys FOR ACTION zi_order_pg~Set_Status_Approved RESULT result.

    METHODS Set_Status_Reject FOR MODIFY
      IMPORTING keys FOR ACTION zi_order_pg~Set_Status_Reject RESULT result.

    METHODS Set_Status_Submitted FOR MODIFY
      IMPORTING keys FOR ACTION zi_order_pg~Set_Status_Submitted RESULT result.

    METHODS Filling_employee_details FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_order_pg~Filling_employee_details.

    METHODS setInitailCreatedDate FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_order_pg~setInitailCreatedDate.

    METHODS setInitialStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_order_pg~setInitialStatus.

    METHODS validateOrderId FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_order_pg~validateOrderId.

    METHODS validate_employee_id FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_order_pg~validate_employee_id.

ENDCLASS.

CLASS lhc_zi_order_pg IMPLEMENTATION.

  METHOD get_instance_authorizations.
    LOOP AT keys INTO DATA(key).

      SELECT SINGLE * FROM zdt_order_pg
        WHERE employee_id = @key-EmployeeId
          AND order_id = @key-OrderId
        INTO @DATA(order).

      " Check if the current user is the manager (CB9980009057)
      DATA(is_manager) = COND #(
        WHEN sy-uname = 'CB9980009057' THEN abap_true
        ELSE abap_false
      ).

      " Define authorization logic for Set_Status_Approved
      DATA(set_status_approved) = COND #(
        WHEN order-order_status = 'SUBMITTED' AND is_manager = abap_true
             THEN if_abap_behv=>auth-allowed
*        WHEN order-order_status = 'REJECT' AND is_manager = abap_true
*             THEN if_abap_behv=>auth-allowed
        ELSE if_abap_behv=>auth-unauthorized
      ).

      " Define authorization logic for Set_Status_Reject
      DATA(set_status_reject) = COND #(
        WHEN order-order_status = 'SUBMITTED' AND is_manager = abap_true
             THEN if_abap_behv=>auth-allowed
*        WHEN order-order_status = 'APPROVED' AND is_manager = abap_true
*             THEN if_abap_behv=>auth-allowed
        ELSE if_abap_behv=>auth-unauthorized
      ).

      " Define authorization logic for Set_Status_Submitted
      DATA(set_status_submitted) = COND #(
        WHEN is_manager = abap_true " Disable Submit for manager
             THEN if_abap_behv=>auth-unauthorized
        WHEN order-order_status = 'SUBMITTED' OR
             order-order_status = 'APPROVED' OR
             order-order_status = 'REJECT'
             THEN if_abap_behv=>auth-unauthorized " Disable Submit for these statuses
        ELSE if_abap_behv=>auth-allowed
      ).

      " Append the result with the authorization status for each action
      APPEND VALUE #(
        EmployeeId = key-EmployeeId
        OrderId = key-OrderId
        %action-Set_Status_Approved = set_status_approved
        %action-Set_Status_Reject = set_status_reject
        %action-Set_Status_Submitted = set_status_submitted
      ) TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD Set_Status_Approved.
    READ ENTITIES OF zi_order_pg IN LOCAL MODE
    ENTITY zi_order_pg ALL FIELDS WITH CORRESPONDING #( Keys )
    RESULT DATA(lt_order)
    FAILED DATA(lt_failed).

    LOOP AT lt_order ASSIGNING FIELD-SYMBOL(<fs_order>).
      SELECT SINGLE order_status
      FROM zdt_order_pg
      WHERE employee_id = @<fs_order>-EmployeeId AND order_id = @<fs_order>-OrderId
      INTO @DATA(lv_status).

*      IF lv_status = 'IN PROGRESS'.

      <fs_order>-OrderStatus = 'APPROVED'.

      MODIFY ENTITIES OF zi_order_pg IN LOCAL MODE
      ENTITY zi_order_pg
          UPDATE FIELDS ( orderStatus )
          WITH VALUE #( FOR ls_result IN lt_order INDEX INTO i (
                       %key-EmployeeId = <fs_order>-%key-EmployeeId
                       %key-orderId     = <fs_order>-%key-orderId
                           orderStatus = <fs_order>-orderStatus
                       %control  = VALUE #(
                                             orderStatus = if_abap_behv=>mk-on
                                           )
                       ) )
      FAILED   lt_failed
      REPORTED DATA(lt_reported)
      MAPPED   DATA(lt_mapped).

*displaying a success message
      INSERT VALUE #(
     %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Order is Approved Successfully' )
   ) INTO TABLE reported-zi_order_pg.

*      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD Set_Status_Reject.
    READ ENTITIES OF zi_order_pg IN LOCAL MODE
         ENTITY zi_order_pg ALL FIELDS WITH CORRESPONDING #( Keys )
         RESULT DATA(lt_order)
         FAILED DATA(lt_failed).

    LOOP AT lt_order ASSIGNING FIELD-SYMBOL(<fs_order>).
      SELECT SINGLE order_status
      FROM zdt_order_pg
      WHERE employee_id = @<fs_order>-EmployeeId AND order_id = @<fs_order>-OrderId
      INTO @DATA(lv_status).

*      IF lv_status = 'IN PROGRESS'.

      <fs_order>-OrderStatus = 'REJECT'.

      MODIFY ENTITIES OF zi_order_pg IN LOCAL MODE
      ENTITY zi_order_pg
          UPDATE FIELDS ( orderStatus )
          WITH VALUE #( FOR ls_result IN lt_order INDEX INTO i (
                       %key-EmployeeId = <fs_order>-%key-EmployeeId
                       %key-orderId     = <fs_order>-%key-orderId
                           orderStatus = <fs_order>-orderStatus
                       %control  = VALUE #(
                                             orderStatus = if_abap_behv=>mk-on
                                           )
                       ) )
      FAILED   lt_failed
      REPORTED DATA(lt_reported)
      MAPPED   DATA(lt_mapped).

*displaying a success message
      INSERT VALUE #(
     %msg = new_message_with_text( severity =
     if_abap_behv_message=>severity-success text = 'Order is Rejected Successfully' )
   ) INTO TABLE reported-zi_order_pg.

*      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD Set_Status_Submitted.
    READ ENTITIES OF zi_order_pg IN LOCAL MODE
         ENTITY zi_order_pg ALL FIELDS WITH CORRESPONDING #( Keys )
         RESULT DATA(lt_order)
         FAILED DATA(lt_failed).

    LOOP AT lt_order ASSIGNING FIELD-SYMBOL(<fs_order>).

      SELECT SINGLE order_status
      FROM zdt_order_pg
      WHERE employee_id = @<fs_order>-EmployeeId AND order_id = @<fs_order>-OrderId
      INTO @DATA(lv_status).

      IF lv_status = 'IN PROGRESS'.

        <fs_order>-OrderStatus = 'SUBMITTED'.

        MODIFY ENTITIES OF zi_order_pg IN LOCAL MODE
        ENTITY zi_order_pg
            UPDATE FIELDS ( orderStatus )
            WITH VALUE #( FOR ls_result IN lt_order INDEX INTO i (
                         %key-EmployeeId = <fs_order>-%key-EmployeeId
                         %key-orderId     = <fs_order>-%key-orderId
                             orderStatus = <fs_order>-orderStatus
                         %control  = VALUE #(
                                               orderStatus = if_abap_behv=>mk-on
                                             )
                         ) )
        FAILED   lt_failed
        REPORTED DATA(lt_reported)
        MAPPED   DATA(lt_mapped).

*displaying a success message
        INSERT VALUE #(
       %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success text = 'Order is Submitted Successfully' )
     ) INTO TABLE reported-zi_order_pg.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD Filling_employee_details.
    DATA : employeeDetail  TYPE zdt_employee_pg.

    READ ENTITIES OF zi_order_pg IN LOCAL MODE
          ENTITY zi_order_pg
          FIELDS ( employeeId OrderId ) WITH CORRESPONDING #( keys )
          RESULT DATA(orders).
    LOOP AT orders ASSIGNING FIELD-SYMBOL(<fs_order>).
      SELECT SINGLE * FROM zdt_employee_pg
        WHERE employee_id = @<fs_order>-EmployeeId INTO @employeeDetail.
      IF sy-subrc  = 0.
        <fs_order>-EmployeeName = employeeDetail-employee_name.
        <fs_order>-EmployeeRole  = employeeDetail-employee_role.
      ENDIF.
      MODIFY ENTITIES OF zi_order_pg IN LOCAL MODE
         ENTITY  zi_order_pg
          UPDATE FIELDS ( EmployeeName EmployeeRole )
          WITH VALUE #(  (  %key-EmployeeId = <fs_order>-%key-EmployeeId
                            %Key-orderId = <fs_order>-%key-orderId
                       EmployeeName  = <fs_order>-EmployeeName
                       EmployeeRole  = <fs_order>-EmployeeRole
*                       OrderCreationDate  = <fs_order>-OrderCreationDate

                           %control = VALUE #(
                           EmployeeName = if_abap_behv=>mk-on
                           EmployeeRole = if_abap_behv=>mk-on
*                           OrderCreationDate = if_abap_behv=>mk-on
                            ) ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD setInitailCreatedDate.
    READ ENTITIES OF zi_order_pg IN LOCAL MODE
            ENTITY zi_order_pg
            FIELDS ( OrderCreationDate  ) WITH CORRESPONDING #( keys )
            RESULT DATA(order).

    DATA(current_date) = cl_abap_context_info=>get_system_date( ) .
    LOOP AT order ASSIGNING FIELD-SYMBOL(<fs_order>).
      <fs_order>-OrderCreationDate = current_date.
    ENDLOOP.

    MODIFY ENTITIES OF zi_order_pg IN LOCAL MODE
           ENTITY  zi_order_pg
            UPDATE FIELDS ( OrderCreationDate )
            WITH VALUE #(  (  %key-EmployeeId = <fs_order>-%key-EmployeeId
                              %Key-orderId = <fs_order>-%key-orderId
                              OrderCreationDate  = <fs_order>-OrderCreationDate
                             %control = VALUE #(
                             OrderCreationDate = if_abap_behv=>mk-on
                              ) ) ).

  ENDMETHOD.

  METHOD setInitialStatus.
    READ ENTITIES OF zi_order_pg IN LOCAL MODE
            ENTITY zi_order_pg
            FIELDS ( orderStatus ) WITH CORRESPONDING #( keys )
            RESULT DATA(order).

    LOOP AT order ASSIGNING FIELD-SYMBOL(<fs_order>).
      <fs_order>-OrderStatus = 'IN PROGRESS'.

      MODIFY ENTITIES OF zi_order_pg IN LOCAL MODE
     ENTITY  zi_order_pg
      UPDATE FIELDS ( OrderStatus )
      WITH VALUE #(  (  %key-EmployeeId = <fs_order>-%key-EmployeeId
                        %Key-orderId = <fs_order>-%key-orderId
                   OrderStatus  = <fs_order>-orderStatus

                       %control = VALUE #(
                       orderStatus = if_abap_behv=>mk-on
                        ) ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD validateOrderId.
    DATA(is_order_id_valid) = abap_false.

    READ ENTITIES OF zi_order_pg IN LOCAL MODE
        ENTITY zi_order_pg
        FIELDS ( OrderId ) WITH CORRESPONDING #( keys )
        RESULT DATA(orders).

    LOOP AT orders ASSIGNING FIELD-SYMBOL(<order>).
*      DATA(order_id) = <order>-OrderId.

      IF <order>-OrderId CP 'ORD*'.
        DATA(order_numeric_part) = substring( val = <order>-OrderId off = 3 ).

        IF order_numeric_part CO '0123456789' AND strlen( order_numeric_part ) > 0.
          is_order_id_valid = abap_true.
        ELSE.
          reported-zi_order_pg = VALUE #( BASE reported-zi_order_pg
              ( %msg = new_message_with_text(
                  severity = if_abap_behv_message=>severity-error
                  text     = 'Please enter some numbers after ORD' )
              )
          ).
          RETURN.
        ENDIF.
      ELSE.
        reported-zi_order_pg = VALUE #( BASE reported-zi_order_pg
            ( %msg = new_message_with_text(
                severity = if_abap_behv_message=>severity-error
                text     = 'OrderId must start with "ORD" & followed by number' )
            )
        ).
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validate_employee_id.
    READ ENTITIES OF zi_order_pg IN LOCAL MODE
            ENTITY zi_order_pg
            FIELDS ( EmployeeId ) WITH CORRESPONDING #( keys )
            RESULT DATA(orders).
    DATA(emp_id) = orders[ 1 ]-EmployeeId.

    SELECT SINGLE employee_id FROM zdt_employee_pg
    WHERE employee_id = @emp_id INTO @DATA(result).
    IF sy-subrc IS NOT INITIAL.
      DATA(lv_text1) = 'Employee is not Valid' .
      APPEND VALUE #( %key = keys[ 1 ]-%key
                      %msg = new_message_with_text(
                      text = lv_text1
                      severity = if_abap_behv_message=>severity-error
                      )   ) TO reported-zi_order_pg.
      RETURN.
    ENDIF.
    SHIFT emp_id LEFT DELETING LEADING '0'.
    IF strlen( emp_id ) <> 5.
      DATA(lv_text2) = 'Employee ID should be 5 digits'.
      APPEND VALUE #( %key = keys[ 1 ]-%key
                      %msg = new_message_with_text(
                      text = lv_text2
                      severity = if_abap_behv_message=>severity-error
                      )   ) TO reported-zi_order_pg.
      RETURN.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
