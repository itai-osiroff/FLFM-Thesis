% =========================================================================
% Interactive Downsampling Factor Calculator
% Assumes im_1 (reference/lower res) and im_2 (higher res) are in workspace
% =========================================================================

disp('===============================================================');
disp('Point Selection Instructions:');
disp('1. Click a feature in the LEFT image (im_1).');
disp('2. Click the matching feature in the RIGHT image (im_2).');
disp('3. Repeat for at least 2 pairs (more is better).');
disp('4. Press the ENTER key to finish and calculate.');
disp('===============================================================');

% Image rectifications:
% 1. thorcam
% im_2 = thorcam;
% im_2 = flipud(imrotate(im_2,-90));
% 2. validation
im_2 = val;
im_2 = imrotate(im_2, -90);

% Prepare robust display copies to prevent white-out
fixed_disp  = imadjust(mat2gray(im_1));
moving_disp = imadjust(mat2gray(im_2));

% Create the selection figure
fig = figure('Name', 'Interactive Point Selection', 'NumberTitle', 'off', ...
             'Position', [100, 100, 1200, 500]);

% Display im_1 on the left
ax1 = subplot(1, 2, 1);
imshow(fixed_disp); 
title('im\_1 (Reference) - Click Here FIRST');
hold on;

% Display im_2 on the right
ax2 = subplot(1, 2, 2);
imshow(moving_disp); 
title('im\_2 (Moving) - Click Here SECOND');
hold on;

points_1 = [];
points_2 = [];

% Loop to collect points infinitely until the user presses Enter
while true
    % 1. Get point from left image (im_1)
    title(ax1, 'im\_1 (Reference) - CLICK HERE NOW', 'Color', 'r', 'FontWeight', 'bold');
    title(ax2, 'im\_2 (Moving) - Please wait...', 'Color', 'k', 'FontWeight', 'normal');
    
    [x1, y1, button1] = ginput(1);
    
    % If user presses Enter (empty button), break the loop
    if isempty(button1) 
        break; 
    end
    
    % Plot a red cross where the user clicked
    plot(ax1, x1, y1, 'r+', 'MarkerSize', 12, 'LineWidth', 2);
    
    % 2. Get point from right image (im_2)
    title(ax1, 'im\_1 (Reference) - Please wait...', 'Color', 'k', 'FontWeight', 'normal');
    title(ax2, 'im\_2 (Moving) - CLICK MATCHING POINT NOW', 'Color', 'r', 'FontWeight', 'bold');
    
    [x2, y2, button2] = ginput(1);
    
    % If user presses Enter here, break the loop
    if isempty(button2) 
        break; 
    end
    
    % Plot a red cross where the user clicked
    plot(ax2, x2, y2, 'r+', 'MarkerSize', 12, 'LineWidth', 2);
    
    % Store the valid pair
    points_1 = [points_1; x1, y1];
    points_2 = [points_2; x2, y2];
end

% Close the selection figure safely
if isvalid(fig)
    close(fig);
end

% Ensure the user selected at least 2 points (needed to calculate a distance)
if size(points_1, 1) < 2
    error('At least 2 matching point pairs are required to calculate a scale factor.');
end

% -------------------------------------------------------------------------
% 4. Calculate best uniform downsampling factor
% -------------------------------------------------------------------------
% We calculate the Euclidean distance between all pairs of selected points 
% in im_1, and the distances between the corresponding points in im_2.
% The scale factor is the ratio of these distances.
d_1 = pdist(points_1); 
d_2 = pdist(points_2);

% We use the median of all the distance ratios. This makes the calculation 
% highly robust to slight misclicks or human error on any single point pair.
down_samp_fact = median(d_1 ./ d_2);

% -------------------------------------------------------------------------
% 5. Output to terminal and display results
% -------------------------------------------------------------------------
fprintf('\n---> Calculated Downsampling Factor for im_2: %.5f\n\n', down_samp_fact);

% Apply the downsampling using the calculated factor and anti-aliasing filter
im_2_down = double(im_2);
im_2_down = imresize(imgaussfilt(im_2_down, 1/down_samp_fact/2), down_samp_fact, "bilinear");

% Display the side-by-side comparison
figure('Name', 'Downsampling Results', 'NumberTitle', 'off', 'Position', [100, 100, 1000, 500]);

% Show im_1
subplot(1, 2, 1);
imshow(fixed_disp); % Using the contrast-adjusted version for clear display
title('im\_1 (Reference Resolution)');

% Show downsampled im_2
subplot(1, 2, 2);
imshow(imadjust(mat2gray(im_2_down))); % Apply contrast adjustment to the downsampled result too
title(sprintf('im_2 Downsampled\n(Calculated Factor: %.4f)', down_samp_fact));