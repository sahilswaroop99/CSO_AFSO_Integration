page 50204 "AF Item Location FactBox"
{

    ApplicationArea = All;
    Caption = 'Item Info.';
    DataCaptionExpression = CapItem;
    PageType = ListPart;
    SourceTable = Item;
    //SourceTableView = where("Use As In-Transit" = const(false));
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Editable = false;


    layout
    {
        area(Content)
        {
            // group(PriceInfo)
            // {
            //     Caption = 'Price Info.';
            grid(PriceDB)
            {
                group(Price1)
                {
                    Caption = 'B2B';
                    //ShowCaption = false;
                    field(UnitPrice1; B2BPrice)
                    {
                        Caption = 'Unit Price';
                        ApplicationArea = all;
                    }
                    field(Tax1; B2BTax)
                    {
                        Caption = 'Tax';
                        ApplicationArea = all;
                    }
                    field(Total; B2BTotal)
                    {
                        Caption = 'Total';
                        ApplicationArea = all;
                    }
                    field("AF OEM No."; Rec."AF OEM No.")
                    {
                        Caption = 'OEM No.';
                        ApplicationArea = all;
                        //Style = AttentionAccent;
                    }

                }
                group(Price2)
                {
                    Caption = 'B2C';
                    field(UnitPrice2; B2CPrice)
                    {
                        Caption = 'Unit Price';
                        ApplicationArea = all;
                        //ShowCaption = false;
                    }
                    field(Tax2; B2CTax)
                    {
                        Caption = 'Tax';
                        ApplicationArea = all;
                        //ShowCaption = false;
                    }
                    field(Total2; B2CTotal)
                    {
                        Caption = 'Total';
                        ApplicationArea = all;
                        // ShowCaption = false;
                    }
                    field("AF Part Link No."; Rec."AF Part Link No.")
                    {
                        Caption = 'Part Link';
                        ApplicationArea = all;
                        // Style = AttentionAccent;
                    }

                }
            }
            //}
            field("No."; Rec."No.")
            { ApplicationArea = all; }
            field(Description; Rec.Description)
            { ApplicationArea = all; }

            group(StockInfo)
            {
                Caption = 'Stock Info.';
                grid(Gd)
                {
                    GridLayout = Rows;
                    /*                     group(g0)
                                        {
                                            // Caption = LocCode[0];
                                            ShowCaption = false;
                                            Label(LocCode0)
                                            {
                                                Caption = 'Location';
                                                ApplicationArea = all;
                                            }
                                            Label(Invt0)
                                            {
                                                Caption = 'Stock on Hand';
                                                ApplicationArea = all;
                                                Editable = false;
                                            }
                                            Label(Resrved0)
                                            {
                                                Caption = 'Allocation';
                                                ApplicationArea = all;
                                                Editable = false;
                                            }
                                            Label(SalesQty0)
                                            {
                                                Caption = 'Qty on Sales Orders';
                                                ApplicationArea = all;
                                                Editable = false;
                                            }
                                            Label(AvailableQty0)
                                            {
                                                Caption = 'Available for Shipment';
                                                ApplicationArea = all;
                                                Editable = false;
                                                //BlankZero = true;
                                            }

                                        } */

                    group(g1)
                    {
                        // Caption = LocCode[1];
                        ShowCaption = false;
                        Visible = VisiLoc1;
                        field(LocCode1; LocCode[1])
                        {
                            Caption = 'Location';
                            ApplicationArea = all;
                            ColumnSpan = 2;
                            // ShowCaption = false;
                        }
                        field(Invt1; Invt[1])
                        {
                            Caption = 'Stock on Hand';
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                            // ShowCaption = false;
                        }
                        field(Resrved1; Resrved[1])
                        {
                            Caption = 'Allocation';
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                            // ShowCaption = false;
                        }
                        field(SalesQty1; SalesQty[1])
                        {
                            Caption = 'Qty on SO';
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                            // ShowCaption = false;
                        }
                        field(AvailableQty1; PurchQty[1])//Invt[1] - SalesQty[1])
                        {
                            Caption = 'Avail. for Shipment';
                            ApplicationArea = all;
                            Editable = false;
                            // ShowCaption = false;
                            DecimalPlaces = 0 : 2;

                        }

                    }
                    group(g2)
                    {
                        // Caption = LocCode[2];
                        ShowCaption = false;
                        Visible = VisiLoc2;
                        field(LocCode2; LocCode[2])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                        }
                        field(Invt2; Invt[2])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                        }
                        field(Resrved2; Resrved[2])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                        }
                        field(SalesQty2; SalesQty[2])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                        }
                        field(AvailableQty2; PurchQty[2])// Invt[2] - SalesQty[2])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                            //BlankZero = true;
                        }
                    }
                    group(g3)
                    {
                        // Caption = LocCode[3];
                        ShowCaption = false;
                        Visible = VisiLoc3;
                        field(LocCode3; LocCode[3])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                        }
                        field(Invt3; Invt[3])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                        }
                        field(Resrved3; Resrved[3])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                        }
                        field(SalesQty3; SalesQty[3])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                        }
                        field(AvailableQty3; PurchQty[3])//Invt[3] - SalesQty[3])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                            //BlankZero = true;
                        }
                    }
                    group(g4)
                    {
                        // Caption = LocCode[4];
                        ShowCaption = false;
                        Visible = VisiLoc4;
                        field(LocCode4; LocCode[4])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                        }
                        field(Invt4; Invt[4])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                        }
                        field(Resrved4; Resrved[4])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                        }
                        field(SalesQty4; SalesQty[4])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                        }
                        field(AvailableQty4; PurchQty[4])//Invt[4] - SalesQty[4])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                            //BlankZero = true;
                        }
                    }
                    group(g5)
                    {
                        // Caption = LocCode[5];
                        ShowCaption = false;
                        Visible = VisiLoc5;
                        field(LocCode5; LocCode[5])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                        }
                        field(Invt5; Invt[5])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                        }
                        field(Resrved5; Resrved[5])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                        }
                        field(SalesQty5; SalesQty[5])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                        }
                        field(AvailableQty5; PurchQty[5])//Invt[5] - SalesQty[5])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                            //BlankZero = true;
                        }
                    }
                    group(g6)
                    {
                        // Caption = LocCode[6];
                        ShowCaption = false;
                        Visible = VisiLoc6;
                        field(LocCode6; LocCode[6])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                        }
                        field(Invt6; Invt[6])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                        }
                        field(Resrved6; Resrved[6])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                        }
                        field(SalesQty6; SalesQty[6])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                        }
                        field(AvailableQty6; PurchQty[6])//Invt[6] - SalesQty[6])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                            //BlankZero = true;
                        }
                    }
                    group(g7)
                    {
                        // Caption = LocCode[7];
                        ShowCaption = false;
                        Visible = VisiLoc7;
                        field(LocCode7; LocCode[7])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                        }
                        field(Invt7; Invt[7])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                        }
                        field(Resrved7; Resrved[7])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                        }
                        field(SalesQty7; SalesQty[7])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                        }
                        field(AvailableQty7; PurchQty[7])//Invt[7] - SalesQty[7])
                        {
                            ShowCaption = false;
                            ApplicationArea = all;
                            Editable = false;
                            DecimalPlaces = 0 : 2;
                            //BlankZero = true;
                        }
                    }

                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        SalesInvLine: Record "Sales Invoice Line";
    begin
        Clear(Invt);
        Clear(SalesQty);
        Clear(PurchQty);
        Clear(Resrved);
        Clear(Invt);
        Clear(LocCode);
        CalcLocationInventory();
        GetSalesPriceInfor();
    end;

    trigger OnInit()
    begin
        VisiLoc1 := true;
        VisiLoc2 := true;
        VisiLoc3 := true;
        VisiLoc4 := true;
        VisiLoc5 := true;
        VisiLoc6 := true;
        VisiLoc7 := true;
    end;

    trigger OnOpenPage()
    begin
        VisiLoc1 := False;
        VisiLoc2 := False;
        VisiLoc3 := False;
        VisiLoc4 := False;
        VisiLoc5 := False;
        VisiLoc6 := False;
        VisiLoc7 := False;
    end;

    var
        SalesHeader: Record "Sales Header";
        CapItem: text;
        LocCode: array[7] of Text;
        Invt, Resrved, SalesQty, PurchQty : array[7] of Decimal;
        B2CPrice, B2CTax, B2CTotal, B2BPrice, B2BTax, B2BTotal : decimal;
        VisiLoc1, VisiLoc2, VisiLoc3, VisiLoc4, VisiLoc5, VisiLoc6, VisiLoc7 : Boolean;
    //  Item: Record Item;

    local procedure CalcLocationInventory()
    var
        Location: Record Location;
        i: Integer;
        Item: Record Item;
    begin
        Item.SetLoadFields("No.", "Location Filter");
        Item.Get(Rec."No.");
        Location.SetLoadFields(Code, Name);
        Location.SetRange("Use As In-Transit", false);
        if Location.FindSet() then
            repeat
                i += 1;
                if i < 8 then begin
                    LocCode[i] := '     ' + Location.Code;
                    Item.SetRange("Location Filter", Location.Code);
                    Item.CalcFields(Inventory, "Reserved Qty. on Sales Orders", "Qty. on Sales Order", "Qty. on Purch. Order");
                    Invt[i] := Item.Inventory;
                    Resrved[i] := Item."Reserved Qty. on Sales Orders";
                    SalesQty[i] := Item."Qty. on Sales Order";
                    PurchQty[i] := Item."Qty. on Purch. Order";
                    case i of
                        1:
                            VisiLoc1 := true;
                        2:
                            VisiLoc2 := true;
                        3:
                            VisiLoc3 := true;
                        4:
                            VisiLoc4 := true;
                        5:
                            VisiLoc5 := true;
                        6:
                            VisiLoc6 := true;
                        7:
                            VisiLoc7 := true;
                    end;
                end;
            until (Location.Next() = 0) or (i > 7);
    end;

    local procedure GetSalesPriceInfor()
    begin
        Clear(B2CPrice);
        Clear(B2CTax);
        Clear(B2CTotal);
        Clear(B2BPrice);
        Clear(B2BTax);
        Clear(B2BTotal);
        if SalesHeader."Sell-to Customer No." = '' then
            exit;
        CalcPricePerGroup('B2B', B2BPrice, B2BTax);
        B2BTotal := B2BPrice + B2BTax;
        CalcPricePerGroup('B2C', B2CPrice, B2CTax);
        B2CTotal := B2CPrice + B2CTax;
    end;

    local procedure CalcPricePerGroup(PricGroup: Code[10]; var Price: Decimal; var Tax: Decimal)
    var
        TempSalesLine: Record "Sales Line" temporary;
    begin
        TempSalesLine.init();
        TempSalesLine.SuspendStatusCheck(true);
        TempSalesLine.SetHideValidationDialog(true);
        TempSalesLine.Validate("Document Type", SalesHeader."Document Type");
        TempSalesLine.Validate("Document No.", SalesHeader."No.");
        TempSalesLine."Line No." := 10000;
        TempSalesLine.Insert();
        TempSalesLine.type := TempSalesLine.Type::Item;
        TempSalesLine.Validate("No.", Rec."No.");
        // TempSalesLine.InitHeaderDefaults(SalesHeader);
        // TempSalesLine."Gen. Prod. Posting Group" := Rec."Gen. Prod. Posting Group";
        // TempSalesLine."VAT Prod. Posting Group" := Rec."VAT Prod. Posting Group";
        // TempSalesLine."Tax Group Code" := Rec."Tax Group Code";
        TempSalesLine."Customer Price Group" := PricGroup;
        TempSalesLine.Validate(Quantity, 1);
        TempSalesLine.Validate("Line Discount %", 0);
        TempSalesLine.Modify();
        Price := TempSalesLine."Unit Price";
        Tax := TempSalesLine."Amount Including VAT" - TempSalesLine.Amount;
    end;

    procedure SetSalesHeader(pSalesHdr: Record "Sales Header")
    begin
        SalesHeader.Copy(pSalesHdr);
    end;

}

