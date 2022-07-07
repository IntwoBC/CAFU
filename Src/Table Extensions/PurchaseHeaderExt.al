tableextension 50209 PurchHeaderExt extends "Purchase Header"
{
    fields
    {
        field(50201; Subject; Text[250])
        {

        }
        field(50202; "Delivery/Lifting Time"; Text[50])
        {

        }
        field(50203; "Delivery Place"; Text[50])
        {

        }
        field(50204; "Quality & Quantity "; Text[50])
        {
            Caption = 'Quality & Quantity Determination';
        }
    }

    var
        myInt: Integer;
}