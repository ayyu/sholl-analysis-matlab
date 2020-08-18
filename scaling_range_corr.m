clear
RES=[];
[filename, pathname]=uigetfile('*.txt', 'pick tractography file ');
FILE = [pathname filename];


%M contains the log of distance from the seed in column 1 and the subjects tractography
%results in the remaining columns.  The tractography results are the
%log(cumulative_number) at that voxel.  
M =load(FILE);
%D1 = M(:,1);
%P1 = M(:,4);

for i =2
    
%%%%%%%%  increasing points from max(size(M)) to 0

% this loop below aims to find the starting point of the fit (which part of
% the data will be included as the starting point of the fit
for n = 1:max(size(M))
   
    
    D = M(n:max(size(M)),1);%%% D = log10(distance)
    P = M(n:max(size(M)),i);
    %r = corrcoef(D,P);
    [B,BINT,R] = regress(P,D);%fitting P,D

 R2 =R.^2;
 
 %sum of the squared residuals
  RES(n,i-1) = sum(R2)/(max(size(M))-(n-1));
  
  
    
    
end

MIN = 1+(find(RES(:,i-1) ==max(RES(:,i-1))));
LL(i-1,1) =MIN;% minium is the the minimum point from which we should start fitting 



%%%%%%%%  decreasing points from max(size(M)) to 0

% this loop aims to identify the maximum data point included in the fit.
for n = 1:max(size(M))-4
   
    
    Dd = M(1:max(size(M))-(n-1),1);
    Pd = M(1:max(size(M))-(n-1),i);
    %r = corrcoef(D,P);
    [Bd,BINTd,Rd] = regress(Pd,Dd);

 Rd2 =Rd.^2;
  RESd(n,i-1) = sum(Rd2)/(max(size(M))-(n-1));
  
    
    
end


MAX =max(size(M))-(find(RESd(:,i-1) ==min(RESd(:,i-1)),1,'first'));
LL(i-1,2) =MAX; % maximum point included in the fit




%this line of code finds the slope of the fit including the data between
%MIN and MAX
% LL column 1 contains the index of the starting point (row number) and
% column the index of the maximum point of the fit and the 3rd column
% contains the slope
  LL(i-1,3)= stepwisefit(M(MIN:MAX,1),M(MIN:MAX,i));


end



