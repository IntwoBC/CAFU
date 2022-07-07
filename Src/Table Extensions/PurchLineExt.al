tableextension 50210 PurchLineExt extends "Purchase Line"
{
    fields
    {
        modify("Description 2")
        {
            Caption = 'Delivery Place';
        }
    }

    var
        myInt: Integer;
}