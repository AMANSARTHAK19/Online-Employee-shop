CLASS lhc_zi_delivery_pg DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculate_product_price FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_delivery_pg~calculate_product_price.

    METHODS expactedDeliveryDate FOR DETERMINE ON SAVE
      IMPORTING keys FOR zi_delivery_pg~expactedDeliveryDate.

    METHODS validateQuantity FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_delivery_pg~validateQuantity.

    METHODS validProductId_in_delivery FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_delivery_pg~validProductId_in_delivery.

ENDCLASS.

CLASS lhc_zi_delivery_pg IMPLEMENTATION.

  METHOD calculate_product_price.
    READ ENTITIES OF zi_order_pg IN LOCAL MODE
          ENTITY zi_order_pg
          FIELDS ( CurrencyCode ) WITH CORRESPONDING #( keys )
          RESULT DATA(bill_currency_key).
    DATA(CurrencyKey) = bill_currency_key[ 1 ]-CurrencyCode.


    READ ENTITIES OF zi_order_pg IN LOCAL MODE
        ENTITY zi_delivery_Pg
        FIELDS ( Quantity ) WITH CORRESPONDING #( keys )
        RESULT DATA(Quantity_info).
    DATA(delivery_quantity) =  Quantity_info[ 1 ]-Quantity.
    DATA(delivery_employe_id)   = Quantity_info[ 1 ]-EmployeeId.
    DATA(delivery_product_id) = Quantity_info[ 1 ]-ProductId.

    SELECT SINGLE * FROM zdt_products_pg
    WHERE employee_id = @delivery_employe_id AND product_id = @delivery_product_id
    INTO @DATA(valuation_per_unit).
    IF sy-subrc IS INITIAL.
      LOOP AT Quantity_info ASSIGNING FIELD-SYMBOL(<fs_quantity>).
        <fs_quantity>-CurrencyCode   = CurrencyKey.
        <fs_quantity>-TotalProductPrice = valuation_per_unit-valuation_per_unit * delivery_quantity.
      ENDLOOP.
      MODIFY ENTITIES OF zi_order_pg IN LOCAL MODE
              ENTITY zi_delivery_pg
              UPDATE FIELDS ( CurrencyCode TotalProductPrice )
              WITH VALUE #(
                ( %key-EmployeeId = <fs_quantity>-%key-employeeId
                %key-orderId = <fs_quantity>-%key-orderId
                %key-ProductId = <fs_quantity>-%key-ProductId
                  CurrencyCode = <fs_quantity>-CurrencyCode
                  TotalProductPrice = <fs_quantity>-TotalProductPrice
                  %control = VALUE #(
                  CurrencyCode    = if_abap_behv=>mk-on
                    TotalProductPrice = if_abap_behv=>mk-on

                  )
                )
              ).
    ENDIF.
  ENDMETHOD.

  METHOD expactedDeliveryDate.
    READ ENTITIES OF zi_order_pg IN LOCAL MODE
        ENTITY zi_order_pg
        FIELDS ( OrderCreationDate ) WITH CORRESPONDING #( keys )
        RESULT DATA(CreationDate).
    CHECK CreationDate IS NOT INITIAL.
    DATA(created_date) = CreationDate[ 1 ]-OrderCreationDate.
*
*  " Read Expected Delivery Date
    READ ENTITIES OF zi_order_pg IN LOCAL MODE
      ENTITY zi_delivery_pg
      FIELDS ( ExpectedDeliveryDate ) WITH CORRESPONDING #( keys )
      RESULT DATA(DeliveryInfo).
    CHECK DeliveryInfo IS NOT INITIAL.
    LOOP AT DeliveryInfo ASSIGNING FIELD-SYMBOL(<deliveryinfo>).
      <deliveryinfo>-ExpectedDeliveryDate = created_date + 7.
    ENDLOOP.
    MODIFY ENTITIES OF zi_order_pg IN LOCAL MODE
            ENTITY zi_delivery_pg
            UPDATE FIELDS ( ExpectedDeliveryDate )
            WITH VALUE #(
              ( %key-EmployeeId = <deliveryinfo>-%key-employeeId
              %key-orderId = <deliveryinfo>-%key-orderId
              %key-ProductId = <deliveryinfo>-%key-ProductId
                ExpectedDeliveryDate = <deliveryinfo>-ExpectedDeliveryDate
                %control = VALUE #(
                  ExpectedDeliveryDate = if_abap_behv=>mk-on
                )
              )
            ).
  ENDMETHOD.

  METHOD validateQuantity.
    READ ENTITIES OF zi_order_pg IN LOCAL MODE
        ENTITY zi_delivery_Pg
        FIELDS ( Quantity ) WITH CORRESPONDING #( keys )
        RESULT DATA(result).
    LOOP AT result ASSIGNING FIELD-SYMBOL(<quantity>).
      IF <quantity>-Quantity >= 10.
        DATA(lv_text1) = 'Quantity Must be less then 10'.
        APPEND VALUE #(  %key-EmployeeId = <quantity>-%key-employeeId
          %key-orderId = <quantity>-%key-orderId
          %key-ProductId = <quantity>-%key-ProductId
                        %msg = new_message_with_text(
                        text = lv_text1
                        severity = if_abap_behv_message=>severity-error
                        )   ) TO reported-zi_delivery_pg.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validProductId_in_delivery.
*    READ ENTITIES OF zi_order_pg IN LOCAL MODE
*          ENTITY zi_delivery_Pg
*          FIELDS ( EmployeeId OrderId ProductId ) WITH CORRESPONDING #( keys )
*          RESULT DATA(result).
*    LOOP AT result ASSIGNING FIELD-SYMBOL(<res>).
*    ENDLOOP.
*
*    SELECT SINGLE * FROM  zdt_products_pg
*    WHERE employee_id = @<res>-EmployeeId AND order_id = @<res>-OrderId AND
*    product_id = @<res>-ProductId INTO @DATA(product).
*    IF sy-subrc IS NOT INITIAL.
*      DATA(lv_text) = 'Product Must be in Product table'.
*      APPEND VALUE #(  %key-EmployeeId = <res>-%key-employeeId
*        %key-orderId = <res>-%key-orderId
*        %key-ProductId = <res>-%key-ProductId
*                      %msg = new_message_with_text(
*                      text = lv_text
*                      severity = if_abap_behv_message=>severity-error
*                      )   ) TO reported-zi_delivery_pg.
*
*      RETURN.
*    ENDIF.
  ENDMETHOD.

ENDCLASS.
