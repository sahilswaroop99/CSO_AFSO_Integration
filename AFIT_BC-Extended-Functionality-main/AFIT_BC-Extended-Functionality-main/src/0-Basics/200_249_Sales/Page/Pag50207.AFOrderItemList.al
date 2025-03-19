page 50207 "AF Order ItemList"
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
            // group(FiltersF)
            // {
            //     ShowCaption = false;
            field(MakeFilter; ItemCodeFilter)
            {
                Caption = 'Item Code';
                ToolTip = 'Specify Item code to search the list';
                trigger OnValidate()
                begin
                    if ItemCodeFilter <> '' then
                        Rec.SetFilter("Item No.", '*' + ItemCodeFilter + '*')
                    else
                        Rec.SetRange("Item No.");
                    CurrPage.Update();
                end;
            }
            field(ModelFilter; DescFilter)
            {
                Caption = 'Description';
                ToolTip = 'Specify Item Description to search the list';
                trigger OnValidate()
                begin
                    if DescFilter <> '' then
                        Rec.SetFilter(Description, '*' + DescFilter + '*')
                    else
                        Rec.SetRange(Description);
                    CurrPage.Update();
                end;
            }
            // }
            repeater(General)
            {
                Editable = false;
                ShowCaption = false;
                FreezeColumn = "No.";
                field("No."; Rec."Item No.")
                {
                    Style = Strong;
                    ToolTip = 'Click on Item No. to Add the item to Sales Order';
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
                    ToolTip = 'Specifies a OEM of the item.';
                }
                field("AF Part Link No."; Rec."Part Link No.")
                {
                    ApplicationArea = all;
                    ToolTip = 'Specifies a Part Link Number of the item.';
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
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

    var
        SalesHdr: Record "Sales Header";


        ItemCodeFilter, DescFilter : Code[80];

    procedure SetSalesOrder(pSalesHdr: Record "Sales Header")
    begin
        if pSalesHdr."No." = '' then
            exit;
        SalesHdr.Copy(pSalesHdr);
    End;

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
