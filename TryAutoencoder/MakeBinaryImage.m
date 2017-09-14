%7th code, to generate 0-1 matrices for each stroke
mat = dir('*.mat'); 
cellStroke=cell(length(mat),1);
labels=zeros(length(mat),1);
maxLine=0;
maxPix=0;
for q = 1:length(mat) 
    cur=mat(q);
    if length(cur.name)>16||length(cur.name)<10
        continue;
    end
    stS = load(mat(q).name); 
    [~,lineq,pixq]=size(stS.stStroke.BBODs);
    if lineq>maxLine
        maxLine=lineq;
    end
    if pixq>maxPix
        maxPix=pixq;
    end
end

for q = 1:length(mat) 
    if q==533
        q;
    end
    cur=mat(q);
    if length(cur.name)>16||length(cur.name)<10
        continue;
    end
    %nmS=str2num(cur.name(7:9));
    stS = load(mat(q).name); 
    stStroke=stS.stStroke;
    dataSum=squeeze(sum(stStroke.BBODs,1));
    dataSum(dataSum>=0)=1;
    dataSum(dataSum<0)=0;
    [lineq,pixq]=size(dataSum);
    dataZeros = [dataSum zeros(lineq,maxPix-pixq);zeros(maxLine-lineq,maxPix)];
    %dataResize=zeros(maxLine,maxPix);
    cellStroke{q}=dataZeros;
    labels(q)=stStroke.name;
end
cellStroke=cellStroke(~cellfun('isempty',cellStroke));
testSet=cellStroke(ceil(length(cellStroke)*3/4):length(cellStroke));
trainSet=cellStroke(1:ceil(length(cellStroke)*3/4)-1);
testLabel=labels(ceil(length(cellStroke)*3/4):length(cellStroke));
trainLabel=labels(1:ceil(length(cellStroke)*3/4)-1);
%save('cSt','cellStroke');

%autoenc = trainAutoencoder(cellStroke);