function T_out = clean_zeros(T)
% Clean subgroup columns by turning 0 → NaN after first nonzero.
% Recomputes Total from first year when any subgroup exists.

    T_out = T;
    vars = ["Coal","Oil","Gas","Cement","Flaring","Other"];

    % Ensure all subgroup columns exist
    for v = vars
        if ~ismember(v, T_out.Properties.VariableNames)
            T_out.(v) = nan(height(T_out),1);
        end
    end

    % --- Clean each subgroup (0→NaN after first nonzero) ---
    for v = vars
        col = T_out.(v);
        if ~isnumeric(col), continue; end

        firstNonZero = find(~isnan(col) & col ~= 0, 1, 'first');
        if ~isempty(firstNonZero)
            zeroAfter = (col == 0);
            zeroAfter(1:firstNonZero) = false;
            col(zeroAfter) = NaN;
        end
        T_out.(v) = col;
    end

    % --- Recompute Total ---
    data    = T_out{:, vars};
    hasData = any(~isnan(data), 2);
    sums    = sum(data, 2, 'omitnan');
    sums(~hasData) = NaN;

    newTotal = nan(height(T_out),1);
    if any(hasData)
        firstAny = find(hasData, 1, 'first');
        newTotal(firstAny:end) = sums(firstAny:end);
    end
    T_out.Total = newTotal;
end