function [data] = h_unpack_hycom_csv(filename)
%h_unpack_hycom_csv

T = readtable(filename,'ReadVariableNames',false);

% unpack HYCOM time as a string
hycomTimeStr = T.Var1{1};
str = split(hycomTimeStr,'T');
str_ymd = split(str{1},'-');
str_hhmmss = split(str{2}(1:end-1),':');
hycomTime = [cellfun(@str2num,str_ymd); cellfun(@str2num,str_hhmmss)].';

% process data
scale = 0.001;
offset = 20;

T.Var5(T.Var5==-30000) = NaN;
T.Var5 = T.Var5 .* scale + offset;

T.Var6(T.Var6==-30000) = NaN;
T.Var6 = T.Var6 .* scale + offset;

% format into output structure
data.time = hycomTime;
data.lat = T.Var2(1);
data.lon = T.Var3(1);

data.depth = T.Var4;
data.sal = T.Var5;
data.temp = T.Var6;
data.ssp = snd_spd(data.depth,data.temp,data.sal);

end

