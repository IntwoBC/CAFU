codeunit 50202 "Process Sales Shipment"
{
    TableNo = "Sales Shipment Staging";

    trigger OnRun()
    var
        SHeader: Record "Sales Header";
        RecLines: Record "Sales Line";
        SalesPost: Codeunit "Sales-Post";
        RecSalesSetup: Record "Sales & Receivables Setup";
        NoSeries: Codeunit NoSeriesManagement;
        EntryExists: Boolean;
    begin
        RecSalesSetup.GET;
        RecSalesSetup.TestField("Customized Sales Order Nos.");
        Rec.TestField(Status, Rec.Status::"Ready To Ship");
        EntryExists := false;
        if Rec."LPO No." <> '' then begin
            Clear(SHeader);
            SHeader.SetHideValidationDialog(true);
            SHeader.SetRange("Document Type", SHeader."Document Type"::Order);
            SHeader.SetRange("Sell-to Customer No.", Rec."Customer Code");
            SHeader.SetRange("External Document No.", Rec."LPO No.");
            SHeader.SetRange("Created From Staging", false);// Not checking in the Auto created SO's
            if SHeader.FindFirst() then begin
                RecLines.SetRange("Document Type", RecLines."Document Type"::Order);
                RecLines.SetRange("Document No.", SHeader."No.");
                RecLines.SetRange("Completely Shipped", false);
                RecLines.SetRange(Type, RecLines.Type::Item);
                if RecLines.FindSet() then
                //comment
                begin
                    repeat
                        if RecLines."No." = Rec."Item No." then begin
                            EntryExists := true;
                            RecLines.SetHideValidationDialog(true);
                            RecLines.Validate("Qty. to Ship", Rec.Quantity);
                            RecLines.Validate("Vehicle No.", Rec."Vehicle No.");
                            RecLines.Validate(Branch, Rec.Branch);
                            RecLines.Validate("Shortcut Dimension 3 Code", Rec."Shortcut Dimension 3 Code");
                            RecLines.Validate("Staging Entry No.", Rec."Entry No.");
                            RecLines.Validate("Shipment Date", Rec."Date");
                        end else
                            RecLines.Validate("Qty. to Ship", 0);
                        RecLines.Modify();
                    until RecLines.Next() = 0;
                end;
                if not EntryExists then
                    Error('Sales Line does not exists for the LPO %1. Identification fields and values Sales Order No. %2', Rec."LPO No.", SHeader."No.");
                SHeader.Validate("Ship-to Name", Rec."Delivery Location Code");
                SHeader.Validate("Branch", Rec.Branch);
                SHeader.Validate("Shortcut Dimension 3 Code", Rec."Shortcut Dimension 3 Code");
                SHeader.Validate("Order Date", Rec."Date");
                SHeader.Modify();
                SHeader.Ship := true;
                SalesPost.Run(SHeader);
            end else
                Error('Sales Header does not exists for the LPO %1.', Rec."LPO No.");
        end else begin
            Clear(SHeader);
            SHeader.SetHideValidationDialog(true);
            SHeader.Init();
            SHeader.Validate("Document Type", SHeader."Document Type"::Order);
            SHeader.Validate("No.", NoSeries.GetNextNo(RecSalesSetup."Customized Sales Order Nos.", WorkDate(), true));
            SHeader.Insert(true);
            SHeader.Validate("Sell-to Customer No.", Rec."Customer Code");
            SHeader.Validate("Posting Date", Rec."Date");
            SHeader.Validate("Order Date", Rec."Date");
            SHeader.Validate("External Document No.", Rec."LPO No.");
            SHeader.Validate("Ship-to Name", Rec."Delivery Location Code");
            SHeader.Validate("Branch", Rec.Branch);
            SHeader.Validate("Shortcut Dimension 3 Code", Rec."Shortcut Dimension 3 Code");
            SHeader.Validate("Created From Staging", true);
            SHeader.Validate("Staging Entry No.", Rec."Entry No.");
            SHeader.Modify();
            Clear(RecLines);
            RecLines.Init();
            RecLines.SetHideValidationDialog(true);
            RecLines.Validate("Document Type", RecLines."Document Type"::Order);
            RecLines.Validate("Document No.", SHeader."No.");
            RecLines.Validate("Line No.", 10000);
            RecLines.Validate(Type, RecLines.Type::Item);
            RecLines.Validate("No.", Rec."Item No.");
            RecLines.Validate(Quantity, Rec.Quantity);
            RecLines.Validate("Vehicle No.", Rec."Vehicle No.");
            RecLines.Validate("Staging Entry No.", Rec."Entry No.");
            RecLines.Validate("Shortcut Dimension 3 Code", Rec."Shortcut Dimension 3 Code");
            RecLines.Validate("Branch", Rec.Branch);
            RecLines.Validate("Shipment Date", Rec."Date");
            RecLines.Insert(true);

            SHeader.Ship := true;
            SalesPost.Run(SHeader);
        end;
    end;

}
