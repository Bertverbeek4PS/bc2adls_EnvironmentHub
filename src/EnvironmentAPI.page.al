page 50104 "ENVHUB Environment API"
{
    PageType = API;
    APIPublisher = 'envhub';
    APIGroup = 'envhub';
    APIVersion = 'v1.0';
    EntityName = 'Environment';
    EntitySetName = 'Environments';
    SourceTable = "ENVHUB Environment";
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