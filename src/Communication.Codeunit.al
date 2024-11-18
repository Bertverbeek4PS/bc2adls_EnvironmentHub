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
        baseUrl: Text;

    begin
        if ENVHUBSetup.Get() then;
        if EnvironmentInformation.IsSaaS() then begin
            baseUrl := 'https://api.businesscentral.dynamics.com/v2.0/%1/%2/api/v1.0/companies';
            exit(ENVHUBHttp.RequestMessage(StrSubstNo(baseUrl, ENVHUBSetup."Tenant ID", environmentName), Method::Get, ''))
        end else begin 
            baseUrl := ENVHUBSetup."Base URL" + '/api/v1.0/companies?tenant=%1';
            exit(ENVHUBHttp.RequestMessage(StrSubstNo(baseUrl, environmentName), Method::Get, '')); //Change of baseUrl with tenant/environment name
        end;
    end;
}