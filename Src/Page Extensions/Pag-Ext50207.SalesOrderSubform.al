pageextension 50207 SalesOrderSubform extends "Sales Order Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("Vehicle No."; Rec."Vehicle No.")
            {
                ApplicationArea = All;
            }
            field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
            {
                ApplicationArea = All;
            }
            field("C Standard Line Disc. %"; Rec."C Standard Line Disc. %")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            field("C Standard Line Disc. Amt"; Rec."C Standard Line Disc. Amt")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            field("C Discount Calculation Type"; Rec."C Discount Calculation Type")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            field("C Percentage"; Rec."C Percentage")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            field("C Percentage Dis. Amount"; Rec."C Percentage Dis. Amount")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            field("C Absolute Discount Per Unit"; Rec."C Absolute Discount Per Unit")
            {
                ApplicationArea = All;
                Enabled = false;
            }
            field("C Total Absolute Dis. Amount"; Rec."C Total Absolute Dis. Amount")
            {
                ApplicationArea = All;
                Enabled = false;
            }
        }
        modify("Line Discount Amount")
        {
            Visible = true;
        }
        moveafter("Line Discount %"; "Line Discount Amount")
    }
}
