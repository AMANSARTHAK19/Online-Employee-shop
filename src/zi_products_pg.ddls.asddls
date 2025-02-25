@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'products'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_products_pg as select from zdt_products_pg
association to parent zi_order_pg as _order on $projection.EmployeeId = _order.EmployeeId 
and $projection.OrderId = _order.OrderId

composition[ 0..* ] of  zi_delivery_pg as _delivery 
{
    key employee_id as EmployeeId,
    key order_id as OrderId,
    key product_id as ProductId,
    product_description as ProductDescription,
    currency_code as CurrencyCode,
    @Semantics.amount.currencyCode : 'CurrencyCode'
    valuation_per_unit as ValuationPerUnit,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    last_changed_at as LastChangedAt,
    
    _order,
    _delivery
}
