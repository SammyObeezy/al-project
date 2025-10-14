page 50106 "Vehicle Management Role Center"
{
    ApplicationArea = All;
    Caption = 'Vehicle Management Role Center';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            part(Part1; "Headline RC Vehicle Manager")
            {
                ApplicationArea = All;
            }
            part(Part2; "Vehicle Management RC Cue Card")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Sections)
        {
            group("Vehicle Types")
            {
                Caption = 'Vehicle Types';
                Image = Setup;

                action(ViewParentBrands)
                {
                    Caption = 'Vehicle Brands';
                    RunObject = page "Vehicle Types";
                    RunPageView = where("Parent No." = const(0));
                }
                action(ViewBrandsModels)
                {
                    Caption = 'Brand Models';
                    RunObject = page "Vehicle Types";
                    RunPageView = where("Parent No." = filter(<> 0));
                }
            }
            group("Vehicle Register")
            {
                Caption = 'Vehicle Register';
                Image = Setup;

                action(Vehicles)
                {
                    Caption = 'List of Vehicles';
                    RunObject = page "Vehicle Register";
                }
            }
        }
        area(Reporting)
        {
            action(VehicleBrandsReport)
            {
                Caption = 'Vehicle Brands Report';
                Image = Report;
                RunObject = report "Vehicle Brands";
            }
            action(VehicleRegisteredPerModelReport)
            {
                Caption = 'Vehicle Register Per Model Report';
                Image = Report;
                RunObject = report "Vehicle Register Per Model";
            }
        }
    }
}
profile VehicleManagerProfile
{
    ProfileDescription = 'Vehicle Management Profile';
    RoleCenter = "Vehicle Management Role Center";
    Caption = 'Vehicle Management Role Center';
}
