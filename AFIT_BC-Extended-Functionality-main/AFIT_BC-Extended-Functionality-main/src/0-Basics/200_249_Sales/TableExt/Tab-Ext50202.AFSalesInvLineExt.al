tableextension 50202 "AF SalesInv Line Ext" extends "Sales Invoice Line"
{
    //SS
    fields
    {
        field(70005; "PartNumber"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
    //SS
    keys
    {
        key(KeyAFCustItem; "Sell-to Customer No.", Type, "No.", "Posting Date")
        { }
    }
}
