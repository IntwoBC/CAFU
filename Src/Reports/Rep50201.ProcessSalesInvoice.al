report 50201 "Process Sales Invoice"
{
    Caption = 'Process Sales Invoice';
    UseRequestPage = false;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Shipment Staging"; "Sales Shipment Staging")
        {
            DataItemTableView = sorting("Entry No.") order(ascending) where(Status = const("Ready To Invoice"));

            trigger OnAfterGetRecord()
            begin
                ClearLastError();
                Commit();
                if not Codeunit.Run(Codeunit::"Process Sales Invoice", "Sales Shipment Staging") then begin
                    "Sales Shipment Staging".Status := "Sales Shipment Staging".Status::"Invoicing Error";
                    "Sales Shipment Staging"."Error Remarks" := CopyStr(GetLastErrorText(), 1, 250);
                    "Sales Shipment Staging".Modify();
                end;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
