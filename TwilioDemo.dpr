program TwilioDemo;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.Classes,
  System.SysUtils,
  System.JSON,
  System.Net.HttpClient,
  TwilioClient in 'TwilioClient.pas';

var
  client: TTwilioClient;
  allParams: TStringList;
  response: TTwilioClientResponse;
  json: TJSONValue;
  fromPhoneNumber: string;
  toPhoneNumber: string;

begin
  try
    // Create environment variables (named below) with your Twilio credentials
    client := TTwilioClient.Create(
      GetEnvironmentVariable('TWILIO_ACCOUNT_SID'),
      GetEnvironmentVariable('TWILIO_AUTH_TOKEN'));

    // Your Twilio phone number
    fromPhoneNumber := '+15017122661';

    // Your destination number (for trials, this needs to be your mobile #)
    toPhoneNumber := '+15558675310';

    // Make a phone call
    Writeln('----- Phone Call -----');
    
    allParams := TStringList.Create;
    allParams.Add('From=' + fromPhoneNumber);
    allParams.Add('To=' + toPhoneNumber);
    allParams.Add('Url=http://demo.twilio.com/docs/voice.xml');

    // POST to the Calls resource
    response := client.Post('Calls', allParams);

    if response.Success then
      Writeln('Call SID: ' + response.ResponseData.GetValue<string>('sid'))
    else if response.ResponseData <> nil then
      Writeln(response.ResponseData.ToString)
    else
      Writeln('HTTP status: ' + response.HTTPResponse.StatusCode.ToString);

    // Send a text message
    Writeln('----- SMS -----');

    allParams := TStringList.Create;
    allParams.Add('From=' + fromPhoneNumber);
    allParams.Add('To=' + toPhoneNumber);
    allParams.Add('Body=Never gonna give you up, Delphi');

    // POST to the Messages resource
    response := client.Post('Messages', allParams);
    if response.Success then
      Writeln('Message SID: ' + response.ResponseData.GetValue<string>('sid'))
    else if response.ResponseData <> nil then
      Writeln(response.ResponseData.ToString)
    else
      Writeln('HTTP status: ' + response.HTTPResponse.StatusCode.ToString);
  finally
    client.Free;
  end;

  Writeln('Press ENTER to exit.');
  Readln;
end.
