%% main_test_hycom_claw.m
% eeshan bhatt
% 
% test script to access functions for automatic downloading of HYCOM data

%% prep workspace
clear; clc; close all;

%% parameters for test download
request.time = [2020 03 08 12 00 00];
request.lat = 72.3642;
request.lon = -150.4196;

%% string creation
downloadURL = h_outputDownloadString(request);
% clipboard('copy',downloadURL);

%% download
output = h_downloadProfile(request,downloadURL);

%% plot

figure('name','hycom-plot','renderer','painters','position',[4900 4900 1000 700]); clf;
t = tiledlayout(1,3,'TileSpacing','compact');

% temperature
nexttile();
plot(output.temp,output.depth,'linewidth',3);
set(gca,'ydir','reverse');
grid on
ylabel('depth [m]');
xlabel('temp [degC]');

% salinity
nexttile();
plot(output.sal,output.depth,'linewidth',3);
set(gca,'ydir','reverse');
xlim([29 36]);
grid on
xlabel('sal [psu]');

% sound speed
nexttile();
plot(output.ssp,output.depth,'linewidth',3);
set(gca,'ydir','reverse');
grid on
xlabel('ssp [m/s]');

titstr = sprintf('%0.4f N, %0.4f E, %s',output.lat,output.lon,datestr(output.time));
sgtitle({'HYCOM profile',titstr},'fontsize',16)