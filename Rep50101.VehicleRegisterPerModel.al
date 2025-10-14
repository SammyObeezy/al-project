report 50101 "Vehicle Register Per Model"
{
    ApplicationArea = All;
    Caption = 'Vehicle Register Per Model';
    RDLCLayout = 'Rep50101.VehicleRegisterPerModel.rdl';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(VehicleRegister; "Vehicle Register")
        {
            RequestFilterFields = "Vehicle Type No.";
            column(VehicleRegisterTypeNo; "Vehicle Type No.")
            {
            }
            column(VehicleRegisterDescription; Description)
            {
            }
            column(VehicleRegisterRegistrationRegNo; "Registration No.")
            {
            }
            column(VehicleRegisterCreatedBy; "Created By")
            {
            }
            column(VehicleRegisterCreatedAt; SystemCreatedAt)
            {
            }
            column(VehicleRegisterUpdatedBy; "Updated By")
            {
            }
            column(VehicleRegisterUpdatedAt; SystemModifiedAt)
            {
            }
            dataitem("Vehicle Types"; "Vehicle Types")
            {
                DataItemLink = "No." = field("Vehicle Type No.");
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
                column(ParentBrandName; "Parent Brand Name")
                {

                }
                column(RegisteredVehicles; "Registered Vehicles")
                {

                }
            }
        }

    }
    requestpage
    {
        SaveValues = true;
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
