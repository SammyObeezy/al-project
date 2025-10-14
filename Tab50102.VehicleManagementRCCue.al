table 50102 "Vehicle Management RC Cue"
{
    Caption = 'Vehicle Management RC Cue';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Cue No."; Integer)
        {
            Caption = 'Cue No.';
        }
        field(2; "Number of Parent Brands"; Integer)
        {
            Caption = 'Number of Parent Brands';

            FieldClass = FlowField;
            // Count only brands vehicle types
            CalcFormula = count("Vehicle Types" where("Parent No." = const(0)));
        }
        field(3; "Number of Vehicle Models"; Integer)
        {
            Caption = 'Number of Vehicle Models';
            FieldClass = FlowField;
            // Count only non-parent vehicle types (models)
            CalcFormula = count("Vehicle Types" where("Parent No." = filter(<> 0)));
        }
        field(4; "Total Registered Vehicles"; Integer)
        {
            Caption = 'Total Registered Vehicles';
            FieldClass = FlowField;
            // Count the total number of registered vehicles
            CalcFormula = count("Vehicle Register");
        }
    }
    keys
    {
        key(PK; "Cue No.")
        {
            Clustered = true;
        }
    }
}
