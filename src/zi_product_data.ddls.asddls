@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'product data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zi_product_data as select from zdt_product_data
{
    key product_id as ProductId,
    product_description as ProductDescription,
    currency_code as CurrencyCode,
    @Semantics.amount.currencyCode : 'CurrencyCode'
    valuation_per_unit as ValuationPerUnit,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt
}
