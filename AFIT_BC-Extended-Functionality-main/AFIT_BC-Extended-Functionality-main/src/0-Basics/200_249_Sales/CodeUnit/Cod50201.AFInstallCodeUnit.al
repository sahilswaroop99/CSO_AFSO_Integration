codeunit 50201 AFInstallCodeUnit
{
    Subtype = Install;
    trigger OnInstallAppPerCompany()
    var
        AFMakeModelYear: Query AFMakeModelYear;
    begin
        if not AFMakeModelYear.Open() then
            exit;
        while AFMakeModelYear.Read() do begin
            CreateYearLookupRec(AFMakeModelYear.Year, AFMakeModelYear.Make, AFMakeModelYear.Model);
        end;
        AFMakeModelYear.Close();
    end;
    //<<BPIT
    local procedure CreateYearLookupRec(Year: Integer; Make: Code[20]; Model: Code[20])
    var
        AFYearLookup: Record AFMakeModelYearLookup;
    begin
        if AFYearLookup.Get(Year, Make, Model) then
            exit;
        AFYearLookup.Init();
        AFYearLookup.Year := Year;
        AFYearLookup.Make := Make;
        AFYearLookup.Model := Model;
        if AFYearLookup.Insert() then;
    end;
    //>>

}
