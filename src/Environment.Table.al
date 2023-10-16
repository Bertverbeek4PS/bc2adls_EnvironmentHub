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
}