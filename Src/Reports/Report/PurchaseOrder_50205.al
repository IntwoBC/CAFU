report 50205 "Cafu Purchase Order"
{
    Caption = 'Purchase Order';
    UsageCategory = Administration;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\Reports\Report\Purchase Order.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name") { }
            column(No; "No.") { }
            column(Buy_from_Address; "Buy-from Address") { }
            column(Buy_from_Address_2; "Buy-from Address 2") { }
            column(Buy_from_City; "Buy-from City") { }
            column(Buy_from_Country_Region_Code; "Buy-from Country/Region Code") { }
            column(Buy_from_Post_Code; "Buy-from Post Code") { }
            column(Document_Date; "Document Date") { }
            column(Vendor_Invoice_No_; "Vendor Invoice No.") { }
            column(Subject; Subject) { }
            column(Delivery_Lifting_Time; "Delivery/Lifting Time") { }
            column(Delivery_Place; "Delivery Place") { }
            column(Quality___Quantity_; "Quality & Quantity ") { }
            column(CompInfoName; CompInfo.Name) { }
            column(CompInfoPic; CompInfo.Picture) { }
            column(CompInfoPic2; CompInfo.Picture_LT) { }
            column(CompInfoAdd; CompInfo.Address) { }
            column(CompInfoAdd2; CompInfo."Address 2") { }
            column(CompInfoCountryCode; CompInfo."Country/Region Code") { }
            column(CompInfo; CompInfo.City) { }
            column(CompInfoHomePage; CompInfo."Home Page") { }
            column(CompInfoCountry; CompInfo.County)
            {

            }
            column(CompInfoPhone; CompInfo."Phone No.")
            {

            }
            column(Payment_Terms_Code; "Payment Terms Code")
            {

            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = field("No.");

                column(SrNo; SrNo)
                {

                }
                column(Description; Description)
                {

                }
                column(Quantity; Quantity)
                {

                }
                column(Direct_Unit_Cost; "Direct Unit Cost")
                {

                }
                column(Description_2; "Description 2")
                {

                }
                column(Unit_of_Measure; "Unit of Measure")
                {

                }
                column(Amount_Including_VAT; "Amount Including VAT")
                {

                }
                column(VAT_Base_Amount; "VAT Base Amount")
                {

                }
                column(VAT__; "VAT %")
                {

                }
                column(GetLineAmountExclVAT; GetLineAmountExclVAT)
                {

                }
                trigger OnPreDataItem()
                begin
                    CompInfo.get();
                    CompInfo.CalcFields(Picture, Picture_LT);
                end;

                trigger
                OnAfterGetRecord()
                begin
                    if "Purchase Line".get() then
                        if SrNo = 0 then;
                    SrNo := SrNo + 1;
                end;
            }
        }
    }

    var
        myInt: Integer;
        CompInfo: Record "Company Information";
        SrNo: Integer;
}