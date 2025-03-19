pageextension 50101 "AF Ship-to Address" extends "Ship-to Address"
{
    layout
    {
        addafter("Post Code")
        {
            field("Route"; Rec.Route)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Route No of the Customer.', Comment = '%';

            }
        }
    }
}
