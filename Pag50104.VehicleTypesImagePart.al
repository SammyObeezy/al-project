page 50104 "Vehicle Types Image Part"
{
    ApplicationArea = All;
    Caption = 'Vehicle Types Image Part';
    PageType = CardPart;
    SourceTable = "Vehicle Types";

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Logo/Image"; Rec."Logo/Image")
                {
                    ToolTip = 'Specifies the value of the Logo/Image field.', Comment = '%';
                }
            }
        }
    }
}
