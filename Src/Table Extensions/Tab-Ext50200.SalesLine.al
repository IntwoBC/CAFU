tableextension 50200 "Sales Line" extends "Sales Line"
{
    fields
    {
        field(50201; "Vehicle No."; Text[50])
        {
            Caption = 'Vehicle No.';
            DataClassification = ToBeClassified;
        }

        field(50202; "C Standard Line Disc. Amt"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50203; "C Discount Calculation Type"; Option)
        {
            OptionMembers = " ",Percentage,"Absolute discount per unit","Whichever is less";
            DataClassification = ToBeClassified;
        }
        field(50204; "C Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
            MaxValue = 100;
        }
        field(50205; "C Absolute Discount Per Unit"; Decimal)
        {
            DataClassification = ToBeClassified;
            MaxValue = 100;
        }
        field(50206; "C Percentage Dis. Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
        }
        field(50207; "C Total Absolute Dis. Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 3;
        }

        field(50208; "LPO No."; Code[30])
        {
            Caption = 'LPO No.';
            DataClassification = ToBeClassified;
        }
        field(50209; "Delivery Location Code"; Text[100])
        {
            Caption = 'Delivery Location Code';
            DataClassification = ToBeClassified;
        }
        field(50210; Branch; Code[20])
        {
            Caption = 'Branch';
            DataClassification = ToBeClassified;
        }
        field(50212; "C Standard Line Disc. %"; Decimal)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                "C Standard Line Disc. Amt" := ("Unit Price" * Quantity) * "C Standard Line Disc. %" / 100;
            end;
        }
        field(50213; "Staging Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50214; Qty; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50215; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), "Blocked" = CONST(false));
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(3, "Shortcut Dimension 3 Code");
            end;
        }

        /* modify("No.")
         {
             trigger OnAfterValidate()
             var
                 RecHeader: Record "Sales Header";
                 RecCustomer: Record Customer;
             begin
                 if not (Rec."Document Type" IN [Rec."Document Type"::Order, Rec."Document Type"::Invoice]) then exit;
                 Clear(RecHeader);
                 RecHeader.GET(Rec."Document Type", Rec."Document No.");
                 Clear(RecCustomer);
                 RecCustomer.GET(RecHeader."Sell-to Customer No.");
                 Rec."C Discount Calculation Type" := RecCustomer."Discount Calculation Type";
                 Rec."C Percentage" := RecCustomer.Percentage;
                 Rec."C Absolute Discount Per Unit" := RecCustomer."Absolute Discount Per Unit";
             end;
         }*/
    }

}
