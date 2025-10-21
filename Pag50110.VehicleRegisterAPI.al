page 50110 "Vehicle Register API"
{
    APIGroup = 'vehicleManagement';
    APIPublisher = 'vehiclePublisher';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    DelayedInsert = true;
    EntityName = 'vehicle';
    EntitySetName = 'vehicles';
    PageType = API;
    SourceTable = "Vehicle Register";

    Caption = 'Vehicle Register API';
    EntityCaption = 'Vehicle';
    EntitySetCaption = 'Vehicles';
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(vehicleTypeNo; Rec."Vehicle Type No.")
                {
                    Caption = 'Vehicle Type No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(registrationNo; Rec."Registration No.")
                {
                    Caption = 'Registration No.';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'System Id';
                }
                field(VehicleTypeName; Rec."Vehicle Type Name")
                {
                    Caption = 'Vehicle Type Name';
                }
            }
        }
    }
}
