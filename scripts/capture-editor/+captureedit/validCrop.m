function [crop,preserved] = validCrop(mask,preferred)
%VALIDCROP Preserve a valid crop, else find the maximum all-valid rectangle.
% O(rows*columns) histogram stack; equal areas prefer top, then left.
if nargin<2, preferred=[]; end
mask=logical(mask); preserved=captureedit.isValidCrop(mask,preferred);
if preserved, crop=preferred; return; end
if ~any(mask(:)), error('captureedit:NoOverlap','No shared pixels. Adjust alignment or preparation, then try again.'); end
width=size(mask,2); heights=zeros(1,width+1); stack=zeros(1,width+1);
bestArea=0; bestRow=Inf; bestColumn=Inf; bestHeight=0; bestWidth=0;
for row=1:size(mask,1)
 heights(1:width)=(heights(1:width)+1).*mask(row,:); top=0;
 for column=1:width+1
  while top>0 && heights(stack(top))>heights(column)
   h=heights(stack(top)); top=top-1;
   left=1; if top>0, left=stack(top)+1; end
   w=column-left; area=h*w; firstRow=row-h+1;
   if area>bestArea || (area==bestArea && (firstRow<bestRow || (firstRow==bestRow && left<bestColumn)))
    bestArea=area; bestRow=firstRow; bestColumn=left; bestHeight=h; bestWidth=w;
   end
  end
  top=top+1; stack(top)=column;
 end
end
crop=struct('rowStartOneBased',bestRow,'columnStartOneBased',bestColumn,'height',bestHeight,'width',bestWidth);
end
