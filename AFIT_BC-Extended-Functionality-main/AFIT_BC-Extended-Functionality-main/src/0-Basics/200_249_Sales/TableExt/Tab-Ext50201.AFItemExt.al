tableextension 50201 "AF Item Ext" extends Item
{
    fields
    {
        field(50100; "AF Part Link No."; Code[30])
        {
            Caption = 'Part Link No.';
            DataClassification = ToBeClassified;
        }
        field(50101; "AF OEM No."; Code[30])
        {
            Caption = 'OEM No.';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(AFPartNoKy; "AF Part Link No.")
        { }
        key(AFOEMNoKy; "AF OEM No.")
        { }
    }
}
