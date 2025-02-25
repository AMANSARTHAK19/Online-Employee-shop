@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'employee'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity zc_employee_pg as projection on zi_employee_pg
{
    key EmployeeId,
    EmployeeName,
    EmployeeRole,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt
}
