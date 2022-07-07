pageextension 50200 CompanyInfoPageExt extends "Company Information"
{
    layout
    {
        addafter(Picture)
        {
            field(Picture_LT; Rec.Picture_LT)
            {
                ApplicationArea = All;
            }
        }
    }
}
