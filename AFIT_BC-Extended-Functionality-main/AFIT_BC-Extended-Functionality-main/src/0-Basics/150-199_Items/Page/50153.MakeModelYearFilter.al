page 50153 "AF Make, Model, Year Filter"
{
    Caption = 'Filter Items by Make, Model, Year';
    DataCaptionExpression = '';
    PageType = StandardDialog;
    SourceTable = "AF Item Vehicle Ex Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                ShowCaption = false;
                field(Make; Rec.Make)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Make';
                    ToolTip = 'Specifies the value of the Make field.';
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Model';
                    ToolTip = 'Specifies the value of the Model field.';


                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Year';
                    ToolTip = 'Specifies the value of the Year field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        Rec.DeleteAll();
    end;
}
