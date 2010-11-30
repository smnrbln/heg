% video: baslangic ani
clear all;  close all;  clc;

%%%%%%%%%%%%%%%% D O   N O T   E D I T   M E %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LIB_PATH = sprintf('..%s..%s..%slib%s', filesep,filesep,filesep,filesep);                         %
addpath(LIB_PATH,'-end');                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dbg = true;

dbnm = pathos('_db/orj/');          % bu dizine db resimlerini koy!
dbnm_sel = pathos('_db/sel/');      mkdir(dbnm_sel);

if length(dir(dbnm_sel)) == 2
    DIR = dir(strcat(dbnm, '*.png'));
    [ts, te] = extract_extreme_time(DIR, dbnm, dbg);
    sel_frame(DIR, dbnm, dbnm_sel, ts, te, dbg);
end

sc = 0.25; % %25 scale
T = 50;
dip_initialise('silent');

DIR = dir(strcat(dbnm_sel, '*.png'));
sz  = length(DIR);

for f=1:sz
    imgnm = DIR(f).name;    
    fr = imread(strcat(dbnm_sel, imgnm));
    
    % preprocess    
    fr = preprocess(fr, sc);
    
    % maske
    bw = (rgb2gray(fr) < T);
    a = dip_image(bw);
    a = bopening(a,5,-1,0);    
    maske = boolean(a);

    maske = imresize(maske, 1/sc);
    fr    = imresize(fr, 1/sc);
    
    % extract marker

    % compute alpha
    
    if dbg
        figure(1);  
        subplot(121);   imshow(fr)
        subplot(122);   imshow(maske)
        drawnow;
    end
end