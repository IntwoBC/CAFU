codeunit 50203 "Custom Events"
{
    /*[EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterShowDimensions', '', false, false)]
    local procedure OnAfterShowDimensions(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line");
    var
        RecGLSetup: Record "General Ledger Setup";
        RecDimSetEntry: Record "Dimension Set Entry";
    begin
        if SalesLine."Dimension Set ID" <> xSalesLine."Dimension Set ID" then begin
            RecGLSetup.GET;
            CLEAR(RecDimSetEntry);
            IF RecDimSetEntry.GET(SalesLine."Dimension Set ID", RecGLSetup."Shortcut Dimension 3 Code") THEN
                SalesLine."Shortcut Dimension 3 Code" := RecDimSetEntry."Dimension Value Code";
        end;
    end;*/

    /*[EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnShowDocDimOnBeforeUpdateSalesLines', '', false, false)]
    local procedure OnShowDocDimOnBeforeUpdateSalesLines(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header");
    var
        RecGLSetup: Record "General Ledger Setup";
        RecDimSetEntry: Record "Dimension Set Entry";
    begin
        RecGLSetup.GET;
        CLEAR(RecDimSetEntry);
        IF RecDimSetEntry.GET(SalesHeader."Dimension Set ID", RecGLSetup."Shortcut Dimension 3 Code") THEN
            SalesHeader."Shortcut Dimension 3 Code" := RecDimSetEntry."Dimension Value Code";
    end;*/

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesShptLineInsert', '', false, false)]
    local procedure OnAfterSalesShptLineInsert(var SalesShipmentLine: Record "Sales Shipment Line"; SalesLine: Record "Sales Line"; ItemShptLedEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean; SalesInvoiceHeader: Record "Sales Invoice Header"; var TempWhseShptHeader: Record "Warehouse Shipment Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header"; SalesShptHeader: Record "Sales Shipment Header");
    var
        RecSalesShipmentStaging: Record "Sales Shipment Staging";
    begin
        if not (SalesLine."Document Type" IN [SalesLine."Document Type"::Order, SalesLine."Document Type"::Invoice]) then exit;
        if SalesLine."Staging Entry No." <> 0 then begin
            Clear(RecSalesShipmentStaging);
            RecSalesShipmentStaging.GET(SalesLine."Staging Entry No.");
            RecSalesShipmentStaging."Sales Shipment No." := SalesShipmentLine."Document No.";
            RecSalesShipmentStaging.Status := RecSalesShipmentStaging.Status::"Ready To Invoice";
            RecSalesShipmentStaging."Error Remarks" := '';
            RecSalesShipmentStaging.Modify();
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesInvLineInsert', '', false, false)]
    local procedure OnAfterSalesInvLineInsert(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean; var SalesHeader: Record "Sales Header"; var TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)"; var TempWhseShptHeader: Record "Warehouse Shipment Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header"; PreviewMode: Boolean);
    var
        RecSalesShipmentStaging: Record "Sales Shipment Staging";
    begin
        if not (SalesLine."Document Type" IN [SalesLine."Document Type"::Order, SalesLine."Document Type"::Invoice]) then exit;
        if SalesLine."Staging Entry No." <> 0 then begin
            Clear(RecSalesShipmentStaging);
            RecSalesShipmentStaging.GET(SalesLine."Staging Entry No.");
            RecSalesShipmentStaging."Sales Invoice No." := SalesInvLine."Document No.";
            RecSalesShipmentStaging.Status := RecSalesShipmentStaging.Status::Invoiced;
            RecSalesShipmentStaging."Error Remarks" := '';
            RecSalesShipmentStaging.Modify();
        end;
    end;

}
