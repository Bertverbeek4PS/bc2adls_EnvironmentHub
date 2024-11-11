permissionset 50101 "ENVHUB API"
{
    Assignable = true;
    Caption = 'ENVHUB API';
    Permissions =
        tabledata "ENVHUB Environment" = R,
        tabledata "ENVHUB Environment Company" = R,
        tabledata "ENVHUB Setup" = R,
        tabledata Company = R;
}