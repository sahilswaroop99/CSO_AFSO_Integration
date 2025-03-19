codeunit 50200 "AF SalesPostingEventSub"
{
    EventSubscriberInstance = StaticAutomatic;

    /// <summary>
    /// Deletes the record from AF Sales Order Item filter table while posting the sale document.
    /// </summary>
    /// <param name="SalesHeader"></param>
    /// <param name="SalesInvoiceHeader"></param>
    /// <param name="CommitIsSuppressed"></param>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterDeleteAfterPosting, '', false, false)]
    local procedure AFOnAfterDeleteAfterPosting(SalesHeader: Record "Sales Header"; SalesInvoiceHeader: Record "Sales Invoice Header"; CommitIsSuppressed: Boolean)
    var
        AFSalesItemFilter: Record "AF SalesOrder Item Filters";
        AFOrderItemBuff: Record "AF Order Item Buffer";
    begin
        if SalesHeader."Document Type" <> SalesHeader."Document Type"::Order then
            Exit;
        if AFSalesItemFilter.get(SalesHeader."No.") then
            AFSalesItemFilter.Delete();

        AFOrderItemBuff.Reset();
        AFOrderItemBuff.SetRange("Order No.", SalesHeader."No.");
        if AFOrderItemBuff.FindSet() then
            AFOrderItemBuff.DeleteAll();
    end;

    // [EventSubscriber(ObjectType::Table, Database::"Sales Header", OnAfterDeleteEvent, '', false, false)]
    // local procedure AFSalesHeadeOnAfterDeleteEvent(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    // var
    //     AFSalesOrderFilter: Record "AF SalesOrder Item Filters";
    //     AFOrderItemBuff: Record "AF Order Item Buffer";
    // begin
    //     if Rec."Document Type" <> Rec."Document Type"::Order then
    //         exit;
    //     if AFSalesOrderFilter.Get(Rec."No.") then
    //         AFSalesOrderFilter.Delete();
    //     AFOrderItemBuff.Reset();
    //     AFOrderItemBuff.SetRange("Order No.", Rec."No.");
    //     if AFOrderItemBuff.FindSet() then
    //         AFOrderItemBuff.DeleteAll();
    // end; //already written on table extension.
}
