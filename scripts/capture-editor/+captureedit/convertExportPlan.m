function plan=convertExportPlan(plan,outputMode)
%CONVERTEXPORTPLAN Change output representation without evaluating filters again.
if ~ismember(outputMode,{'native','floating-mat'}), error('captureedit:InvalidExport','Unknown export output mode.'); end
plan.options.outputMode=outputMode; plan.hasClipping=false; plan.hasFloatOverflow=false;
for k=1:numel(plan.images)
 item=plan.images(k); x=double(item.raw); source=item.source;
 stats=struct('lowCount',0,'highCount',0,'roundingCount',0,'precisionCount',0,'nonfiniteCount',0,'denominator',numel(x));
 if strcmp(outputMode,'floating-mat')
  item.output=x; item.format='mat';
  switch item.role
   case 'global', item.variable='average_rectified_global_image';
   case 'local', item.variable='average_rectified_image';
   otherwise, item.variable='image';
  end
 else
  item.format=source.format; item.variable=source.variable;
  if isinteger(source.image)
   lo=double(intmin(class(source.image))); hi=double(intmax(class(source.image)));
   stats.lowCount=nnz(x<lo); stats.highCount=nnz(x>hi);
   bounded=min(max(x,lo),hi); stats.roundingCount=nnz(bounded~=round(bounded));
   item.output=cast(round(bounded),'like',source.image);
  else
   item.output=cast(item.raw,'like',source.image);
   stats.nonfiniteCount=nnz(~isfinite(item.output));
   stats.precisionCount=nnz(isfinite(item.output)&double(item.output)~=x);
  end
 end
 item.conversion=stats;
 ds=struct('lowCount',0,'highCount',0,'roundingCount',0,'denominator',numel(x));
 if plan.options.displayTiff && strcmp(item.format,'mat')
  % Display loss concerns values actually rendered after native conversion.
  v=(double(item.output)-source.displayRange(1))/diff(source.displayRange);
  ds.lowCount=nnz(v<0); ds.highCount=nnz(v>1);
  bounded=min(max(v,0),1)*65535; ds.roundingCount=nnz(bounded~=round(bounded));
 end
 item.displayConversion=ds; plan.images(k)=item;
 plan.hasClipping=plan.hasClipping || stats.lowCount>0 || stats.highCount>0 || ds.lowCount>0 || ds.highCount>0;
 plan.hasFloatOverflow=plan.hasFloatOverflow || stats.nonfiniteCount>0;
end
end
