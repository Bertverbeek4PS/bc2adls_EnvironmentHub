table 50100 "ENVHUB Environment"
{
    fields
    {
        field(1; "Environment Name"; text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Environment Name")
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        ENVHUBEnvironmentCompany: Record "ENVHUB Environment Company";
    begin
        ENVHUBEnvironmentCompany.SetRange("Environment Name", rec."Environment Name");
        ENVHUBEnvironmentCompany.DeleteAll();
    end;
}