page 50100 "Vehicle Types"
{
    ApplicationArea = All;
    Caption = 'Vehicle Types';
    PageType = List;
    SourceTable = "Vehicle Types";
    UsageCategory = Lists;

    CardPageId = "Vehicle Types Card";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Brand Name"; Rec."Brand Name")
                {
                    ToolTip = 'Specifies the value of the Brand Name field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                }
                field("Parent No."; Rec."Parent No.")
                {
                    ToolTip = 'Specifies the value of the Parent No. field.', Comment = '%';
                    Visible = ShowParentBrands;
                }
                field("Parent Brand Name"; Rec."Parent Brand Name")
                {
                    ToolTip = 'Specifies the value of the Parent Brand Name field.', Comment = '%';
                    Visible = ShowParentBrands;
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
        area(FactBoxes)
        {

            part("Images/Logo Section"; "Vehicle Types Image Part")
            {
                // Filter on the image that is related to the current vehicle type
                SubPageLink = "No." = field("No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Import Brands")
            {
                Caption = 'Import Vehicle Brands';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;

                // Be visible when page list is not showing brand models.
                Visible = not ShowParentBrands;
                trigger OnAction()
                begin
                    Xmlport.Run(Xmlport::"Vehicle Brands", false, true);
                end;
            }
            action("Import Brand Models")
            {
                Caption = 'Import Vehicle Brand Models';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;

                // Be visible when page list is showing brand models of the parent vehicle
                Visible = ShowParentBrands;
                trigger OnAction()
                begin
                    Xmlport.Run(Xmlport::"Vehicle Brand Models", false, true);
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

    trigger OnAfterGetCurrRecord()
    begin
        // Check if the first record in the list page has "Parent No." field set to 0
        if Rec."Parent No." = 0 then begin
            // Do not show parent brand fields since value is 0
            ShowParentBrands := false;
        end else begin
            // Show parent brand fields since field is not 0
            ShowParentBrands := true;
        end;
    end;

    var
        ShowParentBrands: Boolean;
}
