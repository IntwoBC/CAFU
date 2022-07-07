page 50200 "Sales Shipment Staging"
{
    ApplicationArea = All;
    Caption = 'Sales Shipment Staging';
    PageType = List;
    SourceTable = "Sales Shipment Staging";
    SourceTableView = sorting("Entry No.") order(descending);
    UsageCategory = Lists;
    PromotedActionCategories = 'New,Process,Report,Navigate,Print/Send,Shipment,Certificate of Supply';
    RefreshOnActivate = true;
    InsertAllowed = true;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Transaction ID"; Rec."Transaction Id")
                {
                    ApplicationArea = All;
                }
                field("Customer Code"; Rec."Customer Code")
                {
                    ToolTip = 'Specifies the value of the Customer Code field.';
                    ApplicationArea = All;
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date  field.';
                    ApplicationArea = All;
                }
                field("Time"; Rec."Time")
                {
                    ApplicationArea = All;
                }
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item field.';
                    ApplicationArea = All;
                }
                field(UOM; Rec.UOM)
                {
                    ToolTip = 'Specifies the value of the UOM field.';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;
                }
                field("Vehicle No."; Rec."Vehicle No.")
                {
                    ToolTip = 'Specifies the value of the Vehicle No. field.';
                    ApplicationArea = All;
                }
                field("LPO No."; Rec."LPO No.")
                {
                    ToolTip = 'Specifies the value of the LPO No. field.';
                    ApplicationArea = All;
                }
                field("Delivery Location Code"; Rec."Delivery Location Code")
                {
                    ToolTip = 'Specifies the value of the Delivery Location field.';
                    ApplicationArea = All;
                }
                field(Branch; Rec.Branch)
                {
                    ToolTip = 'Specifies the value of the Branch field.';
                    ApplicationArea = All;
                }
                field("Shortcut Dimension 3 Code"; Rec."Shortcut Dimension 3 Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Error Remarks"; Rec."Error Remarks")
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Sales Shipment No."; Rec."Sales Shipment No.")
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Sales Invoice No."; Rec."Sales Invoice No.")
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Created At';
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Process Shipment")
            {
                ApplicationArea = All;
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    ProcessSalesShipment: Report "Process Sales Shipment";
                    RecSalesShipmentStaging: Record "Sales Shipment Staging";
                begin
                    Clear(RecSalesShipmentStaging);
                    CurrPage.SetSelectionFilter(RecSalesShipmentStaging);
                    if RecSalesShipmentStaging.FindSet() then begin
                        if not Confirm('Do you want to process Sales Shipment?', false) then
                            exit;
                        Clear(ProcessSalesShipment);
                        ProcessSalesShipment.SetTableView(RecSalesShipmentStaging);
                        ProcessSalesShipment.Run();
                        CurrPage.Update(false);
                    end;
                end;
            }

            action("Process Invoice")
            {
                ApplicationArea = All;
                Image = Process;
                Promoted = true;
                Visible = false;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    ProcessSalesInvoice: Report "Process Sales Invoice";
                    RecSalesShipmentStaging: Record "Sales Shipment Staging";
                begin
                    Clear(RecSalesShipmentStaging);
                    CurrPage.SetSelectionFilter(RecSalesShipmentStaging);
                    if RecSalesShipmentStaging.FindSet() then begin
                        if not Confirm('Do you want to process Sales Invoice?', false) then
                            exit;
                        Clear(ProcessSalesInvoice);
                        ProcessSalesInvoice.SetTableView(RecSalesShipmentStaging);
                        ProcessSalesInvoice.Run();
                        CurrPage.Update(false);
                    end;
                end;
            }

            action("Batch Invoice Processing")
            {
                ApplicationArea = All;
                RunObject = report "Sales Invoice Batch Processing";
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                begin

                end;
            }


            action("Change Status")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = Change;

                trigger OnAction()
                var
                    RecSalesShipmentStaging: Record "Sales Shipment Staging";
                begin
                    Clear(RecSalesShipmentStaging);
                    CurrPage.SetSelectionFilter(RecSalesShipmentStaging);
                    if RecSalesShipmentStaging.FindSet() then begin
                        if not Confirm('Do you want to change the status?', false) then
                            exit;
                                                                  repeat
                                                                      if not (RecSalesShipmentStaging.Status in [RecSalesShipmentStaging.Status::"Shipment Error", RecSalesShipmentStaging.Status::"Invoicing Error"]) then
                                                                          RecSalesShipmentStaging.TestField(Status, RecSalesShipmentStaging.Status::"Shipment Error");
                                                                      if RecSalesShipmentStaging.Status = RecSalesShipmentStaging.Status::"Shipment Error" then
                                                                          RecSalesShipmentStaging.Status := RecSalesShipmentStaging.Status::"Ready To Ship"
                                                                      else
                                                                          RecSalesShipmentStaging.Status := RecSalesShipmentStaging.Status::"Ready To Invoice";
                                                                      RecSalesShipmentStaging."Error Remarks" := '';
                                                                      RecSalesShipmentStaging.Modify();
                                                                  until RecSalesShipmentStaging.Next() = 0;
                        CurrPage.Update(false);
                    end;
                end;
            }
        }

        area(Creation)
        {
            action("Upload CSV")
            {
                ApplicationArea = All;
                Image = Excel;
                Promoted = true;
                PromotedCategory = New;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    Xmlport.Run(Xmlport::UploadSalesShipment);
                end;
            }
        }

        area(Navigation)
        {
            action("Shipment")
            {
                ApplicationArea = All;
                Image = Shipment;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                trigger OnAction()
                var
                    RecShipmentHeader: Record "Sales Shipment Header";
                begin
                    Rec.TestField("Sales Shipment No.");
                    Clear(RecShipmentHeader);
                    RecShipmentHeader.SetRange("No.", Rec."Sales Shipment No.");
                    Page.RunModal(Page::"Posted Sales Shipment", RecShipmentHeader);
                end;
            }

            action("Invoice")
            {
                ApplicationArea = All;
                Image = Invoice;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                trigger OnAction()
                var
                    RecInvHeader: Record "Sales Invoice Header";
                begin
                    Rec.TestField("Sales Invoice No.");
                    Clear(RecInvHeader);
                    RecInvHeader.SetRange("No.", Rec."Sales Invoice No.");
                    Page.RunModal(Page::"Posted Sales Invoice", RecInvHeader);
                end;
            }
        }

    }
}

