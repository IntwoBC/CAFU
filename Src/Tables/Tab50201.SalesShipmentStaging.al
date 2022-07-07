table 50201 "Sales Shipment Staging"
{
    Caption = 'Sales Shipment Staging';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; "Customer Code"; Code[20])
        {
            Caption = 'Customer Code';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(3; "Date"; Date)
        {
            Caption = 'Date';
            DataClassification = ToBeClassified;
        }
        field(4; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            TableRelation = Item;
        }
        field(5; UOM; Code[10])
        {
            Caption = 'UOM';
            DataClassification = ToBeClassified;
            TableRelation = "Unit of Measure";
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(7; "Vehicle No."; Text[50])
        {
            Caption = 'Vehicle No.';
            DataClassification = ToBeClassified;
        }
        field(8; "LPO No."; Code[30])
        {
            Caption = 'LPO No.';
            DataClassification = ToBeClassified;
        }
        field(9; "Delivery Location Code"; Text[100])
        {
            Caption = 'Delivery Location Code';
            DataClassification = ToBeClassified;
        }
        field(10; Branch; Code[20])
        {
            Caption = 'Branch';
            DataClassification = ToBeClassified;
        }
        field(11; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Ready To Ship","Shipped",Invoiced,"Shipment Error","Invoicing Error","Ready To Invoice";
            Editable = false;
        }
        field(12; "Error Remarks"; Text[250])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(13; "Sales Shipment No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "Sales Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50215; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), "Blocked" = CONST(false));
        }
        field(50216; Id; Guid)
        {
            DataClassification = ToBeClassified;
        }
        field(50217; "Transaction Id"; Code[50])
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                RecStaging: Record "Sales Shipment Staging";
            begin
                if Rec."Transaction Id" <> '' then begin
                    Clear(RecStaging);
                    RecStaging.SetRange("Transaction Id", Rec."Transaction Id");
                    RecStaging.SetRange("Entry No.", Rec."Entry No.");
                    if RecStaging.FindFirst() then
                        Error('Transaction ID already exists. Entry No. %1', Rec."Entry No.");
                end;
            end;
        }
        field(50218; "Time"; Text[15])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        Id := CreateGuid();
    end;

    trigger OnModify()
    begin
        if Rec.Status IN [Rec.Status::Invoiced, Rec.Status::"Ready To Invoice"] then begin
            if xRec.Status IN [xRec.Status::Invoiced, xRec.Status::"Ready To Invoice"] then begin
                Error('Modification is not allowed for Invoiced Records.');
            end;
        end;
    end;
}
