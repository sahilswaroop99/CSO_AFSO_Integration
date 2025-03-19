pageextension 50150 "AF Item Card" extends "Item Card"
{
    layout
    {
        addafter(Blocked)
        {
            field("AF OEM No."; Rec."AF OEM No.")
            {
                ApplicationArea = all;
            }
            field("AF Part Link No."; Rec."AF Part Link No.")
            {
                ApplicationArea = all;
            }
        }
        // addlast(content)
        // {
        //     part("Compatible Vehicles"; "AF Item Vehicle Subform")
        //     {
        //         ApplicationArea = All;
        //         SubPageLink = "Item No." = field("No.");
        //         UpdatePropagation = Both;
        //     }
        // }
    }

    actions
    {
        addbefore("Va&riants")
        {
            action("Item Vehicles")
            {
                ApplicationArea = All;
                Caption = 'Item Vehicles';
                Image = ServiceHours;
                RunObject = page "AF Item Vehicle List";
                RunPageLink = "Item No." = field("No.");
            }
        }
    }

    // var
    //     vehicleRec: Record "AF Vehicle";
    //     vehicleMake: Text[30];

    // trigger OnAfterGetRecord()
    // begin
    //     if vehicleRec.Get(Rec.VehicleID) then
    //         vehicleMake := vehicleRec.Make;
    // end;
}
