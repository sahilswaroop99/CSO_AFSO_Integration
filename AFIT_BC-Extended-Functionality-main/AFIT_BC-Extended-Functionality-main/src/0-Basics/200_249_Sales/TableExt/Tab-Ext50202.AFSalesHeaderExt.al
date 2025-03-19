tableextension 50200 "AF Sales Header Ext" extends "Sales Header"
{
    trigger OnAfterDelete()
    var
        AFSalesOrderFilter: Record "AF SalesOrder Item Filters";
        AFOrderItemBuff: Record "AF Order Item Buffer";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        if AFSalesOrderFilter.Get(Rec."No.") then
            AFSalesOrderFilter.Delete();
        AFOrderItemBuff.Reset();
        AFOrderItemBuff.SetRange("Order No.", Rec."No.");
        if AFOrderItemBuff.FindSet() then
            AFOrderItemBuff.DeleteAll();
    end;
}
