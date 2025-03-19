
page 50152 "AF Item Vehicle List"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Item Vehicle List';
    DataCaptionFields = "Item No.";
    PageType = ListPart;
    SourceTable = "AF Item Vehicle";
    UsageCategory = Lists;
    DelayedInsert = true;

    InsertAllowed = true;
    ModifyAllowed = false;
    DeleteAllowed = true;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                ShowCaption = false;
                field("Item No."; Rec."Item No.")
                {
                    Visible = true;
                    Editable = false;
                }
                field("Make"; Rec.Make)
                {
                    Lookup = true;
                }
                field("Model"; Rec.Model)
                {
                }
                field("FromYear"; Rec.FromYear)
                {
                }
                field("ToYear"; Rec.ToYear)
                {
                }
            }
        }

    }

}
