pageextension 50212 PurchHeaderExt extends "Purchase Order"
{
    layout
    {
        addlast(General)
        {
            field(Subject; rec.Subject)
            {
                ApplicationArea = All;
            }
            field("Delivery/Lifting Time"; rec."Delivery/Lifting Time")
            {
                ApplicationArea = All;
            }
            field("Delivery Place"; rec."Delivery Place")
            {
                ApplicationArea = All;
            }
            field("Quality & Quantity "; rec."Quality & Quantity ")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}