CLASS lhc_zi_products_pg DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS setProductDetails FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_products_pg~setProductDetails.

    METHODS validProductId FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_products_pg~validProductId.
ENDCLASS.

CLASS lhc_zi_products_pg IMPLEMENTATION.

  METHOD setProductDetails.

    READ ENTITIES OF zi_order_pg IN LOCAL MODE
                      ENTITY zi_order_pg
                      FIELDS ( CurrencyCode )
                      WITH CORRESPONDING #( keys )
                      RESULT DATA(Order_Currency_code).
    DATA(order_curr_code) = Order_Currency_code[ 1 ]-CurrencyCode.

    READ ENTITIES OF zi_order_pg IN LOCAL MODE
                    ENTITY zi_products_pg
                    FIELDS ( ProductId )
                    WITH CORRESPONDING #( keys )
                    RESULT DATA(OrderProduct).
    DATA(entered_productId) = OrderProduct[ 1 ]-ProductId.

    IF entered_productId IS NOT INITIAL.
      SELECT SINGLE * FROM zdt_product_data WHERE
      product_id = @entered_productId INTO @DATA(Product_details).
      IF sy-subrc NE 0.
        RETURN.
      ENDIF.
    ENDIF.
    LOOP AT OrderProduct ASSIGNING FIELD-SYMBOL(<product_info>).
      <product_info>-ProductDescription = Product_details-product_description.
      <product_info>-CurrencyCode = order_curr_code.
      <product_info>-ValuationPerUnit = Product_details-valuation_per_unit.

      MODIFY ENTITIES OF zi_order_pg IN LOCAL MODE
         ENTITY  zi_products_pg
          UPDATE FIELDS ( ProductDescription CurrencyCode ValuationPerUnit  )
          WITH VALUE #(  (  %key-EmployeeId = <product_info>-%key-EmployeeId
                            %Key-orderId = <product_info>-%key-orderId
                            %key-ProductId = <product_info>-%key-ProductId
                       ProductDescription  =  <product_info>-ProductDescription
                       CurrencyCode  = <product_info>-CurrencyCode
                       ValuationPerUnit = <product_info>-ValuationPerUnit
                           %control = VALUE #(
                           ProductDescription = if_abap_behv=>mk-on
                           CurrencyCode = if_abap_behv=>mk-on
                           ValuationPerUnit = if_abap_behv=>mk-on
                            ) ) ).
    ENDLOOP.
  ENDMETHOD.

  METHOD validProductId.
    READ ENTITIES OF zi_order_pg IN LOCAL MODE
                  ENTITY zi_products_pg
                  FIELDS ( ProductId )
                  WITH CORRESPONDING #( keys )
                  RESULT DATA(OrderProduct).
    DATA(product_id) = OrderProduct[ 1 ]-ProductId.
    IF product_id IS INITIAL.
      INSERT VALUE #(
     %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
     text = 'Invalid Product ID' )
   ) INTO TABLE reported-zi_order_pg.
      RETURN.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
