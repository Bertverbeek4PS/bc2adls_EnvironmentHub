page 50101 "ENVHUB Environment Companies"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ENVHUB Environment Company";
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Name; rec."Company Name")
                {
                    Editable = false;
                }
                field(Enabled; Rec.Enabled) { }
            }
        }
    }
}