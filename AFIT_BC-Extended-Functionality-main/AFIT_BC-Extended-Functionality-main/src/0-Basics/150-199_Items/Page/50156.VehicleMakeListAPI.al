page 50156 "AF Vehicle Make List API"
{
    APIGroup = 'AFIT';
    APIPublisher = 'Autofit';
    APIVersion = 'beta';
    ApplicationArea = All;
    Caption = 'Vehicle Make List API';
    DelayedInsert = true;
    EntityName = 'VehicleMake';
    EntitySetName = 'VehicleMakeList';
    PageType = API;
    SourceTable = "AF Vehicle Make";
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
                field("code"; Rec."Code")
                {
                    Caption = 'Make';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
            }
        }
    }
}
