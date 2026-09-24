thorcam_rect = flipud(imrotate(thorcam,-90));
thorcam_rect_down = imresize(imgaussfilt(thorcam_rect, 1/0.1135/2), 0.1135,"bilinear");
figure;imshow(double(average_rectified_global_image)/max(double(average_rectified_global_image), [], "all"));title("global average");colorbar;impixelinfo
%figure;imshow(average_rectified_global_image, [min(average_rectified_global_image,[],"all"), max(average_rectified_global_image,[],"all")]);title("global average");colorbar;impixelinfo
figure;imshow(double(average_rectified_image)/max(double(average_rectified_image), [], "all"));title("local average");colorbar;impixelinfo
%figure;imshow(average_rectified_image, [min(average_rectified_image,[],"all"), max(average_rectified_image,[],"all")]);title("local average");colorbar;impixelinfo
figure;imshow(double(thorcam_rect)/max(double(thorcam_rect),[],"all"));title("thorcam original resolution");colorbar;impixelinfo;
%figure;imshow(thorcam_rect, [min(thorcam_rect, [], "all"), max(thorcam_rect,[],"all")]);title("thorcam original resolution");colorbar;impixelinfo;
figure;imshow(double(thorcam_rect_down)/max(double(thorcam_rect_down), [],"all"));title("thorcam downsampled");colorbar;impixelinfo;
%figure;imshow(thorcam_rect_down, [min(thorcam_rect_down, [], "all"), max(thorcam_rect_down,[],"all")]);title("thorcam downsampled");colorbar;impixelinfo;
center_view = squeeze(global_rectified_views(4, 4, :,:));
side_2_2_view = squeeze(global_rectified_views(2, 2, :,:));
down_4_6_view = squeeze(global_rectified_views(4, 6, :,:));
figure;imshow(double(center_view)/max(double(center_view),[],"all"));title("center_view");colorbar;impixelinfo;
%figure;imshow(center_view, [min(center_view, [], "all"), max(center_view,[],"all")]);title("center_view");colorbar;impixelinfo;
figure;imshow(double(side_2_2_view)/max(double(side_2_2_view),[],"all"));title("view 2-2");colorbar;impixelinfo;
%figure;imshow(side_2_2_view, [min(side_2_2_view, [], "all"), max(side_2_2_view,[],"all")]);title("view 2-2");colorbar;impixelinfo;
figure;imshow(double(down_4_6_view)/max(double(down_4_6_view),[],"all"));title("view 4-6");colorbar;impixelinfo;
%figure;imshow(down_4_6_view, [min(down_4_6_view, [], "all"), max(down_4_6_view,[],"all")]);title("view 4-6");colorbar;impixelinfo;

%thorcam - saturation
thorcam_sat_factor = 0.5;
thorcam_rect_2save = double(thorcam_rect)/max(double(thorcam_rect),[],"all");
thorcam_rect_2save = min(thorcam_rect_2save, thorcam_sat_factor);
thorcam_rect_2save = double(thorcam_rect_2save)/max(double(thorcam_rect_2save),[],"all");
%thorcam downsampled - saturation
thorcam_sat_factor = 1;
thorcam_rect_down_2save = double(thorcam_rect_down)/max(double(thorcam_rect_down),[],"all");
thorcam_rect_down_2save = min(thorcam_rect_down_2save, thorcam_sat_factor);
thorcam_rect_down_2save = double(thorcam_rect_down_2save)/max(double(thorcam_rect_down_2save),[],"all");

%global average + local average - saturation
sat_factor = 1;

global_img = double(average_rectified_global_image);
local_img  = double(average_rectified_image);

shared_max = max([global_img(:); local_img(:)]);

if shared_max > 0
    global_2save = global_img / shared_max;
    local_2save  = local_img  / shared_max;
else
    global_2save = zeros(size(global_img));
    local_2save  = zeros(size(local_img));
end

% Apply identical clipping
global_2save = max(0, min(global_2save, sat_factor));
local_2save  = max(0, min(local_2save, sat_factor));

%views - saturation
center_2save = double(center_view)/max(double(center_view),[],"all");
sat_factor = 1;
center_2save = min(center_2save, sat_factor);
center_2save = double(center_2save)/max(double(center_2save),[],"all");

