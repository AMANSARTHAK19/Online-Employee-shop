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
    Notes,
    OrderCreationDate,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    
    _products : redirected to composition child zc_products_pg
}
