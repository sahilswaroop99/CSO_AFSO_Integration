page 50206 "AF SalesOrder Item Search"
{
    ApplicationArea = All;
    Caption = 'Item Search';
    PageType = CardPart;
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = "AF SalesOrder Item Filters";
    // SourceTableView = sorting("Order No.", "Item No.") order(ascending);
    //SourceTableTemporary = true;
    ShowFilter = false;


    layout
    {
        area(Content)
        {
            group(Filters)
            {
                ShowCaption = false;
                field(Make; Rec.Make)
                {
                    ApplicationArea = all;
                    trigger OnValidate()
                    begin
                        Rec.Model := '';
                    end;
                }
                field(Model; Rec.Model)
                { ApplicationArea = all; }
                field(Year; Rec.Year)
                {
                    trigger OnValidate()
                    var
                        Y: Integer;
                    begin
                        if Rec.Year <> '' then begin
                            if not Evaluate(Y, Rec.Year) then
                                Error('Please enter the Number');
                            if y < 999 then begin
                                Y := Y + 2000;
                                Rec.Year := Format(Y);
                            end;
                        end;
                    end;
                }
                field(PartNumber; Rec.PartNumber)
                {
                    //ShowCaption = false;
                    Caption = 'Item/Part/OEM/Desc';
                    ApplicationArea = all;
                }
                // field(SearchItems; SearchItems)
                // {
                //     ShowCaption = false;
                //     Editable = false;
                //     ApplicationArea = all;
                //     Style = StrongAccent;
                //     trigger OnDrillDown()
                //     begin
                //         SetFiltersFromAFItems();
                //     end;
                // }
                group(result)
                {
                    ShowCaption = false;
                    usercontrol(AFButton; RMSButton)
                    {
                        ApplicationArea = all;
                        trigger Ready()
                        begin
                            CurrPage.AFButton.addButton('CLICK HERE TO SEARCH');
                        end;

                        trigger ButtonPressed()
                        begin
                            SetFiltersFromAFItems();
                        end;
                    }
                    label(SearchStatus)
                    {
                        CaptionClass = SearchStatus;
                        Style = AttentionAccent;
                    }
                }

            }

        }
    }
    trigger OnOpenPage()
    begin
        if AFSalesItemFilter.get(SalesHdr."No.") then begin
            Rec.Make := AFSalesItemFilter.Make;
            Rec.Model := AFSalesItemFilter.Model;
            Rec.Year := AFSalesItemFilter.Year;
            Rec.PartNumber := AFSalesItemFilter.PartNumber;
            SearchStatus := AFSalesItemFilter.SearchStatus;
        end;
        SearchItems := '👉🔍Click here to search';
    end;

    var
        SalesHdr: Record "Sales Header";

        AFSalesItemFilter: Record "AF SalesOrder Item Filters";
        //PartNumber, 
        SearchItems: Code[30];
        //  Rec.Make, Rec.Model,
        OldOrderNo: code[20];
        // Rec.Year: Code[4];
        SearchStatus: Text;
        NoOfRows: Integer;

    procedure SetSalesOrder(pSalesHdr: Record "Sales Header")
    begin
        if pSalesHdr."No." = '' then
            exit;
        SalesHdr.Copy(pSalesHdr);
        if not AFSalesItemFilter.get(SalesHdr."No.") then begin
            AFSalesItemFilter.Init();
            AFSalesItemFilter.SearchStatus := 'Enter make, model, year or Part Number';
            AFSalesItemFilter."Order No" := SalesHdr."No.";
            if AFSalesItemFilter.Insert() then;
        end;
        if OldOrderNo <> SalesHdr."No." then begin
            Rec.Make := AFSalesItemFilter.Make;
            Rec.Model := AFSalesItemFilter.Model;
            Rec.Year := AFSalesItemFilter.Year;
            Rec.PartNumber := AFSalesItemFilter.PartNumber;
            SearchStatus := AFSalesItemFilter.SearchStatus;
        end;
        OldOrderNo := SalesHdr."No.";
        CurrPage.Update(false);
    end;


    local procedure SetFiltersFromAFItems()
    begin
        SearchItemsWithFilters();
        if Rec.Find('-') then;
        CurrPage.Update(false);
    end;

    local procedure SearchItemsWithFilters()
    var
        FilterText: Text;
        Item: Record Item;
        F: Boolean;
        AFOrderItemBuff: Record "AF Order Item Buffer";
    begin
        AFOrderItemBuff.Reset();
        AFOrderItemBuff.SetRange("Order No.", SalesHdr."No.");
        if AFOrderItemBuff.FindSet() then
            AFOrderItemBuff.DeleteAll();
        Clear(NoOfRows);
        if Rec.PartNumber <> '' then begin
            Item.Reset();
            Item.SetLoadFields("No.", Description, "AF OEM No.", "AF Part Link No.");
            Item.SetFilter("No.", '*' + Rec.PartNumber + '*');
            if Item.Find('-') then begin
                repeat
                    InsertOrderItem(Item);
                until Item.Next() = 0;
                F := true
            end;
            Item.SetRange("No.");
            Item.SetCurrentKey("AF OEM No.");
            // if (FilterText <> '') then
            //     Item.SetFilter("No.", FilterText);
            Item.SetFilter("AF OEM No.", '*' + Rec.PartNumber + '*');
            if Item.FindSet() then begin
                repeat
                    InsertOrderItem(Item);
                until Item.next() = 0;
                F := true;
            end;
            Item.SetRange("AF OEM No.");
            Item.SetCurrentKey("AF Part Link No.");
            Item.SetFilter("AF Part Link No.", '*' + Rec.PartNumber + '*');
            if Item.FindSet() then begin
                repeat
                    InsertOrderItem(Item);
                until Item.next() = 0;
                F := True;
            end;
            Item.SetRange("AF OEM No.");
            Item.SetRange("AF Part Link No.");
            Item.SetCurrentKey(Description);
            Item.SetFilter(Description, '*' + Rec.PartNumber + '*');
            if Item.FindSet() then begin
                repeat
                    InsertOrderItem(Item);
                until Item.next() = 0;
                F := True;
            end;
            if F then begin
                SearchStatus := '%1 -Results from Item/Part/OEM/Descr. search for ' + Rec.PartNumber;
                AFSalesItemFilter.PartNumber := Rec.PartNumber;
            end;
            if not F then
                GetItemsFromMakeModelYear()
        end else begin
            GetItemsFromMakeModelYear()
        end;
        SearchStatus := StrSubstNo(SearchStatus, NoOfRows);
        if not AFSalesItemFilter.get(SalesHdr."No.") then begin
            AFSalesItemFilter.Init();
            AFSalesItemFilter."Order No" := SalesHdr."No.";
            if AFSalesItemFilter.Insert() then;
        end;
        AFSalesItemFilter.Make := Rec.Make;
        AFSalesItemFilter.Model := Rec.Model;
        AFSalesItemFilter.Year := Rec.Year;
        AFSalesItemFilter.SearchStatus := SearchStatus;
        AFSalesItemFilter.PartNumber := Rec.PartNumber;
        AFSalesItemFilter.Modify();
        //if AFOrderItemBuff.Get(SalesHdr."No.") then;
    end;

    local procedure InsertOrderItem(pItem: Record Item)
    var
        AFOrderItemBuff: Record "AF Order Item Buffer";
    begin
        If SalesHdr."No." <> '' then begin
            if AFOrderItemBuff.Get(SalesHdr."No.", pItem."No.") then
                Exit;
            AFOrderItemBuff.Init();
            AFOrderItemBuff."Order No." := SalesHdr."No.";
            AFOrderItemBuff."Item No." := pItem."No.";
            AFOrderItemBuff.Description := pItem.Description;
            AFOrderItemBuff."OEM No." := pItem."AF OEM No.";
            AFOrderItemBuff."Part Link No." := pItem."AF Part Link No.";
            AFOrderItemBuff.Insert();
            NoOfRows += 1;
        end;
    end;


    local procedure GetItemsFromMakeModelYear()
    var
        VehicleEx: Record "AF Item Vehicle Ex";
        YearInt: Integer;
        Item: Record Item;
    begin

        if (Rec.Make = '') and (Rec.Model = '')
            and (Rec.Year = '') then begin
            SearchStatus := 'Must enter make, model, year or Part Number';
            exit;
        end;

        if Rec.Make <> '' then
            VehicleEx.SetRange("Make", Rec.Make);

        if Rec.Model <> '' then
            VehicleEx.SetRange("Model", Rec.Model);

        if Rec.Year <> '' then begin
            if Evaluate(YearInt, Rec.Year) = false then
                Error('The code value "%1" could not be converted to an integer.')
            else
                VehicleEx.SetRange("Year", YearInt);
        end;
        if not VehicleEx.FindSet() then begin
            SearchStatus := 'No results from make, model, year or Part Number';
            exit;
        end;
        Item.SetLoadFields("No.", Description, "AF OEM No.", "AF Part Link No.");
        repeat
            if Item.get(VehicleEx."Item No.") then
                InsertOrderItem(Item);
        until VehicleEx.Next() = 0;
        SearchStatus := '%1 - Results from';
        if Rec.Make <> '' then
            SearchStatus := SearchStatus + ' Make=' + getMakeName(Rec.Make);
        if Rec.Model <> '' then
            SearchStatus := SearchStatus + ', Model=' + getModelName(Rec.Make, Rec.Model);
        if Rec.Year <> '' then
            SearchStatus := SearchStatus + ' Year=' + Rec.Year;
        Rec.PartNumber := '';
    end;

    local procedure getMakeName(pMake: Code[20]): Text
    var
        AFMake: Record "AF Vehicle Make";
    begin
        AFMake.SetRange(Code, pMake);
        if AFMake.FindFirst() then
            if AFMake.Description <> '' then
                exit(AFMake.Description);
        exit(pMake);
    end;

    local procedure getModelName(pMake: Code[20]; pModel: Code[20]): Text
    var
        AFModel: Record "AF Vehicle Model";
    begin
        if AFModel.Get(pMake, pModel) then
            if AFModel.Description <> '' then
                exit(AFModel.Description);
        exit(pMake);
    end;
}
