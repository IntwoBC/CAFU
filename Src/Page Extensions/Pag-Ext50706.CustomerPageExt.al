pageextension 50206 CustomerPageExt extends "Customer Card"
{
    layout
    {
        addlast(Invoicing)
        {
            // field("Discount Calculation Type"; Rec."Discount Calculation Type")
            // {
            //     ApplicationArea = All;
            // }
            // field(Percentage; Rec.Percentage)
            // {
            //     ApplicationArea = All;
            //     Enabled = (Rec."Discount Calculation Type" = Rec."Discount Calculation Type"::Percentage) OR (Rec."Discount Calculation Type" = Rec."Discount Calculation Type"::"Whichever is less");
            // }
            // field("Absolute Discount Per Unit"; Rec."Absolute Discount Per Unit")
            // {
            //     ApplicationArea = All;
            //     Enabled = (Rec."Discount Calculation Type" = Rec."Discount Calculation Type"::"Absolute discount per unit") OR (Rec."Discount Calculation Type" = Rec."Discount Calculation Type"::"Whichever is less");
            // }
            field("Invoicing Frequency"; Rec."Invoicing Frequency")
            {
                ApplicationArea = All;
            }
            group("Additional Invoicing Criteria")
            {
                field(Branch; Rec.Branch)
                {
                    ApplicationArea = All;
                }
                field("Delivery Location"; Rec."Delivery Location")
                {
                    ApplicationArea = All;
                }
                field(Item; Rec.Item)
                {
                    ApplicationArea = All;
                }
                field("Item Category"; Rec."Item Category")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    /*trigger OnQueryClosePage(clsoeAction: Action): Boolean
    begin
        if Rec."Discount Calculation Type" = Rec."Discount Calculation Type"::Percentage then
            Rec.TestField(Percentage)
        else
            if Rec."Discount Calculation Type" = Rec."Discount Calculation Type"::"Absolute discount per unit" then
                Rec.TestField("Absolute Discount Per Unit")
            else
                if Rec."Discount Calculation Type" = Rec."Discount Calculation Type"::"Whichever is less" then begin
                    Rec.TestField(Percentage);
                    Rec.TestField("Absolute Discount Per Unit");
                end
    end;*/
}
