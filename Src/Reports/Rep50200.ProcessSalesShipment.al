report 50200 "Process Sales Shipment"
{
    Caption = 'Process Sales Shipment';
    UseRequestPage = false;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Shipment Staging"; "Sales Shipment Staging")
        {
            DataItemTableView = sorting("Entry No.") order(ascending) where(Status = const("Ready To Ship"));

            trigger OnAfterGetRecord()
            begin
                ClearLastError();
                Commit();
                if not Codeunit.Run(Codeunit::"Process Sales Shipment", "Sales Shipment Staging") then begin
                    "Sales Shipment Staging".Status := "Sales Shipment Staging".Status::"Shipment Error";
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
