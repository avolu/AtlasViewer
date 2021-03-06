%
% data_diff.m
%
% Usage:
%    status = data_diff(data1,data2)
%
% Description:
%    Compares two structures and reports on their difference.
% 
% Input: 
%    data1 first structure 
%    data2 second structure
%
% Output: 
%    0 if data1 and data2 are identical
%    1 if the fields are the same but the values aren't
%    2 if the fields aren't the same.
%
% Authors: 
%    Michael Arant - original author of comp_struct.m which this function
%                    uses to compare structures.
%    Jay Dubb      - author of this function and contributor to comp_struct.m
%
function status = data_diff(data1,data2)

status = 0;
if isempty(data1) && ~isempty(data2)
    status = 1;
    return;
end
if ~isempty(data1) && isempty(data2)
    status = 1;
    return;
end

[foo1, foo2, err] = comp_struct(data1,data2);
for ii=1:length(err)
    if strcmp(err{ii},'Un-matched')
        status=2;
    else
        status=3;
    end    
end
