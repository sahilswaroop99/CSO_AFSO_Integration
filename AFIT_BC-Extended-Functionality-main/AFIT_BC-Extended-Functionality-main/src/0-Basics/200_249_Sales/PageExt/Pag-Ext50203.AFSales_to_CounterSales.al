/*
pageextension 50203 AFSales_to_CounterSales extends "AF Sales Order"
{
    actions
    {
        addlast(processing)
        {

            action(MoveToCounterSales)
            {
                Caption = 'Move to Counter Sales';
                ApplicationArea = All;
                Image = SalesShipment;
                ToolTip = 'Moves the order details to the Counter Sales Order for processing.';

                trigger OnAction()
                var
                    CounterSalesOrder: Record "Sales Header"; // Replace with actual table name
                    CounterSalesLine: Record "Sales Line"; // Replace with actual table name
                    AFOrderHeader: Record "Sales Header";
                    AFOrderLine: Record "Sales Line";
                begin
                    // Get the selected AF Sales Order
                    if not AFOrderHeader.Get(Rec."No.") then
                        Error('Sales Order not found.');

                    // Initialize and insert Counter Sales Order
                    CounterSalesOrder.Init();
                    CounterSalesOrder."No." := ''; // Business Central will assign a number
                    CounterSalesOrder."Sell-to Customer No." := AFOrderHeader."Sell-to Customer No.";
                    CounterSalesOrder."Sell-to Customer Name" := AFOrderHeader."Sell-to Customer Name";
                    CounterSalesOrder."Posting Date" := AFOrderHeader."Posting Date";
                    CounterSalesOrder.Insert(true);

                    // Transfer Sales Lines
                    AFOrderLine.SetRange("Document No.", AFOrderHeader."No.");
                    if AFOrderLine.FindSet() then begin
                        repeat
                            CounterSalesLine.Init();
                            CounterSalesLine."Document No." := CounterSalesOrder."No.";
                            CounterSalesLine."No." := AFOrderLine."No.";
                            CounterSalesLine."Quantity" := AFOrderLine."Quantity";
                            CounterSalesLine."Unit Price" := AFOrderLine."Unit Price";
                            CounterSalesLine.Insert();
                        until AFOrderLine.Next() = 0;
                    end;

                    // Open Counter Sales Order Page for review
                    Page.Run(Page::"IWX POS Sales Order", CounterSalesOrder);
                end;

            }
        }
    }
}
*/