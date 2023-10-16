codeunit 50101 "ENVHUB Http"
{
    Access = Internal;
    trigger OnRun()
    begin

    end;

    procedure RequestMessage(Uri: Text; Method: Option Get,Post,Patch; Body: Text): JsonObject
    var
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        JsonResponse: JsonObject;
        [NonDebuggable]
        AccessToken: Text;
        JsonContent: Text;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
    begin
        AccessToken := GetAccessToken();

        RequestMessage.Method(format(Method));
        RequestMessage.SetRequestUri(Uri);

        if (Method = Method::Post) and (Body <> '') then begin
            Content.WriteFrom(body);
            Content.GetHeaders(ContentHeaders);
            ContentHeaders.Remove('Content-Type');
            ContentHeaders.Add('Content-Type', 'application/json');
            RequestMessage.Content(Content);
        end;

        Client.DefaultRequestHeaders().Add('Authorization', StrSubstNo('Bearer %1', AccessToken));
        Client.DefaultRequestHeaders().Add('Accept', 'application/json');

        if Client.Send(RequestMessage, ResponseMessage) then begin
            if ResponseMessage.HttpStatusCode = 200 then begin
                ResponseMessage.Content.ReadAs(JsonContent);
                JsonResponse.ReadFrom(JsonContent);
                exit(JsonResponse);
            end;
        end;
    end;

    [NonDebuggable]
    local procedure GetAccessToken(): Text
    var
        OAuth2: Codeunit OAuth2;
        Credentials: Codeunit "ENVHUB Credentials";
        Setup: Record "ENVHUB Setup";
        AccessToken: Text;
        AuthCodeError: Text;
        Scopes: List of [Text];
        UrlLbl: label 'https://login.microsoftonline.com/%1/oauth2/v2.0/token', comment = '%1 = tenant ID';
    begin
        Setup.Get;

        if not Credentials.IsInitialized() then
            Credentials.Init();

        Scopes.Add('https://api.businesscentral.dynamics.com/.default');
        OAuth2.AcquireTokenWithClientCredentials(
            Credentials.GetClientID(),
            Credentials.GetClientSecret(),
            StrSubstNo(UrlLbl, Setup."Tenant ID"),
            Setup."Redirect URL",
            Scopes,
            AccessToken);

        if (AccessToken = '') or (AuthCodeError <> '') then
            Error(AuthCodeError);

        exit(AccessToken);
    end;
}