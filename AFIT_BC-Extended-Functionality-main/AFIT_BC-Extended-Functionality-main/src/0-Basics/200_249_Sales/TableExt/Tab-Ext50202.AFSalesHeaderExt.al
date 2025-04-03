tableextension 50200 "AF Sales Header Ext" extends "Sales Header"
{
    //SS
    /*  fields
      {
          field(70000; "Customer Comment"; Text[250])
          {

              DataClassification = CustomerContent;
          }

          field(70001; "Business Hours"; Text[250])
          {
              DataClassification = CustomerContent;
          }

          field(70002; "PartNumber"; Code[20])
          {
              DataClassification = ToBeClassified;
          }
      }//SS*/
    fields
    {
        field(50100; "Business Hours"; Text[50])
        {

        }
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                RecCustomer: Record Customer;
            begin
                if RecCustomer.Get("Sell-to Customer No.") then begin
                    Validate("Business Hours", RecCustomer."Business Hours");
                end;
            end;
        }
    }
    //Atul

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
