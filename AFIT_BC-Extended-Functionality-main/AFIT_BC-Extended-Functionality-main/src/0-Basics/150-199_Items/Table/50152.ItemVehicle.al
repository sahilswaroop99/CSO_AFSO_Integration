table 50152 "AF Item Vehicle"
{
    Caption = 'Item Compatible Vehicle';
    DataClassification = ToBeClassified;

    fields
    {
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(3; Make; Code[20])
        {
            TableRelation = "AF Vehicle Make".Code;
            DataClassification = ToBeClassified;
        }
        field(4; Model; Code[20])
        {
            TableRelation = "AF Vehicle Model".Model where("Make" = field("Make"));
            DataClassification = ToBeClassified;
        }
        field(5; "FromYear"; Integer)
        {
            Caption = 'From Year';
            DataClassification = ToBeClassified;
        }
        field(6; "ToYear"; Integer)
        {
            Caption = 'To Year';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Item No.", Make, Model, "FromYear", "ToYear")
        {
            Clustered = true;
        }
    }



    trigger OnInsert()
    begin
        HandleExpand();
    end;

    trigger OnDelete()
    begin
        HandleCollapse();
    end;

    local procedure HandleExpand()
    var
        AFItemVehicleExRec: Record "AF Item Vehicle Ex";
        Year: Integer;
    begin
        for Year := FromYear to ToYear do begin
            AFItemVehicleExRec.Init();
            AFItemVehicleExRec."Item No." := "Item No.";
            AFItemVehicleExRec.Make := Make;
            AFItemVehicleExRec.Model := Model;
            AFItemVehicleExRec.Year := Year;
            AFItemVehicleExRec.Insert();
            CreateYearLookupRec(Year); //BPIT
        end;
    end;

    local procedure HandleCollapse()
    var
        AFItemVehicleExRec: Record "AF Item Vehicle Ex";
    begin
        AFItemVehicleExRec.SetRange("Item No.", "Item No.");
        AFItemVehicleExRec.SetRange(Make, Make);
        AFItemVehicleExRec.SetRange(Model, Model);
        AFItemVehicleExRec.SetRange(Year, FromYear, ToYear);
        if AFItemVehicleExRec.FindSet() then begin
            repeat
                AFItemVehicleExRec.Delete();
            until AFItemVehicleExRec.Next() = 0;
        end;
    end;

    //<<BPIT
    local procedure CreateYearLookupRec(Year: Integer)
    var
        AFYearLookup: Record AFMakeModelYearLookup;
    begin
        if AFYearLookup.Get(Year, Make, Model) then
            exit;
        AFYearLookup.Init();
        AFYearLookup.Year := Year;
        AFYearLookup.Make := Make;
        AFYearLookup.Model := Model;
        if AFYearLookup.Insert() then;
    end;
    //>>

}
