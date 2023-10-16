table 50102 "ENVHUB Setup"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary key"; Code[10])
        {
            Caption = 'Primary Key';
            Editable = false;
        }
        field(2; "Tenant Id"; Text[100])
        {
            Caption = 'Tenant Id';
        }
        field(3; "Redirect URL"; Text[250])
        {
            Caption = 'Redirect URL';
        }
    }
    keys
    {
        key(Key1; "Primary key")
        {
            Clustered = true;
        }
    }
}