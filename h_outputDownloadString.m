function [downloadStr] = h_outputDownloadString(request)
%h_outputDownloadString ingests single request variable to create NCSS
%THREDDS url identifier
%
% INPUT
% request is a structure
% request.time as [year month day hour minute second]
% request.lon as decimal degrees
% request.lat as decimal degrees

% OUTPUT
% downloadStr for system command

% sample working wget command
% wget 
% 'http://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_53.X/data/2015?var=salinity&var=water_temp&latitude=72&longitude=-150&time=2015-12-01T09%3A00%3A00Z&vertCoord=&accept=netcdf4'
%-O data.nc4

%% make URL

urlBegin = 'https://ncss.hycom.org/thredds/ncss/GLBv0.08/expt_53.X/data/2015?var=salinity&var=water_temp';
urlPlace = sprintf('&latitude=%d&longitude=%d',request.lat,request.lon);
urlTime = sprintf('&time=%d-%02d-%02dT%02d%%3A%02d%%3A%02dZ',request.time(:));
urlEnd = '&vertCoord=&accept=csv';

%% concatenate URL
downloadStr = [urlBegin urlPlace urlTime urlEnd];
end

