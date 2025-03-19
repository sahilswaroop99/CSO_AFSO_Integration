page 50154 "AF Item Vehicle Subform"
{
    ApplicationArea = All;
    Caption = 'Compatible Vehicles';
    PageType = ListPart;
    SourceTable = "AF Item Vehicle";
    ModifyAllowed = true;
    InsertAllowed = true;
    DeleteAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Make"; Rec.Make)
                {
                    ApplicationArea = All;
                }
                field("Model"; Rec.Model)
                {
                    ApplicationArea = All;
                }
                field("From Year"; Rec.FromYear)
                {
                    ApplicationArea = All;
                }
                field("To Year"; Rec.ToYear)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        ItemRec: Record Item;
    begin
        Rec."Item No." := ItemRec."No.";
        exit(true);
    end;
}


// page 50106 "AF Item Vehicle Subform"
// {
//     ApplicationArea = All;
//     Caption = 'Compatible Vehicles';
//     PageType = ListPart;
//     SourceTable = "AF Item Vehicle";
//     ModifyAllowed = true;
//     InsertAllowed = true;

//     layout
//     {
//         area(Content)
//         {
//             repeater(General)
//             {
//                 field("ItemNo."; Rec."ItemNo.")
//                 {
//                     ApplicationArea = All;
//                     TableRelation = "Item";
//                     Visible=false;
//                 }

//             }
//         }
//     }
//     // actions
//     // {
//     //     area(processing)
//     //     {
//     //         action("Add Vehicles Years")
//     //         {
//     //             Caption = 'Add Years';
//     //             Image = New;

//     //             trigger OnAction()
//     //             begin
//     //                 ShowYearInputDialog();
//     //             end;
//     //         }
//     //     }
//     // }
//     // var
//     //     itemVehicle: Record "AF Item Vehicle";
//     //     YearInputDialog: Page "AF Year Range";
//     //     fromYear: Integer;
//     //     toYear: Integer;
//     //     vehicleMake: Text[30];
//     //     vehicleModel: Text[30];
//     //     itemNo: Code[20];

//     // local procedure ShowYearInputDialog()
//     // begin
//     //     Clear(YearInputDialog);
//     //     if YearInputDialog.RunModal() = Action::OK then begin
//     //         fromYear := YearInputDialog.GetFromYear();
//     //         toYear := YearInputDialog.GetToYear();
//     //         AddVehicleYears()
//     //     end;
//     // end;

//     // local procedure AddVehicleYears()
//     // var
//     //     newYear: Integer;
//     // begin
//     //     itemVehicle.Reset();
//     //     itemVehicle.SetRange("ItemNo.", GetItem(Rec.VehicleID));

//     //     if itemVehicle.FindSet() then begin
//     //         repeat
//     //             Rec.SetRange("VehicleID", Rec.VehicleID);
//     //             if itemVehicle.FindFirst() then begin
//     //                 vehicleMake := Rec.Make;
//     //                 vehicleModel := Rec.Model;
//     //                 for newYear := fromYear to toYear do begin
//     //                     Rec.SetRange(Year, newYear);
//     //                     if Not Rec.Get() then begin
//     //                         Rec.Init();
//     //                         Rec.VehicleID := GetNewVehicleID();
//     //                         Rec.Make := vehicleMake;
//     //                         Rec.Model := vehicleModel;
//     //                         Rec.Year := newYear;
//     //                         itemVehicle."ItemNo." := GetItem(Rec.VehicleID);
//     //                         Rec.Insert();
//     //                     end
//     //                     else begin
//     //                         Rec.Year := newYear;
//     //                         Rec.Modify();
//     //                     end;
//     //                 end;
//     //             end;
//     //         Until itemVehicle.Next() = 0;
//     //     end;
//     // end;

//     // procedure GetItem(vehicleId: Integer): Code[20]
//     // begin
//     //     itemVehicle.Reset();
//     //     itemVehicle.SetRange("VehicleID", vehicleId);
//     //     if itemVehicle.FindFirst() then
//     //         itemNo := itemVehicle."ItemNo.";
//     //     exit(itemNo);
//     // end;

//     // local procedure GetNewVehicleID(): Integer
//     // var
//     //     maxVehicleID: Integer;
//     // begin
//     //     Rec.Reset();
//     //     if Rec.FindLast() then
//     //         maxVehicleID := Rec.VehicleID;
//     //     exit(maxVehicleID + 1);
//     // end;
// }
