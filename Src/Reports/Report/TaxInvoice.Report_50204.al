report 50204 "Tax Invoice Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Src\Reports\Report\TaxInvoice.rdl';
    Caption = 'Tax Invoice';
    PreviewMode = PrintLayout;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Sales Header"; "Sales Invoice Header")
        {
            DataItemTableView = SORTING("No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Invoice Header';
            CalcFields = Amount, "Amount Including VAT";
            column(External_Document_No_; "External Document No.") { }
            column(No_SalesHeader; "No.") { }
            column(PostingDate; "Posting Date") { }
            column(Due_Date; "Due Date") { }
            column(Currency_Code; CurrencyCode) { }
            column(VAT_Registration_No_; "VAT Registration No.") { }
            column(VATAmount; VATAmount) { }

            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(CompanyPicture; CompanyInfo.Picture) { }
                    column(CompanyPicture2; CompanyInfo.Picture_LT) { }
                    column(CompanyAddress1; CompanyAddr[1]) { }
                    column(CompanyAddress2; CompanyAddr[2]) { }
                    column(CompanyAddress3; CompanyAddr[3]) { }
                    column(CompanyAddress4; CompanyAddr[4]) { }
                    column(CompanyAddress5; CompanyAddr[5]) { }
                    column(CompanyAddress6; CompanyAddr[6]) { }
                    column(CompanyAddress7; CompanyAddr[7]) { }
                    column(CompanyAddress8; CompanyAddr[8]) { }
                    column(Delivered; DeliveredText) { }
                    column(CafuTruck; CafuTruckText) { }
                    column(CustomerAddr1; CustomerAddr[1]) { }
                    column(CustomerAddr2; CustomerAddr[2]) { }
                    column(CustomerAddr3; CustomerAddr[3]) { }
                    column(CustomerAddr4; CustomerAddr[4]) { }
                    column(CustomerAddr5; CustomerAddr[5]) { }
                    column(CustomerAddr6; CustomerAddr[6]) { }
                    column(CustomerAddr7; CustomerAddr[7]) { }
                    column(CustomerAddr8; CustomerAddr[8]) { }
                    column(BankDetails1; BankDetails[1]) { }
                    column(BankDetails2; BankDetails[2]) { }
                    column(BankDetails3; BankDetails[3]) { }
                    column(BankDetails4; BankDetails[4]) { }
                    column(BankDetails5; BankDetails[5]) { }
                    column(OutputNo; OutputNo) { }
                    column(TotalAmountInclVATInWords; TotalAmountInclVATInWords) { }

                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not DimSetEntry1.FindSet then
                                    CurrReport.Break();
                            end else
                                if not Continue then
                                    CurrReport.Break();

                            Clear(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := StrSubstNo('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(
                                        '%1, %2 %3', DimText, DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimSetEntry1.Next = 0;
                        end;

                        // trigger OnPreDataItem()
                        // begin
                        //     if not ShowInternalInfo then
                        //         CurrReport.Break();
                        // end;
                    }
                    dataitem("Sales Line"; "Sales Invoice Line")
                    {
                        DataItemLink = "Document No." = FIELD("No.");
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = SORTING("Document No.", "Line No.") where(Type = filter(<> ''));

                        // trigger OnPreDataItem()
                        // begin
                        //     CurrReport.Break();
                        // end;
                    }
                    dataitem(RoundLoop; "Integer")
                    {
                        DataItemTableView = SORTING(Number);
                        column(No_SalesLine; "Sales Line"."No.") { }
                        column(Desc_SalesLine; "Sales Line".Description) { }
                        column(Posting_Date; "Sales Line"."Posting Date") { }
                        column(Unit_of_Measure; "Sales Line"."Unit of Measure") { }
                        column(Quantity; "Sales Line".Quantity) { }
                        column(Unit_Price; "Sales Line"."Unit Price") { }
                        column(VAT__; "Sales Line"."VAT %") { }
                        column(LineVatAmount; LineVatAmount) { }
                        column(Line_Amount; "Sales Line"."Line Amount") { }
                        column(Amount_Including_VAT; "Sales Line"."Amount Including VAT") { }
                        column(QuantityTotal; QuantityTotal) { }
                        column(TaxableAmount; TaxableAmount) { }
                        column(TotalAmount; TotalAmount) { }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = SORTING(Number) WHERE(Number = FILTER(1 ..));

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry2.FindSet then
                                        CurrReport.Break();
                                end else
                                    if not Continue then
                                        CurrReport.Break();

                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            '%1, %2 %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.Next = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                // if not ShowInternalInfo then
                                //     CurrReport.Break();

                                DimSetEntry2.SetRange("Dimension Set ID", "Sales Line"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                                "Sales Line".Find('-')
                            else
                                "Sales Line".Next;
                            // "Sales Line" := SalesLine;

                            // if not "Sales Header"."Prices Including VAT" and
                            //    (SalesLine."VAT Calculation Type" = SalesLine."VAT Calculation Type"::"Full VAT")
                            // then
                            //     SalesLine."Line Amount" := 0;

                            // if (SalesLine.Type = SalesLine.Type::"G/L Account") then
                            //     "Sales Line"."No." := '';

                            LineVatAmount := "Sales Line"."Amount Including VAT" - "Sales Line"."Line Amount";
                            QuantityTotal += "Sales Line".Quantity;
                            TaxableAmount += "Sales Line"."Line Amount";
                            TotalAmount += "Sales Line"."Amount Including VAT";

                            if FixedLength > 24 then begin
                                OutputNo := OutputNo + 1;
                                FixedLength := 0;
                            end;
                            FixedLength := FixedLength + 1;
                        end;

                        trigger OnPostDataItem()
                        begin
                            SalesLine.DeleteAll();
                        end;

                        trigger OnPreDataItem()
                        begin
                            "Sales Line".SetRange("Document No.", "Sales Header"."No.");
                            MoreLines := "Sales Line".FindSet();
                            //MoreLines := SalesLine.Find('+');
                            // while MoreLines and (SalesLine.Description = '') and (SalesLine."Description 2" = '') and
                            //       (SalesLine."No." = '') and (SalesLine.Quantity = 0) and
                            //       (SalesLine.Amount = 0)
                            // do
                            //     MoreLines := SalesLine.Next(-1) <> 0;
                            // if not MoreLines then
                            //     CurrReport.Break();
                            // SalesLine.SetRange("Line No.", 0, SalesLine."Line No.");
                            SetRange(Number, 1, "Sales Line".Count);
                        end;
                    }

                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    }
                    dataitem(Total2; "Integer")
                    {
                        DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    }
                }

                trigger OnAfterGetRecord()
                var
                    SalesPost: Codeunit "Sales-Post";
                begin
                    Clear(SalesLine);
                    Clear(SalesPost);
                    SalesLine.DeleteAll();

                    if Number > 1 then begin
                        CopyText := FormatDocument.GetCOPYText;
                        OutputNo += 1;
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    if Print then
                        CODEUNIT.Run(CODEUNIT::"Sales-Printed", "Sales Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            var
                Customer: Record Customer;
                CountriesRegion: Record "Country/Region";
            begin
                QuantityTotal := 0;
                TaxableAmount := 0;
                VATAmount := 0;
                TotalAmount := 0;

                VATAmount := "Amount Including VAT" - Amount;

                if "Currency Code" <> '' then
                    CurrencyCode := '(' + "Currency Code" + ')';

                Customer.Get("Sell-to Customer No.");
                if CountriesRegion.Get(Customer."Country/Region Code") then;
                CustomerAddr[1] := "Sell-to Customer Name";
                CustomerAddr[2] := "Sell-to Address";
                CustomerAddr[3] := "Sell-to Address 2";
                CustomerAddr[4] := CountriesRegion.Name + ' ' + "Sell-to Post Code";
                CustomerAddr[5] := "Sell-to City";
                CustomerAddr[6] := "VAT Registration No.";
                CustomerAddr[7] := "Payment Terms Code";

                if BankAccount.Get(Bank) then begin
                    BankDetails[1] := 'Account Name : ' + CompanyInfo.Name;
                    BankDetails[2] := 'Bank : ' + BankAccount.Name;
                    BankDetails[3] := 'Swift Code : ' + BankAccount."SWIFT Code";
                    BankDetails[4] := 'Account No. : ' + BankAccount."Bank Account No.";
                    BankDetails[5] := 'IBAN : ' + BankAccount.IBAN;
                end;

                //Amount in Words VAT Amount
                IF "Amount Including VAT" <> 0 THEN BEGIN
                    CLEAR(DecimalValue);
                    CLEAR(DecimalValueInWords);
                    DecimalValue := ROUND("Amount Including VAT") MOD 1 * 100;
                    MyAmountInWords.InitTextVariable();
                    MyAmountInWords.FormatNoText(DecimalValueInWords, DecimalValue, '');
                    IF DecimalValueInWords[1] = '' THEN
                        DecimalValueInWords[1] := 'ZERO';

                    MyAmountInWords.FormatNoText(TotalAmountInclVATWords, "Amount Including VAT", '');
                    TotalAmountInclVATInWords := TotalAmountInclVATWords[1] + StrSubstNo(Text001, DecimalValue);
                END;
                //Amount in Words VAT Amount

            end;

            trigger OnPostDataItem()
            var
                Task: Record "To-do";
                ClientTypeMgt: Codeunit "Client Type Management";
            begin
                MarkedOnly := true;
                Commit();
                CurrReport.Language := GlobalLanguage;
                if not (ClientTypeMgt.GetCurrentClientType in [CLIENTTYPE::Web, CLIENTTYPE::Tablet, CLIENTTYPE::Phone, CLIENTTYPE::Desktop]) then
                    if GuiAllowed then
                        if Find('-') and Task.WritePermission then
                            if Print and (NoOfRecords = 1) then
                                if Confirm(Text007) then;
                //CreateTask;
            end;

            trigger OnPreDataItem()
            begin
                NoOfRecords := Count;
                if Delivered = 0 then
                    DeliveredText := 'DELIVERED'
                else
                    DeliveredText := 'EX-GATE';
                if CafuTruck = 0 then
                    CafuTruckText := 'CAFU Truck - FLEET'
                else
                    CafuTruckText := 'CAFU Truck - BULK';
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Delivered; Delivered)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Delivered';
                        OptionCaption = 'DELIVERED,EX-GATE';
                        ToolTip = 'Specifies the Delivered Options.';
                    }
                    field(CafuTruck; CafuTruck)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Cafu Truck';
                        OptionCaption = 'CAFU Truck - FLEET,CAFU Truck - BULK';
                        ToolTip = 'Specifies the cafutruck options.';
                    }
                    field(Bank; Bank)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank Info';
                        ToolTip = 'Specifies the list of banks';
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            BankListPL: Page "Bank Account List";
                            BankAccRL: Record "Bank Account";
                        begin
                            BankListPL.LookupMode := true;
                            if BankListPL.RunModal() = Action::LookupOK then begin
                                BankListPL.GetRecord(BankAccRL);
                                Bank := BankAccRL."No.";
                            end;
                        end;
                    }
                }
            }
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;

            case SalesSetup."Archive Quotes" of
                SalesSetup."Archive Quotes"::Never:
                    ArchiveDocument := false;
                SalesSetup."Archive Quotes"::Always:
                    ArchiveDocument := true;
            end;
        end;

        trigger OnOpenPage()
        begin
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get();
        SalesSetup.Get();
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents", CompanyInfo1, CompanyInfo2, CompanyInfo3);
    end;

    trigger OnPreReport()
    var
        CountriesRegion: Record "Country/Region";
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture, Picture_LT);
        if CountriesRegion.Get(CompanyInfo."Country/Region Code") then;
        CompanyAddr[1] := CompanyInfo.Name;
        CompanyAddr[2] := CompanyInfo.Address;
        CompanyAddr[3] := CompanyInfo."Address 2";
        CompanyAddr[4] := CountriesRegion.Name + ' ' + CompanyInfo.City;
        CompanyAddr[5] := CompanyInfo."Post Code";
        CompanyAddr[6] := CompanyInfo."VAT Registration No.";
        CompanyAddr[7] := CompanyInfo."Home Page";
    end;

    var
        FixedLength: Integer;
        CustomerAddr: array[8] of Text[100];
        Delivered: Option;
        DeliveredText: Text;
        CafuTruck: Option;
        CafuTruckText: Text;
        Bank: Code[20];
        BankAccount: Record "Bank Account";
        BankDetails: array[8] of Text[100];
        QuantityTotal: Decimal;
        TaxableAmount: Decimal;
        //VATAmount: Decimal;
        TotalAmount: Decimal;
        MyAmountInWords: Report "My Amount In Words";
        DecimalValue: Decimal;
        DecimalValueInWords: ARRAY[2] OF Text;
        TotalAmountInclVATWords: ARRAY[2] OF Text;
        TotalAmountInclVATInWords: Text;
        CurrencyCode: Text;
        LineVatAmount: Decimal;
        Text001: Label ' Dirhams & %1/100 ONLY';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        VATAmountLine: Record "VAT Amount Line" temporary;
        SalesLine: Record "Sales Invoice Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        CurrExchRate: Record "Currency Exchange Rate";
        Language: Codeunit Language;
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        ArchiveManagement: Codeunit ArchiveManagement;
        FormatDocument: Codeunit "Format Document";
        CustAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        Text007: Label 'Do you want to create a follow-up task?';
        NoOfRecords: Integer;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        Text008: Label 'VAT Amount Specification in ';
        Text009: Label 'Local Currency';
        Text010: Label 'Exchange rate: %1/%2';
        OutputNo: Integer;
        Print: Boolean;
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;

    procedure InitializeRequest(NoOfCopiesFrom: Integer; ShowInternalInfoFrom: Boolean; ArchiveDocumentFrom: Boolean; LogInteractionFrom: Boolean; PrintFrom: Boolean)
    begin
        NoOfCopies := NoOfCopiesFrom;
        ShowInternalInfo := true;
        ArchiveDocument := ArchiveDocumentFrom;
        LogInteraction := LogInteractionFrom;
        Print := PrintFrom;
    end;
}

