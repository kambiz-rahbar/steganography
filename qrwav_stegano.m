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
message_img = imresize(message_img,size(cover_img)/2);

%% steganography
[LL_cover,LH_cover,HL_cover,HH_cover] = dwt2(cover_img,'haar');

[QH_cover,RH_cover] = qr(HH_cover);

[Q_message,R_message] = qr(double(message_img));

alpha = 0.01;
R_new = RH_cover + alpha * R_message;

HH_new = QH_cover * R_new;

stego_img = idwt2(LL_cover,LH_cover,HL_cover,HH_new,'haar');

%% restore message
[LL_stego,LH_stego,HL_stego,HH_stego] = dwt2(stego_img,'haar');

[~,RH_stego] = qr(HH_stego);

R_extract = 1/alpha * (RH_stego - RH_cover);

restore_message = Q_message * R_extract;

%% show results
subplot(2,2,1); imshow(cover_img,[]); title('cover image');
subplot(2,2,2); imshow(message_img,[]); title('message');
subplot(2,2,3); imshow(stego_img,[]); title('stego image');
subplot(2,2,4); imshow(restore_message,[]); title('restore message');

