pageextension 50100 "AF Customer Action" extends "Customer Card"
{
    actions
    {
        addafter("Contact")
        {
            action("Customer Business Hours")
            {
                ApplicationArea = All;
                Caption = 'Customer Business Hours';
                Image = ServiceHours;
                RunObject = page "AF Customer Business Hour";
                RunPageLink = "Customer No." = field("No.");

                trigger OnAction()
                var
                    custBizHoursSub: page "AF Business Hour Subform";
                begin
                    custBizHoursSub.ValidateEntry(Rec."No.");
                end;
            }
        }
    }
}
