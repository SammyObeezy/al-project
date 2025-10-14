xmlport 50102 "Import Vehicle Register"
{
    Caption = 'Import Vehicle Register';
    Format = VariableText; // Important for CSV files

    schema
    {
        textelement(RootNodeName)
        {
            tableelement(VehicleRegister; "Vehicle Register")
            {
                fieldelement(No; VehicleRegister.No)
                {
                }
                fieldelement(VehicleTypeNo; VehicleRegister."Vehicle Type No.")
                {
                }
                fieldelement(RegistrationNo; VehicleRegister."Registration No.")
                {
                }
                fieldelement(Description; VehicleRegister.Description)
                {
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
}
