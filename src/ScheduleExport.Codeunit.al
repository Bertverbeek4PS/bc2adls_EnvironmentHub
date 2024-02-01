// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License. See LICENSE in the project root for license information.
codeunit 50100 "ENVHUB Schedule Export"
{
    procedure CreateJobQueueEntry(
        RecurringJob: Boolean;
        Monday: Boolean;
        Tuesday: Boolean;
        Wednesday: Boolean;
        Thursdays: Boolean;
        Friday: Boolean;
        Saturday: Boolean;
        Sunday: Boolean;
        MinBetweenRuns: Integer)
    var
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueCategory: Record "Job Queue Category";
        JobCategoryCodeTxt: Label 'ADLSE';
        JobCategoryDescriptionTxt: Label 'Export to Azure Data Lake';
    begin
        JobQueueCategory.InsertRec(JobCategoryCodeTxt, JobCategoryDescriptionTxt);
        if JobQueueEntry.FindJobQueueEntry(JobQueueEntry."Object Type to Run"::Codeunit, Codeunit::"ADLSE Execution") then
            exit;
        JobQueueEntry.Init();
        JobQueueEntry.Validate("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.Validate("Object ID to Run", CODEUNIT::"ADLSE Execution");
        JobQueueEntry.Insert(true);
        JobQueueEntry.Description := JobQueueCategory.Description;
        JobQueueEntry."Recurring Job" := RecurringJob;
        if RecurringJob then begin
            JobQueueEntry."Run on Mondays" := Monday;
            JobQueueEntry."Run on Tuesdays" := Tuesday;
            JobQueueEntry."Run on Wednesdays" := Wednesday;
            JobQueueEntry."Run on Thursdays" := Thursdays;
            JobQueueEntry."Run on Fridays" := Friday;
            JobQueueEntry."Run on Saturdays" := Saturday;
            JobQueueEntry."Run on Sundays" := Sunday;
            JobQueueEntry."No. of Minutes between Runs" := MinBetweenRuns;
        end;
        JobQueueEntry."Earliest Start Date/Time" := CurrentDateTime();
        JobQueueEntry.Modify(true);

    end;

    [ServiceEnabled]
    procedure DeleteScheduleMultiExport()
    var
        JobQueueEntry: Record "Job Queue Entry";
    begin
        JobQueueEntry.Reset();
        JobQueueEntry.SetRange("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SetRange("Object ID to Run", Codeunit::"ADLSE Execution");
        if JobQueueEntry.FindSet() then begin
            JobQueueEntry.DeleteAll();
        end;
    end;

    procedure ScheduleExport(
        RecurringJob: Boolean;
        Monday: Boolean;
        Tuesday: Boolean;
        Wednesday: Boolean;
        Thursdays: Boolean;
        Friday: Boolean;
        Saturday: Boolean;
        Sunday: Boolean;
        TimeToRun: DateTime;
        MinBetweenRuns: Integer;
        MinutesOutOfSync: Integer;
        Environment: Text[250])
    begin
        MyBusinessScheduleExport(RecurringJob, Monday, Tuesday, Wednesday, Thursdays, Friday, Saturday, Sunday, TimeToRun, MinBetweenRuns, MinutesOutOfSync, Environment);
    end;

    procedure DeleteSchedule(Environment: Text[250])
    var
        Url: Text[250];
        WebClientUrl: Text[250];
        ADLSEFieldApiUrlTok: Label 'envhub/envhub/v1.0/companies(%1)/envCompanies(%2)', Locked = true;
    begin
        MyBusinessDeleteSchedule(Environment);
    end;

    [ExternalBusinessEvent('DeleteSchedule', 'Delete job queue', 'Deletion of all Job Queues', EventCategory::ADLSE)]
    local procedure MyBusinessDeleteSchedule(Environment: Text[250])
    begin
    end;

    [ExternalBusinessEvent('ScheduleExport', 'Schedule export', 'An export is created in a job queue', EventCategory::ADLSE)]
    local procedure MyBusinessScheduleExport(RecurringJob: Boolean;
        Monday: Boolean;
        Tuesday: Boolean;
        Wednesday: Boolean;
        Thursdays: Boolean;
        Friday: Boolean;
        Saturday: Boolean;
        Sunday: Boolean;
        TimeToRun: DateTime;
        MinBetweenRuns: Integer;
        MinutesOutOfSync: Integer;
        Environment: Text[250])
    begin
    end;
}