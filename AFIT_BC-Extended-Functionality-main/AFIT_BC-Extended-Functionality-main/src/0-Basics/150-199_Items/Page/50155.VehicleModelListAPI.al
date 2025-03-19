page 50155 "AF Vehicle Model List API"
{
    APIGroup = 'AFIT';
    APIPublisher = 'Autofit';
    APIVersion = 'beta';
    ApplicationArea = All;
    Caption = 'Vehicle Model List API';
    DelayedInsert = true;
    EntityName = 'VehicleModel';
    EntitySetName = 'VehicleModelList';
    PageType = API;
    SourceTable = "AF Vehicle Model";
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
                field(make; Rec.Make)
                {
                    Caption = 'Make';
                }
                field(model; Rec.Model)
                {
                    Caption = 'Model';
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
