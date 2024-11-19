page 50102 "ENVHUB Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "ENVHUB Setup";

    layout
    {
        area(Content)
        {
            group(Access)
            {
                Caption = 'App registration';

                field(TenantId; rec."Tenant Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the tenant ID where the enviroment is located.';
                    Visible = SaaSEnvironment;
                }
                field("Client ID"; ClientID)
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the application client ID for the Azure App Registration that accesses the storage account.';

                    trigger OnValidate()
                    begin
                        Credentials.SetClientID(ClientID);
                    end;
                }
                field("Client Secret"; ClientSecret)
                {
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                    Tooltip = 'Specifies the client secret for the Azure App Registration that accesses the storage account.';

                    trigger OnValidate()
                    begin
                        Credentials.SetClientSecret(ClientSecret);
                    end;
                }
                field(RedirectUrl; rec."Redirect URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the redirect URL of the application that will be used to the Business Central integration.';

                }
                field(BaseUrl; rec."Base URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the redirect base URL api of the application that will be used to the Business Central integration. Like https://nav.contoso.com:7048/bc/api/v2.0/v1.0/companies.';
                    Visible = not SaaSEnvironment;
                }
            }
        }
    }

    var
        [NonDebuggable]
        ClientID: Text;
        [NonDebuggable]
        ClientSecret: Text;
        Credentials: Codeunit "ENVHUB Credentials";
        EnvironmentInformation: Codeunit "Environment Information";
        SaaSEnvironment: Boolean;

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            InitializeDefaultRedirectUrl();
            Rec.Insert();
        end else begin
            Credentials.Init();
            ClientID := Credentials.GetClientID();
            ClientSecret := Credentials.GetClientSecret();
        end;
        SaaSEnvironment := EnvironmentInformation.IsSaaS();
    end;

    local procedure InitializeDefaultRedirectUrl()
    var
        OAuth2: Codeunit "OAuth2";
        RedirectUrl: Text;
    begin
        OAuth2.GetDefaultRedirectUrl(RedirectUrl);
        Rec."Redirect URL" := CopyStr(RedirectUrl, 1, MaxStrLen(Rec."Redirect URL"));
    end;
}