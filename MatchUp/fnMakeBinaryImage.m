function [ data2d,data2dOrigin,labelS ] = fnMakeBinaryImage( stSS )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    maxPix=140;
    maxLine=140;


    stStroke=stSS.stStroke;
    stStroke.BBODs(stStroke.BBODs>=0)=1;
    stStroke.BBODs(stStroke.BBODs<0)=0;
    dataSum=squeeze(sum(stStroke.BBODs,1));
    dataSum(dataSum>0)=1;
    [line,pix]=size(dataSum);
    dataZeros = [dataSum zeros(line,maxPix-pix);zeros(maxLine-line,maxPix)];
    labelS=stStroke.name;
    data2dOrigin=dataZeros;

%creat a new cellStroke (for centralization)
    [row,col] = find(dataZeros);
    row_min = min(row);
    row_max = max(row);
    col_min = min(col);
    col_max = max(col);
    chop_rows = dataZeros(row_min:row_max,:);
    chop_mat = chop_rows(:,col_min:col_max);
    sz = size(chop_mat);
    
    data2d = padarray(chop_mat,[floor((140-sz(1))/2) floor((140-sz(2))/2)]);
    if size(data2d,1) ~= 140
        data2d = [data2d;zeros(1,size(data2d,2))];
    end
    if size(data2d,2) ~= 140
        data2d = [data2d zeros(140,1)];  
    end
    



end

