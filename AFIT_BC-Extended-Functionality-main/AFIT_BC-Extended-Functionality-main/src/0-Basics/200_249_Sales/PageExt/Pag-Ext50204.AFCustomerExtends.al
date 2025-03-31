pageextension 50204 AFCustCardExten extends "Customer Card"
{
    layout
    {
        //Atul
        addafter("Exclude from Pmt. Practices")
        {
            field("Business Hours"; Rec."Business Hours")
            {
                ApplicationArea = All;
            }
        }
        //Atul
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}