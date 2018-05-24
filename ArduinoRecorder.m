function ArduinoRecorder(s,event)
global arduino

avail = s.BytesAvailable;
if avail >= 14
    %         tmp = igetfield(s,  'fread');
    tmp = [];
    for i=1:min([14*5 floor(avail/14)])
        tmpAnal = fread(s,2*6);
        tmpDigi = fread(s,2);
        tmp = [tmp; [typecast(uint8(tmpAnal), 'uint16'); typecast(uint8(tmpDigi), 'uint16')]'];
    end
    arduino.data = [data; tmp];
end


end