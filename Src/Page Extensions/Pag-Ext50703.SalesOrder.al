pageextension 50203 "Sales Order" extends "Sales Order"
{
    layout
    {
        addlast(General)
        {
            field("Comment 1"; Rec."Comment 1")
            {
                ApplicationArea = All;
            }
            field("Comment 2"; Rec."Comment 2")
            {
                ApplicationArea = All;
            }
            field("Comment 3"; Rec."Comment 3")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("Ship-to Name")
        {
            field(Branch; Rec.Branch)
            {
                ApplicationArea = All;
            }
        }
    }
}
