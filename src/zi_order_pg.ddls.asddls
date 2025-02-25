@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'order'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zi_order_pg as select from zdt_order_pg
composition[0..*] of zi_products_pg as _products
{
    key employee_id as EmployeeId,
    key order_id as OrderId,
    employee_role as EmployeeRole,
    employee_name as EmployeeName,
    order_status as OrderStatus,
    currency_code as CurrencyCode,
    notes as Notes,
    order_creation_date as OrderCreationDate,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt,
    
    _products
}
