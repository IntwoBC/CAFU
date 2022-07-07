page 50201 "Sales Shipment Staging API"
{
    PageType = API;
    Caption = 'Sales Shipment Staging', Locked = true;
    ChangeTrackingAllowed = true;
    APIPublisher = 'InTWO';
    APIVersion = 'beta';
    APIGroup = 'Sales';
    EntityName = 'SalesShipment';
    EntitySetName = 'SalesShipments';
    SourceTable = "Sales Shipment Staging";
    DelayedInsert = true;
    ODataKeyFields = Id;


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Id; Rec.Id)
                {
                    ApplicationArea = All;
                }
                field("TransactionID"; Rec."Transaction Id")
                {
                    ApplicationArea = All;
                }
                field("CustomerCode"; Rec."Customer Code")
                {
                    ToolTip = 'Specifies the value of the Customer Code field.';
                    ApplicationArea = All;
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date  field.';
                    ApplicationArea = All;
                }
                field("Time"; Rec."Time")
                {
                    ApplicationArea = All;
                }
                field("ItemNo"; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item field.';
                    ApplicationArea = All;
                }
                field(UOM; Rec.UOM)
                {
                    ToolTip = 'Specifies the value of the UOM field.';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;
                }
                field("VehicleNo"; Rec."Vehicle No.")
                {
                    ToolTip = 'Specifies the value of the Vehicle No. field.';
                    ApplicationArea = All;
                }
                field("LPONo"; Rec."LPO No.")
                {
                    ToolTip = 'Specifies the value of the LPO No. field.';
                    ApplicationArea = All;
                }
                field("DeliveryLocationCode"; Rec."Delivery Location Code")
                {
                    ToolTip = 'Specifies the value of the Delivery Location field.';
                    ApplicationArea = All;
                }
                field(Branch; Rec.Branch)
                {
                    ToolTip = 'Specifies the value of the Branch field.';
                    ApplicationArea = All;
                }
                field("LOB"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        RecStaging: Record "Sales Shipment Staging";
    begin
        Rec.TestField("Transaction Id");
        Rec.TestField("Vehicle No.");

        Clear(RecStaging);
        RecStaging.SETRANGE("Transaction Id", Rec."Transaction Id");
        if RecStaging.FindFirst() then
            Error('Transaction ID already exists. Entry No. %1', RecStaging."Entry No.");

        Rec.Insert(true);

        Rec.Modify(true);
        exit(false);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Error('You do no have permission to delete the record. Please contact to your administrator.');
    end;

    trigger OnModifyRecord(): Boolean
    var
        RecStaging: Record "Sales Shipment Staging";
    begin
        Rec.TestField("Transaction Id");
        Rec.TestField("Vehicle No.");

        RecStaging.SETRANGE("Transaction Id", Rec."Transaction Id");
        RecStaging.FINDFIRST;

        if RecStaging.Status IN [RecStaging.Status::Invoiced, RecStaging.Status::"Ready To Invoice"] then begin
            Error('Modification is not allowed for Invoiced Records');
        end;

        RecStaging.TRANSFERFIELDS(Rec, FALSE);
        Rec.TRANSFERFIELDS(RecStaging);
    end;
}
