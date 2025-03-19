page 50100 "AF Customer Business Hour"
{
    ApplicationArea = All;
    Caption = 'Customer Business Hours';
    PageType = Document;
    SourceTable = "AF Customer Business Hour";
    UsageCategory = Lists;
    PopulateAllFields = true;


    layout
    {
        area(Content)
        {
            field("Customer No."; Rec."Customer No.")
            {
                ToolTip = 'Specifies the value of the Customer No. field.', Comment = '%';
                Editable = false;
                QuickEntry = true;
            }

            part("Business Hours"; "AF Business Hour Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Customer No." = field("Customer No.");
                UpdatePropagation = Both;
            }
        }
    }


    trigger OnAfterGetRecord()
    var
        custBizHour: Record "AF Customer Business Hour";
    begin
        if custBizHour."Customer No." <> Rec."Customer No." then
            CurrPage.Update(false)
        else
            custBizHour.Modify();
    end;
}