tableextension 50207 "SalesNReceivable Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50200; "Customized Sales Order Nos."; code[20])
        {
            Caption = 'CAFU Sales Order Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}
