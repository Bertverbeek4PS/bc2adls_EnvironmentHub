// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License. See LICENSE in the project root for license information.
page 50105 "ANVHUB Schedule Export"
{
    PageType = Card;
    Caption = 'Schedule Export';
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group("Schedule")
            {
                group(Filtering)
                {
                    field(Environment; Environment)
                    {
                        ApplicationArea = All;
                        Caption = 'Environment';
                        Tooltip = 'Select the environment to schedule the job for.';
                        Lookup = true;
                        LookupPageId = "ENVHUB Environment";
                        TableRelation = "ENVHUB Environment"."Environment Name";
                    }

                    // field(Company; Company)
                    // {
                    //     ApplicationArea = All;
                    //     Caption = 'Company';
                    //     Tooltip = 'Select the Company to schedule the job for.';
                    //     Lookup = true;
                    //     LookupPageId = "ENVHUB Environment Companies";
                    //     TableRelation = "ENVHUB Environment Company"."Company Name";
                    // }
                }
                group("Time")
                {
                    field(TimeToRun; TimeToRun)
                    {
                        ApplicationArea = All;
                        Caption = 'Job start time';
                        Tooltip = 'At what time should the job should start';

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            DateTimeDialog: Page "Date-Time Dialog";
                        begin
                            DateTimeDialog.SetDateTime(TimeToRun);
                            if DateTimeDialog.RunModal() = Action::OK then
                                TimeToRun := DateTimeDialog.GetDateTime();
                            exit;
                        end;
                    }
                }
                group(Recurring)
                {
                    field(RecurringJob; RecurringJob)
                    {
                        ApplicationArea = All;
                        Caption = 'Recurring job';
                        Tooltip = 'Is the job recurring';
                    }
                    field("MinutesBetweenRuns"; MinutesBetweenRuns)
                    {
                        ApplicationArea = All;
                        Caption = 'Minutes between runs';
                        Tooltip = 'The number of minutes between the job is finished and the next one starts.';
                    }
                    field("MinutesOutOfSync"; MinutesOutOfSync)
                    {
                        ApplicationArea = All;
                        Caption = 'Minutes out of sync';
                        Tooltip = 'A maximum of 3 job queues can be scheduled at the same time. When there are more then 3 companies in an environment, it''s not possible to schedule all companies directly. This is the time in minutes between scheduling batches of jobs.';
                    }
                    field("MaximumNoofAttemptstoRun"; MaximumNoofAttemptstoRun)
                    {
                        ApplicationArea = All;
                        Caption = 'Maximum No of Attempts to Run';
                    }
                    field("RerunDelay"; RerunDelay)
                    {
                        ApplicationArea = All;
                        Caption = 'Rerun Delay (sec.)';
                    }

                    field("DelayByRunAgain"; DelayByRunAgain)
                    {
                        ApplicationArea = All;
                        Caption = 'Delay By Run Again';
                    }
                    field("InactivityTimeoutPeriod"; InactivityTimeoutPeriod)
                    {
                        ApplicationArea = All;
                        Caption = 'Inactivity Time-out Period';
                    }
                    field("JobTimeout"; JobTimeout)
                    {
                        ApplicationArea = All;
                        Caption = 'Job Time out';
                    }
                    field("StartingTime"; StartingTime)
                    {
                        ApplicationArea = All;
                        Caption = 'Starting Time';
                    }
                    field("EndingTime"; EndingTime)
                    {
                        ApplicationArea = All;
                        Caption = 'Ending Time';
                    }
                }
                group(When)
                {
                    Enabled = RecurringJob;
                    Editable = RecurringJob;
                    field(RunOnMonday; RunOnMonday)
                    {
                        ApplicationArea = All;
                        Caption = 'Run on monday';
                        Tooltip = 'The job should run on monday';
                    }
                    field(RunOnTuesDay; RunOnTuesDay)
                    {
                        ApplicationArea = All;
                        Caption = 'Run on tuesday';
                        Tooltip = 'The job should run on tuesday';
                    }
                    field(RunOnWednesday; RunOnWednesday)
                    {
                        ApplicationArea = All;
                        Caption = 'Run on wednesday';
                        Tooltip = 'The job should run on wednesday';
                    }
                    field(RunOnThursday; RunOnThursday)
                    {
                        ApplicationArea = All;
                        Caption = 'Run on thursday';
                        Tooltip = 'The job should run on thursday';
                    }
                    field(RunOnFriday; RunOnFriday)
                    {
                        ApplicationArea = All;
                        Caption = 'Run on friday';
                        Tooltip = 'The job should run on friday';
                    }
                    field(RunOnSaturday; RunOnSaturday)
                    {
                        ApplicationArea = All;
                        Caption = 'Run on saturday';
                        Tooltip = 'The job should run on saturday';
                    }
                    field(RunOnSunday; RunOnSunday)
                    {
                        ApplicationArea = All;
                        Caption = 'Run on sunday';
                        Tooltip = 'The job should run on sunday';
                    }
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ScheduleMultiCompany)
            {
                ApplicationArea = All;
                Caption = 'Schedule multi company';
                Tooltip = 'Schedules a job for multiple companies';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = Calendar;

                trigger OnAction()
                var
                    ADLSESchedule: Codeunit "ENVHUB Schedule Export";
                begin
                    ADLSESchedule.ScheduleExport(
                        RecurringJob,
                        RunOnMonday,
                        RunOnTuesDay,
                        RunOnWednesday,
                        RunOnThursday,
                        RunOnFriday,
                        RunOnSaturday,
                        RunOnSunday,
                        TimeToRun,
                        MinutesBetweenRuns,
                        MinutesOutOfSync,
                        Environment,
                        MaximumNoofAttemptstoRun,
                        RerunDelay,
                        DelayByRunAgain,
                        InactivityTimeoutPeriod,
                        StartingTime,
                        EndingTime);
                    Message('One or more jobs are scheduled for the selected companies');
                end;
            }
            action(DeleteScheduleMultiCompany)
            {
                ApplicationArea = All;
                Caption = 'Deletes all scheduled jobs';
                Tooltip = 'Deletes scheduled jobs for all companies';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                Image = Delete;

                trigger OnAction()
                var
                    ADLSESchedule: Codeunit "ENVHUB Schedule Export";
                begin
                    ADLSESchedule.DeleteSchedule(Environment);
                    Message('Deleted scheduled jobs for all companies');
                end;
            }
        }
    }

    trigger OnInit()
    begin
        // set defaults
        RecurringJob := true;
        RunOnMonday := true;
        RunOnTuesDay := true;
        RunOnWednesday := true;
        RunOnThursday := true;
        RunOnFriday := true;
        RunOnSaturday := false;
        RunOnSunday := false;
        TimeToRun := CurrentDateTime() + (2 * 60 * 1000); // in 2 minute
        MinutesBetweenRuns := 60;
        MinutesOutOfSync := 4;
    end;

    var
        RecurringJob: Boolean;
        RunOnMonday: Boolean;
        RunOnTuesDay: Boolean;
        RunOnWednesday: Boolean;
        RunOnThursday: Boolean;
        RunOnFriday: Boolean;
        RunOnSaturday: Boolean;
        RunOnSunday: Boolean;
        TimeToRun: DateTime;
        MinutesBetweenRuns: Integer;
        MinutesOutOfSync: Integer;
        MaximumNoofAttemptstoRun: Integer;
        RerunDelay: Integer;
        DelayByRunAgain: Integer;
        InactivityTimeoutPeriod: Integer;
        JobTimeout: Duration;
        StartingTime: Time;
        EndingTime: Time;
        Environment: Text;
        Company: Text;
}