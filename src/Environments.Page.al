page 50100 "ENVHUB Environment"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "ENVHUB Environment";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Environment Name"; rec."Environment Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Companies)
            {
                ApplicationArea = All;
                Caption = 'Companies';
                ToolTip = 'Open the list of companies for the selected environment.';
                Image = Company;

                trigger OnAction()
                var
                    EnvironmentCompany: Record "ENVHUB Environment Company";
                begin
                    EnvironmentCompany.SetRange("Environment Name", rec."Environment Name");
                    Page.RunModal(Page::"ENVHUB Environment Companies", EnvironmentCompany);
                end;
            }
            action(GetCompanies)
            {
                ApplicationArea = All;
                Caption = 'Get Companies';
                ToolTip = 'Get all the companies of an environment.';
                Image = Import;

                trigger OnAction()
                var
                    ENVHUBCommunication: Codeunit "ENVHUB Communication";
                begin
                    ENVHUBCommunication.InsertCompanies(rec."Environment Name");
                end;
            }
            action(ScheduleExport)
            {
                ApplicationArea = All;
                Caption = 'Schedule Export';
                ToolTip = 'Schedule an export accross all environments.';
                Image = TaskList;
                RunObject = Page "ANVHUB Schedule Export";
            }
            action(Setup)
            {
                ApplicationArea = All;
                Caption = 'Setup';
                ToolTip = 'Setup the Environment Hub.';
                Image = Setup;
                RunObject = Page "ENVHUB Setup";
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Companies';

                group(CompaniesGroup)
                {
                    ShowAs = SplitButton;
                    actionref(ExportNow_Promoted; Companies) { }
                    actionref(StopExport_Promoted; GetCompanies) { }
                }
                actionref(Setup_Promoted; Setup) { }
            }
        }
    }
}