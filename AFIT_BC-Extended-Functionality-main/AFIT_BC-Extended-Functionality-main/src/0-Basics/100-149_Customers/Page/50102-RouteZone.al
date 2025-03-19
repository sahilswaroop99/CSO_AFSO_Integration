page 50102 "AF Route Zone"
{
    ApplicationArea = All;
    Caption = 'Route Zone';
    PageType = Worksheet;
    SourceTable = "AF Route Zone";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(RouteNo; Rec.RouteNo)
                {
                    ToolTip = 'Specifies the value of the RouteNo field.', Comment = '%';
                }
                field(ZipCode; Rec.ZipCode)
                {
                    ToolTip = 'Specifies the value of the ZipCode field.', Comment = '%';
                }
            }
        }
    }
}
