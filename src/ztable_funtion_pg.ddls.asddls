@EndUserText.label: 'table funtion'
@ClientHandling.type: #CLIENT_DEPENDENT
//@AccessControl.authorizationCheck: #NOT_REQUIRED
define table function ztable_funtion_pg
returns
{
  client      : abap.clnt;
  employee_id : z_employee_id_pg;
  order_id    : zorder_id_pg;
  currency_code : zcurrency_code_pg;
  total_product_price    : ztotal_product_price;
  @Semantics.amount.currencyCode : 'currency_code'
  total_bill  : zvaluation_pg;
 
}
implemented by method
  zcl_calculate_total_bill_pg=>get_data;