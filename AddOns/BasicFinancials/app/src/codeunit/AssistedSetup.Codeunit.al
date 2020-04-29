codeunit 20605 "Assisted Setup BF"
{
    Access = Internal;

    var
        AssistedSetupTxt: Label 'Set up Basic Financials extension';
        AssistedSetupHelpTxt: Label 'https://go.microsoft.com/fwlink/?linkid=', Locked = true;
        AssistedSetupDescriptionTxt: Label 'Basic Financials';
        AlreadySetUpQst: Label 'You have already completed the Basic Financials extension assisted setup guide. Do you want to run it again ?';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assisted Setup", 'OnRegister', '', false, false)]
    local procedure SetupInitialize()
    var
        BaseAppID: Codeunit "BaseApp ID";
        AssistedSetup: Codeunit "Assisted Setup";
        AssistedSetupGroup: Enum "Assisted Setup Group";
        VideoCategory: Enum "Video Category";
    begin
        AssistedSetup.Add(BaseAppID.Get(), PAGE::"Assisted Setup BF", AssistedSetupTxt, AssistedSetupGroup::ReadyForBusiness, '', VideoCategory::ReadyForBusiness, AssistedSetupHelpTxt, AssistedSetupDescriptionTxt);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Assisted Setup", 'OnReRunOfCompletedSetup', '', false, false)]
    local procedure OnReRunOfCompletedSetup(ExtensionId: Guid; PageID: Integer; var Handled: Boolean)
    begin
        if ExtensionId <> GetAppId() then
            exit;
        case PageID of
            Page::"Assisted Company Setup Wizard":
                begin
                    if Confirm(AlreadySetUpQst, true) then
                        Page.Run(PAGE::"Assisted Setup BF");
                    Handled := true;
                end;
        end;
    end;

    local procedure GetAppId(): Guid
    var
        Info: ModuleInfo;
        EmptyGuid: Guid;
    begin
        if Info.Id() = EmptyGuid then
            NavApp.GetCurrentModuleInfo(Info);
        exit(Info.Id());
    end;
}