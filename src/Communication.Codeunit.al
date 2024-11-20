codeunit 50103 "ENVHUB Communication"
{
    Access = Internal;
    trigger OnRun()
    begin

    end;

    procedure InsertCompanies(environmentName: Text[30])
    var
        JsonResponse: JsonObject;
        ENVHUBEnvironmentCompany: Record "ENVHUB Environment Company";
        Index: Integer;
        Companies: JsonToken;
        CompaniesArray: JsonArray;
        Company: JsonToken;
        CompanyObject: JsonObject;
        Id: JsonToken;
        Name: JsonToken;
        GuidValue: Guid;
    begin
        JsonResponse := GetAllCompaniesOfEnvironment(environmentName);
        if JsonResponse.Get('value', Companies) then begin
            CompaniesArray := Companies.AsArray();
            for Index := 0 to CompaniesArray.Count - 1 do begin
                CompaniesArray.Get(Index, Company);
                CompanyObject := Company.AsObject();
                if CompanyObject.Get('id', Id) and CompanyObject.Get('name', Name) then begin
                    Evaluate(GuidValue, Id.AsValue().AsText());
                    if not ENVHUBEnvironmentCompany.Get(environmentName, GuidValue) then begin
                        ENVHUBEnvironmentCompany.Init;
                        ENVHUBEnvironmentCompany."Environment Name" := environmentName;
                        ENVHUBEnvironmentCompany."Company GUID" := GuidValue;
                        ENVHUBEnvironmentCompany."Company Name" := Name.AsValue().AsText();
                        ENVHUBEnvironmentCompany.Insert();
                    end;
                end;
            end;
        end;
    end;

    local procedure GetAllCompaniesOfEnvironment(environmentName: Text[30]): JsonObject
    var
        ENVHUBSetup: Record "ENVHUB Setup";
        ENVHUBHttp: Codeunit "ENVHUB Http";
        EnvironmentInformation: Codeunit "Environment Information";
        Method: Option Get,Post,Patch;
        SaasUrlLbl: Label 'https://api.businesscentral.dynamics.com/v2.0/%1/%2/api/v1.0/companies', comment = '%1 = Tenant ID, %2 = Environment name';
        OnPremUrlLbl: Label '%1/api/v1.0/companies?tenant=%2', comment = '%1 = Base URL, %2 = Environment name';
    begin
        if ENVHUBSetup.Get() then;
        if EnvironmentInformation.IsSaaS() then
            exit(ENVHUBHttp.RequestMessage(StrSubstNo(SaasUrlLbl, ENVHUBSetup."Tenant ID", environmentName), Method::Get, ''))
        else
            exit(ENVHUBHttp.RequestMessage(StrSubstNo(OnPremUrlLbl, ENVHUBSetup."Base URL", environmentName), Method::Get, ''));
    end;
}