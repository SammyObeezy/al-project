report 50100 "Vehicle Brands"
{
    ApplicationArea = All;
    Caption = 'Vehicle Brands';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Rep50100.VehicleBrands.rdl';
    dataset
    {
        dataitem(VehicleTypes; "Vehicle Types")
        {
            DataItemTableView = where("Parent No." = const(0));
            column(No; "No.")
            {
            }
            column(BrandName; "Brand Name")
            {
            }
            column(Description; Description)
            {
            }
            column(LogoImage; "Logo/Image")
            {
            }
            column(CreatedBy; "Created By")
            {
            }
            column(UpdatedBy; "Updated By")
            {
            }
            column(RegisteredBrandNames; "Registered Brand Names")
            {
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
