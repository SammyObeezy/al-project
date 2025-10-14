xmlport 50100 "Vehicle Brands"
{
    Caption = 'Vehicle Brands';
    Format = VariableText;

    schema
    {
        textelement(RootNodeName)
        {
            tableelement(VehicleTypes; "Vehicle Types")
            {
                fieldelement(BrandName; VehicleTypes."Brand Name")
                {
                }
                fieldelement(Description; VehicleTypes.Description)
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
