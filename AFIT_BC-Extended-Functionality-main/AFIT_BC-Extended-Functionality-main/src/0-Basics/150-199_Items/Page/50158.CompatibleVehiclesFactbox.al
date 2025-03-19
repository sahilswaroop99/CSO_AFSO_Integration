page 50158 "AF Compatible Vehicles Factbox"
{
    ApplicationArea = All;
    Caption = 'Item Compatible Vehicles';
    PageType = ListPart;
    SourceTable = "AF Item Vehicle";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            field("Item No"; ItemNo)
            {
                ApplicationArea = All;
            }
            repeater(Control1)
            {
                ShowCaption = false;

                field(Make; Rec.Make)
                {
                    ApplicationArea = All;
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                }
                field(FromYear; Rec.FromYear)
                {
                    ApplicationArea = All;
                }
                field(ToYear; Rec.ToYear)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        ItemNo: Code[20];

    procedure LoadCompatibleVehiclesData(No: Code[20])

    begin
        ItemNo := No;
        CurrPage.Update(true);
    end;
}
