% =========================================================================
% Image Downsampling, Registration, Normalization, and Saving Script
% Assumes im_1, im_2, im_3, and im_4 are already loaded in the workspace.
% im_1 is the lowest resolution, im_3 is the highest.
% im_4 is treated as a parallel modified version of im_1.
% =========================================================================

% -------------------------------------------------------------------------
% USER SETTINGS
% -------------------------------------------------------------------------
% Hardcode your downsampling factors here (must be <= 1):
down_samp_fact_2 = 0.11101;  % Replace with your known factor for im_2
down_samp_fact_3 = 0.07946;  % Replace with your known factor for im_3

% Image rectifications:
% 1. thorcam
im_2 = flipud(imrotate(thorcam,-90));
% 2. validation
im_3 = imrotate(val, -90);
% global
im_1 = average_rectified_global_image;
% local
im_4 = average_rectified_image;

% Ensure images are floating point for filtering and normalization
im_1 = double(im_1);
im_2 = double(im_2);
im_3 = double(im_3);
im_4 = double(im_4);

% -------------------------------------------------------------------------
% 1. Downsample im_2 and im_3 using the user-defined factors
% -------------------------------------------------------------------------
% Apply the requested filtering and resizing logic
im_2_down = imresize(imgaussfilt(im_2, 1/down_samp_fact_2/2), down_samp_fact_2, "bilinear");
im_3_down = imresize(imgaussfilt(im_3, 1/down_samp_fact_3/2), down_samp_fact_3, "bilinear");

% -------------------------------------------------------------------------
% 2. Find alignment using Translation and Optional Rotation Sweep
% -------------------------------------------------------------------------
% Settings for rotation search
enable_rotation = true;
angle_sweep = -2:0.25:2; % Sweep range and step size

if ~enable_rotation
    angle_sweep = 0;
end

if size(im_1, 3) == 3
    gray_1 = rgb2gray(uint8(im_1));
    gray_2 = rgb2gray(uint8(im_2_down));
    gray_3 = rgb2gray(uint8(im_3_down));
else
    gray_1 = im_1; gray_2 = im_2_down; gray_3 = im_3_down;
end

disp('Sweeping angles for optimal alignment...');
[rot2, t2, im_2_rot] = sweep_alignment(gray_2, gray_1, angle_sweep);
[rot3, t3, im_3_rot] = sweep_alignment(gray_3, gray_1, angle_sweep);

fprintf('im_2 matched at %.2f degrees.\n', rot2);
fprintf('im_3 matched at %.2f degrees.\n', rot3);

% -------------------------------------------------------------------------
% 3. Crop all images to the common overlapping FOV
% -------------------------------------------------------------------------
[h1, w1, ~] = size(im_1);
ref = imref2d([h1, w1]); 

% Create 2D affine matrices for pure translation (rotation is already applied)
tform2_trans = affine2d([1 0 0; 0 1 0; t2(1) t2(2) 1]);
tform3_trans = affine2d([1 0 0; 0 1 0; t3(1) t3(2) 1]);

% Warp the already-rotated images
im_2_aligned = imwarp(im_2_rot, tform2_trans, 'OutputView', ref);
im_3_aligned = imwarp(im_3_rot, tform3_trans, 'OutputView', ref);

% Create logical masks for the valid data areas
mask2 = true(size(im_2_down, 1), size(im_2_down, 2));
mask3 = true(size(im_3_down, 1), size(im_3_down, 2));

% Rotate the masks using nearest neighbor to keep them strictly logical
mask2_rot = imrotate(mask2, rot2, 'nearest', 'crop');
mask3_rot = imrotate(mask3, rot3, 'nearest', 'crop');

% Translate the masks
mask2_aligned = imwarp(mask2_rot, tform2_trans, 'OutputView', ref);
mask3_aligned = imwarp(mask3_rot, tform3_trans, 'OutputView', ref);

% Find intersecting region where both have valid data
common_mask = mask2_aligned & mask3_aligned;
[rows, cols] = find(common_mask);
r_min = min(rows); r_max = max(rows);
c_min = min(cols); c_max = max(cols);

