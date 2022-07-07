tableextension 50208 "Sales Line Discount" extends "Sales Line Discount"
{
    fields
    {
        field(50200; "Discount Calculation Type"; Option)
        {
            OptionMembers = " ",Percentage,"Absolute discount per unit","Whichever is less";
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "Line Discount %" = 0 then
                    Error('%1 must have a value.', Rec.FieldCaption("Line Discount %"));
            end;
        }
        // field(50201; "Percentage"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     MaxValue = 100;
        // }
        field(50202; "Absolute Discount Per Unit"; Decimal)
        {
            DataClassification = ToBeClassified;
            MaxValue = 100;
            DecimalPlaces = 0 : 4;

            trigger OnValidate()
            begin
                if "Line Discount %" = 0 then
                    Error('%1 must have a value.', Rec.FieldCaption("Line Discount %"));
                if Rec."Discount Calculation Type" IN [Rec."Discount Calculation Type"::"Absolute discount per unit", Rec."Discount Calculation Type"::"Whichever is less"] then
                    if Rec."Absolute Discount Per Unit" = 0 then
                        Error('%1 must have a value.', Rec.FieldCaption("Absolute Discount Per Unit"));

            end;
        }

        modify("Minimum Quantity")
        {
            trigger OnAfterValidate()
            begin
                if Rec."Minimum Quantity" <> 0 then begin
                    Rec."Discount Calculation Type" := Rec."Discount Calculation Type"::" ";
                    Rec."Line Discount %" := 0;
                    Rec."Absolute Discount Per Unit" := 0;
                end;
            end;
        }
    }
}
