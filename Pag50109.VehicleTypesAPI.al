page 50109 "Vehicle Types API"
{
    APIGroup = 'vehicleManagement';
    APIPublisher = 'vehiclePublisher';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'Vehicle Types API';
    DelayedInsert = true;
    EntityName = 'vehicleType';
    EntitySetName = 'vehicleTypes';
    PageType = API;
    SourceTable = "Vehicle Types";

    EntityCaption = 'Vehicle Type';
    EntitySetCaption = 'Vehicle Types';
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(brandName; Rec."Brand Name")
                {
                    Caption = 'Brand Name';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(logoImage; Rec."Logo/Image")
                {
                    Caption = 'Logo/Image';
                }
                field(parentNo; Rec."Parent No.")
                {
                    Caption = 'Parent No.';
                }
                field(SystemId; Rec.SystemId)
                {
                    Caption = 'System Id';
                }
            }
        }
    }
}
