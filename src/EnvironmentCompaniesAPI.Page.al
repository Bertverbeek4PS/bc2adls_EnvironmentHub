// Create an API page for table and field

page 50103 "ENVHUB Env Companies API"
{
    PageType = API;
    APIPublisher = 'envhub';
    APIGroup = 'envhub';
    APIVersion = 'v1.0';
    EntityName = 'envCompany';
    EntitySetName = 'envCompanies';
    SourceTable = "ENVHUB Environment Company";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    DelayedInsert = false;
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(environmentName; Rec."Environment Name") { }
                field(companyGuid; Rec."Company GUID") { }
                field(companyName; Rec."Company Name") { }
                field(enabled; Rec.Enabled) { }
                field(systemId; Rec.SystemId)
                {
                    Editable = false;
                }
                field(systemRowVersion; Rec.SystemRowVersion)
                {
                    Editable = false;
                }
            }
        }
    }
}