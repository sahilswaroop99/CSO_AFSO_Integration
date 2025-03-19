page 50201 "AF SalesOrder ItemList"
{
    ApplicationArea = All;
    Caption = 'Item List';
    PageType = ListPart;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTable = "AF Order Item Buffer";
    SourceTableView = sorting("Order No.", "Item No.") order(ascending);
    ShowFilter = true;

    layout
    {
        area(Content)
        {
            grid(FiltersF)
            {
                ShowCaption = false;
                GridLayout = Rows;
                group(G1)
                {
                    Caption = 'Make.....';
                    field(Make; gMake)
                    {
                        ShowCaption = false;
                        ApplicationArea = all;
                        LookupPageId = "AF Vehicle Make List";
                        TableRelation = "AF Vehicle Make";
                        Lookup = true;
                        trigger OnValidate()
                        begin
                            gModel := '';
                            // if AFSalesItemFilter."Order No" <> '' then
                            //     AFSalesItemFilter.Modify()
                        end;
                    }
                }
                group(G2)
                {

                    Caption = 'Model.....';
                    field(Model; gModel)
                    {
                        ShowCaption = false;
                        ApplicationArea = all;
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            AFModels: Record "AF Vehicle Model";
                            AFModelPage: Page "AF Vehicle Model List";
                        begin
                            AFModels.SetRange(Make, gMake);
                            AFModelPage.SetTableView(AFModels);
                            AFModelPage.SetRecord(AFModels);
                            AFModelPage.LookupMode(true);
                            if AFModelPage.RunModal() = Action::LookupOK then begin
                                AFModelPage.GetRecord(AFModels);
                                gModel := AFModels.Model;
                                // if AFSalesItemFilter."Order No" <> '' then
                                //     AFSalesItemFilter.Modify()
                            end;
                        end;
                    }
                }
                group(G3)
                {
                    Caption = 'Year.....';
                    field(Year; gYear)
                    {
                        ShowCaption = false;
                        ApplicationArea = all;
                        trigger OnValidate()
                        var
                            Y: Integer;
                        begin
                            if gYear <> '' then begin
                                if not Evaluate(Y, gYear) then
                                    Error('Please enter the Number');
                                if y < 100 then begin
                                    Y := Y + 2000;
                                    gYear := Format(Y);
                                end;
                            end;
                            // if AFSalesItemFilter."Order No" <> '' then
                            //     AFSalesItemFilter.Modify();
                        end;
                    }
                }
                group(G4)
                {
                    Caption = 'Item/Part/OEM/Desc';
                    field(PartNumberS; PartNumberS)
                    {
                        ShowCaption = false;
                        ApplicationArea = all;
                    }
                }

            }

            // field(SearchItems; SearchItems)
            // {
            //     ShowCaption = false;
            //     Editable = false;
            //     ApplicationArea = all;
            //     Style = Favorable;
            //     trigger OnDrillDown()
            //     begin
            //         SetFiltersFromAFItems();
            //     end;
            // }
            // label(SearchStatus)
            // {
            //     CaptionClass = SearchStatus;
            //     Style = Attention;
            // }
            repeater(General)
            {
                Editable = false;
                ShowCaption = false;
                FreezeColumn = "No.";
                field("No."; Rec."Item No.")
                {
                    Style = Strong;
                    ToolTip = 'Specifies the number of the Item and Click to Add the item to Sales Order';
                    trigger OnDrillDown()
                    begin
                        InsertSalesLine(Rec."Item No.");
                        CurrPage.Update(false);
                    end;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the item.';
                }
                field("AF OEM No."; Rec."OEM No.")
                {
                    ApplicationArea = all;
                }
                field("AF Part Link No."; Rec."Part Link No.")
                {
                    ApplicationArea = all;
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Search)
            {
                ApplicationArea = All;
                Caption = 'Search the Items';
                Image = Sparkle;
                trigger OnAction()
                begin
                    SetFiltersFromAFItems();
                end;
            }
            separator(Line2)
            { }
            action(OpenItemCard)
            {
                Caption = 'Item Card';
                ApplicationArea = all;
                //Visible = false;
                RunObject = page "Item Card";
                RunPageLink = "No." = field("Item No.");
                RunPageMode = View;

            }
        }
    }
    trigger OnOpenPage()
    begin
        if AFSalesItemFilter.get(SalesHdr."No.") then begin
            gMake := AFSalesItemFilter.Make;
            gModel := AFSalesItemFilter.Model;
            gYear := AFSalesItemFilter.Year;
            PartNumberS := AFSalesItemFilter.PartNumber;
            SearchStatus := AFSalesItemFilter.SearchStatus;
        end;
        SearchItems := 'Click here to search';
    end;

    trigger OnClosePage()
    begin
        // if AFSalesItemFilter."Order No" <> '' then
        //     AFSalesItemFilter.Modify();
    end;

    var
        SalesHdr: Record "Sales Header";

        AFSalesItemFilter: Record "AF SalesOrder Item Filters";
        PartNumberS, SearchItems : Code[30];
        gMake, gModel, OldOrderNo : code[20];
        gYear: Code[4];
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
            gMake := AFSalesItemFilter.Make;
            gModel := AFSalesItemFilter.Model;
            gYear := AFSalesItemFilter.Year;
            PartNumberS := AFSalesItemFilter.PartNumber;
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
        if PartNumberS <> '' then begin
            Item.Reset();
            Item.SetLoadFields("No.", Description, "AF OEM No.", "AF Part Link No.");
            Item.SetFilter("No.", '*' + PartNumberS + '*');
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
            Item.SetFilter("AF OEM No.", '*' + PartNumberS + '*');
            if Item.FindSet() then begin
                repeat
                    InsertOrderItem(Item);
                until Item.next() = 0;
                F := true;
            end;
            Item.SetRange("AF OEM No.");
            Item.SetCurrentKey("AF Part Link No.");
            Item.SetFilter("AF Part Link No.", '*' + PartNumberS + '*');
            if Item.FindSet() then begin
                repeat
                    InsertOrderItem(Item);
                until Item.next() = 0;
                F := True;
            end;
            Item.SetRange("AF OEM No.");
            Item.SetRange("AF Part Link No.");
            Item.SetCurrentKey(Description);
            Item.SetFilter(Description, '*' + PartNumberS + '*');
            if Item.FindSet() then begin
                repeat
                    InsertOrderItem(Item);
                until Item.next() = 0;
                F := True;
            end;
            if F then begin
                SearchStatus := '%1 -Results from Item/Part/OEM/Descr. search for ' + PartNumberS;
                AFSalesItemFilter.PartNumber := PartNumberS;
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

        AFSalesItemFilter.Make := gMake;
        AFSalesItemFilter.Model := gModel;
        AFSalesItemFilter.Year := gYear;
        AFSalesItemFilter.SearchStatus := SearchStatus;
        AFSalesItemFilter.PartNumber := PartNumberS;
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

        if (gMake = '') and (gModel = '')
            and (gYear = '') then begin
            SearchStatus := 'Must enter make, model, year or Part Number';
            exit;
        end;

        if gMake <> '' then
            VehicleEx.SetRange("Make", gMake);

        if gModel <> '' then
            VehicleEx.SetRange("Model", gModel);

        if gYear <> '' then begin
            if Evaluate(YearInt, gYear) = false then
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
        SearchStatus := '%1 - Results from make, model or year';
        PartNumberS := '';
    end;

    local procedure InsertSalesLine(pItemNo: Code[20])
    var
        SalesLine: Record "Sales Line";
        LineNo: Integer;
    begin
        if SalesHdr."No." = '' then
            exit;
        SalesLine.SetRange("Document Type", SalesHdr."Document Type");
        SalesLine.SetRange("Document No.", SalesHdr."No.");
        if SalesLine.FindLast() then
            LineNo := SalesLine."Line No.";
        LineNo += 1000;
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetRange("No.", pItemNo);
        if SalesLine.FindFirst() then begin
            SalesLine.Validate(Quantity, SalesLine.Quantity + 1);
            SalesLine.Modify();
        end else begin
            SalesLine.Init();
            SalesLine.Validate("Document Type", SalesHdr."Document Type");
            SalesLine.Validate("Document No.", SalesHdr."No.");
            SalesLine."Line No." := LineNo;
            SalesLine.Validate(Type, SalesLine.Type::Item);
            SalesLine.Validate("No.", pItemNo);
            SalesLine.Validate(Quantity, 1);
            SalesLine.Insert();
        end;
    end;

}
