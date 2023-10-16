pageextension 50100 "ENVHUB ADLSE Setup Ext" extends "ADLSE Setup"
{
    actions
    {
        addafter(DeleteOldRuns)
        {
            action(envhub)
            {
                ApplicationArea = All;
                Caption = 'Environment Hub';
                Tooltip = 'Setup and manage enviroments and companies with bc2adls extension.';
                Image = Company;
                RunObject = Page "ENVHUB Environment";
            }
        }
    }
}