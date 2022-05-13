%% test_bay_of_bengal_mooring.m
% eeshan bhatt
%
% download for comparison against Bay of Bengal Mooring

%% prep workspace
clear; clc; close all;

%% parameters for download
request.lat = 18.5; %N
request.lon = 89; %E

% time = Dec 2014 to Jan 2016
t1 = [2014 12 1 12 00 00];
t2 = [2016 1 31 12 00 00];
tstep = datenum(t2) - datenum(t1); % days

%% parfor loop to download
tic;
for k = 1:tstep;
    request.time = datevec(datenum(t1 + [0 0 k-1 0 0 0])); % add days
    
    %% string creation
    downloadURL = h_outputDownloadString(request);
    clipboard('copy',downloadURL);
    
    %% download
    [output(k),status] = h_downloadProfile(request,downloadURL);
    
    %% print success message
    if status
        fprintf('%d is a success! \n',k);
    else
        warning('%d timestep was not found',k);
    end
    
    %pause(1.5);
end
toc;