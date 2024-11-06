function [C,backup,after] = contour_get3(BW)
% CONTOUR_FOLLOWING takes a binary array and returns the sorted row and
% column coordinates of contour pixels.
%
% C = CONTOUR_FOLLOWING(BW) takes BW as an input. BW is a binary array
% containing the image of an object ('1': foreground, '0': background). It
% returns a circular list (N x 2, C(1,:)=C(end,:)) of the 
% (row,column)-coordinates of the object's contour, in the order of 
% appearence (This function was inspired from the freeman contour coding 
% algorithm).
%
% Note: 
% - if the object is less than 3 pixels, CONTOUR_FOLLOWING sends back [0 0].
% - the algorithm is quite robust: the object can have holes, and can also
% be only one pixel thick in some parts (in this case, some coordinates
% pair will appear two times: they are counted "way and back").


[m,n]=size(BW);                                                            % getting the image height and width
BW1=BW;

backup=zeros(m,n);

Itemp=zeros(m+2,n+2);                                                      % we create a '0' frame around the image to avoid border problems
Itemp(2:(m+1),2:(n+1))=BW;
BW=Itemp;
% figure
% imshow(BW)
% 
% BW = BW - imerode(BW,[0 1 0 ; 1 1 1 ; 0 1 0]);                             % gets the contour by substracting the erosion to the image
% BW = bwmorph(BW,'thin',Inf);                                               % to be sure to have strictly 8-connected contour


if (sum(sum(BW))<3),                                                       % we consider that less than 3 pixels cannot make a contour
    C=[0 0];
    after=BW;
    return; 
end;

%[col,row]=find(BW',1);                                                      % takes the first encountered '1' pixel as the starting point of the contour
[row,col]=find(BW,1); 

MAJ=[6 6 0 0 2 2 4 4];                                                     % variable initialization
%backup(row-1,col-1)=1;
C=[row,col ; 0 0];
k=0;
ended=0;
direction=4;

while(ended==0),
    k=k+1;
    found_next=0;  
    w=1;
    while(found_next==0),
        switch mod(direction,8),
            case 7,
                if (BW(row, col+1)==1),
                    row=row;
                    col=col+1;
                    C(k,:)=[row col];
                    BW(row, col)=0;
                     BW1(row, col)=0;
                    backup(row-1,col-1)=1;
                    found_next=1;
                end;
            case 6;
                if (BW(row+1, col+1)==1),
                    row=row+1;
                    col=col+1;
                    C(k,:)=[row col];
                    BW(row, col)=0;
                    BW1(row, col)=0;
                    backup(row-1,col-1)=1;
                    found_next=1;
                end;
            case 5;
                if (BW(row+1, col)==1),
                    row=row+1;
                    col=col;
                    C(k,:)=[row col];

                    BW(row, col)=0;
                    BW1(row, col)=0;
                    backup(row-1,col-1)=1;
                    found_next=1;
                end;
            case 4;
                if (BW(row+1, col-1)==1),
                    row=row+1;
                    col=col-1;
                    C(k,:)=[row col];

                    BW(row, col)=0;
                    BW1(row, col)=0;
                    backup(row-1,col-1)=1;
                    found_next=1;
                end;
            case 3;
                if (BW(row, col-1)==1),
                    row=row;
                    col=col-1;
                    C(k,:)=[row col];
                    BW(row, col)=0;
                    BW1(row, col)=0;
                    backup(row-1,col-1)=1;
                    found_next=1;
                end;
            case 2;
                if (BW(row-1, col-1)==1),
                    row=row-1;
                    col=col-1;
                    C(k,:)=[row col];
                    BW(row, col)=0;
                    BW1(row, col)=0;
                    backup(row-1,col-1)=1;
                    found_next=1;
                end;
            case 1;
                if (BW(row-1, col)==1),
                    row=row-1;
                    col=col;
                    C(k,:)=[row col];
                    BW(row, col)=0;
                    BW1(row, col)=0;
                    backup(row-1,col-1)=1;
                    found_next=1;
                end;
            case 0;
                if (BW(row-1, col+1)==1),
                    row=row-1;
                    col=col+1;
                    C(k,:)=[row col];
                    BW(row, col)=0;
                    BW1(row, col)=0;
                    backup(row-1,col-1)=1;
                    found_next=1;
                end;
                
        end

        if (found_next==0&&w<8)
            direction=direction+1; 
            w=w+1;
        end

        if (found_next==0&&w==8)
            found_next=1;
            ended=1;
        end
        
    end
    
%     if(w==8&&found_next==1)%and((length(C)>3),(([C(1,:) C(2,:)]==[C((end-1),:) C(end,:)])))),
%         ended=1; 
%     end
    
    direction = MAJ((mod(direction,8)+1));

end
%C=C(1:(end-1),:);                                                          % the first and last points in the list are the same (circular list)
C=C-1;                                                                      % to go back to the original coordinates (without the '0' frame)
after=BW(2:(m+1),2:(n+1));
if(length(C)<20)
    %BW=linedelete(BW,backup);
    BW=bwmorph(BW,'thin');
    BW=bwmorph(BW,'clean');
    [C,backup,after]=contour_get3(BW(2:(m+1),2:(n+1)));
end
% figure
% plot3(C(:,1),C(:,2),1:length(C))