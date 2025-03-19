table 50151 "AF Vehicle Model"
{
    Caption = 'Vehicle Model';
    DataClassification = ToBeClassified;

    fields
    {
        field(2; Make; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Make';
            TableRelation = "AF Vehicle Make";

            // trigger OnValidate()
            // begin
            //     UpdateMakeModel();
            // end;
        }
        field(3; Model; Code[10])
        {
            Caption = 'Model';
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; Make, Model)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Model, Description)
        {

        }
    }

    // trigger OnInsert()
    // begin
    //     UpdateMakeModel();
    // end;

    // local procedure UpdateMakeModel()
    // begin
    //     if (Make <> '') and (Model <> '') then
    //         Code := Make + Model
    //     else
    //         Code := ''; // Handle case when Make or Model is empty
    // end;
}
