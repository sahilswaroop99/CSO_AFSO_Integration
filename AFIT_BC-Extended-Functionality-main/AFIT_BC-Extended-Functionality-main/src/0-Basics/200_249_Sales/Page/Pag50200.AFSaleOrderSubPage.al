page 50200 "AF Sale Order SubPage"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type" = filter(Order));

    layout
    {
        area(content)
        {
            // group(Control51)
            // {
            //     ShowCaption = false;
            //     group(Control28)
            //     {
            //         ShowCaption = false;
            //         field("Total Amount Excl. VAT"; TotalSalesLine.Amount)
            //         {
            //             ApplicationArea = Basic, Suite;
            //             AutoFormatExpression = Currency.Code;
            //             AutoFormatType = 1;
            //             CaptionClass = DocumentTotals.GetTotalExclVATCaption(Currency.Code);
            //             Caption = 'Total Amount Excl. VAT';
            //             DrillDown = false;
            //             Editable = false;
            //             ToolTip = 'Specifies the sum of the value in the Line Amount Excl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
            //         }
            //         field("Total VAT Amount"; VATAmount)
            //         {
            //             ApplicationArea = Basic, Suite;
            //             AutoFormatExpression = Currency.Code;
            //             AutoFormatType = 1;
            //             CaptionClass = DocumentTotals.GetTotalVATCaption(Currency.Code);
            //             Caption = 'Total VAT';
            //             Editable = false;
            //             ToolTip = 'Specifies the sum of VAT amounts on all lines in the document.';
            //         }
            field("Total Amount Incl. VAT"; TotalSalesLine."Amount Including VAT")
            {
                ApplicationArea = Basic, Suite;
                Style = StrongAccent;
                AutoFormatExpression = Currency.Code;
                AutoFormatType = 1;
                CaptionClass = DocumentTotals.GetTotalInclVATCaption(Currency.Code);
                Caption = 'Total Amount Incl. VAT';
                Editable = false;
                ToolTip = 'Specifies the sum of the value in the Line Amount Incl. VAT field on all lines in the document minus any discount amount in the Invoice Discount Amount field.';
            }
            //         field(ClickHere2; 'Refresh Totals')
            //         {
            //             Editable = false;
            //             ShowCaption = false;
            //             ApplicationArea = all;
            //             Style = AttentionAccent;
            //             trigger OnDrillDown()
            //             begin
            //                 GetTotalSalesHeader();
            //                 CalculateTotals();
            //                 CurrPage.Update();
            //             end;
            //         }
            //     }

            // }
            repeater(Control1)
            {
                ShowCaption = false;
                // field(Type; Rec.Type)
                // {
                //     ApplicationArea = Advanced;
                //     Enabled = false;
                //     Visible = false;
                //     ToolTip = 'Specifies the type of entity that will be posted for this sales line, such as Item, Resource, or G/L Account.';

                //     trigger OnValidate()
                //     begin
                //         NoOnAfterValidate();
                //         SetLocationCodeMandatory();
                //         UpdateEditableOnRow();
                //         UpdateTypeText();
                //         DeltaUpdateTotals();
                //     end;
                // }
                // field(FilteredTypeField; TypeAsText)
                // {
                //     ApplicationArea = Basic, Suite;
                //     Caption = 'Type';
                //     Enabled = false;
                //     Visible = false;
                //     Editable = CurrPageIsEditable;
                //     LookupPageID = "Option Lookup List";
                //     TableRelation = "Option Lookup Buffer"."Option Caption" where("Lookup Type" = const(Sales));
                //     ToolTip = 'Specifies the type of transaction that will be posted with the document line. If you select Comment, then you can enter any text in the Description field, such as a message to a customer. ';
                //     //  Visible = IsFoundation;

                //     trigger OnValidate()
                //     begin
                //         TempOptionLookupBuffer.SetCurrentType(Rec.Type.AsInteger());
                //         if TempOptionLookupBuffer.AutoCompleteLookup(TypeAsText, TempOptionLookupBuffer."Lookup Type"::Sales) then
                //             Rec.Validate(Type, TempOptionLookupBuffer.ID);
                //         TempOptionLookupBuffer.ValidateOption(TypeAsText);
                //         UpdateEditableOnRow();
                //         UpdateTypeText();
                //         DeltaUpdateTotals();
                //     end;
                // }
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ShowMandatory = not IsCommentLine;
                    ToolTip = 'Specifies what you are selling, such as a product or a fixed asset. You’ll see different lists of things to choose from depending on your choice in the Type field.';

                    trigger OnValidate()
                    var
                        IsHandled: Boolean;
                    begin
                        IsHandled := false;
                        OnBeforeValidateNo(Rec, xRec, IsHandled);
                        if IsHandled then
                            exit;

                        NoOnAfterValidate();
                        UpdateEditableOnRow();
                        Rec.ShowShortcutDimCode(ShortcutDimCode);

                        QuantityOnAfterValidate();
                        UpdateTypeText();
                        DeltaUpdateTotals();

                        CurrPage.Update();
                    end;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic, Suite;
                    QuickEntry = false;
                    ShowMandatory = not IsCommentLine;
                    ToolTip = 'Specifies a description of what you’re selling. Based on your choices in the Type and No. fields, the field may show suggested text that you can change it for this document. To add a comment, set the Type field to Comment and write the comment itself here.';

                    trigger OnValidate()
                    begin
                        UpdateEditableOnRow();

                        Rec.RestoreLookupSelection();

                        if Rec."No." = xRec."No." then
                            exit;

                        NoOnAfterValidate();
                        Rec.ShowShortcutDimCode(ShortcutDimCode);
                        UpdateTypeText();
                        DeltaUpdateTotals();
                        OnAfterValidateDescription(Rec, xRec);
                    end;

                    trigger OnAfterLookup(Selected: RecordRef)
                    begin
                        Rec.SaveLookupSelection(Selected);
                    end;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    // Editable = not IsBlankNumber;
                    // Enabled = not IsBlankNumber;
                    QuickEntry = false;
                    ShowMandatory = LocationCodeMandatory;
                    ToolTip = 'Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.';


                    trigger OnValidate()
                    begin
                        LocationCodeOnAfterValidate();
                        DeltaUpdateTotals();
                    end;
                }
                // field("Bin Code"; Rec."Bin Code")
                // {
                //     ApplicationArea = Warehouse;
                //     ToolTip = 'Specifies the bin where the items are picked or put away.';
                //     Visible = false;
                // }
                field(Control50; Rec.Reserve)
                {
                    ApplicationArea = Reservation;
                    ToolTip = 'Specifies whether a reservation can be made for items on this line.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        ReserveOnAfterValidate();
                    end;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = UnitofMeasureCodeIsChangeable;
                    Enabled = UnitofMeasureCodeIsChangeable;
                    QuickEntry = false;
                    ToolTip = 'Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.';

                    trigger OnValidate()
                    begin
                        UnitofMeasureCodeOnAfterValidate();
                    end;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = not IsCommentLine;
                    Enabled = not IsCommentLine;
                    ShowMandatory = (Rec.Type <> Rec.Type::" ") and (Rec."No." <> '');
                    ToolTip = 'Specifies how many units are being sold.';

                    AboutTitle = 'How much is being ordered';
                    AboutText = 'The quantity on a line specifies how much of an item a customer is ordering. This quantity determines whether the order qualifies for special prices or discounts.';

                    trigger OnValidate()
                    begin
                        QuantityOnAfterValidate();
                        DeltaUpdateTotals();
                        SetItemChargeFieldsStyle();
                        if SalesSetup."Calc. Inv. Discount" and (Rec.Quantity = 0) then
                            CurrPage.Update(false);
                    end;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = not IsBlankNumber;
                    Enabled = not IsBlankNumber;
                    ShowMandatory = (Rec.Type <> Rec.Type::" ") and (Rec."No." <> '');
                    ToolTip = 'Specifies the price for one unit on the sales line.';

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Reserved Quantity"; Rec."Reserved Quantity")
                {
                    ApplicationArea = Reservation;
                    BlankZero = true;
                    QuickEntry = false;
                    Visible = false;
                    ToolTip = 'Specifies how many units of the item on the line have been reserved.';
                }

                field("Line Discount %"; Rec."Line Discount %")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = not IsBlankNumber;
                    Enabled = not IsBlankNumber;
                    // Visible = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the discount percentage that is granted for the item on the line.';

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Line Discount Amount"; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the discount amount that is granted for the item on the line.';
                    //Visible = false;
                    Editable = not IsBlankNumber;
                    Enabled = not IsBlankNumber;
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Line Amount"; Rec."Line Amount")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Editable = not IsBlankNumber;
                    Enabled = not IsBlankNumber;
                    ShowMandatory = (Rec.Type <> Rec.Type::" ") and (Rec."No." <> '');
                    ToolTip = 'Specifies the net amount, excluding any invoice discount amount, that must be paid for products on the line.';

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the sum of the amounts in the Amount Including VAT fields on the associated sales lines.';
                }




                field("Unit of Measure"; Rec."Unit of Measure")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the unit of measure for the item or resource on the sales line.';
                    Visible = false;
                }
                field("Unit Cost (LCY)"; Rec."Unit Cost (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the unit cost of the item on the line.';
                    Visible = false;
                }
                field(SalesPriceExist; Rec.PriceExists())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Price Exists';
                    Editable = false;
                    ToolTip = 'Specifies that there is a specific price for this customer.';
                    Visible = false;
                }

                field("Tax Liable"; Rec."Tax Liable")
                {
                    ApplicationArea = SalesTax;
                    Editable = false;
                    ToolTip = 'Specifies if the customer or vendor is liable for sales tax.';
                    Visible = false;
                }
                field("Tax Area Code"; Rec."Tax Area Code")
                {
                    ApplicationArea = SalesTax;
                    Visible = false;
                    ToolTip = 'Specifies the tax area that is used to calculate and post sales tax.';

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }
                field("Tax Group Code"; Rec."Tax Group Code")
                {
                    ApplicationArea = SalesTax;
                    Editable = not IsCommentLine;
                    Enabled = not IsCommentLine;
                    Visible = false;
                    ShowMandatory = (NOT IsCommentLine) AND (Rec."No." <> '');
                    ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';

                    trigger OnValidate()
                    begin
                        DeltaUpdateTotals();
                    end;
                }

                field("Qty. to Ship"; Rec."Qty. to Ship")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Visible = false;
                    ToolTip = 'Specifies the quantity of items that remain to be shipped.';

                    AboutTitle = 'Partially shipping the order?';
                    AboutText = 'If you want to ship only parts of the order, adjust the *Qty. to Ship* value to that quantity. By common default, the total quantity is shipped.';

                    trigger OnValidate()
                    begin
                        SetItemChargeFieldsStyle();
                        if Rec."Qty. to Asm. to Order (Base)" <> 0 then begin
                            CurrPage.SaveRecord();
                            CurrPage.Update(false);
                        end;
                    end;
                }
                field("Quantity Shipped"; Rec."Quantity Shipped")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    QuickEntry = false;
                    Visible = false;
                    ToolTip = 'Specifies how many units of the item on the line have been posted as shipped.';

                    trigger OnDrillDown()
                    var
                        SalesShipmentLine: Record "Sales Shipment Line";
                    begin
                        SalesShipmentLine.SetCurrentKey("Document No.", "No.", "Shipment Date");
                        SalesShipmentLine.SetRange("Order No.", Rec."Document No.");
                        SalesShipmentLine.SetRange("Order Line No.", Rec."Line No.");
                        SalesShipmentLine.SetFilter(Quantity, '<>%1', 0);
                        Page.RunModal(0, SalesShipmentLine);
                    end;
                }
                field("Qty. to Invoice"; Rec."Qty. to Invoice")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Visible = false;
                    ToolTip = 'Specifies the quantity that remains to be invoiced. It is calculated as Quantity - Qty. Invoiced.';

                    AboutTitle = 'Invoicing more or less than you ship?';
                    AboutText = 'Adjust the *Qty. to Invoice* to specify the quantity you want to invoice now. If that is more than you ship, use the prepayment functionality.';

                    trigger OnValidate()
                    begin
                        SetItemChargeFieldsStyle();
                    end;
                }
                field("Quantity Invoiced"; Rec."Quantity Invoiced")
                {
                    ApplicationArea = Basic, Suite;
                    BlankZero = true;
                    Visible = false;
                    ToolTip = 'Specifies how many units of the item on the line have been posted as invoiced.';

                    trigger OnDrillDown()
                    var
                        SalesInvoiceLine: Record "Sales Invoice Line";
                    begin
                        SalesInvoiceLine.SetCurrentKey("Document No.", "No.", "Posting Date");
                        SalesInvoiceLine.SetRange("Order No.", Rec."Document No.");
                        SalesInvoiceLine.SetRange("Order Line No.", Rec."Line No.");
                        SalesInvoiceLine.SetFilter(Quantity, '<>%1', 0);
                        Page.RunModal(0, SalesInvoiceLine);
                    end;
                }

                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date that the customer has asked for the order to be delivered.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        UpdateForm(true);
                    end;
                }
                field("Promised Delivery Date"; Rec."Promised Delivery Date")
                {
                    ApplicationArea = OrderPromising;
                    ToolTip = 'Specifies the date that you have promised to deliver the order, as a result of the Order Promising function.';
                    Visible = false;

                    trigger OnValidate()
                    begin
                        UpdateForm(true);
                    end;
                }
                field("Planned Delivery Date"; Rec."Planned Delivery Date")
                {
                    ApplicationArea = Planning;
                    QuickEntry = false;
                    Visible = false;
                    ToolTip = 'Specifies the planned date that the shipment will be delivered at the customer''s address. If the customer requests a delivery date, the program calculates whether the items will be available for delivery on this date. If the items are available, the planned delivery date will be the same as the requested delivery date. If not, the program calculates the date that the items are available for delivery and enters this date in the Planned Delivery Date field.';

                    trigger OnValidate()
                    begin
                        UpdateForm(true);
                    end;
                }

                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = Basic, Suite;
                    QuickEntry = false;
                    Visible = false;
                    ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';

                    trigger OnValidate()
                    begin
                        ShipmentDateOnAfterValidate();
                    end;
                }
                /*    field("Gen. Bus. Posting Group"; Rec."Gen. Bus. Posting Group")
                   {
                       ApplicationArea = Basic, Suite;
                       ToolTip = 'Specifies the vendor''s or customer''s trade type to link transactions made for this business partner with the appropriate general ledger account according to the general posting setup.';
                       Visible = false;

                       trigger OnValidate()
                       begin
                           DeltaUpdateTotals();
                       end;
                   }
                   field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                   {
                       ApplicationArea = Basic, Suite;
                       ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                       Visible = false;

                       trigger OnValidate()
                       begin
                           DeltaUpdateTotals();
                       end;
                   }
                   field("VAT Bus. Posting Group"; Rec."VAT Bus. Posting Group")
                   {
                       ApplicationArea = Basic, Suite;
                       ToolTip = 'Specifies the vendor''s VAT specification to link transactions made for this vendor with the appropriate general ledger account according to the VAT posting setup.';
                       Visible = false;

                       trigger OnValidate()
                       begin
                           DeltaUpdateTotals();
                       end;
                   }
                   field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                   {
                       ApplicationArea = Basic, Suite;
                       ToolTip = 'Specifies the VAT product posting group. Links business transactions made for the item, resource, or G/L account with the general ledger, to account for VAT amounts resulting from trade with that record.';
                       Visible = false;

                       trigger OnValidate()
                       begin
                           DeltaUpdateTotals();
                       end;
                   } */

                field("Shipping Time"; Rec."Shipping Time")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how long it takes from when the items are shipped from the warehouse to when they are delivered.';
                    Visible = false;
                }

                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = DimVisible1;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                    Visible = DimVisible2;
                }
                /*     field(ShortcutDimCode3; ShortcutDimCode[3])
                    {
                        ApplicationArea = Dimensions;
                        CaptionClass = '1,2,3';
                        TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3),
                                                                      "Dimension Value Type" = const(Standard),
                                                                      Blocked = const(false));
                        Visible = DimVisible3;

                        trigger OnValidate()
                        begin
                            ValidateShortcutDimension(3);
                        end;
                    }
                    field(ShortcutDimCode4; ShortcutDimCode[4])
                    {
                        ApplicationArea = Dimensions;
                        CaptionClass = '1,2,4';
                        TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4),
                                                                      "Dimension Value Type" = const(Standard),
                                                                      Blocked = const(false));
                        Visible = DimVisible4;

                        trigger OnValidate()
                        begin
                            ValidateShortcutDimension(4);
                        end;
                    }
                    field(ShortcutDimCode5; ShortcutDimCode[5])
                    {
                        ApplicationArea = Dimensions;
                        CaptionClass = '1,2,5';
                        TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5),
                                                                      "Dimension Value Type" = const(Standard),
                                                                      Blocked = const(false));
                        Visible = DimVisible5;

                        trigger OnValidate()
                        begin
                            ValidateShortcutDimension(5);
                        end;
                    }
                    field(ShortcutDimCode6; ShortcutDimCode[6])
                    {
                        ApplicationArea = Dimensions;
                        CaptionClass = '1,2,6';
                        TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6),
                                                                      "Dimension Value Type" = const(Standard),
                                                                      Blocked = const(false));
                        Visible = DimVisible6;

                        trigger OnValidate()
                        begin
                            ValidateShortcutDimension(6);
                        end;
                    }
                    field(ShortcutDimCode7; ShortcutDimCode[7])
                    {
                        ApplicationArea = Dimensions;
                        CaptionClass = '1,2,7';
                        TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7),
                                                                      "Dimension Value Type" = const(Standard),
                                                                      Blocked = const(false));
                        Visible = DimVisible7;

                        trigger OnValidate()
                        begin
                            ValidateShortcutDimension(7);
                        end;
                    }
                    field(ShortcutDimCode8; ShortcutDimCode[8])
                    {
                        ApplicationArea = Dimensions;
                        CaptionClass = '1,2,8';
                        TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8),
                                                                      "Dimension Value Type" = const(Standard),
                                                                      Blocked = const(false));
                        Visible = DimVisible8;

                        trigger OnValidate()
                        begin
                            ValidateShortcutDimension(8);
                        end;
                    } */
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the document number.';
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the line number.';
                    Visible = false;
                }


            }

        }
    }

    actions
    {
        area(processing)
        {

            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                group("F&unctions")
                {
                    Caption = 'F&unctions';
                    Image = "Action";

                    action(GetPrices)
                    {
                        AccessByPermission = TableData "Sales Price Access" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Get Price';
                        Ellipsis = true;
                        Image = Price;
                        Visible = ExtendedPriceEnabled;
                        ToolTip = 'Insert the lowest possible price in the Unit Price field according to any special price that you have set up.';

                        trigger OnAction()
                        begin
                            ShowPrices();
                        end;
                    }
                    action(GetLineDiscount)
                    {
                        AccessByPermission = TableData "Sales Discount Access" = R;
                        ApplicationArea = Basic, Suite;
                        Caption = 'Get Li&ne Discount';
                        Ellipsis = true;
                        Image = LineDiscount;
                        Visible = ExtendedPriceEnabled;
                        ToolTip = 'Insert the best possible discount in the Line Discount field according to any special discounts that you have set up.';

                        trigger OnAction()
                        begin
                            ShowLineDisc();
                        end;
                    }
                    action(Reserve)
                    {
                        ApplicationArea = Reservation;
                        Caption = '&Reserve';
                        Ellipsis = true;
                        Image = Reserve;
                        Enabled = Rec.Type = Rec.Type::Item;
                        ToolTip = 'Reserve the quantity of the selected item that is required on the document line from which you opened this page. This action is available only for lines that contain an item.';

                        trigger OnAction()
                        begin
                            Rec.Find();
                            Rec.ShowReservation();
                        end;
                    }
                    action(OrderTracking)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Order &Tracking';
                        Image = OrderTracking;
                        Enabled = Rec.Type = Rec.Type::Item;
                        ToolTip = 'Track the connection of a supply to its corresponding demand for the selected item. This can help you find the original demand that created a specific production order or purchase order. This action is available only for lines that contain an item.';

                        trigger OnAction()
                        begin
                            ShowTracking();
                        end;
                    }

                }
                group("Item Availability by")
                {
                    Enabled = Rec.Type = Rec.Type::Item;
                    Caption = 'Item Availability by';
                    Image = ItemAvailability;
                    action(ItemAvailabilityByLocation)
                    {
                        AccessByPermission = TableData Location = R;
                        ApplicationArea = Location;
                        Caption = 'Location';
                        Image = Warehouse;
                        ToolTip = 'View the actual and projected quantity of the item per location.';

                        trigger OnAction()
                        begin
                            ItemAvailFormsMgt.ShowItemAvailFromSalesLine(Rec, ItemAvailFormsMgt.ByLocation())
                        end;
                    }

                }
                group("Related Information")
                {
                    Caption = 'Related Information';
                    action("Reservation Entries")
                    {
                        AccessByPermission = TableData Item = R;
                        ApplicationArea = Reservation;
                        Caption = 'Reservation Entries';
                        Image = ReservationLedger;
                        Enabled = Rec.Type = Rec.Type::Item;
                        ToolTip = 'View all reservation entries for the selected item. This action is available only for lines that contain an item.';

                        trigger OnAction()
                        begin
                            Rec.ShowReservationEntries(true);
                        end;
                    }
                    action(ItemTrackingLines)
                    {
                        ApplicationArea = ItemTracking;
                        Caption = 'Item &Tracking Lines';
                        Image = ItemTrackingLines;
                        ShortCutKey = 'Ctrl+Alt+I';
                        Enabled = Rec.Type = Rec.Type::Item;
                        ToolTip = 'View or edit serial and lot numbers for the selected item. This action is available only for lines that contain an item.';

                        trigger OnAction()
                        begin
                            Rec.OpenItemTrackingLines();
                        end;
                    }
                    action(SelectItemSubstitution)
                    {
                        AccessByPermission = TableData "Item Substitution" = R;
                        ApplicationArea = Suite;
                        Caption = 'Select Item Substitution';
                        Image = SelectItemSubstitution;
                        ToolTip = 'Select another item that has been set up to be sold instead of the original item if it is unavailable.';

                        trigger OnAction()
                        begin
                            CurrPage.SaveRecord();
                            Rec.ShowItemSub();
                            CurrPage.Update(true);
                            if (Rec.Reserve = Rec.Reserve::Always) and (Rec."No." <> xRec."No.") then begin
                                Rec.AutoReserve();
                                CurrPage.Update(false);
                            end;
                        end;
                    }
                    action(Dimensions)
                    {
                        AccessByPermission = TableData Dimension = R;
                        ApplicationArea = Dimensions;
                        Caption = 'Dimensions';
                        Image = Dimensions;
                        ShortCutKey = 'Alt+D';
                        ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                        trigger OnAction()
                        begin
                            Rec.ShowDimensions();
                        end;
                    }
                    action("Co&mments")
                    {
                        ApplicationArea = Comments;
                        Caption = 'Co&mments';
                        Image = ViewComments;
                        ToolTip = 'View or add comments for the record.';

                        trigger OnAction()
                        begin
                            Rec.ShowLineComments();
                        end;
                    }

                    action(OrderPromising)
                    {
                        AccessByPermission = TableData "Order Promising Line" = R;
                        ApplicationArea = OrderPromising;
                        Caption = 'Order &Promising';
                        Image = OrderPromising;
                        ToolTip = 'Calculate the shipment and delivery dates based on the item''s known and expected availability dates, and then promise the dates to the customer.';

                        trigger OnAction()
                        begin
                            OrderPromisingLine();
                        end;
                    }
                    action(DocAttach)
                    {
                        ApplicationArea = All;
                        Caption = 'Attachments';
                        Image = Attach;
                        ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                        trigger OnAction()
                        var
                            DocumentAttachmentDetails: Page "Document Attachment Details";
                            RecRef: RecordRef;
                        begin
                            RecRef.GetTable(Rec);
                            DocumentAttachmentDetails.OpenForRecRef(RecRef);
                            DocumentAttachmentDetails.RunModal();
                        end;
                    }

                    action(DocumentLineTracking)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document &Line Tracking';
                        Image = Navigate;
                        ToolTip = 'View related open, posted, or archived documents or document lines. ';

                        trigger OnAction()
                        begin
                            ShowDocumentLineTracking();
                        end;
                    }


                }
            }

            group(Errors)
            {
                Caption = 'Issues';
                Image = ErrorLog;
                Visible = BackgroundErrorCheck;
                ShowAs = SplitButton;

                action(ShowLinesWithErrors)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Lines with Issues';
                    Image = Error;
                    Visible = BackgroundErrorCheck;
                    Enabled = not ShowAllLinesEnabled;
                    ToolTip = 'View a list of sales lines that have issues before you post the document.';

                    trigger OnAction()
                    begin
                        Rec.SwitchLinesWithErrorsFilter(ShowAllLinesEnabled);
                    end;
                }
                action(ShowAllLines)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show All Lines';
                    Image = ExpandAll;
                    Visible = BackgroundErrorCheck;
                    Enabled = ShowAllLinesEnabled;
                    ToolTip = 'View all sales lines, including lines with and without issues.';

                    trigger OnAction()
                    begin
                        Rec.SwitchLinesWithErrorsFilter(ShowAllLinesEnabled);
                    end;
                }
            }
            group("Page")
            {
                Caption = 'Page';

                action(EditInExcel)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Edit in Excel';
                    Image = Excel;
                    Visible = false;
                    // Visible = IsSaaSExcelAddinEnabled;
                    ToolTip = 'Send the data in the sub page to an Excel file for analysis or editing';
                    AccessByPermission = System "Allow Action Export To Excel" = X;

                    trigger OnAction()
                    var
                        EditinExcel: Codeunit "Edit in Excel";
                        EditinExcelFilters: Codeunit "Edit in Excel Filters";
                    begin
                        EditinExcelFilters.AddField('Document_No', Enum::"Edit in Excel Filter Type"::Equal, Rec."Document No.", Enum::"Edit in Excel Edm Type"::"Edm.String");

                        EditinExcel.EditPageInExcel(
                            'Sales_Order_Line',
                            page::"Sales Order Subform",
                            EditinExcelFilters,
                            StrSubstNo(ExcelFileNameTxt, Rec."Document No."));
                    end;

                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeAfterGetCurrRecord(Rec, IsHandled, TotalSalesHeader, Currency);
        if IsHandled then
            exit;

        GetTotalSalesHeader();
        CalculateTotals();
        SetLocationCodeMandatory();
        UpdateEditableOnRow();
        UpdateTypeText();
        SetItemChargeFieldsStyle();
    end;

    trigger OnAfterGetRecord()
    var
        Item: Record "Item";
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
        UpdateEditableOnRow();
        UpdateTypeText();
        SetItemChargeFieldsStyle();
        if Rec."Variant Code" = '' then
            VariantCodeMandatory := Item.IsVariantMandatory(Rec.Type = Rec.Type::Item, Rec."No.");
    end;

    trigger OnDeleteRecord(): Boolean
    var
        SalesLineReserve: Codeunit "Sales Line-Reserve";
    begin
        if (Rec.Quantity <> 0) and Rec.ItemExists(Rec."No.") then begin
            Commit();
            if not SalesLineReserve.DeleteLineConfirm(Rec) then
                exit(false);

            OnBeforeDeleteReservationEntries(Rec);
            SalesLineReserve.DeleteLine(Rec);
        end;
        DocumentTotals.SalesDocTotalsNotUpToDate();
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        Rec.AddLoadFields(
            "Price Calculation Method", "Sell-to Customer No.", "Customer Disc. Group", "Customer Price Group",
            "VAT %", "VAT Calculation Type", "VAT Bus. Posting Group", "VAT Prod. Posting Group",
            "Dimension Set ID", "Currency Code", "Qty. per Unit of Measure", "Allow Line Disc.");

        DocumentTotals.SalesCheckAndClearTotals(Rec, xRec, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        exit(Rec.Find(Which));
    end;

    trigger OnInit()
    var
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
        EInvoiceMgt: Codeunit "E-Invoice Mgt.";
    begin
        SalesSetup.Get();
        Currency.InitRoundingPrecision();
        TempOptionLookupBuffer.FillLookupBuffer(Enum::"Option Lookup Type"::Sales);
        IsFoundation := ApplicationAreaMgmtFacade.IsFoundationEnabled();
        //IsPACEnabled := EInvoiceMgt.IsPACEnvironmentEnabled();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        DocumentTotals.SalesCheckIfDocumentChanged(Rec, xRec);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.InitType();
        SetDefaultType();

        Clear(ShortcutDimCode);
        UpdateTypeText();
    end;

    trigger OnOpenPage()
    var
        AllocationAccountMgt: Codeunit "Allocation Account Mgt.";
    begin
        UseAllocationAccountNumber := AllocationAccountMgt.UseAllocationAccountNoField();
        SetOpenPage();

        SetDimensionsVisibility();
        SetItemReferenceVisibility();
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        TempOptionLookupBuffer: Record "Option Lookup Buffer" temporary;
        TransferExtendedText: Codeunit "Transfer Extended Text";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        AmountWithDiscountAllowed: Decimal;
        Text001: Label 'You cannot use the Explode BOM function because a prepayment of the sales order has been invoiced.';
        VariantCodeMandatory: Boolean;
        LocationCodeVisible: Boolean;
        IsFoundation: Boolean;
        CurrPageIsEditable: Boolean;
        BackgroundErrorCheck: Boolean;
        ShowAllLinesEnabled: Boolean;
        IsSaaSExcelAddinEnabled: Boolean;
        ExtendedPriceEnabled: Boolean;
        AttachingLinesEnabled: Boolean;
        UpdateInvDiscountQst: Label 'One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?';
        ItemChargeStyleExpression: Text;
        ItemChargeToHandleStyleExpression: Text;
        TypeAsText: Text[30];
        UseAllocationAccountNumber: Boolean;
        ActionOnlyAllowedForAllocationAccountsErr: Label 'This action is only available for lines that have Allocation Account set as Type.';
        ExcelFileNameTxt: Label 'Sales Order %1 - Lines', Comment = '%1 = document number, ex. 10000';

    protected var
        Currency: Record Currency;
        TotalSalesHeader: Record "Sales Header";
        TotalSalesLine: Record "Sales Line";
        DocumentTotals: Codeunit "Document Totals";
        ShortcutDimCode: array[8] of Code[20];
        DimVisible1: Boolean;
        DimVisible2: Boolean;
        DimVisible3: Boolean;
        DimVisible4: Boolean;
        DimVisible5: Boolean;
        DimVisible6: Boolean;
        DimVisible7: Boolean;
        DimVisible8: Boolean;
        InvDiscAmountEditable: Boolean;
        InvoiceDiscountAmount: Decimal;
        InvoiceDiscountPct: Decimal;
        IsCommentLine: Boolean;
        IsBlankNumber: Boolean;
        ItemReferenceVisible: Boolean;
        LocationCodeMandatory: Boolean;
        SuppressTotals: Boolean;
        UnitofMeasureCodeIsChangeable: Boolean;
        AttachToInvtItemEnabled: Boolean;
        VATAmount: Decimal;
        IsPACEnabled: Boolean;

    local procedure SetOpenPage()
    var
        ServerSetting: Codeunit "Server Setting";
        PriceCalculationMgt: Codeunit "Price Calculation Mgt.";
        DocumentErrorsMgt: Codeunit "Document Errors Mgt.";
        Location: Record Location;
    begin
        OnBeforeSetOpenPage();

        if Location.ReadPermission then
            LocationCodeVisible := not Location.IsEmpty();

        IsSaaSExcelAddinEnabled := ServerSetting.GetIsSaasExcelAddinEnabled();
        SuppressTotals := CurrentClientType() = ClientType::ODataV4;
        ExtendedPriceEnabled := PriceCalculationMgt.IsExtendedPriceCalculationEnabled();
        BackgroundErrorCheck := DocumentErrorsMgt.BackgroundValidationEnabled();
        AttachingLinesEnabled :=
            SalesSetup."Auto Post Non-Invt. via Whse." = SalesSetup."Auto Post Non-Invt. via Whse."::"Attached/Assigned";
    end;

    procedure ApproveCalcInvDisc()
    begin
        CODEUNIT.Run(CODEUNIT::"Sales-Disc. (Yes/No)", Rec);
        DocumentTotals.SalesDocTotalsNotUpToDate();
    end;

    local procedure ValidateInvoiceDiscountAmount()
    var
        SalesHeader: Record "Sales Header";
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        if SuppressTotals then
            exit;

        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        if SalesHeader.InvoicedLineExists() then
            if not ConfirmManagement.GetResponseOrDefault(UpdateInvDiscountQst, true) then
                exit;

        SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, SalesHeader);
        DocumentTotals.SalesDocTotalsNotUpToDate();
        CurrPage.Update(false);
    end;

    procedure CalcInvDisc()
    var
        SalesCalcDiscount: Codeunit "Sales-Calc. Discount";
    begin
        SalesCalcDiscount.CalculateInvoiceDiscountOnLine(Rec);
        DocumentTotals.SalesDocTotalsNotUpToDate();
    end;

    procedure ExplodeBOM()
    begin
        if Rec."Prepmt. Amt. Inv." <> 0 then
            Error(Text001);
        CODEUNIT.Run(CODEUNIT::"Sales-Explode BOM", Rec);
        DocumentTotals.SalesDocTotalsNotUpToDate();
    end;

    procedure OpenPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
        PurchOrder: Page "Purchase Order";
        IsHandled: Boolean;
        PageEditable: Boolean;
    begin
        IsHandled := false;
        OnBeforeOpenPurchOrderForm(Rec, PageEditable, IsHandled);
        if IsHandled then
            exit;

        Rec.TestField("Purchase Order No.");
        PurchHeader.SetRange("No.", Rec."Purchase Order No.");
        PurchOrder.SetTableView(PurchHeader);
        PurchOrder.Editable := PageEditable;
        PurchOrder.Run();
    end;

    procedure OpenSpecialPurchOrderForm()
    var
        PurchHeader: Record "Purchase Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchOrder: Page "Purchase Order";
        IsHandled: Boolean;
        PageEditable: Boolean;
    begin
        IsHandled := false;
        OnBeforeOpenSpecialPurchOrderForm(Rec, PageEditable, IsHandled);
        if IsHandled then
            exit;

        Rec.TestField("Special Order Purchase No.");
        PurchHeader.SetRange("No.", Rec."Special Order Purchase No.");
        if not PurchHeader.IsEmpty() then begin
            PurchOrder.SetTableView(PurchHeader);
            PurchOrder.Editable := PageEditable;
            PurchOrder.Run();
        end else begin
            PurchRcptHeader.SetRange("Order No.", Rec."Special Order Purchase No.");
            if PurchRcptHeader.Count = 1 then
                PAGE.Run(PAGE::"Posted Purchase Receipt", PurchRcptHeader)
            else
                PAGE.Run(PAGE::"Posted Purchase Receipts", PurchRcptHeader);
        end;
    end;

    procedure InsertExtendedText(Unconditionally: Boolean)
    begin
        OnBeforeInsertExtendedText(Rec);
        if TransferExtendedText.SalesCheckIfAnyExtText(Rec, Unconditionally) then begin
            CurrPage.SaveRecord();
            Commit();
            TransferExtendedText.InsertSalesExtText(Rec);
        end;
        OnInsertExtendedTextOnAfterInsertSalesExtText(Rec);

        if TransferExtendedText.MakeUpdate() then
            UpdateForm(true);
    end;

    procedure ShowNonstockItems()
    begin
        Rec.ShowNonstock();
    end;

    procedure ShowTracking()
    var
        TrackingForm: Page "Order Tracking";
    begin
        TrackingForm.SetSalesLine(Rec);
        TrackingForm.RunModal();
    end;

    procedure ItemChargeAssgnt()
    begin
        Rec.ShowItemChargeAssgnt();
    end;

    procedure UpdateForm(SetSaveRecord: Boolean)
    begin
        CurrPage.Update(SetSaveRecord);
    end;

    procedure ShowPrices()
    begin
        Rec.PickPrice();
        UpdateForm(true);
    end;

    procedure ShowLineDisc()
    begin
        Rec.PickDiscount();
    end;

    procedure OrderPromisingLine()
    var
        OrderPromisingLine: Record "Order Promising Line" temporary;
        OrderPromisingLines: Page "Order Promising Lines";
    begin
        OrderPromisingLine.SetRange("Source Type", Rec."Document Type");
        OrderPromisingLine.SetRange("Source ID", Rec."Document No.");
        OrderPromisingLine.SetRange("Source Line No.", Rec."Line No.");

        OrderPromisingLines.SetSource(OrderPromisingLine."Source Type"::Sales);
        OrderPromisingLines.SetTableView(OrderPromisingLine);
        OrderPromisingLines.RunModal();
    end;

    procedure NoOnAfterValidate()
    begin
        OnBeforeNoOnAfterValidate(Rec, xRec);

        InsertExtendedText(false);
        if (Rec.Type = Rec.Type::"Charge (Item)") and (Rec."No." <> xRec."No.") and
           (xRec."No." <> '')
        then
            CurrPage.SaveRecord();

        OnNoOnAfterValidateOnBeforeSaveAndAutoAsmToOrder();

        SaveAndAutoAsmToOrder();

        OnNoOnAfterValidateOnAfterSaveAndAutoAsmToOrder(Rec);

        if Rec.Reserve = Rec.Reserve::Always then begin
            CurrPage.SaveRecord();
            if (Rec."Outstanding Qty. (Base)" <> 0) and (Rec."No." <> xRec."No.") then begin
                Rec.AutoReserve();
                CurrPage.Update(false);
            end;
        end;

        OnAfterNoOnAfterValidate(Rec, xRec);
    end;

    protected procedure VariantCodeOnAfterValidate()
    begin
        OnBeforeVariantCodeOnAfterValidate(Rec, xRec);
        SaveAndAutoAsmToOrder();
    end;

    procedure LocationCodeOnAfterValidate()
    begin
        SaveAndAutoAsmToOrder();

        if (Rec.Reserve = Rec.Reserve::Always) and
           (Rec."Outstanding Qty. (Base)" <> 0) and
           (Rec."Location Code" <> xRec."Location Code")
        then begin
            CurrPage.SaveRecord();
            Rec.AutoReserve();
            CurrPage.Update(false);
        end;

        OnAfterLocationCodeOnAfterValidate(Rec, xRec);
    end;

    protected procedure ReserveOnAfterValidate()
    begin
        if (Rec.Reserve = Rec.Reserve::Always) and (Rec."Outstanding Qty. (Base)" <> 0) then begin
            CurrPage.SaveRecord();
            Rec.AutoReserve();
        end;
    end;

    protected procedure QuantityOnAfterValidate()
    begin
        OnBeforeQuantityOnAfterValidate(Rec, xRec);

        if Rec.Type = Rec.Type::Item then begin
            CurrPage.SaveRecord();
            case Rec.Reserve of
                Rec.Reserve::Always:
                    Rec.AutoReserve();
            end;
        end;

        OnAfterQuantityOnAfterValidate(Rec, xRec);
    end;

    protected procedure QtyToAsmToOrderOnAfterValidate()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeQtyToAsmToOrderOnAfterValidate(Rec, IsHandled);
        if IsHandled then
            exit;

        CurrPage.SaveRecord();
        if Rec.Reserve = Rec.Reserve::Always then
            Rec.AutoReserve();
        CurrPage.Update(true);
    end;

    protected procedure UnitofMeasureCodeOnAfterValidate()
    begin
        OnBeforeUnitofMeasureCodeOnAfterValidate(Rec, xRec);

        DeltaUpdateTotals();
        if Rec.Reserve = Rec.Reserve::Always then begin
            CurrPage.SaveRecord();
            Rec.AutoReserve();
            CurrPage.Update(false);
        end;

        OnAfterUnitofMeasureCodeOnAfterValidate(Rec, xRec);
    end;

    protected procedure ShipmentDateOnAfterValidate()
    begin
        if (Rec.Reserve = Rec.Reserve::Always) and
           (Rec."Outstanding Qty. (Base)" <> 0) and
           (Rec."Shipment Date" <> xRec."Shipment Date")
        then begin
            CurrPage.SaveRecord();
            Rec.AutoReserve();
            CurrPage.Update(false);
        end else
            CurrPage.Update(true);
    end;

    protected procedure SaveAndAutoAsmToOrder()
    begin
        if (Rec.Type = Rec.Type::Item) and Rec.IsAsmToOrderRequired() then begin
            CurrPage.SaveRecord();
            Rec.AutoAsmToOrder();
            CurrPage.Update(false);
        end;
    end;

    procedure ShowDocumentLineTracking()
    var
        DocumentLineTrackingPage: Page "Document Line Tracking";
    begin
        Clear(DocumentLineTrackingPage);
        DocumentLineTrackingPage.SetSourceDoc(
            "Document Line Source Type"::"Sales Order", Rec."Document No.", Rec."Line No.", Rec."Blanket Order No.", Rec."Blanket Order Line No.", '', 0);
        DocumentLineTrackingPage.RunModal();
    end;

    local procedure SetLocationCodeMandatory()
    var
        InventorySetup: Record "Inventory Setup";
    begin
        LocationCodeMandatory := InventorySetup."Location Mandatory" and (Rec.Type = Rec.Type::Item);
    end;

    local procedure GetTotalSalesHeader()
    begin
        DocumentTotals.GetTotalSalesHeaderAndCurrency(Rec, TotalSalesHeader, Currency);
    end;

    procedure ClearTotalSalesHeader();
    begin
        Clear(TotalSalesHeader);
    end;

    procedure CalculateTotals()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCalculateTotals(Rec, IsHandled, DocumentTotals);
        if IsHandled then
            exit;

        if SuppressTotals then
            exit;

        DocumentTotals.SalesCheckIfDocumentChanged(Rec, xRec);
        DocumentTotals.CalculateSalesSubPageTotals(TotalSalesHeader, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        DocumentTotals.RefreshSalesLine(Rec);
    end;

    procedure DeltaUpdateTotals()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeDeltaUpdateTotals(Rec, IsHandled, xRec, SuppressTotals);
        if IsHandled then
            exit;

        if SuppressTotals then
            exit;

        DocumentTotals.SalesDeltaUpdateTotals(Rec, xRec, TotalSalesLine, VATAmount, InvoiceDiscountAmount, InvoiceDiscountPct);
        if Rec."Line Amount" <> xRec."Line Amount" then
            Rec.SendLineInvoiceDiscountResetNotification();
    end;

    procedure ForceTotalsCalculation()
    begin
        DocumentTotals.SalesDocTotalsNotUpToDate();
    end;

    procedure RedistributeTotalsOnAfterValidate()
    var
        SalesHeader: Record "Sales Header";
    begin
        if SuppressTotals then
            exit;

        CurrPage.SaveRecord();

        SalesHeader.Get(Rec."Document Type", Rec."Document No.");
        DocumentTotals.SalesRedistributeInvoiceDiscountAmounts(Rec, VATAmount, TotalSalesLine);
        CurrPage.Update(false);
    end;

    procedure UpdateEditableOnRow()
    begin
        IsCommentLine := not Rec.HasTypeToFillMandatoryFields();
        IsBlankNumber := IsCommentLine;
        UnitofMeasureCodeIsChangeable := not IsCommentLine;
        if AttachingLinesEnabled then
            AttachToInvtItemEnabled := not Rec.IsInventoriableItem();

        CurrPageIsEditable := CurrPage.Editable;
        InvDiscAmountEditable :=
            CurrPageIsEditable and not SalesSetup."Calc. Inv. Discount" and
            (TotalSalesHeader.Status = TotalSalesHeader.Status::Open);

        OnAfterUpdateEditableOnRow(Rec, IsCommentLine, IsBlankNumber);
    end;

    procedure UpdateTypeText()
    var
        RecRef: RecordRef;
    begin
        if not IsFoundation then
            exit;

        OnBeforeUpdateTypeText(Rec);

        RecRef.GetTable(Rec);
        TypeAsText := TempOptionLookupBuffer.FormatOption(RecRef.Field(Rec.FieldNo(Type)));
    end;

    local procedure SetItemChargeFieldsStyle()
    begin
        ItemChargeStyleExpression := '';
        ItemChargeToHandleStyleExpression := '';
        if Rec.AssignedItemCharge() then begin
            if Rec."Qty. To Assign" <> (Rec.Quantity - Rec."Qty. Assigned") then
                ItemChargeStyleExpression := 'Unfavorable';
            if Rec."Item Charge Qty. to Handle" <> Rec."Qty. to Invoice" then
                ItemChargeToHandleStyleExpression := 'Unfavorable';
        end;
    end;

    local procedure SetDimensionsVisibility()
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimVisible1 := false;
        DimVisible2 := false;
        DimVisible3 := false;
        DimVisible4 := false;
        DimVisible5 := false;
        DimVisible6 := false;
        DimVisible7 := false;
        DimVisible8 := false;

        DimMgt.UseShortcutDims(
          DimVisible1, DimVisible2, DimVisible3, DimVisible4, DimVisible5, DimVisible6, DimVisible7, DimVisible8);

        Clear(DimMgt);

        OnAfterSetDimensionsVisibility();
    end;

    local procedure SetItemReferenceVisibility()
    var
        ItemReference: Record "Item Reference";
    begin
        ItemReferenceVisible := not ItemReference.IsEmpty();
    end;

    local procedure SetDefaultType()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSetDefaultType(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if xRec."Document No." = '' then
            Rec.Type := Rec.Type::Item; //updated to Item.
    end;

    local procedure ValidateShortcutDimension(DimIndex: Integer)
    var
        AssembleToOrderLink: Record "Assemble-to-Order Link";
    begin
        Rec.ValidateShortcutDimCode(DimIndex, ShortcutDimCode[DimIndex]);
        AssembleToOrderLink.UpdateAsmDimFromSalesLine(Rec);

        OnAfterValidateShortcutDimCode(Rec, ShortcutDimCode, DimIndex);
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterNoOnAfterValidate(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterQuantityOnAfterValidate(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterLocationCodeOnAfterValidate(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateEditableOnRow(SalesLine: Record "Sales Line"; var IsCommentLine: Boolean; var IsBlankNumber: Boolean);
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterValidateDescription(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateShortcutDimCode(var SalesLine: Record "Sales Line"; var ShortcutDimCode: array[8] of Code[20]; DimIndex: Integer)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeDeleteReservationEntries(var SalesLine: Record "Sales Line");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertExtendedText(var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeNoOnAfterValidate(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetDefaultType(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateTypeText(var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnReferenceNoOnAfterLookup(var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnNoOnAfterValidateOnAfterSaveAndAutoAsmToOrder(var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnNoOnAfterValidateOnBeforeSaveAndAutoAsmToOrder()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeQtyToAsmToOrderOnAfterValidate(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAfterGetCurrRecord(var SalesLine: Record "Sales Line"; var IsHandled: Boolean; var TotalSalesHeader: Record "Sales Header"; var Currency: Record Currency)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateTotals(var SalesLine: Record "Sales Line"; var IsHandled: Boolean; var DocumentTotals: Codeunit "Document Totals")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOpenPurchOrderForm(SalesOrderLine: Record "Sales Line"; var PageEditable: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOpenSpecialPurchOrderForm(SalesOrderLine: Record "Sales Line"; var PageEditable: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeSetOpenPage()
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterSetDimensionsVisibility();
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeDeltaUpdateTotals(var SalesLine: Record "Sales Line"; var IsHandled: Boolean; xSalesLine: Record "Sales Line"; SuppressTotals: Boolean)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeQuantityOnAfterValidate(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeVariantCodeOnAfterValidate(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeUnitofMeasureCodeOnAfterValidate(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterUnitofMeasureCodeOnAfterValidate(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertExtendedTextOnAfterInsertSalesExtText(SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeValidateNo(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;
}
