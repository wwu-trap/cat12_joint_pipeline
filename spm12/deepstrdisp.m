function deepstrdisp(S, strStartsWith)
    if nargin == 1
        strStartsWith = '';
    end
    if isstruct(S)
        field_names = fieldnames(S);
        for i = 1:numel(field_names)
            deepstrdisp(S.(field_names{i}), strStartsWith);
        end
    elseif iscell(S)
        for i = 1:numel(S)
            deepstrdisp(S{i}, strStartsWith);
        end
    elseif ischar(S) && startsWith(S, strStartsWith)
        disp(S)
    end
end
