tableextension 50100 "AF Ship-to Address" extends "Ship-to Address"
{
    fields
    {
        field(50100; Route; Integer)
        {
            Caption = 'Route';
            DataClassification = CustomerContent;
            TableRelation = "AF Route Zone";

        }
    }
}
