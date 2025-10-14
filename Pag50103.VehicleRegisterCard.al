page 50103 "Vehicle Register Card"
{
    ApplicationArea = All;
    Caption = 'Vehicle Register Card';
    PageType = Card;
    SourceTable = "Vehicle Register";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(No; Rec.No)
                {
                    ToolTip = 'Specifies the value of the No field.', Comment = '%';
                }
                field("Vehicle Type No."; Rec."Vehicle Type No.")
                {
                    ToolTip = 'Specifies the value of the Vehicle Type No. field.', Comment = '%';
                }
                field("Vehicle Type Name"; Rec."Vehicle Type Name")
                {
                    ToolTip = 'Specifies the value of the Vehicle Type Name field.', Comment = '%';
                }
                field("Registration No."; Rec."Registration No.")
                {
                    ToolTip = 'Specifies the value of the Registration No. field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    MultiLine = true;
                }
                // field("Created By"; Rec."Created By")
                // {
                //     ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                // }
                // field("Updated By"; Rec."Updated By")
                // {
                //     ToolTip = 'Specifies the value of the Updated By field.', Comment = '%';
                // }
            }
            group(Other)
            {
                Caption = 'Other Details';

                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field("Updated By"; Rec."Updated By")
                {
                    ToolTip = 'Specifies the value of the Updated By field.', Comment = '%';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                }
            }
        }
        area(FactBoxes)
        {
            part("Images/Logo Section"; "Vehicle Types Image Part")
            {
                // Filter on the image is related to the current vehicle type
                SubPageLink = "No." = field("Vehicle Type No.");
            }
        }
    }
}
