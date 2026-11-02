function tests=test_session_v2
tests=functiontests(localfunctions);
end
function testVersionsAndUnknownFilters(t)
root=tempname; mkdir(root); c=onCleanup(@() rmdir(root,'s'));
imwrite(uint8(magic(8)),fullfile(root,'a.png'));
s=captureedit.loadSources(root,struct('thorcam','a.png'));
p=fullfile(root,'session.json'); stacks=struct('thorcam',struct([]));
captureedit.saveSession(p,root,s,stacks,[],captureedit.editHistory('new'),struct('section','Edit'));
r=jsondecode(fileread(p)); verifyEqual(t,r.schemaVersion,3);
[~,~,~,~,view]=captureedit.loadSession(p,root); verifyEqual(t,view.section,'Edit');
r.schemaVersion=1; write(p,r); [~,~,~,~,view]=captureedit.loadSession(p,root); verifyEqual(t,view.section,'Edit');
r.schemaVersion=4; write(p,r); verifyError(t,@()captureedit.loadSession(p,root),'captureedit:SessionVersion');
r.schemaVersion=2; r.stacks.thorcam=struct('id','x','type','future','enabled',false,'params',struct()); write(p,r);
verifyError(t,@()captureedit.loadSession(p,root),'captureedit:InvalidFilter');
end
function write(p,r)
f=fopen(p,'w'); c=onCleanup(@()fclose(f)); fprintf(f,'%s',jsonencode(r));
end

function testPolicyRoundtripAndLegacyHistory(t)
root=tempname; mkdir(root); cleanup=onCleanup(@()rmdir(root,'s'));
imwrite(uint8(magic(8)),fullfile(root,'a.png'));
s=captureedit.loadSources(root,struct('thorcam','a.png')); stacks=struct('thorcam',struct([]));
state=struct('stacks',stacks,'processingPolicy','preserve'); h=captureedit.editHistory('new'); h.undo={jsonencode(state)};
p=fullfile(root,'policy.json'); captureedit.saveSession(p,root,s,stacks,[],h,struct(),'preserve');
[~,~,~,history,~,policy]=captureedit.loadSession(p,root);
verifyEqual(t,policy,'preserve'); snapshot=jsondecode(history.undo{1}); verifyEqual(t,snapshot.processingPolicy,'preserve');
r=jsondecode(fileread(p)); r.schemaVersion=2; write(p,r);
[~,~,~,history,~,policy]=captureedit.loadSession(p,root); snapshot=jsondecode(history.undo{1});
verifyEqual(t,policy,'legacy-clamp'); verifyEqual(t,snapshot.processingPolicy,'legacy-clamp');
end
