tableextension 50203 SalesInvoiceHeader extends "Sales Invoice Header"
{
    fields
    {
        field(50200; "Comment 1"; Text[250])
        {
            Caption = 'Comment 1';
            DataClassification = ToBeClassified;
        }
        field(50201; "Comment 2"; Text[250])
        {
            Caption = 'Comment 2';
            DataClassification = ToBeClassified;
        }
        field(50202; "Comment 3"; Text[250])
        {
            Caption = 'Comment 3';
            DataClassification = ToBeClassified;
        }
        field(50203; "Created From Staging"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50204; "Staging Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50205; "Shortcut Dimension 3 Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            CaptionClass = '1,2,3';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3), "Blocked" = CONST(false));
        }
        field(50206; "Branch"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
}
