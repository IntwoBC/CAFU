xmlport 50200 UploadSalesShipment
{
    Caption = 'Upload Sales Shipment';
    Direction = Import;
    Format = VariableText;
    TextEncoding = UTF8;
    FieldSeparator = ',';
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement("SalesShipmentStaging"; "Sales Shipment Staging")
            {
                textelement(TransactionId)
                {
                }
                textelement(CustomerCode)
                {

                }
                fieldelement("Date"; SalesShipmentStaging.Date)
                {
                }
                textelement("Time")
                {

                }
                textelement(ItemNo)
                {
                }
                textelement(UOM)
                {

                }
                textelement(Quantity)
                {
                }

                textelement(VehicleNo)
                {
                }
                textelement(LPO)
                {
                }
                textelement(LocationCode)
                {
                }
                textelement(Branch)
                {
                }
                textelement(LOB)
                {
                    MinOccurs = Zero;
                }


                trigger OnAfterInitRecord()
                begin
                    if Pagecaption = true then begin
                        Pagecaption := false;
                        currXMLport.Skip();
                    end;
                end;

                trigger OnBeforeInsertRecord()
                var
                    testdecimal: Decimal;
                    dt: Date;
                    RecSHeader: Record "Sales Header";
                    RecSLine: Record "Sales Line";
                    RecStaging: Record "Sales Shipment Staging";
                begin
                    if TransactionId = '' then
                        Error('Transaction ID must have value in Row No.%1', nRecNum + 1);

                    Clear(RecStaging);
                    RecStaging.SETRANGE("Transaction Id", TransactionId);
                    if RecStaging.FindFirst() then
                        Error('Transaction ID already exists. Entry No. %1', RecStaging."Entry No.");

                    if VehicleNo = '' then
                        Error('Vehicle No. must have value in Row No.%1', nRecNum + 1);

                    SalesShipmentStaging.Validate("Transaction Id", TransactionId);
                    SalesShipmentStaging.Validate("Customer Code", CustomerCode);
                    SalesShipmentStaging.Validate("Time", "Time");
                    SalesShipmentStaging.Validate("Item No.", ItemNo);

                    if LPO <> '' then begin
                        Clear(RecSHeader);
                        RecSHeader.SetRange("Document Type", RecSHeader."Document Type"::Order);
                        RecSHeader.SetRange("Sell-to Customer No.", CustomerCode);
                        RecSHeader.SetRange("External Document No.", LPO);
                        RecSHeader.FindSet();
                        Clear(RecSLine);
                        RecSLine.SetRange("Document Type", RecSLine."Document Type"::Order);
                        RecSLine.SetRange("Document No.", RecSHeader."No.");
                        RecSLine.SetRange(Type, RecSLine.Type::Item);
                        RecSLine.SetRange("No.", ItemNo);
                        RecSLine.FindFirst();
                    end;


                    // Evaluate(dt, "Date");
                    // SalesShipmentStaging.Validate("Date", dt);


                    SalesShipmentStaging.Validate(UOM, UOM);

                    if Quantity = '' then
                        testdecimal := 0
                    else
                        Evaluate(testdecimal, Quantity);
                    SalesShipmentStaging.Validate(Quantity, testdecimal);

                    SalesShipmentStaging.Validate("Vehicle No.", VehicleNo);
                    SalesShipmentStaging.Validate("LPO No.", LPO);
                    SalesShipmentStaging.Validate("Delivery Location Code", LocationCode);
                    SalesShipmentStaging.Validate(Branch, Branch);
                    if LOB <> '' then
                        SalesShipmentStaging.Validate("Shortcut Dimension 3 Code", LOB);
                    nRecNum += 1;
                    dlgProgress.UPDATE(1, nRecNum);
                end;
            }
        }
    }

    trigger OnPreXmlPort()
    begin
        Pagecaption := true;
        nRecNum := 0;
        dlgProgress.OPEN(tcProgress);
    end;

    trigger OnPostXmlPort()
    begin

        dlgProgress.CLOSE;
        Message('Total No. of records inserted: %1', nRecNum);
    end;


    var
        Pagecaption: Boolean;
        dlgProgress: Dialog;
        nRecNum: Integer;
        tcProgress: Label 'Uploading Records #1';
}
