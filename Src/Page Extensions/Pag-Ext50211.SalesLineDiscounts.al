pageextension 50211 "Sales Line Discounts" extends "Sales Line Discounts"
{
    layout
    {
        addlast(Control1)
        {
            field("Discount Calculation Type"; Rec."Discount Calculation Type")
            {
                ApplicationArea = All;
                Enabled = (Rec."Minimum Quantity" = 0);

            }
            // field(Percentage; Rec."Line Discount %")
            // {
            //     ApplicationArea = All;
            //     Enabled = (Rec."Discount Calculation Type" = Rec."Discount Calculation Type"::Percentage) OR (Rec."Discount Calculation Type" = Rec."Discount Calculation Type"::"Whichever is less");

            // }
            field("Absolute Discount Per Unit"; Rec."Absolute Discount Per Unit")
            {
                ApplicationArea = All;
                DecimalPlaces = 0 : 4;
                Enabled = (Rec."Minimum Quantity" = 0) AND ((Rec."Discount Calculation Type" = Rec."Discount Calculation Type"::"Absolute discount per unit") OR (Rec."Discount Calculation Type" = Rec."Discount Calculation Type"::"Whichever is less"));
            }
        }
    }
}
