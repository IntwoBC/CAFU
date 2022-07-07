permissionset 50200 CAFU
{
    Assignable = true;
    Caption = 'CAFu', MaxLength = 30;
    Permissions =
        table "Sales Shipment Staging" = X,
        tabledata "Sales Shipment Staging" = RMID,
        codeunit "Process Sales Shipment" = X,
        codeunit "Custom Events" = X,
        codeunit "Process Sales Invoice" = X,
        codeunit "Sales Invoice Batch Processing" = X,
        codeunit "Sales Price & Discount" = X,
        codeunit "Job Automation" = X,
        page "Sales Shipment Staging" = X,
        page "Sales Shipment Staging API" = X,
        report "Process Sales Shipment" = X,
        report "Process Sales Invoice" = X,
        report "Sales Invoice Batch Processing" = X,
        report "My Amount In Words" = X,
        report "Cafu Purchase Order" = X,
        report "Tax Invoice Report" = X,
        xmlport UploadSalesShipment = X;
}
