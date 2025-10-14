page 50102 "Vehicle Types Card"
{
    ApplicationArea = All;
    Caption = 'Vehicle Types Card';
    PageType = Card;
    SourceTable = "Vehicle Types";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.', Comment = '%';
                }
                field("Parent No."; Rec."Parent No.")
                {
                    ToolTip = 'Specifies the value of the Parent No. field.', Comment = '%';
                }
                field("Brand Name"; Rec."Brand Name")
                {
                    ToolTip = 'Specifies the value of the Brand Name field.', Comment = '%';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%';
                    MultiLine = true;
                }
                field("Logo/Image"; Rec."Logo/Image")
                {
                    ToolTip = 'Specifies the value of the Logo/Image field.', Comment = '%';
                }
                // field("Created By"; Rec."Created By")
                // {
                //     ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                // }
                // field("Updated By"; Rec."Updated By")
                // {
                //     ToolTip = 'Specifies the value of the Updated By field.', Comment = '%';
                // }
                // field(SystemCreatedAt; Rec.SystemCreatedAt)
                // {
                //     ToolTip = 'Specifies the value of the SystemCreatedAt field.', Comment = '%';
                // }
                // field(SystemModifiedAt; Rec.SystemModifiedAt)
                // {
                //     ToolTip = 'Specifies the value of the SystemModifiedAt field.', Comment = '%';
                // }
            }

            group(Register)
            {
                Caption = 'Vehicle Register';
                part("Vehicle Register List"; "Vehicle Register List Part")
                {
                    // Filter on the vehicles that are linkedto the current vehicle type
                    SubPageLink = "Vehicle Type No." = field("No.");
                }
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
                field("Registered Brand Names"; Rec."Registered Brand Names")
                {
                    ToolTip = 'Specifies the value of the Registered Brand Names field.', Comment = '%';
                }
                field("Registered Vehicles"; Rec."Registered Vehicles")
                {
                    ToolTip = 'Specifies the value of the Registered Vehicle field.', Comment = '%';
                }
            }
        }

        area(FactBoxes)
        {
            part("Images/Logo Section"; "Vehicle Types Image Part")
            {
                //Filter on the image that is relatd to the currnt vehicle type
                SubPageLink = "No." = field("No.");
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("List Fields Data")
            {
                Caption = 'List fields data';
                Image = BulletList;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    myInt: Integer;
                begin

                    Message(
                        '"Parent Brand Name" = %1\"Brand Name" = %2\"Description" = %3\"Created By" = %4\"Updated By" = %5',
                        Rec."Parent Brand Name",
                        Rec."Brand Name",
                        Rec.Description,
                        Rec."Created By",
                        Rec."Updated By"
                    );
                end;
            }
        }

        area(Navigation)
        {
            action("Vehicle Register")
            {
                Caption = 'Vehicle Register List';
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Report;

                RunObject = page "Vehicle Register";
                RunPageLink = "Vehicle Type No." = field("No.");
                RunPageMode = view;
            }
        }
    }

}
