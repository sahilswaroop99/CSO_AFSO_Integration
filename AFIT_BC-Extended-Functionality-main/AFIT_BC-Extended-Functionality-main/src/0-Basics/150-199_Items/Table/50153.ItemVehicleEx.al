table 50153 "AF Item Vehicle Ex"
{
    Caption = 'Item Vehicle Ex';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            TableRelation = Item;
        }
        field(2; Make; Code[20])
        {
            TableRelation = "AF Vehicle Make";
        }
        field(3; Model; Code[20])
        {
        }
        field(4; Year; Integer)
        {
            Caption = 'Year';
        }
    }
    keys
    {
        key(PK; "Item No.", Make, Model, Year)
        {
            Clustered = true;
        }
    }


}
