page 50101 "AF Customer Business Hour API"
{
    APIGroup = 'AFIT';
    APIPublisher = 'Autofit';
    APIVersion = 'beta';
    ApplicationArea = All;
    Caption = 'Customer Business Hours API';
    DelayedInsert = true;
    EntityName = 'CustomerBizHours';
    EntitySetName = 'CustomerBizHours';
    PageType = API;
    SourceTable = "AF Customer Business Hour";
    ODataKeyFields = SystemId;
    ChangeTrackingAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                }
                field(dayOfWeek; Rec."Day of Week")
                {
                    Caption = 'Day of Week';
                }
                field(endTime; Rec."End Time")
                {
                    Caption = 'End Time';
                }
                field(isWorking; Rec."Is Working")
                {
                    Caption = 'Is Working';
                }
                field(startTime; Rec."Start Time")
                {
                    Caption = 'Start Time';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
            }
        }
    }
}
