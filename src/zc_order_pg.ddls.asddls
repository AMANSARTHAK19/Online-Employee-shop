@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'order'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity zc_order_pg
  as projection on zi_order_pg
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
  key EmployeeId,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key OrderId,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      EmployeeRole,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      EmployeeName,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      OrderStatus,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      CurrencyCode,
      @EndUserText.label: 'Total Bill'
      @Semantics.amount.currencyCode : 'CurrencyCode'
      _tblfn.total_bill as billamt,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      Notes,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      OrderCreationDate,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,

      _products : redirected to composition child zc_products_pg,
      _tblfn
}
