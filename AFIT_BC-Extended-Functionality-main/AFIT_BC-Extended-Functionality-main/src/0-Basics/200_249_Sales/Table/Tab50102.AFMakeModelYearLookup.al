table 50102 AFMakeModelYearLookup
{
    Caption = 'AFMakeModelYearLookup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Year; Integer)
        {
            Caption = 'Year';
        }
        field(2; Make; Code[20])
        {
            Caption = 'Make';
        }
        field(3; Model; Code[20])
        {
            Caption = 'Model';
        }
    }
    keys
    {
        key(PK; Year, Make, Model)
        {
            Clustered = true;
        }
    }
}
