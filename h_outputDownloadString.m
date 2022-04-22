function [downloadStr] = h_outputDownloadString(request)
%h_outputDownloadString ingests single request variable to create NCSS
%THREDDS url identifier
% GOFS 3.1 41-layer HYCOM + NCODA Global 1/12 degree reanalysis/analysis
% https://tds.hycom.org/thredds/catalog.html
%
% INPUT
% request is a structure
% request.time as [year month day hour minute second]
% request.lon as decimal degrees
% request.lat as decimal degrees

% OUTPUT
% downloadStr for websave
% see sample.txt for sample wget command

%% make beginning of URL match HYCOM database
% if there's overlap of dates, preference goes towards the newer model run

if request.time(1) <= 1993
    error('HYCOM database begins at 1994')
elseif datenum(request.time) > now;
    warning('You are trying to read the future!');
end

% from 1/1/1994 to 12/30/2015, GLBv0.08/expt_53.X reanalysis
modelChange(1) = datenum([1994 1 1 0 0 0]);

% from 12/31/2015 to 4/30/2016, GLBv0.08/expt_56.3 analysis
modelChange(2) = datenum([2015 12 31 0 0 0]);

% from 5/1/2016 to 1/31/2017, GLBv0.08/expt_57.2 analysis
modelChange(3) = datenum([2016 5 1 0 0 0]);

% from 2/1/2017 to 5/31/2017, GLBv0.08/expt_92.8 analysis
modelChange(4) = datenum([2017 2 1 0 0 0]);

% from 6/1/2017 to 9/30/2017, GLBv0.08/expt_57.7 analysis
modelChange(5) = datenum([2017 6 1 0 0 0]);

% from 10/1/2017 to 12/31/2017, GLBv0.08/expt_92.9 analysis
modelChange(6) = datenum([2017 10 1 0 0 0]);

% from 1/1/2018 to 12/3/2018, GLBv0.08/expt_93.0 analysis
modelChange(7) = datenum([2018 1 1 0 0 0]);

% from 12/4/2018 onward, GLBy0.08/expt_93.0 analysis
modelChange(8) = datenum([2018 12 4 0 0 0]);

modelDirectory = find(datenum(request.time) >= modelChange,1,'last');

switch modelDirectory
    case 1
        urlBegin = sprintf('https://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_53.X/data/%d?var=salinity&var=water_temp',request.time(1));
    case 2
        urlBegin = sprintf('https://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_56.3?var=salinity&var=water_temp');
    case 3
        urlBegin = sprintf('https://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_57.2?var=salinity&var=water_temp');
    case 4
        urlBegin = sprintf('https://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_92.8?var=salinity&var=water_temp');
    case 5
        urlBegin = sprintf('https://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_57.7?var=salinity&var=water_temp');
    case 6
        urlBegin = sprintf('https://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_92.9?var=salinity&var=water_temp');
    case 7
        urlBegin = sprintf('https://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_93.0?var=salinity&var=water_temp');
    case 8
        urlBegin = sprintf('https://ncss.hycom.org/thredds/ncss/GLBy0.08/expt_93.0?var=salinity&var=water_temp');
end

%% make rest of URL
urlPlace = sprintf('&latitude=%.4f&longitude=%.4f',request.lat,request.lon);
urlTime = sprintf('&time=%d-%02d-%02dT%02d%%3A%02d%%3A%02dZ',request.time(:));
urlEnd = '&vertCoord=&accept=csv';

%% concatenate URL
downloadStr = [urlBegin urlPlace urlTime urlEnd];
end