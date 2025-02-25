CLASS zcl_calculate_total_bill_pg DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .
    CLASS-METHODS get_data FOR TABLE FUNCTION ztable_funtion_pg.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_calculate_total_bill_pg IMPLEMENTATION.
  METHOD get_data BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT
      OPTIONS READ-ONLY
      USING zdt_order_pg  zdt_delivery_pg.

    RETURN
    select
        o.client as client  ,
        o.employee_id as employee_id,
        o.order_id as order_id,
        o.currency_code as currency_code,
       sum ( d.total_product_price ) as total_product_price,
       sum( total_product_price ) as total_bill
      from zdt_order_pg as o
      inner join zdt_delivery_pg as d
        on o.client = d.client
        and o.employee_id = d.employee_id
        and o.order_id = d.order_id
        group by o.client , o.employee_id , o.order_id , o.currency_code;
  endmethod.
ENDCLASS.
