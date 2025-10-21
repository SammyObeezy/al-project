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

    procedure CreateVehicleTypeJSON(
          JSONData: Text
      ): Text
    var
        RequestParser: JsonObject;
        RequestBrandName: JsonToken;
        RequestDescription: JsonToken;
        RequestLogoImageB64: JsonToken;
        RequestParentBrandNo: JsonToken;

        BrandName: Text;
        Description: Text;
        LogoImageB64: Text;
        ParentBrandNo: Integer;

        NewVehicleType: Record "Vehicle Types";
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        Base64Convert: Codeunit "Base64 Convert";
        StoreImageRef: FieldRef;
        StoreRecRef: RecordRef;

        ResponseObject: JsonObject;
        Response: Text;
    begin
        /*
        {
            "brand_name":"Volkswagen Beetle",
            "description":"Volkswagen Beetle",
            "logo_image": "BASE_64_CONTENTS",
            "parent_brand_no": 1
        }
        */
        RequestParser.ReadFrom(JsonData);
        RequestParser.SelectToken('$.brand_name', RequestBrandName);
        RequestParser.SelectToken('$.description', RequestDescription);
        RequestParser.SelectToken('$.logo_image', RequestLogoImageB64);
        RequestParser.SelectToken('$.parent_brand_no', RequestParentBrandNo);

        BrandName := RequestBrandName.AsValue().AsText();
        Description := RequestDescription.AsValue().AsText();
        LogoImageB64 := RequestLogoImageB64.AsValue().AsText();
        ParentBrandNo := RequestParentBrandNo.AsValue().AsInteger();

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
        /*
            Response

            {
                "status":"SUCCESS",
                "status_description":"Vehicle Type has been created successfully"
            }
        */
        // Add the property "status" with the value "SUCCESS" to the ResponseObject
        ResponseObject.Add('status', 'SUCCESS');
        // Add the property "status_description" with the value "Vehicle Type has been created successfully" to the ResponseObject
        ResponseObject.Add('status_description', 'Vehicle Type has been created successfully');
        // Convert ResponseObject to Response JSON string/text
        ResponseObject.WriteTo(Response);

        // Send Response text as SOAP API response value
        exit(Response);
    end;

    procedure CreateVehicleJSON(
    JSONData: Text
): Text
    var
        RequestParser: JsonObject;
        RequestVehicleTypeNo: JsonToken;
        RequestDescription: JsonToken;
        RequestRegistrationNo: JsonToken;

        VehicleTypeNo: Integer;
        Description: Text;
        RegistrationNo: Text;

        NewVehicle: Record "Vehicle Register";

        ResponseObject: JsonObject;
        Response: Text;
    begin
        /*
        {
            "vehicle_type_no": 18,
            "description":"2022 Black Toyota Land Crusier",
            "registration_no": "REG997"
        }
        */
        RequestParser.ReadFrom(JsonData);
        RequestParser.SelectToken('$.vehicle_type_no', RequestVehicleTypeNo);
        RequestParser.SelectToken('$.description', RequestDescription);
        RequestParser.SelectToken('$.registration_no', RequestRegistrationNo);

        VehicleTypeNo := RequestVehicleTypeNo.AsValue().AsInteger();
        Description := RequestDescription.AsValue().AsText();
        RegistrationNo := RequestRegistrationNo.AsValue().AsText();

        // Initialize the record
        NewVehicle.Init();

        NewVehicle."Vehicle Type No." := VehicleTypeNo;
        // Validate the TableRelation of the "Vehicle Type No." field
        NewVehicle.Validate("Vehicle Type No.");

        NewVehicle.Description := Description;

        NewVehicle."Registration No." := RegistrationNo;
        // Run the validation logic on the OnValidate trigger of the field
        NewVehicle.Validate("Registration No.");

        NewVehicle.Insert(true);

        // Response message
        /*
            Response

            {
                "status":"SUCCESS",
                "status_description":"New Vehicle has been created successfully"
            }
        */
        // Add the property "status" with the value "SUCCESS" to the ResponseObject
        ResponseObject.Add('status', 'SUCCESS');
        // Add the property "status_description" with the value "New Vehicle has been created successfully" to the ResponseObject
        ResponseObject.Add('status_description', 'New Vehicle has been created successfully');
        // Convert ResponseObject to Response JSON string/text
        ResponseObject.WriteTo(Response);

        // Send Response text as SOAP API response value
        exit(Response);
    end;

    procedure UpdateVehicleTypeJSON(
        JSONData: Text
    ): Text
    var
        RequestParser: JsonObject;
        RequestVehicleTypeNo: JsonToken;
        RequestBrandName: JsonToken;
        RequestDescription: JsonToken;
        RequestLogoImageB64: JsonToken;
        RequestParentBrandNo: JsonToken;

        VehicleTypeNo: Integer;
        BrandName: Text;
        Description: Text;
        LogoImageB64: Text;
        ParentBrandNo: Integer;

        ExistingVehicleType: Record "Vehicle Types";
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        Base64Convert: Codeunit "Base64 Convert";
        StoreImageRef: FieldRef;
        StoreRecRef: RecordRef;

        ResponseObject: JsonObject;
        Response: Text;
    begin
        /*
        {
            "vehicle_type_no": 20,
            "brand_name":"Mitsubishi Pajero",
            "description":"The Mitsubishi Pajero is a full-size SUV (sport utility vehicle) manufactured and marketed globally by Mitsubishi over four generations — introduced in 1981 and discontinued in 2021",
            "logo_image": "",
            "parent_brand_no": 12
        }
        */
        RequestParser.ReadFrom(JsonData);
        RequestParser.SelectToken('$.vehicle_type_no', RequestVehicleTypeNo);
        RequestParser.SelectToken('$.brand_name', RequestBrandName);
        RequestParser.SelectToken('$.description', RequestDescription);
        RequestParser.SelectToken('$.logo_image', RequestLogoImageB64);
        RequestParser.SelectToken('$.parent_brand_no', RequestParentBrandNo);

        VehicleTypeNo := RequestVehicleTypeNo.AsValue().AsInteger();
        BrandName := RequestBrandName.AsValue().AsText();
        Description := RequestDescription.AsValue().AsText();
        LogoImageB64 := RequestLogoImageB64.AsValue().AsText();
        ParentBrandNo := RequestParentBrandNo.AsValue().AsInteger();

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
            Section to handle conversion of logo image from base64 text format to blob
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

            // Update the Vehicle Type record while running the OnModify trigger
            ExistingVehicleType.Modify(true);

            // Response message
            // Add the property "status" with the value "SUCCESS" to the ResponseObject
            ResponseObject.Add('status', 'SUCCESS');
            // Add the property "status_description" with the value "Vehicle Type details has been updated successfully" to the ResponseObject
            ResponseObject.Add('status_description', 'Vehicle Type details have been updated successfully');
        end else begin
            // Error response message
            ResponseObject.Add('status', 'ERROR');
            ResponseObject.Add('status_description', 'Vehicle Type referenced by no. ' + Format(VehicleTypeNo) + ' does NOT exist in the records');
        end;

        // Convert ResponseObject to Response JSON string/text
        ResponseObject.WriteTo(Response);
        // Send Response text as SOAP API response value
        exit(Response);
    end;

    procedure UpdateVehicleJSON(
    JSONData: Text
): Text
    var
        RequestParser: JsonObject;
        RequestVehicleNo: JsonToken;
        RequestVehicleTypeNo: JsonToken;
        RequestDescription: JsonToken;
        RequestRegistrationNo: JsonToken;

        VehicleNo: Integer;
        VehicleTypeNo: Integer;
        Description: Text;
        RegistrationNo: Text;

        ExistingVehicle: Record "Vehicle Register";

        ResponseObject: JsonObject;
        Response: Text;
    begin
        /*
        {
            "vehicle_no": 16,
            "vehicle_type_no": 26,
            "description":"Orange Porsche Cayenne, 2022 Model",
            "registration_no":"REG990"
        }
        */
        RequestParser.ReadFrom(JsonData);
        RequestParser.SelectToken('$.vehicle_no', RequestVehicleNo);
        RequestParser.SelectToken('$.vehicle_type_no', RequestVehicleTypeNo);
        RequestParser.SelectToken('$.description', RequestDescription);
        RequestParser.SelectToken('$.registration_no', RequestRegistrationNo);

        VehicleNo := RequestVehicleNo.AsValue().AsInteger();
        VehicleTypeNo := RequestVehicleTypeNo.AsValue().AsInteger();
        Description := RequestDescription.AsValue().AsText();
        RegistrationNo := RequestRegistrationNo.AsValue().AsText();

        // First Check if the vehicle exists
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

            // Add the property "status" with the value "SUCCESS" to the ResponseObject
            ResponseObject.Add('status', 'SUCCESS');
            // Add the property "status_description" with the value "Vehicle details has been updated successfully" to the ResponseObject
            ResponseObject.Add('status_description', 'Vehicle details have been updated successfully');
        end else begin
            // Vehicle has NOT been found
            // Error response message
            ResponseObject.Add('status', 'ERROR');
            ResponseObject.Add('status_description', 'Vehicle referenced by no. ' + Format(VehicleNo) + ' does NOT exist in the records');
        end;

        // Convert ResponseObject to Response JSON string/text
        ResponseObject.WriteTo(Response);
        // Send Response text as SOAP API response value
        exit(Response);
    end;

    procedure DeleteVehicleTypeJSON(
        JSONData: Text
    ): Text
    var
        RequestParser: JsonObject;
        RequestVehicleTypeNo: JsonToken;

        VehicleTypeNo: Integer;

        ExistingVehicleType: Record "Vehicle Types";

        ResponseObject: JsonObject;
        Response: Text;
    begin
        /*
        {
            "vehicle_type_no": 10
        }
        */
        RequestParser.ReadFrom(JsonData);
        RequestParser.SelectToken('$.vehicle_type_no', RequestVehicleTypeNo);

        VehicleTypeNo := RequestVehicleTypeNo.AsValue().AsInteger();

        // First Check if the vehicle type exists
        ExistingVehicleType.Reset;

        // Filter using the VehicleNo field
        ExistingVehicleType.SetRange("No.", VehicleTypeNo);

        if ExistingVehicleType.FindFirst then begin
            // Vehicle has been found
            // Delete the Vehicle Type record without running the OnDelete trigger
            ExistingVehicleType.Delete(false);

            // Response message
            ResponseObject.Add('status', 'SUCCESS');
            ResponseObject.Add('status_description', 'Vehicle Type has been deleted successfully');
        end else begin
            // Error response message
            ResponseObject.Add('status', 'ERROR');
            ResponseObject.Add('status_description', 'Vehicle Type referenced by no. ' + Format(VehicleTypeNo) + ' does NOT exist in the records');
        end;

        // Convert ResponseObject to Response JSON string/text
        ResponseObject.WriteTo(Response);
        // Send Response text as SOAP API response value
        exit(Response);
    end;

    procedure DeleteVehicleJSON(
    JSONData: Text
): Text
    var
        RequestParser: JsonObject;
        RequestVehicleNo: JsonToken;

        VehicleNo: Integer;

        ExistingVehicle: Record "Vehicle Register";

        ResponseObject: JsonObject;
        Response: Text;
    begin
        /*
        {
            "vehicle_no": 34
        }
        */
        RequestParser.ReadFrom(JsonData);
        RequestParser.SelectToken('$.vehicle_no', RequestVehicleNo);

        VehicleNo := RequestVehicleNo.AsValue().AsInteger();

        // First Check if the vehicle exists
        ExistingVehicle.Reset();

        ExistingVehicle.SetRange("No", VehicleNo);

        if ExistingVehicle.FindFirst then begin
            ExistingVehicle.Delete(false);

            // Response message
            ResponseObject.Add('status', 'SUCCESS');
            ResponseObject.Add('status_description', 'Vehicle has been deleted successfully');
        end else begin
            // Error response message
            ResponseObject.Add('status', 'ERROR');
            ResponseObject.Add('status_description', 'Vehicle referenced by no. ' + Format(VehicleNo) + ' does NOT exist in the records');
        end;

        // Convert ResponseObject to Response JSON string/text
        ResponseObject.WriteTo(Response);
        // Send Response text as SOAP API response value
        exit(Response);
    end;

    procedure GetVehicleTypesJSON(): Text
    var
        VehicleTypes: Record "Vehicle Types";

        ResponseObject: JsonObject;
        ResponseData: JsonArray;
        ResponseVehicleType: JsonObject;
        Response: Text;
    begin
        // Retrieve list of Vehicle Types records
        if VehicleTypes.FindSet then begin
            repeat begin
                // Clear/Reset the ResponseVehicleType JsonObject for each loop/iteration
                Clear(ResponseVehicleType);

                // Compute the values of the FlowFields
                VehicleTypes.CalcFields(
                    "Parent Brand Name",
                    "Registered Brand Names",
                    "Registered Vehicles"
                );

                /*
                Define the key-value properties for the ResponseVehicleType JsonObject
                */
                ResponseVehicleType.Add('vehicle_type_no', VehicleTypes."No.");
                ResponseVehicleType.Add('brand_name', VehicleTypes."Brand Name");
                ResponseVehicleType.Add('description', VehicleTypes.Description);
                ResponseVehicleType.Add('created_by', VehicleTypes."Created By");
                ResponseVehicleType.Add('updated_by', VehicleTypes."Updated By");
                ResponseVehicleType.Add('parent_no', VehicleTypes."Parent No.");
                ResponseVehicleType.Add('parent_brand_name', VehicleTypes."Parent Brand Name");
                ResponseVehicleType.Add('registered_brand_names', VehicleTypes."Registered Brand Names");
                ResponseVehicleType.Add('registered_vehicles', VehicleTypes."Registered Vehicles");

                // Add the ResponseVehicleType object to ResponseData array list
                /*
                [
                    {
                        "vehicle_type_no": 1,
                        "brand_name": "",
                        "description": "",
                        "created_by": "",
                        "updated_by": "",
                        "parent_no": 1,
                        "parent_brand_name": "",
                        "registered_brand_names": "",
                        "registered_vehicles": 1
                    }
                ]
                */
                ResponseData.Add(ResponseVehicleType);
            end until VehicleTypes.Next = 0;
        end;

        // Response message
        ResponseObject.Add('status', 'SUCCESS');
        ResponseObject.Add('status_description', 'List of Vehicle Types has been retrieved successfully');
        ResponseObject.Add('data', ResponseData);
        // Convert ResponseObject to Response JSON string/text
        ResponseObject.WriteTo(Response);
        // Send Response text as SOAP API response value
        exit(Response);
    end;

    procedure GetVehiclesJSON(): Text
    var
        Vehicles: Record "Vehicle Register";

        ResponseObject: JsonObject;
        ResponseData: JsonArray;
        ResponseVehicle: JsonObject;
        Response: Text;
    begin
        // Retrieve list of Vehicles records
        if Vehicles.FindSet then begin
            repeat begin
                // Clear/Reset the ResponseVehicle JsonObject for each loop/iteration
                Clear(ResponseVehicle);

                // Compute the values of the FlowFields
                Vehicles.CalcFields(
                    "Vehicle Type Name"
                );

                /*
                Define the key-value properties for the ResponseVehicle JsonObject
                */
                ResponseVehicle.Add('vehicle_no', Vehicles."No");
                ResponseVehicle.Add('vehicle_type_no', Vehicles."Vehicle Type No.");
                ResponseVehicle.Add('vehicle_type_name', Vehicles."Vehicle Type Name");
                ResponseVehicle.Add('description', Vehicles.Description);
                ResponseVehicle.Add('registration_no', Vehicles."Registration No.");
                ResponseVehicle.Add('created_by', Vehicles."Created By");
                ResponseVehicle.Add('updated_by', Vehicles."Updated By");

                // Add the ResponseVehicle object to ResponseData array list
                /*
                [
                    {
                        "vehicle_no": 1,
                        "vehicle_type_no": 1,
                        "vehicle_type_name": "",
                        "description": "",
                        "registration_no": "",
                        "created_by": "",
                        "updated_by": ""
                    }
                ]
                */
                ResponseData.Add(ResponseVehicle);
            end until Vehicles.Next = 0;
        end;

        // Response message
        ResponseObject.Add('status', 'SUCCESS');
        ResponseObject.Add('status_description', 'List of Vehicles has been retrieved successfully');
        ResponseObject.Add('data', ResponseData);
        // Convert ResponseObject to Response JSON string/text
        ResponseObject.WriteTo(Response);
        // Send Response text as SOAP API response value
        exit(Response);
    end;

    procedure GetVehicleTypeJSON(
    JSONData: Text
): Text
    var
        RequestParser: JsonObject;
        RequestVehicleTypeNo: JsonToken;

        VehicleTypeNo: Integer;

        ExistingVehicleType: Record "Vehicle Types";
        TempBlob: Codeunit "Temp Blob";
        InStr: InStream;
        Base64Convert: Codeunit "Base64 Convert";

        ResponseObject: JsonObject;
        ResponseVehicleType: JsonObject;
        Response: Text;
    begin
        /*
        {
            "vehicle_type_no": 1
        }
        */
        RequestParser.ReadFrom(JsonData);
        RequestParser.SelectToken('$.vehicle_type_no', RequestVehicleTypeNo);

        VehicleTypeNo := RequestVehicleTypeNo.AsValue().AsInteger();

        // First Check if the vehicle type exists
        ExistingVehicleType.Reset;

        // Filter using the VehicleNo field
        ExistingVehicleType.SetRange("No.", VehicleTypeNo);

        if ExistingVehicleType.FindFirst then begin
            // Vehicle has been found

            // Compute the values of the FlowFields and Blob field
            ExistingVehicleType.CalcFields(
                "Parent Brand Name",
                "Registered Brand Names",
                "Registered Vehicles",
                "Logo/Image"
            );

            /*
            Define the key-value properties for the ResponseVehicleType JsonObject
            */
            ResponseVehicleType.Add('vehicle_type_no', ExistingVehicleType."No.");
            ResponseVehicleType.Add('brand_name', ExistingVehicleType."Brand Name");
            ResponseVehicleType.Add('description', ExistingVehicleType.Description);
            ResponseVehicleType.Add('created_by', ExistingVehicleType."Created By");
            ResponseVehicleType.Add('updated_by', ExistingVehicleType."Updated By");
            ResponseVehicleType.Add('parent_no', ExistingVehicleType."Parent No.");
            ResponseVehicleType.Add('parent_brand_name', ExistingVehicleType."Parent Brand Name");
            ResponseVehicleType.Add('registered_brand_names', ExistingVehicleType."Registered Brand Names");
            ResponseVehicleType.Add('registered_vehicles', ExistingVehicleType."Registered Vehicles");

            /*
            Convert image from Blob to Base64 text/string
            */
            TempBlob.FromRecord(ExistingVehicleType, ExistingVehicleType.FieldNo("Logo/Image"));
            TempBlob.CreateInStream(InStr);
            ResponseVehicleType.Add('logo_image', Base64Convert.ToBase64(InStr));

            // Add the ResponseVehicleType object
            /*
            {
                "vehicle_type_no": 1,
                "brand_name": "",
                "description": "",
                "created_by": "",
                "updated_by": "",
                "parent_no": 1,
                "parent_brand_name": "",
                "registered_brand_names": "",
                "registered_vehicles": 1,
                "logo_image": ""
            }
            */
            // Response message
            ResponseObject.Add('status', 'SUCCESS');
            ResponseObject.Add('status_description', 'Vehicle Type has been retrieved successfully');
            ResponseObject.Add('data', ResponseVehicleType);

        end else begin
            // Error response message
            ResponseObject.Add('status', 'ERROR');
            ResponseObject.Add('status_description', 'Vehicle Type referenced by no. ' + Format(VehicleTypeNo) + ' does NOT exist in the records');
        end;

        // Convert ResponseObject to Response JSON string/text
        ResponseObject.WriteTo(Response);
        // Send Response text as SOAP API response value
        exit(Response);
    end;

    procedure GetVehicleJSON(
    JSONData: Text
): Text
    var
        RequestParser: JsonObject;
        RequestVehicleNo: JsonToken;

        VehicleNo: Integer;

        ExistingVehicle: Record "Vehicle Register";

        ResponseObject: JsonObject;
        ResponseVehicle: JsonObject;
        Response: Text;
    begin
        /*
        {
            "vehicle_no": 1
        }
        */
        RequestParser.ReadFrom(JsonData);
        RequestParser.SelectToken('$.vehicle_no', RequestVehicleNo);

        VehicleNo := RequestVehicleNo.AsValue().AsInteger();

        // First Check if the vehicle type exists
        ExistingVehicle.Reset;

        // Filter using the VehicleNo field
        ExistingVehicle.SetRange("No", VehicleNo);

        if ExistingVehicle.FindFirst then begin
            // Vehicle has been found

            // Compute the values of the FlowFields and Blob field
            ExistingVehicle.CalcFields(
                "Vehicle Type Name"
            );

            /*
            Define the key-value properties for the ResponseVehicle JsonObject
            */
            ResponseVehicle.Add('vehicle_no', ExistingVehicle."No");
            ResponseVehicle.Add('vehicle_type_no', ExistingVehicle."Vehicle Type No.");
            ResponseVehicle.Add('vehicle_type_name', ExistingVehicle."Vehicle Type Name");
            ResponseVehicle.Add('description', ExistingVehicle.Description);
            ResponseVehicle.Add('registration_no', ExistingVehicle."Registration No.");
            ResponseVehicle.Add('created_by', ExistingVehicle."Created By");
            ResponseVehicle.Add('updated_by', ExistingVehicle."Updated By");

            // Add the ResponseVehicle object
            /*
            {
                "vehicle_no": 1,
                "vehicle_type_no": 1,
                "vehicle_type_name": "",
                "description": "",
                "registration_no": "",
                "created_by": "",
                "updated_by": ""
            }
            */
            // Response message
            ResponseObject.Add('status', 'SUCCESS');
            ResponseObject.Add('status_description', 'Vehicle has been retrieved successfully');
            ResponseObject.Add('data', ResponseVehicle);

        end else begin
            // Error response message
            ResponseObject.Add('status', 'ERROR');
            ResponseObject.Add('status_description', 'Vehicle referenced by no. ' + Format(VehicleNo) + ' does NOT exist in the records');
        end;

        // Convert ResponseObject to Response JSON string/text
        ResponseObject.WriteTo(Response);
        // Send Response text as SOAP API response value
        exit(Response);
    end;
}