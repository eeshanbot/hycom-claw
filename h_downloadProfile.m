function [output,fileFound] = h_downloadProfile(request,downloadURL)
% h_downloadProfile downloads and sorts requested HYCOM file


% create filename, delete local copy if it already exists
filename = ['data-' datestr(request.time,30) '.csv'];
if isfile(filename)
    delete(filename);
end

% try to download file
fileFound = false;
try
    websave(filename,downloadURL);
    fileFound = true;
catch
    %warning('websave did not capture a file');
end

if fileFound
    
    % check if file is empty
    s = dir(filename);
    if s.bytes == 0
        warning('empty file: check URL!')
        delete(filename);
    end
    
    % read data into table
    % discard variable names b/c HYCOM adds too many special characters
    % Var 1 = time
    % Var 2 = latitude[unit="degrees_north"]
    % Var 3 = longitude[unit="degrees_east"]
    % Var 4 = vertCoord[unit="m"]
    % Var 5 = salinity[unit="psu"]
    % Var 6 = water_temp[unit="degC"]
    T = readtable(filename,'ReadVariableNames',false);
    
    % check if time matches
    hycomTimeStr = T.Var1{1};
    str = split(hycomTimeStr,'T');
    str_ymd = split(str{1},'-');
    str_hhmmss = split(str{2}(1:end-1),':');
    hycomTime = [cellfun(@str2num,str_ymd); cellfun(@str2num,str_hhmmss)].';
    timeDiff = 24.*abs(datenum(request.time - hycomTime));
    
    % output warning for non-nearest time neighbor i.e. missing HYCOM file
    if timeDiff >= 1.5
        warning('nearest neighbor time was missing! time difference = %1.2f hours',timeDiff);
    end
    
    % process data
    scale = 0.001;
    offset = 20;
    
    T.Var5(T.Var5==-30000) = NaN;
    T.Var5 = T.Var5 .* scale + offset;
    
    T.Var6(T.Var6==-30000) = NaN;
    T.Var6 = T.Var6 .* scale + offset;
    
    % format into output structure
    output.time = hycomTime;
    output.requestTime = request.time;
    
    output.lat = T.Var2(1);
    output.lon = T.Var3(1);
    
    output.depth = T.Var4;
    output.sal = T.Var5;
    output.temp = T.Var6;
    output.ssp = snd_spd(output.depth,output.temp,output.sal);
else
    output.time = NaN;
    output.requestTime = request.time;
    output.lat = request.lat;
    output.lon = request.lon;
    
    output.depth = NaN;
    output.sal = NaN;
    output.temp = NaN;
    output.ssp = NaN;
end
end

