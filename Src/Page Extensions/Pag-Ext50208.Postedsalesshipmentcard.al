pageextension 50208 "Posted sales shipment card" extends "Posted Sales Shipment"
{
    layout
    {
        addlast(General)
        {
            field("Comment 1"; Rec."Comment 1")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Comment 2"; Rec."Comment 2")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Comment 3"; Rec."Comment 3")
            {
                ApplicationArea = All;
                Editable = false;
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
                Editable = false;
            }
        }
    }
}
