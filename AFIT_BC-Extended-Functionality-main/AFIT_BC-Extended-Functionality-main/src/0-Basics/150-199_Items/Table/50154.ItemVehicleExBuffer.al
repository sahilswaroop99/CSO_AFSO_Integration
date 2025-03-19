table 50154 "AF Item Vehicle Ex Buffer"
{
    Caption = 'Item Vehicle Ex Buffer';
    ReplicateData = false;
    DataClassification = CustomerContent;


    fields
    {
        field(1; ID; Guid)
        {
        }
        field(2; Make; Code[20])
        {
            TableRelation = "AF Vehicle Make";
        }
        field(3; Model; Code[20])
        {
            TableRelation = "AF Vehicle Model".Model where("Make" = field("Make"));
        }
        field(4; Year; code[4])
        {
            TableRelation = "AF Item Vehicle Ex".Year where("Make" = field("Make"), Model = field(Model));
        }

    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }


    trigger OnInsert()
    begin
        ID := System.CreateGuid();
    end;
}
