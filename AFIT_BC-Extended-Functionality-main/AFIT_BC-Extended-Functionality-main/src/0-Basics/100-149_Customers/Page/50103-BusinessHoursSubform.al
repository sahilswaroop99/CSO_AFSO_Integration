page 50103 "AF Business Hour Subform"
{
    ApplicationArea = All;
    Caption = 'Business Hours Details';
    PageType = ListPart;
    SourceTable = "AF Customer Business Hour";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Is Working"; Rec."Is Working")
                {
                    ToolTip = 'Specifies whether the customer is working on this day or not', Comment = '%';
                }
                field("Day of Week"; Rec."Day of Week")
                {
                    ToolTip = 'Specifies the value of the Day of Week field.', Comment = '%';
                    Editable = false;
                }
                field("Start Time"; Rec."Start Time")
                {
                    ToolTip = 'Specifies the value of the Start Time field.', Comment = '%';
                    Editable = Rec."Is Working";

                }
                field("End Time"; Rec."End Time")
                {
                    ToolTip = 'Specifies the value of the End Time field.', Comment = '%';
                    Editable = Rec."Is Working";
                }
            }
        }
    }
    var
        daysEnum: Enum "AF Week Days";
        dayNum: Integer;

    trigger OnModifyRecord(): Boolean

    begin
        if not Rec."Is Working" then begin
            Rec."Start Time" := "AF Starting Time"::"--";
            Rec."End Time" := "AF Ending Time"::"--";
        end;

    end;

    procedure ValidateEntry(CustNo: Code[20])
    begin
        Rec.Reset();
        Rec.SetRange(Rec."Customer No.", CustNo);
        if not Rec.FindSet() then begin
            foreach dayNum in daysEnum.Ordinals() do begin
                Rec.SetFilter(Rec."Day of Week", daysEnum.Names().Get(dayNum));
                if not Rec.FindSet() then begin
                    Rec.Init();
                    Rec."Customer No." := CustNo;
                    Rec."Day of Week" := Enum::"AF Week Days".FromInteger(dayNum);
                    Rec.Insert()
                end;
            end;
        end
    end;
}
