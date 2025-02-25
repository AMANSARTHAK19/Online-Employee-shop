@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'delivery'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_delivery_pg as select from zdt_delivery_pg
association to parent zi_products_pg as _products on $projection.EmployeeId = _products.EmployeeId 
and $projection.OrderId  = _products.OrderId and $projection.ProductId = _products.ProductId

association to zi_order_pg as _order on $projection.EmployeeId = _order.EmployeeId and 
$projection.OrderId = _order.OrderId

{
    key employee_id as EmployeeId,
    key order_id as OrderId,
    key product_id as ProductId,
    quantity_unit as QuantityUnit,
    @Semantics.quantity.unitOfMeasure : 'QuantityUnit'
    quantity as Quantity,
    currency_code as CurrencyCode,
    @Semantics.amount.currencyCode : 'CurrencyCode'
    total_product_price as TotalProductPrice,
    expected_delivery_date as ExpectedDeliveryDate,
    address as Address,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    last_changed_at as LastChangedAt,
    
    _products,
    _order
}
