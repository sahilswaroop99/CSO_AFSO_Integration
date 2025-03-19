table 50100 "AF Route Zone"
{
    Caption = 'Route Zone';
    DataClassification = ToBeClassified;
    DrillDownPageId = "AF Route Zone";

    fields
    {
        field(1; RouteNo; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'RouteNo';
        }
        field(2; ZipCode; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'ZipCode';
            TableRelation = "Post Code";
            ValidateTableRelation = true;
        }
    }
    keys
    {
        key(PK; RouteNo, ZipCode)
        {
            Clustered = true;
        }
    }
}
