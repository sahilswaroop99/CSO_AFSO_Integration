
pageextension 50203 "AFSalesOrder Stats." extends "Sales Order Stats."
{
    layout
    {
        addbefore("TotalSalesLine[1].""Inv. Discount Amount""")
        {
            field(gLineDiscount; gLineDiscount)
            {
                Caption = 'Line Discount %';
                ApplicationArea = all;
                Visible = ShowLineDis;
                MaxValue = 100;
                MinValue = 0;
                trigger OnValidate()
                begin
                    if Confirm('Do you want to update the Line Discount in the lines?', false, true) then begin
                        AFUpdateLineDiscount();
                    end;
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        gLineDiscount := AFGetLineDiscount();
        ShowLineDis := Rec."Document Type" = Rec."Document Type"::Order;
    end;

    trigger OnOpenPage()
    begin
        ShowLineDis := true;
    end;

    var
        gLineDiscount: Decimal;
        ShowLineDis: Boolean;

    local procedure AFGetLineDiscount(): Decimal
    var
        lSalesLine: Record "Sales Line";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        lSalesLine.SetRange("Document Type", Rec."Document Type");
        lSalesLine.SetRange("Document No.", Rec."No.");
        lSalesLine.SetFilter(Type, '%1|%2', lSalesLine.Type::Item, lSalesLine.Type::"G/L Account");
        lSalesLine.SetFilter("Line Discount %", '<>%1', 0);
        if lSalesLine.FindFirst() then
            exit(lSalesLine."Line Discount %");
    end;

    local procedure AFUpdateLineDiscount()
    var
        lSalesLine: Record "Sales Line";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        lSalesLine.SetRange("Document Type", Rec."Document Type");
        lSalesLine.SetRange("Document No.", Rec."No.");
        lSalesLine.SetFilter(Type, '%1|%2', lSalesLine.Type::Item, lSalesLine.Type::"G/L Account");
        lSalesLine.SetHideValidationDialog(true);
        if lSalesLine.FindSet() then
            repeat
                lSalesLine.Validate("Line Discount %", gLineDiscount);
                lSalesLine.Modify()
            until lSalesLine.Next() = 0;
    end;
}
