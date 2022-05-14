%% plot_bay_of_bengal_WHOI_mooring
% eeshan bhatt

%% prep workspace
clear; clc; close all;

%% load data path
path = 'bay-of-bengal-mooring';
listing = dir([path '/*.csv']);

%% load data

for l = 1:numel(listing)
    filename = [listing(l).folder '/' listing(l).name];
    data = h_unpack_hycom_csv(filename);
    
    ind200 = find(data.depth >=  200,1,'first');
    
    plot_time(l) = datenum(data.time);
    plot_ssp{l} = data.ssp(1:ind200);
    plot_sal{l} = data.sal(1:ind200);
    plot_temp{l} = data.temp(1:ind200);
    plot_depth{l} = data.depth(1:ind200);
    
    dbar = gsw_p_from_z(-plot_depth{l},data.lat);
    plot_rho{l} = gsw_rho_t_exact(plot_sal{l},plot_temp{l},dbar);
    ctemp = gsw_CT_from_t(plot_sal{l},plot_temp{l},dbar);
    plot_mld(l) = gsw_mlp(plot_sal{l},ctemp,dbar);
end

%% establish plot
figure('name','whoi-mooring','renderer','painters','position',[0 0 1600 1000]); clf;
tiledlayout(2,15,'TileSpacing','compact','padding','normal');
nColorLevels = 13;

%% plot temp
nexttile(1,[1 7]);
transect(plot_time,plot_depth,plot_temp,'marker','none');

cmocean('thermal',nColorLevels);
cb = colorbar;

datetick('x','mmm');
xlim([min(plot_time) max(plot_time)])
ylim([0 200]);
set(gca,'fontsize',11);

ylabel(cb,'temperature [degC]');

ylabel('depth [m]');

title('WHOI Mooring, 18.5 N, 89 E, Dec 2014 to Jan 2016');


%% plot sal
nexttile(9,[1 7]);
transect(plot_time,plot_depth,plot_sal,'marker','none');

cmocean('-haline',nColorLevels);
cb = colorbar;

datetick('x','mmm');
xlim([min(plot_time) max(plot_time)])
ylim([0 200]);
set(gca,'fontsize',11)
ylabel(cb,'salinity [psu]');

yticklabels([]);

%% plot sal
nexttile(16,[1 7]);
transect(plot_time,plot_depth,plot_ssp,'marker','none');

cmocean('-deep',nColorLevels);
cb = colorbar;

datetick('x','mmm');
xlim([min(plot_time) max(plot_time)])
ylim([0 200]);
set(gca,'fontsize',11)
ylabel(cb,'ssp [m/s]');
ylabel('depth [m]');

%% mixed layer depth
nexttile(24,[1 7]);
transect(plot_time,plot_depth,plot_rho,'marker','none');

hold on
plot(plot_time,plot_mld,'w','linewidth',3);
hold off

cmocean('dense',nColorLevels);
cb = colorbar;
ylabel(cb,'density [kg/m^3], mld @ 0.3 g/kg');


datetick('x','mmm');
xlim([min(plot_time) max(plot_time)])
ylim([0 200]);
set(gca,'fontsize',11)
yticklabels([]);

%% export
export_fig('whoiMooring_BayOfBengal_dec2014_jan2016.png','-r300','-p0.02','-painters');