function lfclose( lfid )
%LFCLOSE Closes a large file opened by lfopen

%close all the file identifiers
for i=2:size(lfid{1},1)
    fclose(lfid{1}(i));
end
%clean up all the temporary files
[status, result] = system(['rm ' lfid{2} '.LFOPEN1*']);
if status
    error(['Temporary file clean up error:' result])
end
end

