table 50201 "AF Order Item Buffer"
{
    Caption = 'AF Order Item Buffer';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "OEM No."; Code[30])
        {
            Caption = 'OEM No.';
        }
        field(5; "Part Link No."; Code[30])
        {
            Caption = 'Part Link No.';
        }
    }
    keys
    {
        key(PK; "Order No.", "Item No.")
        {
            Clustered = true;
        }
    }
}
