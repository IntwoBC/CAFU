pageextension 50210 SalesNReceivableSetup extends "Sales & Receivables Setup"
{
    layout
    {
        addlast("Number Series")
        {
            field("Customized Sales Order Nos."; Rec."Customized Sales Order Nos.")
            {
                ApplicationArea = All;
                Caption = 'CAFU Sales Order Nos.';
            }
        }
    }
}
