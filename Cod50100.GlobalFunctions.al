codeunit 50100 "Global Functions"
{
    procedure ConfirmRecordDeletion()
    var
        myInt: Integer;
    begin
        // Confirm to proceed with deletion
        if not (Confirm('Are you sure you want to delete this record?')) then begin
            // Confirm - No
            Error('Record deletion has been cancelled');
        end else begin
            // Confirm - Yes
            Message('Record will be deleted!');
        end;
        
    end;
}
