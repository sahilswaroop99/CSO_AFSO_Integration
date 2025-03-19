table 50101 "AF Customer Business Hour"
{
    Caption = 'Customer Business Hour';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = CustomerContent;
            TableRelation = Customer;
            ValidateTableRelation = true;

        }
        field(2; "Is Working"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Is Working';
            InitValue = true;
        }

        field(3; "Day of Week"; Enum "AF Week Days")
        {
            DataClassification = CustomerContent;
            Caption = 'Day of Week';
        }
        field(4; "Start Time"; Enum "AF Starting Time")
        {
            DataClassification = CustomerContent;
            Caption = 'Start Time';
            InitValue = "8:00 AM";

        }
        field(5; "End Time"; Enum "AF Ending Time")
        {
            DataClassification = CustomerContent;
            Caption = 'End Time';
            InitValue = "5:00 PM";
        }
    }
    keys
    {
        key(PK; "Customer No.", "Day of Week")
        {
            Clustered = true;
        }
    }
}
