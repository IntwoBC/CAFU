codeunit 50205 "Sales Invoice Batch Processing"
{
    TableNo = "Sales Shipment Staging";

    trigger OnRun()
    var
        RecStaging: Record "Sales Shipment Staging";
    begin
        RecStaging.Copy(Rec);
        Code(RecStaging);
        Rec := RecStaging;

    end;

    local procedure "Code"(var RecSalesShipmentStaging: Record "Sales Shipment Staging")
    var
        SHeader: Record "Sales Header";
        RecLines: Record "Sales Line";
        SalesPost: Codeunit "Sales-Post";
        SalesGetShpt: Codeunit "Sales-Get Shipment";
        SalesShptLine: Record "Sales Shipment Line";
        StagingEntryNumberFilter: Text;
        EntryExists: Boolean;
    begin
        EntryExists := false;

        Clear(SHeader);
        SHeader.SetHideValidationDialog(true);
        SHeader.Init();
        SHeader.Validate("Document Type", SHeader."Document Type"::Invoice);
        SHeader.Insert(true);
        SHeader.Validate("Sell-to Customer No.", RecSalesShipmentStaging."Customer Code");
        SHeader.Validate("Posting Date", PostingDate);//RecSalesShipmentStaging."Date");
        SHeader.Validate("External Document No.", RecSalesShipmentStaging."LPO No.");
        SHeader.Validate("Ship-to Name", RecSalesShipmentStaging."Delivery Location Code");
        SHeader.Validate("Branch", RecSalesShipmentStaging.Branch);
        SHeader.Validate("Created From Staging", true);
        //SHeader.Validate("Staging Entry No.", RecSalesShipmentStaging."Entry No.");
        //Creating same header this time for multiple staging recordsfor same customer- thats why not entering staging entry no.
        SHeader.Modify();

        Clear(StagingEntryNumberFilter);
        SalesGetShpt.SetSalesHeader(SHeader);
        if RecSalesShipmentStaging.FindSet() then begin
            repeat
                Clear(SalesShptLine);
                SalesShptLine.SetRange("Document No.", RecSalesShipmentStaging."Sales Shipment No.");
                SalesShptLine.SetRange("Staging Entry No.", RecSalesShipmentStaging."Entry No.");
                if SalesShptLine.FindFirst() then begin
                    SalesGetShpt.CreateInvLines(SalesShptLine);
                end;
                StagingEntryNumberFilter := StagingEntryNumberFilter + FORMAT(RecSalesShipmentStaging."Entry No.") + '|';
            until RecSalesShipmentStaging.Next() = 0;
        end;

        Clear(RecLines);
        RecLines.SetRange("Document Type", RecLines."Document Type"::Invoice);
        RecLines.SetRange("Document No.", SHeader."No.");
        RecLines.SetRange(Type, RecLines.Type::Item);
        if RecLines.FindSet() then begin
            repeat
                RecLines.Validate(Quantity, RecLines.Quantity - 1);
                RecLines.Validate(Quantity, RecLines.Quantity + 1);
                RecLines.Modify();
            until RecLines.Next() = 0;
        end;
        SHeader.Invoice := true;
        SalesPost.Run(SHeader);

        //deleting sales order
        if StagingEntryNumberFilter <> '' then
            DeleteSalesOrder(StagingEntryNumberFilter);
    end;

    procedure SetPostingDate(Dt: Date)
    begin
        PostingDate := Dt;
    end;


    procedure DeleteSalesOrder(EntryNumber: Text)
    var
        SalesOrderHeader: Record "Sales Header";
        RecStaging: Record "Sales Shipment Staging";
        RecSalesShptLine: Record "Sales Shipment Line";
        RecSalesStaging: Record "Sales Shipment Staging";
    begin
        //Deleting sales order after invoicing
        Clear(SalesOrderHeader);
        Clear(RecSalesStaging);
        RecSalesStaging.SetFilter("Entry No.", CopyStr(EntryNumber, 1, StrLen(EntryNumber) - 1));
        if RecSalesStaging.FindSet() then begin
            repeat
                Clear(RecSalesShptLine);
                RecSalesShptLine.SetRange("Staging Entry No.", RecSalesStaging."Entry No.");
                if RecSalesShptLine.FindFirst() then begin
                    Clear(SalesOrderHeader);
                    SalesOrderHeader.SetRange("Document Type", SalesOrderHeader."Document Type"::Order);
                    SalesOrderHeader.SetRange("No.", RecSalesShptLine."Order No.");
                    if SalesOrderHeader.FindFirst() then begin
                        if IsCompletelyShippedAndInvoiced(SalesOrderHeader."No.") then begin
                            SalesOrderHeader.Delete(true)
                        end;
                    end;
                end;
            until RecSalesStaging.Next() = 0;
        end;
    end;

    local procedure IsCompletelyShippedAndInvoiced(orderNumber: code[20]): Boolean
    var
        RecLines: Record "Sales Line";
    begin
        Clear(RecLines);
        RecLines.SetRange("Document Type", RecLines."Document Type"::Order);
        RecLines.SetRange("Document No.", orderNumber);
        RecLines.SetRange(Type, RecLines.Type::Item);
        if RecLines.FindSet() then begin
            repeat
                if RecLines."Quantity Shipped" <> RecLines."Quantity Invoiced" then
                    exit(false);
            until RecLines.Next() = 0;
        end;
        exit(true);
    end;

    var
        PostingDate: Date;

}
