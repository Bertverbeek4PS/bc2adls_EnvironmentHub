codeunit 50102 "ENVHUB Credentials"
{
    Access = Internal;

    var
        [NonDebuggable]
        ClientID: Text;
        [NonDebuggable]
        ClientSecret: Text;
        ClientIdKeyName: Label 'envhub-client-id', Locked = true;
        ClientSecretKeyName: Label 'envhub-client-secret', Locked = true;
        Initialized: Boolean;

    trigger OnRun()
    begin

    end;

    procedure Init()
    begin
        ClientID := GetSecret(ClientIdKeyName);
        ClientSecret := GetSecret(ClientSecretKeyName);

        Initialized := true;
    end;

    procedure IsInitialized(): Boolean
    begin
        exit(Initialized);
    end;

    [NonDebuggable]
    procedure GetClientID(): Text
    begin
        exit(ClientID);
    end;

    [NonDebuggable]
    procedure SetClientID(NewClientIDValue: Text): Text
    begin
        ClientID := NewClientIDValue;
        SetSecret(ClientIdKeyName, NewClientIDValue);
    end;

    [NonDebuggable]
    procedure GetClientSecret(): Text
    begin
        exit(ClientSecret);
    end;

    [NonDebuggable]
    procedure SetClientSecret(NewClientSecretValue: Text): Text
    begin
        ClientSecret := NewClientSecretValue;
        SetSecret(ClientSecretKeyName, NewClientSecretValue);
    end;

    [NonDebuggable]
    local procedure GetSecret(KeyName: Text) Secret: Text
    begin
        if not IsolatedStorage.Contains(KeyName, DataScope::Company) then
            exit('');
        IsolatedStorage.Get(KeyName, DataScope::Company, Secret);
    end;

    [NonDebuggable]
    local procedure SetSecret(KeyName: Text; Secret: Text)
    begin
        if EncryptionEnabled() then begin
            IsolatedStorage.SetEncrypted(KeyName, Secret, DataScope::Company);
            exit;
        end;
        IsolatedStorage.Set(KeyName, Secret, DataScope::Company);
    end;

}