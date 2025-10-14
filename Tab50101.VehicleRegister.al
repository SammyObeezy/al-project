table 50101 "Vehicle Register"
{
    Caption = 'Vehicle Register';
    DataClassification = ToBeClassified;

    DataCaptionFields = "No", "Vehicle Type Name", "Registration No.";

    LookupPageId = "Vehicle Register"; // List page
    DrillDownPageId = "Vehicle Register"; // List page

    fields
    {
        field(1; No; Integer)
        {
            Caption = 'No';
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Vehicle Type No."; Integer)
        {
            Caption = 'Vehicle Type No.';
            TableRelation = "Vehicle Types"."No." where("Parent No." = filter(<> 0));
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(4; "Registration No."; Code[20])
        {
            Caption = 'Registration No.';

            trigger OnValidate()
            var
                myInt: Integer;
            begin
                // Validate that "Registration No." is not empty
                TestField("Registration No.");
            end;
        }
        field(5; "Created By"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(6; "Updated By"; Code[50])
        {
            Caption = 'Updated By';
            Editable = false;
        }
        field(7; "Vehicle Type Name"; Text[50])
        {
            Caption = 'Vehicle Type Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Vehicle Types"."Brand Name" where("No." = field("Vehicle Type No.")));
        }
    }
    keys
    {
        key(PK; No)
        {
            Clustered = true;
        }
    }
}
