tic

%Does not work well. Tao Jia 11/17/16

%Get number of valid points
epsilon_bbod=0.01;
index=find(bbod>epsilon_bbod); 
[indx1,indx2,indx3]=ind2sub(size(bbod),index);
numpix=length(indx1);
angleFactor=25;

strokes=16;%Number of maximum potential strokes
%mu=rand(k,3)*[nline npix nbin*2];
imSize=size(bbod);
mu=zeros(strokes,3);
for kk=1:strokes
    indexmu=round(rand()*numpix);
    mu(kk,:)=[indx1(indexmu),indx2(indexmu),indx3(indexmu)];
%     plot(indx2(indexmu),indx1(indexmu),'--gs',...
%     'LineWidth',1,...
%     'MarkerSize',10);
end


change=ones(strokes,3);

distance=zeros(imSize(1), imSize(2), imSize(3), strokes);
label=zeros(imSize(1), imSize(2), imSize(3));

distance_real=zeros(numpix,strokes);
label_real=zeros(numpix,1);

min_it=30;
it=0;
epsilon=1;

%main iteration
while norm(max(change))>epsilon && it<min_it%Should have enough iteration and convergence
    it=it+1;
    
    %distance between each center to each pixel
    for kk=1:strokes
        distance_real(:,kk)=sum((repmat(mu(kk,:),numpix,1)-[indx1,indx2,indx3*angleFactor]).^2,2);
    end
    
    %assign pixels to closest centers
    [~,label]=min(distance_real,[],2);
    
    %find new centers
    %mu=zeros(strokes,3);
    for kk=1:strokes
        pixofk=find(label==kk);
        linek=indx1(pixofk);
        pixk=indx2(pixofk);
        bink=indx3(pixofk);
        npixk=length(linek);
        for nn=1:npixk
            mu(kk,:)=mu(kk,:)+[linek(nn), pixk(nn), bink(nn)];
        end
        mu(kk,:)=mu(kk,:)/npixk;
    end
end

new_strokes=zeros(size(bbod));
figure;
% 
% folder = uigetdir(pwd, 'Select a folder');


for kk=1:strokes
    %Some "bad" clusters have no pixel
    badCenter=0;
    for cc=1:3
        if mu(kk,cc)<0 || mu(kk,cc)>imSize(cc) || isnan(mu(kk,cc))
            badCenter=1;
        end
    end
    
    %Create pictures including individual clusters, and combine them
    %into new graph
    if badCenter==0
        pixofk=find(label==kk);
        linek=indx1(pixofk);
        pixk=indx2(pixofk);
        bink=indx3(pixofk);
        npixk=length(linek);
        
        new_strokek=zeros(imSize(1),imSize(2));
        for nn=1:npixk
            new_strokek(linek(nn),pixk(nn))=mu(kk,3);
        end
        
        imagesc(new_strokek);
        title(['Center', num2str(kk)]); 
        hold on
        %new_strokes=new_strokes+new_strokek;
%         figurekname=[folder,'ComLarge',num2str(kk),'.tiff'];
%         imwrite(uint8(round(new_bbod)),figurekname);
    end
end
% figure;
% newOrientation=max(new_strokes,[],3)/(imSize(3))*180;
% imagesc(newOrientation);
%imshow(uint8(round(new_bbod)));
toc