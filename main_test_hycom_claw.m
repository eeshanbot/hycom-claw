%% main_test_hycom_claw.m
% eeshan bhatt
% 
% test script to access functions for automatic downloading of HYCOM data

%% prep workspace
clear; clc; close all;

%% parameters for test download
request.time = [2014 03 23 11 20 00];
request.lat = 72.3642;
request.lon = -150.4196;

%% string creation
filename = ['data-' datestr(request.time,30) '.csv'];
downloadURL = h_outputDownloadString(request);
clipboard('copy',downloadURL);

try 
    websave(filename,downloadURL);
    
    % check if empty
    s = dir(filename);
    if s.bytes == 0
        warning('empty file: check URL!')
        delete(filename);
    end
    
    % check if time matches
    T = readtable(filename,'Range','A2:A2');
    hycomTimeStr = T.Var1{1};
    str = split(hycomTimeStr,'T');
    str_ymd = split(str{1},'-');
    str_hhmmss = split(str{2}(1:end-1),':');
    hycomTime = [cellfun(@str2num,str_ymd); cellfun(@str2num,str_hhmmss)].';
    timeDiff = 24.*abs(datenum(request.time - hycomTime));
    
    if timeDiff >= 1.5
        warning('nearest neighbor time was missing! time difference = %1.2f hours',timeDiff);
    end
catch 
    warning('not found \n');
end

%% get data