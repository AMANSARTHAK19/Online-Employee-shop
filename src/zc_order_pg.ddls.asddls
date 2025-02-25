@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'order'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity zc_order_pg as projection on zi_order_pg
{
    key EmployeeId,
    key OrderId,
    EmployeeRole,
    EmployeeName,
    OrderStatus,
    CurrencyCode,
    @EndUserText.label: 'Total Bill'
    @Semantics.amount.currencyCode : 'CurrencyCode'
   _tblfn.total_bill as billamt,
    Notes,
    OrderCreationDate,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    
    _products : redirected to composition child zc_products_pg,
    _tblfn
}
