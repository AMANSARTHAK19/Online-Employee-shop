@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'product'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity zc_products_pg as projection on zi_products_pg
{
    key EmployeeId,
    key OrderId,
    key ProductId,
    ProductDescription,
    CurrencyCode,
    @Semantics.amount.currencyCode : 'CurrencyCode'
    ValuationPerUnit,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    
    _delivery : redirected to composition child zc_delivery_pg,
    _order : redirected to parent zc_order_pg
    
    
    
}
