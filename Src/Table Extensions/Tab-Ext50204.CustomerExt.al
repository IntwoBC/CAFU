tableextension 50204 CustomerExt extends Customer
{
    fields
    {
        // field(50200; "Discount Calculation Type"; Option)
        // {
        //     OptionMembers = " ",Percentage,"Absolute discount per unit","Whichever is less";
        //     DataClassification = ToBeClassified;

        // }
        // field(50201; "Percentage"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     MaxValue = 100;
        // }
        // field(50202; "Absolute Discount Per Unit"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     MaxValue = 100;
        // }
        field(50203; "Invoicing Frequency"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Monthly,Weekly;
        }
        field(50204; "Branch"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50205; "Delivery Location"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50206; "Item"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if Item then
                    "Item Category" := false
            end;
        }
        field(50207; "Item Category"; Boolean)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "Item Category" then
                    Item := false
            end;
        }

    }
}