side_view_2save = double(side_2_2_view)/max(double(side_2_2_view),[],"all");
sat_factor = 1;
side_view_2save = min(side_view_2save, sat_factor);
side_view_2save = double(side_view_2save)/max(double(side_view_2save),[],"all");

down_view_2save = double(down_4_6_view)/max(double(down_4_6_view),[],"all");
sat_factor = 1;
down_view_2save = min(down_view_2save, sat_factor);
down_view_2save = double(down_view_2save)/max(double(down_view_2save),[],"all");

%saving process
save_loc = "C:\Users\admin2\OneDrive - Technion\office computer files\images_output\13_7_26\ppt\beads_2um_dense_chicken_24kus\power";
imwrite(imresize(thorcam_rect_2save, 4, "nearest"), save_loc+"\thorcam_original_res.tiff", "Compression", "None");
imwrite(imresize(thorcam_rect_down_2save, 4, "nearest"), save_loc+"\thorcam_downsampled.tiff", "Compression", "None");
imwrite(imresize(global_2save, 4, "nearest"), save_loc+"\global_average.tiff", "Compression", "None");
imwrite(imresize(local_2save, 4, "nearest"), save_loc+"\local_average.tiff", "Compression", "None");
imwrite(imresize(center_2save, 4, "nearest"), save_loc+"\center_view.tiff", "Compression", "None");
imwrite(imresize(side_view_2save, 4, "nearest"), save_loc+"\side_2_2_view.tiff", "Compression", "None");
imwrite(imresize(down_view_2save, 4, "nearest"), save_loc+"\down_4_6_view.tiff", "Compression", "None");


%Validation
val_rect = imrotate(val, -90);
val_rect_down = imresize(imgaussfilt(val_rect, 1/0.0955/2), 0.0955,"bilinear");
val_2save = double(val_rect)/max(double(val_rect), [],"all");
sat_factor = 0.5;
val_2save = min(val_2save, sat_factor);
val_2save = val_2save/sat_factor;
val_rect_down_2save = double(val_rect_down)/max(double(val_rect_down), [],"all");
sat_factor = 0.5;
val_rect_down_2save = min(val_rect_down_2save, sat_factor);
val_rect_down_2save = val_rect_down_2save/sat_factor;
imwrite(imresize(val_2save, 4, "nearest"), save_loc+"\val.tiff", "Compression", "None");
imwrite(imresize(val_rect_down_2save, 4, "nearest"), save_loc+"\val_down.tiff", "Compression", "None");

%power checking
z_power_sat_value = max([max(double(z_power_1),[],"all"), max(double(z_power_2),[],"all"), max(double(z_power_3),[],"all")]);
z_power_sat_factor = 1;
% z_power_1_2save = double(z_power_1)/max(double(z_power_1),[],"all");
z_power_1_2save = double(z_power_1)/z_power_sat_value;
z_power_1_2save = min(z_power_1_2save, z_power_sat_factor);
z_power_1_2save = double(z_power_1_2save)/max(double(z_power_1_2save),[],"all");
imwrite(imresize(z_power_1_2save, 4, "nearest"), save_loc+"\local_power_1.tiff","Compression","None");
% z_power_2_2save = double(z_power_2)/max(double(z_power_2),[],"all");
z_power_2_2save = double(z_power_2)/z_power_sat_value;
z_power_2_2save = min(z_power_2_2save, z_power_sat_factor);
z_power_2_2save = double(z_power_2_2save)/max(double(z_power_2_2save),[],"all");
imwrite(imresize(z_power_2_2save, 4, "nearest"), save_loc+"\local_power_2.tiff","Compression","None");
% z_power_3_2save = double(z_power_3)/max(double(z_power_3),[],"all");
z_power_3_2save = double(z_power_3)/z_power_sat_value;
z_power_3_2save = min(z_power_3_2save, z_power_sat_factor);
z_power_3_2save = double(z_power_3_2save)/max(double(z_power_3_2save),[],"all");
imwrite(imresize(z_power_3_2save, 4, "nearest"), save_loc+"\local_power_3.tiff","Compression","None");