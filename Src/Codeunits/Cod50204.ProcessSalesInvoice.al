codeunit 50204 "Process Sales Invoice"
{
    TableNo = "Sales Shipment Staging";

    trigger OnRun()
    var
        SHeader: Record "Sales Header";
        RecLines: Record "Sales Line";
        SalesPost: Codeunit "Sales-Post";
        SalesGetShpt: Codeunit "Sales-Get Shipment";
        SalesShptLine: Record "Sales Shipment Line";
        DeleteSalesOrder: report "Delete Invoiced Sales Orders";
        SalesOrderHeader: Record "Sales Header";
        EntryExists: Boolean;
    begin
        if Rec.Status = Rec.Status::Invoiced then
            exit;
        Rec.TestField(Status, Rec.Status::"Ready To Invoice");
        EntryExists := false;

        Clear(SHeader);
        SHeader.SetHideValidationDialog(true);
        SHeader.Init();
        SHeader.Validate("Document Type", SHeader."Document Type"::Invoice);
        SHeader.Insert(true);
        SHeader.Validate("Sell-to Customer No.", Rec."Customer Code");
        SHeader.Validate("Posting Date", Rec."Date");
        SHeader.Validate("External Document No.", Rec."LPO No.");
        SHeader.Validate("Ship-to Name", Rec."Delivery Location Code");
        //SHeader.Validate("Shortcut Dimension 3 Code", Rec.Branch);
        SHeader.Validate("Branch", Rec.Branch);
        SHeader.Validate("Created From Staging", true);
        SHeader.Validate("Staging Entry No.", Rec."Entry No.");
        SHeader.Modify();


        SalesShptLine.SetCurrentKey("Bill-to Customer No.");
        SalesShptLine.SetRange("Bill-to Customer No.", SHeader."Bill-to Customer No.");
        SalesShptLine.SetRange("Sell-to Customer No.", SHeader."Sell-to Customer No.");
        SalesShptLine.SetFilter("Qty. Shipped Not Invoiced", '<>0');
        SalesShptLine.SetRange("Currency Code", SHeader."Currency Code");
        SalesShptLine.SetRange("Authorized for Credit Card", false);
        SalesShptLine.SetRange("Staging Entry No.", Rec."Entry No.");//To get only lines that belongs to staging table
        SalesShptLine.FindSet();

        SalesGetShpt.SetSalesHeader(SHeader);
        SalesGetShpt.CreateInvLines(SalesShptLine);

        SHeader.Invoice := true;
        SalesPost.Run(SHeader);
        Clear(SalesOrderHeader);
        SalesOrderHeader.SetRange("Document Type", SalesOrderHeader."Document Type"::Order);
        SalesOrderHeader.SetRange("No.", SalesShptLine."Order No.");
        if SalesOrderHeader.FindFirst() then begin
            //report is validating for complete shipped and invoiced itself
            Clear(DeleteSalesOrder);
            DeleteSalesOrder.SetTableView(SalesOrderHeader);
            DeleteSalesOrder.Run();
        end
    end;

}
