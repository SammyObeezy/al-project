codeunit 50101 "Calculator Service"
{
    procedure Addition(Number1: Integer; Number2: Integer): Integer
    begin
        // return the sum of Number1 & Number2
        exit(Number1 + Number2);
    end;

    procedure Substraction(Number1: Integer; Number2: Integer): Integer
    begin
        // Subtract Number2 from Number1
        exit(Number1 - Number2);
    end;

    procedure Multiplication(Number1: Integer; Number2: Integer): Integer
    begin
        // Multiply Number1 and Number2
        exit(Number1 * Number2);
    end;

    procedure Division(Number1: Integer; Number2: Integer): Integer
    begin
        // Divide Number by Number2
        exit(Number1 / Number2);
    end;
}
