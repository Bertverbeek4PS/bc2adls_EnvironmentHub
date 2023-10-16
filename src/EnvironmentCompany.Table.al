table 50101 "ENVHUB Environment Company"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Environment Name"; text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Company GUID"; Guid)
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Company Name"; text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(4; Enabled; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Environment Name", "Company GUID")
        {
            Clustered = true;
        }
    }
}