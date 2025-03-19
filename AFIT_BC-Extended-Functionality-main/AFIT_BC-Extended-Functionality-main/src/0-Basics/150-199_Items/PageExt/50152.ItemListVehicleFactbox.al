pageextension 50152 "Item List Vehicle Factbox" extends "Item List"
{
    layout
    {
        addbefore(ItemAttributesFactBox)
        {
            part(CompatibleVehicles; "AF Compatible Vehicles Factbox")
            {
                ApplicationArea = All;
                SubPageLink = "Item No." = field("No.");
            }
        }
    }


    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.CompatibleVehicles.PAGE.LoadCompatibleVehiclesData(Rec."No.");
    end;

}
