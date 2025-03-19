table 50200 "AF SalesOrder Item Filters"
{
    Caption = 'AF SalesOrder Item Filters';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Order No"; Code[20])
        {
            Caption = 'Order No';
        }
        field(2; Make; Code[20])
        {
            TableRelation = "AF Vehicle Make";
        }
        field(3; Model; Code[20])
        {
            TableRelation = "AF Vehicle Model".Model where("Make" = field("Make"));
        }
        field(4; Year; code[4])
        {
            TableRelation = if (Model = filter('')) AFMakeModelYearLookup.Year where("Make" = field("Make"))
            else
            AFMakeModelYearLookup.Year where("Make" = field("Make"), Model = field(Model));

            ValidateTableRelation = false;
        }
        field(6; PartNumber; Code[35])
        {

        }
        field(10; FilterTxt; Blob)
        {

        }
        field(11; SearchStatus; Text[150])
        {

        }
    }
    keys
    {
        key(PK; "Order No")
        {
            Clustered = true;
        }
    }
    procedure SetFilterTxt(pFilterTxt: Text)
    var
        OutStream: OutStream;
    begin
        Clear(FilterTxt);
        FilterTxt.CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(pFilterTxt);
        Modify();
    end;

    procedure GetFilterText() FilterText: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields(FilterTxt);
        FilterTxt.CreateInStream(InStream, TEXTENCODING::UTF8);
        InStream.ReadText(FilterText);
        exit(FilterText);
    end;
}
