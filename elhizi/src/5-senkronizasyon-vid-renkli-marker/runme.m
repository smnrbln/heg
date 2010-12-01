% video: baslangic ani - renkli marker
clear all;  close all;  clc;

%%%%%%%%%%%%%%%% D O   N O T   E D I T   M E %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LIB_PATH = sprintf('..%s..%s..%slib%s', filesep,filesep,filesep,filesep);                         %
addpath(LIB_PATH,'-end');                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sc = 0.25;
T = 50;

dbg = true;

dbnm = pathos('_db/orj/');              % bu dizine db resimlerini koy!
dbnm_bw = pathos('_db/bw/');            mkdir(dbnm_bw);
dbnm_marker = pathos('_db/marker/');    mkdir(dbnm_marker);

if length(dir(dbnm_bw)) == 2
    fr2bw(dbnm, dbnm_bw, sc, T, dbg);
end

if length(dir(dbnm_marker)) == 2
    bw2marker(dbnm, dbnm_bw, dbnm_marker, dbg);
end

DIR = dir(strcat(dbnm, '*.png'));
DIR_marker = dir(strcat(dbnm_marker, '*.png'));
sz  = length(DIR);

for f=1:sz
    if dbg,
        fprintf('%04d/%04d. frame isleniyor...\n', f,sz);
    end
    
    imgnm = DIR(f).name;    
    fr = imadjustRGB(imread(strcat(dbnm, imgnm)));
    bw_m = imread(strcat(dbnm_marker, imgnm));    
    
    hand = marker_assign(fr, bw_m, dbg);
    alpha(f) = compute_alpha(hand);
    
    if ~dbg
        figure(1);  
        subplot(121);   imshow(fr)
        subplot(122);   imshow(1 - bw_m)
        hold on;
        plot(hand.index(1), hand.index(2), '*g')
        plot(hand.palm(1),  hand.palm(2),  '*r')
        plot(hand.thumb(1), hand.thumb(2), '*y')
        hold off;        
        drawnow;
    end    
end

if dbg
    figure(2)
    plot(alpha);
end