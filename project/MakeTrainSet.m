%Tao Jia 12/08/16, 6th code, separate and name strokes

%clear all; close all; clc;
%folder='C:\Users\Tao\Google Drive\Course\CS\CS229\ChineseCalligraphy\Characters\ChuSuiliang';
folder='C:\Users\Tao\Google Drive\Course\CS\CS229\ChineseCalligraphy\Characters\Yingbi';
%folder = uigetdir(pwd, 'Select a folder');
%rangeYB=177218:177400;
%rangeYB=163330:163330;%gua
%rangeYB=205962:205970;%Chu
rangeYB=164126:164126;
%rangeYB=163038:163338;
%trSet=struct
noTotStroke=0;
noBadStroke=0;
noOtherStroke=0;
for totii=1:length(rangeYB)
    wordNow=rangeYB(totii);
    close all;
    CH=imread([folder,'\Yingbi_',num2str(rangeYB(totii)),'.gif']);
    %CH=imread([folder,'\Yingbi_',num2str(rangeYB(totii)),'.gif']);
    CH=double(CH);
    nline=size(CH,1);npix=size(CH,2);
    indx=find(CH<0.5);indx0=find(CH>0.5);
    CH(indx)=1;CH(indx0)=0;
%     figure
%     imagesc(CH)
%     colorbar
    
    PBOD_v2
    BBOD_v2
    StrokeSepa2
    StrokeBin_v2
    StrokeStore_v2
    
    noTotStroke
    noBadStroke
    noOtherStroke
end