% Crop all images to ONLY the overlapping region
im_1_crop = im_1(r_min:r_max, c_min:c_max, :);
im_2_crop = im_2_aligned(r_min:r_max, c_min:c_max, :);
im_3_crop = im_3_aligned(r_min:r_max, c_min:c_max, :);
im_4_crop = im_4(r_min:r_max, c_min:c_max, :); 

% -------------------------------------------------------------------------
% 4. Normalize and Adjust Intensity Independently
% -------------------------------------------------------------------------
norm_im = @(I) (I - min(I(:))) ./ (max(I(:)) - min(I(:)));

% Find shared min/max across im_1 and im_4 for relative normalization
global_min_14 = min(min(im_1_crop(:)), min(im_4_crop(:)));
global_max_14 = max(max(im_1_crop(:)), max(im_4_crop(:)));
shared_norm = @(I) (I - global_min_14) ./ (global_max_14 - global_min_14);

% Apply normalizations
im_1_norm = shared_norm(im_1_crop);
im_4_norm = shared_norm(im_4_crop);
im_2_norm = norm_im(im_2_crop);
im_3_norm = norm_im(im_3_crop);

% Open interactive GUI for each grayscale image sequentially
disp('Opening intensity adjustment tools...');

% Adjust im_1 and grab the multiplier. Apply the exact same multiplier to im_4.
[im_1_norm, mult_1] = adjust_intensity_gui(im_1_norm, 'im_1 (Shared scale for im_4)');
im_4_norm = min(im_4_norm * mult_1, 1); % Clip at 1 to match GUI behavior
fprintf('Applied im_1 multiplier (%.2f) to im_4 to preserve relative intensity.\n', mult_1);

[im_2_norm, ~] = adjust_intensity_gui(im_2_norm, 'im_2');
[im_3_norm, ~] = adjust_intensity_gui(im_3_norm, 'im_3');

% -------------------------------------------------------------------------
% 5. Save Originals, Processed Images, and Overlays
% -------------------------------------------------------------------------
% Prompt user to select a save folder
save_loc = uigetdir(pwd, 'Select a folder to save the output images');
if save_loc == 0
    error('No folder selected. Script aborted.');
end

% Base normalization function to ensure safe saving formats [0, 1]
norm_for_save = @(I) (I - min(I(:))) ./ (max(I(:)) - min(I(:)));

% Shared normalization for saving the *original* uncropped im_1 and im_4
orig_min_14 = min(min(im_1(:)), min(im_4(:)));
orig_max_14 = max(max(im_1(:)), max(im_4(:)));
shared_save_norm = @(I) (I - orig_min_14) ./ (orig_max_14 - orig_min_14);

% --- 5A. Save Original Images ---
disp('Saving original images...');
originals = {shared_save_norm(im_1), norm_for_save(im_2), norm_for_save(im_3), shared_save_norm(im_4)};
orig_names = {'im_1_original', 'im_2_original', 'im_3_original', 'im_4_original'};

for i = 1:length(originals)
    tiff_path = fullfile(save_loc, sprintf('%s.tiff', orig_names{i}));
    png_path  = fullfile(save_loc, sprintf('%s.png', orig_names{i}));
    imwrite(originals{i}, tiff_path, "Compression", "None");
    imwrite(originals{i}, png_path);
end

% --- 5B. Save Processed Images (4x Blowup) ---
disp('Saving processed images...');
images_to_save = {im_1_norm, im_2_norm, im_3_norm, im_4_norm};
proc_names = {'im_1_processed', 'im_2_processed', 'im_3_processed', 'im_4_processed'};

for i = 1:length(images_to_save)
    im_2save = imresize(images_to_save{i}, 4, "nearest");
    
    tiff_path = fullfile(save_loc, sprintf('%s.tiff', proc_names{i}));
    png_path  = fullfile(save_loc, sprintf('%s.png', proc_names{i}));
    imwrite(im_2save, tiff_path, "Compression", "None");
    imwrite(im_2save, png_path);
end

