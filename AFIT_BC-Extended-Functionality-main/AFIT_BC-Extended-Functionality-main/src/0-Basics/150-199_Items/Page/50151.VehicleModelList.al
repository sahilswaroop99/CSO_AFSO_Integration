page 50151 "AF Vehicle Model List"
{
    PageType = List;
    SourceTable = "AF Vehicle Model";
    ApplicationArea = All;
    Caption = 'Vehicle Model List';
    Editable = true;
    UsageCategory = Lists;
    InsertAllowed = true;
    ModifyAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Make; Rec.Make)
                {
                    ApplicationArea = All;
                    Caption = 'Make';
                    Editable = true;
                    TableRelation = "AF Vehicle Make";
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                    Caption = 'Model';
                    Editable = true;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    Editable = true;
                }
            }
        }
    }



}
