% ---------------------------
% Linear interpolation for all 10 countries processing script
% ---------------------------
emissions = CO2flat;

% --- Ensure Year is numeric ---
if ~isnumeric(emissions.Year)
    if isdatetime(emissions.Year)
        emissions.Year = year(emissions.Year);
    else
        emissions.Year = double(string(emissions.Year)); % handles string/cellstr
    end
end

% --- Normalize country column to string and trim whitespace ---
if ~isstring(emissions.Country)
    emissions.Country = string(emissions.Country);
end
emissions.Country = strtrim(emissions.Country);

% --- Ordered list of countries to process ---
country_list = {'Brazil', 'Canada', 'China', 'France', 'India', ...
                'Italy', 'Japan', 'Mexico', 'United Kingdom', 'USA'};

% --- Columns to interpolate ---
cols = {'Coal','Oil','Gas','Cement','Flaring'};

% --- Diagnostics: show unique countries (quick check) ---
fprintf('Unique countries available in dataset (sample):\n');
disp(unique(emissions.Country));

% --- Initialize results table ---
all_results = table();

fprintf('Starting country loop...\n');
for i = 1:numel(country_list)
    country = country_list{i};
    % Try exact, case-insensitive match first
    idx = strcmpi(emissions.Country, string(country));
    % If nothing found, try partial case-insensitive contains
    if ~any(idx)
        idx = contains(lower(emissions.Country), lower(country));
    end

    nBefore = sum(idx);
    if nBefore == 0
        fprintf('  --> No rows found for "%s" in the dataset. Skipping.\n', country);
        continue;
    end

    country_data = emissions(idx, :);
    % Keep only years >= 1950
    country_data = country_data(country_data.Year >= 1950, :);
    nAfter = height(country_data);
    fprintf('  Processed "%s": %d rows found, %d rows from 1950 onward.\n', country, nBefore, nAfter);

    if nAfter == 0
        fprintf('     --> After filtering for Year>=1950 there are no rows. Skipping "%s".\n', country);
        continue;
    end

    % Replace zeros with NaN in numeric columns
    data_clean = country_data;
    numCols = varfun(@isnumeric, data_clean, 'OutputFormat', 'uniform');
    for c = find(numCols)
        colData = data_clean{:, c};
        colData(colData == 0) = NaN;
        data_clean{:, c} = colData;
    end

    % Linear interpolation on requested cols (if present & numeric)
    interp_data = data_clean;
    for j = 1:numel(cols)
        col = cols{j};
        if ismember(col, interp_data.Properties.VariableNames) && isnumeric(interp_data.(col))
            interp_data.(col) = fillmissing(interp_data.(col), 'linear', 'EndValues', 'none');
        else
            fprintf('     Note: column "%s" missing or not numeric for "%s" — skipping interpolation for that column.\n', col, country);
        end
    end

    % Recompute Total using whichever of the cols exist
    existingCols = intersect(cols, interp_data.Properties.VariableNames);
    if ~isempty(existingCols)
        interp_data.Total = sum(interp_data{:, existingCols}, 2, 'omitnan');
    else
        fprintf('     Warning: no emission columns found for "%s". Total set to NaN.\n', country);
        interp_data.Total = NaN(height(interp_data),1);
    end

    % Ensure a consistent Country column (string)
    interp_data.Country = repmat({country}, height(interp_data), 1);

    % Append
    all_results = [all_results; interp_data];

    % Optional: plot only if Total exists and is numeric
    if ismember('Total', country_data.Properties.VariableNames) && isnumeric(country_data.Total)
        figure;
        hold on;
        plot(country_data.Year, country_data.Total, 'k-', 'LineWidth', 2, 'DisplayName', 'Original');
        plot(interp_data.Year, interp_data.Total, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Linear');
        hold off;
        xlabel('Year'); ylabel('Total Emissions');
        title([country ' Emissions (1950–present): Original vs Linear Interpolated']);
        legend('Location','best'); grid on;
    else
        fprintf('     Skipping plot for "%s": original Total missing or non-numeric.\n', country);
    end
end

% --- Safe display of results ---
if isempty(all_results) || height(all_results) == 0
    disp('*** all_results is empty. No country had data from 1950 onward (or country names did not match).');
    disp('Check the "Unique countries" output above and ensure your country_list matches the strings in CO2flat.Country.');
else
    nShow = min(10, height(all_results));
    fprintf('Showing first %d rows of combined results:\n', nShow);
    disp(all_results(1:nShow, :));
    % optional save
    writetable(all_results, 'Interpolated_Emissions_AllCountries_1950on.csv');
end

fprintf('Done.\n');