% --- 5C. Create and Save Overlays (4x Blowup) ---
disp('Generating and saving overlays...');
% Balance function: stretch each image so its peak intensity is exactly 1
balance = @(I) I ./ max(I(:));

b1 = balance(im_1_norm);
b2 = balance(im_2_norm);
b3 = balance(im_3_norm);
Z = zeros(size(b1), 'like', b1); % Blank channel for pairs

% RGB Composite: R=im_1, G=im_2, B=im_3
overlay_all = cat(3, b1, b2, b3);

% Pairs
overlay_12 = cat(3, b1, b2, Z); % Red/Green
overlay_23 = cat(3, Z, b2, b3); % Green/Blue
overlay_13 = cat(3, b1, Z, b3); % Red/Blue

overlays_to_save = {imresize(overlay_all, 4, "nearest"), ...
                    imresize(overlay_12, 4, "nearest"), ...
                    imresize(overlay_23, 4, "nearest"), ...
                    imresize(overlay_13, 4, "nearest")};
                    
overlay_names = {'overlay_all_123', 'overlay_12', 'overlay_23', 'overlay_13'};

for i = 1:length(overlays_to_save)
    tiff_path = fullfile(save_loc, sprintf('%s.tiff', overlay_names{i}));
    png_path  = fullfile(save_loc, sprintf('%s.png', overlay_names{i}));
    imwrite(overlays_to_save{i}, tiff_path, "Compression", "None");
    imwrite(overlays_to_save{i}, png_path);
end

disp('Processing and saving complete!');

% =========================================================================
% Helper Function: Interactive Intensity GUI (Grayscale)
% =========================================================================
function [out_im, final_val] = adjust_intensity_gui(in_im, im_name)
    % Create a UI Figure
    fig = uifigure('Name', ['Adjust Intensity: ', im_name], 'Position', [100 100 600 650]);
    
    % Create axes and display initial image
    ax = uiaxes(fig, 'Position', [50 200 500 400]);
    img_obj = imshow(in_im, 'Parent', ax);
    title(ax, ['Preview: ', im_name], 'Interpreter', 'none');
    
    % Create Intensity Slider (Range 0.1 to 5, default 1)
    uilabel(fig, 'Position', [250 150 150 22], 'Text', 'Intensity Multiplier:');
    sld = uislider(fig, 'Position', [150 130 300 3], 'Limits', [0.1 5], 'Value', 1);
    
    % Create Accept Button
    btn = uibutton(fig, 'Position', [250 50 100 40], 'Text', 'Accept', ...
                   'ButtonPushedFcn', @(btn,event) uiresume(fig));
               
    % Define the slider callback to update the image preview
    sld.ValueChangedFcn = @(sld, event) update_preview(sld.Value);
    
    function update_preview(val)
        % Multiply intensity and clip at 1 to prevent invalid pixel values
        temp_im = min(in_im * val, 1);
        img_obj.CData = temp_im;
    end
    
    % Pause script execution until the user clicks 'Accept' or closes the window
    uiwait(fig);
    
    % Retrieve final image data and close the figure gracefully
    if isvalid(fig)
        final_val = sld.Value; % Capture the final multiplier used
        out_im = img_obj.CData;
        close(fig);
    else
        out_im = in_im; % Fallback if the user closed the window with the 'X'
        final_val = 1;
    end
end

% =========================================================================
% Helper Function: Rotation Sweep + Cross-Correlation
% =========================================================================
function [best_rot, best_t, rotated_im] = sweep_alignment(moving, fixed, angles)
    max_peak = -Inf;
    best_rot = 0;
    best_t = [0, 0];
    rotated_im = moving;
    
    for theta = angles
        % 'crop' keeps the matrix dimensions identical to the original
        temp_im = imrotate(moving, theta, 'bilinear', 'crop');
        c = normxcorr2(temp_im, fixed);
        peak = max(c(:));
        
        if peak > max_peak
            max_peak = peak;
            best_rot = theta;
            [yPeak, xPeak] = find(c == peak, 1);
            best_t = [xPeak - size(temp_im, 2), yPeak - size(temp_im, 1)];
            rotated_im = temp_im;
        end
    end
end