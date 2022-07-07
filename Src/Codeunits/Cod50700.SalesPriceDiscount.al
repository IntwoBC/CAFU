codeunit 50200 "Sales Price & Discount"
{
    trigger OnRun()
    var
        myInt: Integer;
    begin

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnBeforeFindSalesLineLineDisc', '', false, false)]
    local procedure OnBeforeFindSalesLineLineDisc(var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header"; var IsHandled: Boolean);
    var
        RecHeader: Record "Sales Header";
        RecLine: Record "Sales Line";
        Totalqty: Decimal;
    begin
        if not (SalesLine."Document Type" IN [SalesLine."Document Type"::Order, SalesLine."Document Type"::Invoice]) then exit;
        Clear(RecLine);
        RecLine.SetRange("Document Type", SalesLine."Document Type");
        RecLine.SetRange("Document No.", SalesLine."Document No.");
        RecLine.SetRange(Type, SalesLine.Type::Item);
        RecLine.SetRange("No.", SalesLine."No.");
        RecLine.SetFilter("Line No.", '<>%1', SalesLine."Line No.");
        if RecLine.FindSet() then begin
            repeat
                Totalqty += RecLine.Quantity;
            until RecLine.Next() = 0;
        end;
        SalesLine.Qty := SalesLine.Quantity;
        SalesLine.Quantity := Totalqty + SalesLine.Quantity;
    end;


    //To Store standard calculated line discount Amount
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Price Calc. Mgt.", 'OnAfterFindSalesLineLineDisc', '', true, true)]
    local procedure GetFinalDieselFleetDiscount(var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header"; var SalesLineDiscount: Record "Sales Line Discount")
    begin
        if not (SalesLine."Document Type" IN [SalesLine."Document Type"::Order, SalesLine."Document Type"::Invoice]) then exit;
        SalesLine.Quantity := SalesLine.Qty;
        SalesLine.Validate("C Standard Line Disc. %", SalesLine."Line Discount %");
        SalesLine."C Discount Calculation Type" := SalesLineDiscount."Discount Calculation Type";
        SalesLine."C Percentage" := SalesLineDiscount."Line Discount %";
        SalesLine."C Absolute Discount Per Unit" := SalesLineDiscount."Absolute Discount Per Unit";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateLineDiscountPercentOnBeforeUpdateAmounts', '', false, false)]
    local procedure OnValidateLineDiscountPercentOnBeforeUpdateAmounts(var SalesLine: Record "Sales Line"; CurrFieldNo: Integer);
    begin
        SalesLine."C Total Absolute Dis. Amount" := 0;
        SalesLine."C Percentage Dis. Amount" := 0;
        if not (SalesLine."Document Type" IN [SalesLine."Document Type"::Order, SalesLine."Document Type"::Invoice]) then exit;

        if (SalesLine."C Discount Calculation Type" <> SalesLine."C Discount Calculation Type"::" ") then begin

            if SalesLine."C Discount Calculation Type" = SalesLine."C Discount Calculation Type"::Percentage then begin
                if SalesLine.Quantity <> 0 then begin
                    SalesLine."C Percentage Dis. Amount" := ((SalesLine.Quantity * SalesLine."Unit Price") * SalesLine."C Percentage") / 100;
                    //  SalesLine.Validate("Line Discount Amount", (SalesLine."C Standard Line Disc. Amt" + ((SalesLine.Quantity * SalesLine."Unit Price") * SalesLine."C Percentage") / 100));
                    SalesLine.Validate("Line Discount Amount", (((SalesLine.Quantity * SalesLine."Unit Price") * SalesLine."C Percentage") / 100));

                end;

            end else
                if SalesLine."C Discount Calculation Type" = SalesLine."C Discount Calculation Type"::"Absolute discount per unit" then begin
                    if SalesLine.Quantity <> 0 then begin
                        SalesLine."C Total Absolute Dis. Amount" := (SalesLine."C Absolute Discount Per Unit" * SalesLine.Quantity);
                        // SalesLine.Validate("Line Discount Amount", SalesLine."C Standard Line Disc. Amt" + (SalesLine."C Absolute Discount Per Unit" * SalesLine.Quantity));
                        SalesLine.Validate("Line Discount Amount", (SalesLine."C Absolute Discount Per Unit" * SalesLine.Quantity));
                    end;
                end else
                    if SalesLine."C Discount Calculation Type" = SalesLine."C Discount Calculation Type"::"Whichever is less" then begin
                        SalesLine."C Percentage Dis. Amount" := ((SalesLine.Quantity * SalesLine."Unit Price") * SalesLine."C Percentage") / 100;
                        SalesLine."C Total Absolute Dis. Amount" := (SalesLine."C Absolute Discount Per Unit" * SalesLine.Quantity);
                        if SalesLine."C Percentage Dis. Amount" < SalesLine."C Total Absolute Dis. Amount" then
                            // SalesLine.Validate("Line Discount Amount", SalesLine."C Percentage Dis. Amount" + SalesLine."C Standard Line Disc. Amt")
                            SalesLine.Validate("Line Discount Amount", SalesLine."C Percentage Dis. Amount")

                        else
                            //SalesLine.Validate("Line Discount Amount", SalesLine."C Total Absolute Dis. Amount" + SalesLine."C Standard Line Disc. Amt")
                            SalesLine.Validate("Line Discount Amount", SalesLine."C Total Absolute Dis. Amount")
                    end;
        end else
            SalesLine.Validate("Line Discount Amount", SalesLine."C Standard Line Disc. Amt");

        UpdateLineDiscountForOtherSalesLine(SalesLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeTestQtyFromLindDiscountAmount', '', false, false)]
    local procedure OnBeforeTestQtyFromLindDiscountAmount(var SalesLine: Record "Sales Line"; CurrentFieldNo: Integer; var IsHandled: Boolean);
    begin
        IsHandled := True; // to avoid test quantity field
    end;

    //Not using below code as it will be recursive case and discount will also be wrong bcz it will add more discount along with new discount amount entered in the field
    //Kept this field open for exceptional discount.. for more values.. and If user want to reset discount they can revalidate the Quantity
    //↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
    /*[EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeValidateEvent', 'Line Discount Amount', false, false)]
    local procedure OnBeforeVaildateLineDiscountAmount(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        Rec."C Total Absolute Dis. Amount" := 0;
        Rec."C Percentage Dis. Amount" := 0;
        if not (Rec."Document Type" IN [Rec."Document Type"::Order, Rec."Document Type"::Invoice]) then exit;

        if (Rec."C Discount Calculation Type" <> Rec."C Discount Calculation Type"::" ") then begin

            if Rec."C Discount Calculation Type" = Rec."C Discount Calculation Type"::Percentage then begin
                if Rec.Quantity <> 0 then begin
                    Rec."C Percentage Dis. Amount" := ((Rec.Quantity * Rec."Unit Price") * Rec."C Percentage") / 100;
                    Rec.Validate("Line Discount Amount", Rec."Line Discount Amount" + (((Rec.Quantity * Rec."Unit Price") * Rec."C Percentage") / 100));
                end;
            end else
                if Rec."C Discount Calculation Type" = Rec."C Discount Calculation Type"::"Absolute discount per unit" then begin
                    if Rec.Quantity <> 0 then begin
                        Rec."C Total Absolute Dis. Amount" := (Rec."C Absolute Discount Per Unit" * Rec.Quantity);
                        Rec.Validate("Line Discount Amount", Rec."Line Discount Amount" + (Rec."C Absolute Discount Per Unit" * Rec.Quantity));
                    end;
                end else
                    if Rec."C Discount Calculation Type" = Rec."C Discount Calculation Type"::"Whichever is less" then begin
                        Rec."C Percentage Dis. Amount" := (((Rec.Quantity * Rec."Unit Price") * Rec."C Percentage") / 100);
                        Rec."C Total Absolute Dis. Amount" := (Rec."C Absolute Discount Per Unit" * Rec.Quantity);
                        if Rec."C Total Absolute Dis. Amount" < Rec."C Percentage Dis. Amount" then
                            Rec.Validate("Line Discount Amount", Rec."C Total Absolute Dis. Amount" + Rec."Line Discount Amount")
                        else
                            Rec.Validate("Line Discount Amount", Rec."C Percentage Dis. Amount" + Rec."Line Discount Amount")
                    end;
        end;
    end;*/
    local procedure UpdateLineDiscountForOtherSalesLine(var SalesLinep: Record "Sales Line")
    var
        RecHeader: Record "Sales Header";
        RecLine: Record "Sales Line";
        Totalqty: Decimal;
    begin
        if not (SalesLinep."Document Type" IN [SalesLinep."Document Type"::Order, SalesLinep."Document Type"::Invoice]) then exit;
        Clear(RecLine);
        RecLine.SetRange("Document Type", SalesLinep."Document Type");
        RecLine.SetRange("Document No.", SalesLinep."Document No.");
        RecLine.SetRange(Type, SalesLinep.Type::Item);
        RecLine.SetRange("No.", SalesLinep."No.");
        RecLine.SetFilter("Line No.", '<>%1', SalesLinep."Line No.");
        if RecLine.FindSet() then begin
            repeat
                RecLine."C Total Absolute Dis. Amount" := 0;
                RecLine."C Percentage Dis. Amount" := 0;
                RecLine.Validate("C Standard Line Disc. %", SalesLinep."C Standard Line Disc. %");

                if (RecLine."C Discount Calculation Type" <> RecLine."C Discount Calculation Type"::" ") then begin

                    if RecLine."C Discount Calculation Type" = RecLine."C Discount Calculation Type"::Percentage then begin
                        if RecLine.Quantity <> 0 then begin
                            RecLine."C Percentage Dis. Amount" := ((RecLine.Quantity * RecLine."Unit Price") * RecLine."C Percentage") / 100;
                            //RecLine.Validate("Line Discount Amount", (RecLine."C Standard Line Disc. Amt" + ((RecLine.Quantity * RecLine."Unit Price") * RecLine."C Percentage") / 100));
                            RecLine.Validate("Line Discount Amount", (((RecLine.Quantity * RecLine."Unit Price") * RecLine."C Percentage") / 100));
                        end;

                    end else
                        if RecLine."C Discount Calculation Type" = RecLine."C Discount Calculation Type"::"Absolute discount per unit" then begin
                            if RecLine.Quantity <> 0 then begin
                                RecLine."C Total Absolute Dis. Amount" := (RecLine."C Absolute Discount Per Unit" * RecLine.Quantity);
                                // RecLine.Validate("Line Discount Amount", RecLine."C Standard Line Disc. Amt" + (RecLine."C Absolute Discount Per Unit" * RecLine.Quantity));
                                RecLine.Validate("Line Discount Amount", (RecLine."C Absolute Discount Per Unit" * RecLine.Quantity));
                            end;
                        end else
                            if RecLine."C Discount Calculation Type" = RecLine."C Discount Calculation Type"::"Whichever is less" then begin
                                RecLine."C Percentage Dis. Amount" := ((RecLine.Quantity * RecLine."Unit Price") * RecLine."C Percentage") / 100;
                                RecLine."C Total Absolute Dis. Amount" := (RecLine."C Absolute Discount Per Unit" * RecLine.Quantity);
                                if RecLine."C Percentage Dis. Amount" < RecLine."C Total Absolute Dis. Amount" then
                                    //  RecLine.Validate("Line Discount Amount", RecLine."C Percentage Dis. Amount" + RecLine."C Standard Line Disc. Amt")
                                    RecLine.Validate("Line Discount Amount", RecLine."C Percentage Dis. Amount")

                                else
                                    // RecLine.Validate("Line Discount Amount", RecLine."C Total Absolute Dis. Amount" + RecLine."C Standard Line Disc. Amt")
                                    RecLine.Validate("Line Discount Amount", RecLine."C Total Absolute Dis. Amount")
                            end;
                end else
                    RecLine.Validate("Line Discount Amount", RecLine."C Standard Line Disc. Amt");
                RecLine.Modify();

            until RecLine.Next() = 0;
        end;

    end;
}
