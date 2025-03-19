pageextension 50151 "AF Item Vehicle Filter" extends "Item List"
{
    actions
    {
        addbefore("Va&riants")
        {
            action(FilterByMakeModelYear)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Filter by Make, Model, Year';
                Image = EditFilter;

                trigger OnAction()
                var
                    // ItemAttributeManagement: Codeunit "Item Attribute Management";
                    TypeHelper: Codeunit "Type Helper";
                    CloseAction: Action;
                    FilterText: Text;
                    FilterPageID: Integer;
                    ParameterCount: Integer;
                begin

                    FilterPageID := PAGE::"AF Make, Model, Year Filter";
                    CloseAction := PAGE.RunModal(FilterPageID, TempFilterItemVehicleBuffer);

                    if TempFilterItemVehicleBuffer.IsEmpty() then begin
                        ClearVehicleFilter();
                        exit;
                    end;
                    TempFilteredItem.Reset();
                    TempFilteredItem.DeleteAll();

                    FilterText := GetItemNoFilter(TempFilterItemVehicleBuffer);

                    if ParameterCount < TypeHelper.GetMaxNumberOfParametersInSQLQuery() - 100 then begin
                        Rec.FilterGroup(0);
                        Rec.MarkedOnly(false);
                        Rec.SetFilter("No.", FilterText);
                    end else begin
                        RunOnTempRec := true;
                        Rec.ClearMarks();
                        Rec.Reset();
                    end;
                end;
            }
        }
    }
    var
        TempFilterItemVehicleBuffer: Record "AF Item Vehicle Ex Buffer" temporary;
        TempFilteredItem: Record Item temporary;
    // vehicleQuery: Query "AF Distinct Vehicle Details";

    local procedure ClearVehicleFilter()
    begin
        Rec.ClearMarks();
        Rec.MarkedOnly(false);
        TempFilterItemVehicleBuffer.Reset();
        TempFilterItemVehicleBuffer.DeleteAll();
        Rec.FilterGroup(0);
        Rec.SetRange("No.");
    end;

    procedure GetItemNoFilter(var Buffer: Record "AF Item Vehicle Ex Buffer") ItemNoFilter: Text
    var
        VehicleEx: Record "AF Item Vehicle Ex";
        Item: Record Item;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        YearInt: Integer;

    begin
        if not Buffer.FindSet() then
            exit;

        repeat
            if Buffer.Make <> '' then
                VehicleEx.SetRange("Make", Buffer.Make);

            if Buffer.Model <> '' then
                VehicleEx.SetRange("Model", Buffer.Model);

            if Buffer.Year <> '' then begin
                if Evaluate(YearInt, Buffer.Year) = false then
                    Error('The code value "%1" could not be converted to an integer.')
                else
                    VehicleEx.SetRange("Year", YearInt);
            end;


            if VehicleEx.FindSet() then begin
                repeat
                    if ItemNoFilter = '' then
                        ItemNoFilter := SelectionFilterManagement.AddQuotes(VehicleEx."Item No.")
                    else
                        ItemNoFilter += StrSubstNo('|%1', SelectionFilterManagement.AddQuotes(VehicleEx."Item No."));
                until VehicleEx.Next() = 0;
            end
        until Buffer.Next() = 0;

        exit(ItemNoFilter);
    end;
}