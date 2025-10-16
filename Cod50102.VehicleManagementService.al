codeunit 50102 "Vehicle Management Service"
{
    procedure CreateVehicleType(
        BrandName: Text;
        Description: Text;
        LogoImageB64: Text;
        ParentBrandNo: Integer
    ): Text
    var
        NewVehicleType: Record "Vehicle Types";
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        Base64Convert: Codeunit "Base64 Convert";
        StoreImageRef: FieldRef;
        StoreRecRef: RecordRef;
    begin
        // Initialize the record
        NewVehicleType.Init();

        // Assign brand name value to the field "Brand Name"
        NewVehicleType."Brand Name" := BrandName;
        // Assign description value to the field "Description"
        NewVehicleType.Description := Description;
        // Check if ParentBrandNo is defined
        if ParentBrandNo <> 0 then begin
            // Assign ParentBrandNo to the "Parent No." field
            NewVehicleType."Parent No." := ParentBrandNo;
        end;

        /*
        Section to handle conversion of logo image from base64 text format to blob
        */
        // Check if LogoImageB64 is not empty string/text
        if LogoImageB64 <> '' then begin
            /*
            TempBlob represents a temporary Blob (Binary Large Object) record.
            It's often used to store or manipulate large amounts of data,
            such as files or binary content,
            in memory without persisting them to the database.

            OutStr: A variable that will hold the output stream from the temporary blob
            */
            // 1. Initialize the OutStr variable. Creates an output stream from the temporary blob
            TempBlob.CreateOutStream(OutStr);

            /*
            LogoImageB64: A Text variable containing the Base64-encoded string.
            This represents the image/logo data encoded as Base64.

            OutStr: An OutStream variable where the decoded binary data will be written.
            */
            // 2. Decode the Base64-encoded string (LogoImageB64) and write the decoded binary data to the output stream.
            Base64Convert.FromBase64(LogoImageB64, OutStr);

            // 3. Reset/Empty the "Logo/Image" initial blob value
            Clear(NewVehicleType."Logo/Image");

            /*
            StoreRecRef: This is a variable of type RecordRef.

            A RecordRef allows you to work with any table in Business Central dynamically,
            without explicitly defining the table type at compile time.
            */

            // 4. The Open method is used to bind the RecordRef to table 50100 "Vehicle Types"
            StoreRecRef.Open(50100);

            /*
            StoreImageRef: A variable of type FieldRef.
            A FieldRef allows you to dynamically interact with a specific field in a RecordRef.

            NewVehicleType.FieldNo("Logo/Image"): The FieldNo method retrieves the numeric field ID for the "Logo/Image" field from the NewVehicleType record variable.

            StoreRecRef.Field(FieldID): The Field method retrieves a FieldRef object for the specified field ID from the RecordRef.
            */
            // 5. The FieldRef representing the "Logo/Image" field from StoreRecRef is assigned to StoreImageRef
            StoreImageRef := StoreRecRef.Field(NewVehicleType.FieldNo("Logo/Image"));

            // 6. Copy binary data of the image from the TempBlob record’s Blob field into the FieldRef (StoreImageRef).
            TempBlob.ToFieldRef(StoreImageRef);

            // 7. Check/Test if the FieldRef (StoreImageRef) has a Blob value. If empty an error will be thrown.
            StoreImageRef.TestField();

            // 8. Assign the Blob value from the FieldRef (StoreImageRef) to the "Logo/Image" Blob field
            NewVehicleType."Logo/Image" := StoreImageRef.Value;

            // 9. Check/Test if the Field ("Logo/Image") has a Blob value. If empty an error will be thrown.
            NewVehicleType.TestField("Logo/Image");
        end;

        // Create the new Vehicle Type record while running the OnInsert trigger
        NewVehicleType.Insert(true);

        // Response message
        exit('Vehicle Type has been created successfully');
    end;

    procedure CreateVehicle(
        VehicleTyoeNo: Integer;
        Description: Text;
        RegistrationNo: Text
    ): Text
    var
        NewVehicle: Record "Vehicle Register";
    begin
        NewVehicle.Init();

        NewVehicle."Vehicle Type No." := VehicleTyoeNo;
        // Validate the TableRelation of the "Vehicle Type No." field
        NewVehicle.Validate("Vehicle Type No.");

        NewVehicle.Description := Description;

        NewVehicle."Registration No." := RegistrationNo;
        // Run the validation logic on the onValidate trigger of the field
        NewVehicle.Validate("Registration No.");

        NewVehicle.Insert(true);

        // Response message
        exit('New Vehicle has been created successfully');
    end;

    procedure UpdateVehicleType(
        VehicleTypeNo: Integer;
        BrandName: Text;
        Description: Text;
        LogoImageB64: Text;
        ParentBrandNo: Integer
    ): Text
    var
        ExistingVehicleType: Record "Vehicle Types";
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        Base64Convert: Codeunit "Base64 Convert";
        StoreImageRef: FieldRef;
        StoreRecRef: RecordRef;
    begin
        // First Check if the vehicle type exists
        ExistingVehicleType.Reset;

        // Filter using the VehicleNo field
        ExistingVehicleType.SetRange("No.", VehicleTypeNo);

        if ExistingVehicleType.FindFirst then begin
            // Vehicle has been found

            // Assign brand name value to the field "Brand Name"
            ExistingVehicleType."Brand Name" := BrandName;
            // Assign description value to the field "Description"
            ExistingVehicleType.Description := Description;
            // Check if ParentBrandNo is defined
            if ParentBrandNo <> 0 then begin
                // Assign ParentBrandNo to the "Parent No." field
                ExistingVehicleType."Parent No." := ParentBrandNo;
            end;

            /*
            Section to handle conversion of logo image base64 text format to blob
            */
            // Check if LogoImageB64 is not empty string/text
            if LogoImageB64 <> '' then begin
                TempBlob.CreateOutStream(OutStr);
                Base64Convert.FromBase64(LogoImageB64, OutStr);
                Clear(ExistingVehicleType."Logo/Image");
                StoreRecRef.Open(50100);
                StoreImageRef := StoreRecRef.Field(ExistingVehicleType.FieldNo("Logo/Image"));
                TempBlob.ToFieldRef(StoreImageRef);
                StoreImageRef.TestField();
                ExistingVehicleType."Logo/Image" := StoreImageRef.Value;
                ExistingVehicleType.TestField("Logo/Image");
            end;

            // Update the vehicle Type record while running the OnModify trigger
            ExistingVehicleType.Modify(true);

            // Response message
            exit('Vehicle Type has been updated successfully');
        end else begin
            // Vehicle has NOT been found
            Error('Vehicle Type referenced by no. %1 does NOT exist in the records', VehicleTypeNo);
        end;
    end;

    procedure UpdateVehicle(
        VehicleNo: Integer;
        VehicleTypeNo: Integer;
        Description: Text;
        RegistrationNo: Text
    ): Text
    var
        ExistingVehicle: Record "Vehicle Register";
    begin
        // First Check if the Vehicle exists
        ExistingVehicle.Reset();

        ExistingVehicle.SetRange("No", VehicleNo);

        if ExistingVehicle.FindFirst then begin
            ExistingVehicle."Vehicle Type No." := VehicleTypeNo;
            // Validate the TableRelation of the "Vehicle Type No." field
            ExistingVehicle.Validate("Vehicle Type No.");

            ExistingVehicle.Description := Description;

            ExistingVehicle."Registration No." := RegistrationNo;
            // Run the validation logic on the OnValidate trigger of the field
            ExistingVehicle.Validate("Registration No.");

            ExistingVehicle.Modify(true);

            // Response message
            exit('Vehicle details has been modified successfully');
        end else begin

            // Vehicle has NOT been found
            Error('Vehicle referenced by no. %1 does NOT exist in the records', VehicleNo);
        end;
    end;

    procedure DeleteVehicleType(
        VehicleTypeNo: Integer
    ): Text
    var
        ExistingVehicleType: Record "Vehicle Types";
    begin
        // First check if the vehicle type exists
        ExistingVehicleType.Reset;

        // Filter using the VehicleNo field
        ExistingVehicleType.SetRange("No.", VehicleTypeNo);

        if ExistingVehicleType.FindFirst then begin
            // Vehicle has been found
            // Delete the Vehicle Type record without running the OnDelete trigger
            ExistingVehicleType.Delete(false);

            // Response message
            exit('Vehicle Type has been deleted successfully');
        end else begin
            // Vehicle Type has NOT been found
            Error('Vehicle Type referenced by no. %1 does NOT exist in the records', VehicleTypeNo);
        end;
    end;

    procedure DeleteVehicle(
        VehicleNo: Integer
    ): Text
    var
        ExistingVehicle: Record "Vehicle Register";
    begin
        // First Check if the vehicle exists
        ExistingVehicle.Reset();

        ExistingVehicle.SetRange("No", VehicleNo);

        if ExistingVehicle.FindFirst then begin
            ExistingVehicle.Delete(false);

            // Response message
            exit('Vehicle has been deleted successfully');
        end else begin
            // Vehicle has NOT been found
            Error('Vehicle referenced by no. %1 does NOT exist in the records', VehicleNo);
        end;
    end;
}