program ipcalc2;

{$mode objfpc}{$H+}

uses
  SysUtils;

function ParseIPv4(const S: string): QWord;
var
  I, Octet, Count: Integer;
  Value: QWord;
  Ch: Char;
begin
  Value := 0;
  Octet := 0;
  Count := 0;

  for I := 1 to Length(S) + 1 do
  begin
    if I <= Length(S) then
      Ch := S[I]
    else
      Ch := '.';

    if Ch = '.' then
    begin
      if (Octet < 0) or (Octet > 255) or (Count >= 4) then
        raise Exception.Create('invalid IPv4 address');
      Value := (Value shl 8) or QWord(Octet);
      Inc(Count);
      Octet := 0;
    end
    else if (Ch >= '0') and (Ch <= '9') then
      Octet := Octet * 10 + (Ord(Ch) - Ord('0'))
    else
      raise Exception.Create('invalid IPv4 address');
  end;

  if Count <> 4 then
    raise Exception.Create('invalid IPv4 address');

  Result := Value;
end;

function IPv4ToString(V: QWord): string;
begin
  Result := Format('%d.%d.%d.%d', [
    (V shr 24) and 255,
    (V shr 16) and 255,
    (V shr 8) and 255,
    V and 255
  ]);
end;

var
  IP, Mask, NetworkAddr, BroadcastAddr, FirstAddr, LastAddr, Hosts: QWord;
  Prefix: Integer;
begin
  if ParamCount <> 2 then
  begin
    WriteLn(StdErr, 'usage: ', ParamStr(0), ' IP PREFIX');
    Halt(2);
  end;

  try
    IP := ParseIPv4(ParamStr(1));
    Prefix := StrToInt(ParamStr(2));
  except
    on E: Exception do
    begin
      WriteLn(StdErr, E.Message);
      Halt(2);
    end;
  end;

  if (Prefix < 1) or (Prefix > 30) then
  begin
    WriteLn(StdErr, 'prefix must be between 1 and 30');
    Halt(2);
  end;

  { Parsing is finished. Fill in only these calculations. }
  Mask := 0;          { TODO }
  NetworkAddr := 0;   { TODO }
  BroadcastAddr := 0; { TODO }
  FirstAddr := 0;     { TODO }
  LastAddr := 0;      { TODO }
  Hosts := 0;         { TODO }

  WriteLn('IP: ', IPv4ToString(IP));
  WriteLn('Netmask: ', IPv4ToString(Mask));
  WriteLn('Network: ', IPv4ToString(NetworkAddr));
  WriteLn('Broadcast: ', IPv4ToString(BroadcastAddr));
  WriteLn('First usable: ', IPv4ToString(FirstAddr));
  WriteLn('Last usable: ', IPv4ToString(LastAddr));
  WriteLn('Usable hosts: ', Hosts);
end.
