figure;
hold on
folder='C:\Users\Tao\Google Drive\Course\CS\CS229\ChineseCalligraphy\Characters\Yingbi';
noFile='New163078_3';
stStroke=load([folder,'/',noFile,'.mat']);
dataSS=stStroke.stStroke.BBODs;
for ii=1:size(dataSS,1)
    imagesc(squeeze(dataSS(ii,:,:)));
    testDataSS=dataSS;
    testDataSS(testDataSS==0)=180;
    testDataSS(testDataSS<0)=0;
    [nl,np,na]=find(squeeze(testDataSS(ii,:,:)));
        minna=min(na);
        maxna=max(na);
        meanna=mean(na);
    if minna<30&&maxna>150
            na(na>150)=na(na>150)-180;
    end
end