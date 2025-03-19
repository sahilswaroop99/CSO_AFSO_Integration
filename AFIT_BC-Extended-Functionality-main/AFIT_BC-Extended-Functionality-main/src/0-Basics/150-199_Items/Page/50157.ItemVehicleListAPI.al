page 50157 "AF Item Vehicle List API"
{
    APIGroup = 'AFIT';
    APIPublisher = 'Autofit';
    APIVersion = 'beta';
    ApplicationArea = All;
    Caption = 'Item Vehicle List API';
    DelayedInsert = true;
    EntityName = 'ItemVehicle';
    EntitySetName = 'ItemVehicleList';
    PageType = API;
    SourceTable = "AF Item Vehicle";
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
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(make; Rec.Make)
                {
                    Caption = 'Make';
                }
                field(model; Rec.Model)
                {
                    Caption = 'Model';
                }
                field(fromYear; Rec.FromYear)
                {
                    Caption = 'From Year';
                }
                field(toYear; Rec.ToYear)
                {
                    Caption = 'To Year';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
            }
        }
    }
}
