clc
clear
close all

cover_img = imread('peppers.png');
if size(cover_img,3)~=1
    cover_img = rgb2gray(cover_img);
end

message_img = imread('cameraman.tif');
if size(message_img,3)~=1
    message_img = rgb2gray(message_img);
end
message_img = imresize(message_img,size(cover_img));

%% steganography
COVER_IMG = fft2(cover_img);

[Q_cover,R_cover] = qr(COVER_IMG);

[Q_message,R_message] = qr(double(message_img));

alpha = 0.01;
R_new = R_cover + alpha * R_message;

COVER_IMG = Q_cover * R_new;

stego_img = ifft2(COVER_IMG);

%% restore message
STEGO_IMG = fft2(stego_img);

[~,R_stego] = qr(STEGO_IMG);

R_extract = 1/alpha * (R_stego - R_cover);

restore_message = Q_message * R_extract;
restore_message = abs(restore_message);

%% show results
subplot(2,2,1); imshow(cover_img,[]); title('cover image');
subplot(2,2,2); imshow(message_img,[]); title('message');
subplot(2,2,3); imshow(abs(stego_img),[]); title('stego image');
subplot(2,2,4); imshow(abs(restore_message),[]); title('restore message');

