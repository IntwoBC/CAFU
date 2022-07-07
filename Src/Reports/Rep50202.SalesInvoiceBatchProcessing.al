report 50202 "Sales Invoice Batch Processing"
{
    Caption = 'Sales Invoice Batch Processing';
    UseRequestPage = true;
    ProcessingOnly = true;

    dataset
    {

    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    field(InvoicingFrequency; InvoicingFrequency)
                    {
                        ApplicationArea = All;
                        Caption = 'Invoicing Frequency';
                        trigger OnValidate()
                        begin
                            if InvoicingFrequency = InvoicingFrequency::" " then begin
                                Error('Invoicing Frequency must have a value');
                            end
                        end;
                    }
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date';
                        trigger OnValidate()
                        begin
                            if InvoicingFrequency = InvoicingFrequency::Monthly then begin
                                if StartDate <> CALCDATE('-CM', StartDate) then
                                    Error('Date must be a start date of the month');
                            end else
                                if InvoicingFrequency = InvoicingFrequency::Weekly then begin
                                    if Date2DWY(StartDate, 1) <> 1 then
                                        Error('Date must be a start date of the week');
                                end else
                                    Error('Invoicing Frequency must have a value');
                        end;

                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date';
                        trigger OnValidate()
                        begin
                            if EndDate > WorkDate() then
                                Error('End Date must be less than current date');
                            if InvoicingFrequency = InvoicingFrequency::Monthly then begin
                                if EndDate <> CALCDATE('CM', EndDate) then
                                    Error('Date must be a last date of the month');
                            end else
                                if InvoicingFrequency = InvoicingFrequency::Weekly then begin
                                    if Date2DWY(EndDate, 1) <> 7 then
                                        Error('Date must be a last date of the week');
                                end else
                                    Error('Invoicing Frequency must have a value');
                        end;
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    var
        RecStaging: Record "Sales Shipment Staging";
        RecStaging1: Record "Sales Shipment Staging";
        RecStaging2: Record "Sales Shipment Staging";
        RecCustomer: Record Customer;
        SalesInvoiceBatchProcessing: Codeunit "Sales Invoice Batch Processing";
        AdditionalCombination: Text;
        CustomerCheckList: List of [Text];
        AdditionalCriteriaCheckList: List of [Text];
    begin
        Clear(CustomerCheckList);
        Clear(RecStaging);
        RecStaging.SetRange(Status, RecStaging.Status::"Ready To Invoice");
        RecStaging.SetRange("Date", StartDate, EndDate);
        if RecStaging.FindSet() then begin
            repeat
                Clear(RecCustomer);
                RecCustomer.GET(RecStaging."Customer Code");
                if RecCustomer."Invoicing Frequency" = InvoicingFrequency then begin
                    if not CustomerCheckList.Contains(RecStaging."Customer Code") then begin
                        CustomerCheckList.Add(RecStaging."Customer Code");
                        Clear(AdditionalCriteriaCheckList);
                        Clear(RecStaging1);
                        RecStaging1.SetRange(Status, RecStaging1.Status::"Ready To Invoice");
                        RecStaging1.SetRange("Date", StartDate, EndDate);
                        RecStaging1.SetRange("Customer Code", RecStaging."Customer Code");
                        if RecStaging1.FindSet() then begin
                            repeat
                                Clear(AdditionalCombination);
                                AdditionalCombination := RecStaging."Customer Code";

                                Clear(RecStaging2);
                                RecStaging2.SetRange(Status, RecStaging2.Status::"Ready To Invoice");
                                RecStaging2.SetRange("Date", StartDate, EndDate);
                                RecStaging2.SetRange("Customer Code", RecStaging."Customer Code");

                                if RecCustomer.Branch then begin
                                    RecStaging2.SetRange(Branch, RecStaging1.Branch);
                                    AdditionalCombination := AdditionalCombination + RecStaging1.Branch;
                                end;

                                if RecCustomer."Delivery Location" then begin
                                    RecStaging2.SetRange("Delivery Location Code", RecStaging1."Delivery Location Code");
                                    AdditionalCombination := AdditionalCombination + RecStaging1."Delivery Location Code";
                                end;

                                if RecCustomer.Item then begin
                                    RecStaging2.SetRange("Item No.", RecStaging1."Item No.");
                                    AdditionalCombination := AdditionalCombination + RecStaging1."Item No.";
                                end;

                                if not AdditionalCriteriaCheckList.Contains(AdditionalCombination) then begin
                                    AdditionalCriteriaCheckList.Add(AdditionalCombination);
                                    if RecStaging2.FindSet() then begin
                                        ClearLastError();
                                        Clear(SalesInvoiceBatchProcessing);
                                        Commit();
                                        SalesInvoiceBatchProcessing.SetPostingDate(EndDate);
                                        //if not Codeunit.Run(Codeunit::"Sales Invoice Batch Processing", RecStaging2) then begin
                                        if not SalesInvoiceBatchProcessing.Run(RecStaging2) then begin
                                            RecStaging2.ModifyAll(Status, RecStaging2.Status::"Invoicing Error");
                                            RecStaging2.ModifyAll("Error Remarks", CopyStr(GetLastErrorText(), 1, 250));
                                        end;
                                    end;
                                end;
                            until RecStaging1.Next() = 0;
                        end;
                    end;
                end;
            until RecStaging.Next() = 0;
        end;
    end;





    var
        InvoicingFrequency: Option " ",Monthly,Weekly;
        StartDate: Date;
        EndDate: Date;
}
