@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'delivery'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity zc_delivery_pg as projection on zi_delivery_pg
{
    key EmployeeId,
    key OrderId,
    key ProductId,
    QuantityUnit,
    @Semantics.quantity.unitOfMeasure : 'QuantityUnit'
    Quantity,
    CurrencyCode,
    @Semantics.amount.currencyCode : 'CurrencyCode'
    TotalProductPrice,
    ExpectedDeliveryDate,
    Address,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    
    _products : redirected to parent zc_products_pg,
    _order : redirected to zc_order_pg
}
