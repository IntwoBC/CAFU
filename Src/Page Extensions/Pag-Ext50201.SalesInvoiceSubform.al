pageextension 50201 SalesInvoiceSubform extends "Sales Invoice Subform"
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

    actions
    {
        addlast("F&unctions")
        {
            action("Update Discount")
            {
                ApplicationArea = All;
                Image = ActivateDiscounts;
                Promoted = true;
                Ellipsis = true;
                trigger OnAction()
                var
                    RecLines: Record "Sales Line";
                begin
                    Clear(RecLines);
                    RecLines.SetRange("Document Type", RecLines."Document Type"::Invoice);
                    RecLines.SetRange("Document No.", Rec."Document No.");
                    RecLines.SetRange(Type, RecLines.Type::Item);
                    if RecLines.FindSet() then begin
                        repeat
                            RecLines.Validate(Quantity, RecLines.Quantity - 1);
                            RecLines.Validate(Quantity, RecLines.Quantity + 1);
                            RecLines.Modify();
                        until RecLines.Next() = 0;
                    end;
                end;
            }
        }
    }
}
