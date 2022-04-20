%% main_test_hycom_claw.m
% eeshan bhatt
% 
% test script to access functions for automatic downloading of HYCOM data

%% prep workspace
clear; clc; close all;

%% parameters for test download
request.time = [2015 03 01 01 40 00];
request.lat = 72.3642;
request.lon = -150.4196;

%% string creation
filename = 'data1.csv';
downloadURL = h_outputDownloadString(request);
try 
    websave(filename,downloadURL);
catch 
    warning('not found \n');
end

%% get data
