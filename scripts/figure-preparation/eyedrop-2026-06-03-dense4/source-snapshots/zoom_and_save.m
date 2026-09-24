function interactive_zoom_and_save(im_1, im_2, im_3, im_4)
    % INTERACTIVE_ZOOM_AND_SAVE Allows dynamic zooming and saving of 4 images
    
    % Validate inputs
    if nargin < 4
        error('Please provide exactly 4 images as input.');
    end

    % 1. Create the main figure for drawing the Region of Interest (ROI)
    fig_main = figure('Name', 'Select Zoom Area', 'Position', [50, 200, 600, 500], 'NumberTitle', 'off');
    ax_main = axes('Parent', fig_main);
    
    % Display first image for drawing the ROI
    imshow(im_1, [], 'Parent', ax_main); 
    title(ax_main, 'Drag and resize the rectangle. Click "Finalize Zoom" when done.');

    % Add a finalize button to the main figure
    uicontrol('Parent', fig_main, 'Style', 'pushbutton', ...
              'String', 'Finalize Zoom', ...
              'Position', [20, 20, 150, 40], ...
              'FontSize', 12, ...
              'Callback', @finalizeCallback);

    % 2. Create the preview figure (using a 2x2 grid for 4 images)
    fig_prev = figure('Name', 'Dynamic Preview', 'Position', [700, 200, 800, 800], 'NumberTitle', 'off');
    ax1 = subplot(2, 2, 1, 'Parent', fig_prev);
    ax2 = subplot(2, 2, 2, 'Parent', fig_prev);
    ax3 = subplot(2, 2, 3, 'Parent', fig_prev);
    ax4 = subplot(2, 2, 4, 'Parent', fig_prev);
    
    % Bring main figure to focus
    figure(fig_main);
    
    % Initialize the drawing rectangle in the center of the image
    [img_h, img_w, ~] = size(im_1);
    init_pos = [img_w/4, img_h/4, img_w/2, img_h/2];
    roi = drawrectangle(ax_main, 'Position', init_pos, 'Color', 'r');

    % Initial preview update
    updatePreview(roi, []);

    % 3. Add listeners to update the preview dynamically as the box moves/resizes
    addlistener(roi, 'MovingROI', @updatePreview);
    addlistener(roi, 'ROIMoved',  @updatePreview);

    % 4. Pause execution until the user clicks "Finalize" or closes the window
    uiwait(fig_main);

    % 5. Execute saving logic after uiwait resumes
    if ~isgraphics(fig_main)
        % User closed the figure instead of clicking finalize
        disp('Zoom operation cancelled by user.');
        if isgraphics(fig_prev), close(fig_prev); end
        return;
    end

    % Get the final coordinates and close UI windows
    final_pos = roi.Position;
    close(fig_main);
    if isgraphics(fig_prev), close(fig_prev); end

    % 6. Ask user for a save directory
    save_dir = uigetdir('', 'Select folder to save zoomed images');
    if save_dir == 0
        disp('Save cancelled.');
        return;
    end

    % Crop the 4 images
    zoom_1 = imcrop(im_1, final_pos);
    zoom_2 = imcrop(im_2, final_pos);
    zoom_3 = imcrop(im_3, final_pos);
    zoom_4 = imcrop(im_4, final_pos);

    % Safely scale if they are double/single floating-point formats
    if isa(zoom_1, 'double') || isa(zoom_1, 'single')
        zoom_1 = uint8(255 * mat2gray(zoom_1));
        zoom_2 = uint8(255 * mat2gray(zoom_2));
        zoom_3 = uint8(255 * mat2gray(zoom_3));
        zoom_4 = uint8(255 * mat2gray(zoom_4));
    end

    % Save them to the chosen directory
    imwrite(zoom_1, fullfile(save_dir, 'zoomed_im_1.png'));
    imwrite(zoom_2, fullfile(save_dir, 'zoomed_im_2.png'));
    imwrite(zoom_3, fullfile(save_dir, 'zoomed_im_3.png'));
    imwrite(zoom_4, fullfile(save_dir, 'zoomed_im_4.png'));

    fprintf('Successfully saved 4 zoomed images to:\n%s\n', save_dir);

    
    % --- Nested Callback Functions ---
    
    function updatePreview(src, ~)
        % Updates the secondary window dynamically
        pos = src.Position;
        
        % Ensure the box has a valid width/height to prevent errors
        if pos(3) > 1 && pos(4) > 1
            % Crop images based on current rectangle position
            c1 = imcrop(im_1, pos);
            c2 = imcrop(im_2, pos);
            c3 = imcrop(im_3, pos);
            c4 = imcrop(im_4, pos);
            
            % Update preview axes with auto-scaling
            imshow(c1, [], 'Parent', ax1); title(ax1, 'Preview: Image 1');
            imshow(c2, [], 'Parent', ax2); title(ax2, 'Preview: Image 2');
            imshow(c3, [], 'Parent', ax3); title(ax3, 'Preview: Image 3');
            imshow(c4, [], 'Parent', ax4); title(ax4, 'Preview: Image 4');
        end
    end

    function finalizeCallback(~, ~)
        % Resumes the code execution blocked by uiwait
        uiresume(fig_main);
    end
end

im_1 = im_1_processed;
im_2 = im_2_processed;
im_3 = im_3_processed;
im_4 = im_4_processed;

interactive_zoom_and_save(im_1, im_2, im_3, im_4)