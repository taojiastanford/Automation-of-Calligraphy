%7th code, to generate 0-1 matrices for each stroke
%Tao Jia 12/09/16
%13th code, to generate 0-1 matrices for maobi stroke (if option==1)

option=1;%option=0: Yingbi; 1: ChuSuiliang
if option==0
    mat=dir('New*');
else
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


%%
for q = 1:length(mat) 
    cur=mat(q);
    if length(cur.name)>16||length(cur.name)<10
        continue;
    end
    %nmS=str2num(cur.name(7:9));
    stS = load(mat(q).name); 
    stStroke=stS.stStroke;
    stStroke.BBODs(stStroke.BBODs>=0)=1;
    stStroke.BBODs(stStroke.BBODs<0)=0;
    dataSum=squeeze(sum(stStroke.BBODs,1));
    dataSum(dataSum>0)=1;
    [lineq,pixq]=size(dataSum);
    dataZeros = [dataSum zeros(lineq,maxPix-pixq);zeros(maxLine-lineq,maxPix)];
    %dataResize=zeros(maxLine,maxPix);
    cellStroke{q}=dataZeros;
    labels(q)=stStroke.name;
end

%creat a new cellStroke (for centralization)
NewcellStroke = cell(1297,1);
for i = 1:size(cellStroke,1)
    current_mat = cellStroke{i};
    [row,col] = find(current_mat);
    row_min = min(row);
    row_max = max(row);
    col_min = min(col);
    col_max = max(col);
%     chop_mat = zeros(row_max-row_min+1 , col_max-col_min+1);
    chop_rows = current_mat(row_min:row_max,:);
    chop_mat = chop_rows(:,col_min:col_max);
    sz = size(chop_mat);
    
    New_mat = padarray(chop_mat,[floor((140-sz(1))/2) floor((140-sz(2))/2)]);
    if size(New_mat,1) ~= 140
        New_mat = [New_mat;zeros(1,size(New_mat,2))];        
    end
    if size(New_mat,2) ~= 140
        New_mat = [New_mat zeros(140,1)];  
    end
     NewcellStroke{i} = New_mat; %save the result
end


NewcellStroke=NewcellStroke(~cellfun('isempty',NewcellStroke));

if option==0
    testSet=NewcellStroke(ceil(length(NewcellStroke)*3/4):length(NewcellStroke));
    trainSet=NewcellStroke(1:ceil(length(NewcellStroke)*3/4)-1);
    testLabel=labels(ceil(length(NewcellStroke)*3/4):length(NewcellStroke));
    trainLabel=labels(1:ceil(length(NewcellStroke)*3/4)-1);
else
    cellChu=NewcellStroke;
    chuLabels=labels;
end
%save('cSt','cellStroke');
%autoenc = trainAutoencoder(cellStroke);


