page 50108 "Vehicle Management RC Cue Card"
{
    ApplicationArea = All;
    Caption = 'Vehicle Management Statistics';
    PageType = CardPart;
    SourceTable = "Vehicle Management RC Cue";

    layout
    {
        area(Content)
        {
            cuegroup(General)
            {
                Caption = 'Summary';

                field("Number of Parent Brands"; Rec."Number of Parent Brands")
                {
                    ToolTip = 'Specifies the value of the Number of Parent Brands field.', Comment = '%';
                }
                field("Number of Vehicle Models"; Rec."Number of Vehicle Models")
                {
                    ToolTip = 'Specifies the value of the Number of Vehicle Models field.', Comment = '%';
                }
                field("Total Registered Vehicles"; Rec."Total Registered Vehicles")
                {
                    ToolTip = 'Specifies the value of the Total Registered Vehicles field.', Comment = '%';
                }
            }
        }
    }
    trigger OnOpenPage();
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
