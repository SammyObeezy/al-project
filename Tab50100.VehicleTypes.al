table 50100 "Vehicle Types"
{
    Caption = 'Vehicle Types';
    DataClassification = ToBeClassified;

    DataCaptionFields = "No.", "Brand Name";

    LookupPageId = "Vehicle Types"; // List page
    DrillDownPageId = "Vehicle Types"; // List page

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
            AutoIncrement = true;
        }
        field(2; "Brand Name"; Text[50])
        {
            Caption = 'Brand Name';
        }
        field(3; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(4; "Logo/Image"; Blob)
        {
            Caption = 'Logo/Image';
            Subtype = Bitmap;
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
        field(7; "Parent No."; Integer)
        {
            Caption = 'Parent No.';
            TableRelation = "Vehicle Types"."No." where("Parent No." = const(0));
        }
        field(8; "Parent Brand Name"; Text[50])
        {
            Caption = 'Parent Brand Name';
            FieldClass = FlowField;
            CalcFormula = lookup("Vehicle Types"."Brand Name" where("No." = field("Parent No.")));
        }
        field(9; "Registered Brand Names"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Vehicle Types" where("Parent No." = field("No.")));
        }
        field(10; "Registered Vehicles"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count("Vehicle Register" where("Vehicle Type No." = field("No.")));
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        myInt: Integer;
    begin
        // Populate "Created By fiels with the current user"
        "Created By" := UserId;
    end;

    trigger OnDelete()
    var
        GlobalFunctions: Codeunit "Global Functions";
    begin
        GlobalFunctions.ConfirmRecordDeletion();
    end;
}
