page 50150 "AF Vehicle Make List"
{
    PageType = List;
    SourceTable = "AF Vehicle Make";
    ApplicationArea = All;
    Caption = 'Vehicle Make List';
    Editable = true;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    Caption = 'Make';
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
