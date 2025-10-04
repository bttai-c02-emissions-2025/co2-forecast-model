emissions = CO2flat;

% Extract only US’s rows
US_data = emissions(57317:57540, :);

% Remove the first 50 rows once (starting at year 1800)
US_data(1:50, :) = [];

% Display data before cleaning
disp("data before replacing 0 with NaN: ")
disp(US_data)

% Make a copy to do the cleaning in 
US_clean = US_data;

% Find numeric columns
numCols = varfun(@isnumeric, US_clean, 'OutputFormat', 'uniform');

% Loop through numeric columns and replace 0 with NaN
for c = find(numCols)
    colData = US_clean{:,c};
    colData(colData == 0) = NaN;
    US_clean{:,c} = colData;
end

% Display data after cleaning
disp("data after replacing 0 with NaN")
disp(US_clean)

%STEP 2: INTERPOLATION
% Columns of interest
cols = {'Coal','Oil','Gas','Cement','Flaring'};

% Copy tables for each interpolation method
US_linear = US_clean;
US_spline = US_clean;
US_pchip  = US_clean;

% Loop over each column
for i = 1:numel(cols)
    col = cols{i};
    
    % Extract column as array
    y = US_clean.(col);
    
    % Only interpolate missing values (NaNs)
    if isnumeric(y)
        % Linear interpolation of NaNs only
        US_linear.(col) = fillmissing(y, 'linear', 'EndValues', 'none');
        
        % Spline interpolation of NaNs only
        US_spline.(col) = fillmissing(y, 'spline', 'EndValues', 'none');
        
        % Shape-preserving cubic interpolation of NaNs only
        US_pchip.(col)  = fillmissing(y, 'pchip', 'EndValues', 'none');
    end
end

% --- Example: Display results for first 10 rows ---

disp('Linear interpolation (NaNs filled only):')
disp(US_linear(1:10, [cols, {'Total'}]))

disp('Spline interpolation (NaNs filled only):')
disp(US_spline(1:10, [cols, {'Total'}]))

disp('PCHIP interpolation (NaNs filled only):')
disp(US_pchip(1:10, [cols, {'Total'}]))


%Creating New Totals
% Columns that make up the total
cols = {'Coal','Oil','Gas','Cement','Flaring'};

% Recompute Total for each interpolated dataset
US_linear.Total = sum(US_linear{:,cols}, 2, 'omitnan');
US_spline.Total = sum(US_spline{:,cols}, 2, 'omitnan');
US_pchip.Total  = sum(US_pchip{:,cols}, 2, 'omitnan');

% Extract the year column (adjust name if your table calls it something else)
years = US_data.Year;

% Original total
orig_total = US_data.Total;

% Recomputed totals after interpolation
linear_total  = US_linear.Total;
spline_total  = US_spline.Total;
pchip_total   = US_pchip.Total;

% --- Plot ---
figure;
hold on;

plot(years, orig_total, 'k-', 'LineWidth', 2, 'DisplayName', 'Original');
plot(years, linear_total, 'r--', 'LineWidth', 1.5, 'DisplayName', 'Linear');
plot(years, spline_total, 'b-.', 'LineWidth', 1.5, 'DisplayName', 'Spline');
plot(years, pchip_total, 'g:', 'LineWidth', 1.5, 'DisplayName', 'PCHIP');

hold off;

xlabel('Year');
ylabel('Total Emissions');
title('France Emissions: Original vs Interpolated Totals');
legend('Location','best');
grid on;

% Extract the year column (adjust name if your table calls it something else)
years = US_data.Year;

% Original total
orig_total = US_data.Total;

% Recomputed totals after interpolation
linear_total  = US_linear.Total;
spline_total  = US_spline.Total;
pchip_total   = US_pchip.Total;

% Extract the year column (adjust if your table calls it something else)
years = US_data.Year;

% Original total
orig_total = US_data.Total;

% Recomputed totals after interpolation
linear_total  = US_linear.Total;
spline_total  = US_spline.Total;
pchip_total   = US_pchip.Total;

% --- Plot all with solid lines and different colors ---
figure;
hold on;

plot(years, orig_total, 'k-', 'LineWidth', 2, 'DisplayName', 'Original');
plot(years, linear_total, 'r-', 'LineWidth', 1.5, 'DisplayName', 'Linear');
plot(years, spline_total, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Spline');
plot(years, pchip_total, 'g-', 'LineWidth', 1.5, 'DisplayName', 'PCHIP');

hold off;

xlabel('Year');
ylabel('Total Emissions');
title('US Emissions: Original vs Interpolated Totals');
legend('Location','best');
grid on;

% Extract the year column (adjust if needed)
years = US_data.Year;

% Original total
orig_total = US_data.Total;

% Recomputed totals
linear_total  = US_linear.Total;
spline_total  = US_spline.Total;
pchip_total   = US_pchip.Total;

% --- Plot separately using solid lines, different colors ---
figure;

% Original
subplot(4,1,1);
plot(years, orig_total, 'k-', 'LineWidth', 2);
xlabel('Year'); ylabel('Total');
title('Original Total');
grid on;

% Linear
subplot(4,1,2);
plot(years, linear_total, 'r-', 'LineWidth', 1.5);
xlabel('Year'); ylabel('Total');
title('Linear Interpolation Total');
grid on;

% Spline
subplot(4,1,3);
plot(years, spline_total, 'b-', 'LineWidth', 1.5);
xlabel('Year'); ylabel('Total');
title('Spline Interpolation Total');
grid on;

% PCHIP
subplot(4,1,4);
plot(years, pchip_total, 'g-', 'LineWidth', 1.5);
xlabel('Year'); ylabel('Total');
title('PCHIP Interpolation Total');
grid on;

% Add a shared title
sgtitle('US Emissions Totals: Original and Interpolation Methods');