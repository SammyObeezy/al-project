xmlport 50101 "Vehicle Brand Models"
{
    Caption = 'Vehicle Brand Models';
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
                fieldelement(ParentNo; VehicleTypes."Parent No.")
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
