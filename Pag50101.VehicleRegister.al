page 50101 "Vehicle Register"
{
    ApplicationArea = All;
    Caption = 'Vehicle Register';
    PageType = List;
    SourceTable = "Vehicle Register";
    UsageCategory = Lists;

    CardPageId = "Vehicle Register Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
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
                }
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field("Updated By"; Rec."Updated By")
                {
                    ToolTip = 'Specifies the value of the Updated By field.', Comment = '%';
                }
            }
        }
    }

    // Add the actions block below
    actions
    {
        area(Processing)
        {
            action("Import Vehicles")
            {
                Caption = 'Import Vehicles';
                ToolTip = 'Import vehicles from a CSV file';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    // Runs the XMLport to import data
                    Xmlport.Run(Xmlport::"Import Vehicle Register", false, true);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        Message(
            'Dear %1,\Welcome to the %2 list page!',
            UserId,
            CurrPage.Caption
        );
    end;

    trigger OnClosePage()
    var
        myInt: Integer;
    begin
        Message(
            'Dear %1,\The %2 list page is closed!',
            UserId,
            CurrPage.Caption
        );
    end;
}
