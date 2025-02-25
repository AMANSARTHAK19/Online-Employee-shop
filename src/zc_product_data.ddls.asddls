@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'product data'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity zc_product_data as projection on zi_product_data
{
    key ProductId,
    ProductDescription,
    CurrencyCode,
    @Semantics.amount.currencyCode : 'CurrencyCode'
    ValuationPerUnit,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt
}
