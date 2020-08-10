function S = deepreplace(S, old_value, new_value)
    if endsWith(old_value, '/')
        old_value = old_value(1:end-1);
    end
    if endsWith(new_value, '/')
        new_value = new_value(1:end-1);
    end
    S = deepreplace_rec(S, old_value, new_value); 
end

function S = deepreplace_rec(S, old_value, new_value)
    
    if isstruct(S)
        field_names = fieldnames(S);
        for i = 1:numel(field_names)
            S.(field_names{i}) = deepreplace_rec(S.(field_names{i}), old_value, new_value);
        end
    elseif iscell(S)
        for i = 1:numel(S)
            S{i} = deepreplace_rec(S{i}, old_value, new_value);
        end
    elseif ischar(S) && startsWith(S, old_value)
        S = replace(S, old_value, new_value);
    end
end