% 2019.8.26————3D扫描测试（立体）————OK
clc; clear; close all; 
ori_folder = pwd;
folder = '24-Aug-2019-222011';
tic; %————————————————————————————————————
%{
————摄像头焦距测量_原始数据（5cm）————
距离    20cm       30cm       40cm
像素差  322-176    316-220    316-245
        322-176    316-220    316-246
        322-176    316-119    316-246
———————————————————
%}
l_ = (290-246) * 400/50; %像距/焦距：l' 【这里要修正，具体数值未确定】
D_LasCam = 79; %激光出射口（laser）与摄像头镜头（camera）的距离：D

cd(folder)
im_no = imread('NoLaser.png');
% i = 255;
[height,width,COLOR] = size(im_no);
column = length(3:4:255);
XX = zeros(height,column); YY = XX; ZZ = XX;

ii = 1;
for i = 3:4:255
    im0 = imread([num2str(i), '.png']);
    im_minus = im0 - im_no;
    im_minus_gray = rgb2gray(im_minus);
    [im_max,im_I] = max(im_minus_gray,[],2);
    im_I(im_max<50) = 0;
    
    x = width/2 - im_I; %得到落在物体上激光线的x坐标：x
    y = (1:height) - height/2; %得到落在物体上激光线的y坐标：y
    alpha = atand(x / l_); %物体上激光线与摄像头光轴的夹角：α
    %【DA模块接收3～255，输入4.45V～-4.55V；振镜10V对应20°，激光偏转40°//这里可能也不准】
    theta = (-4.55-4.45) / (255-3) * (i- 252/2) * 38/10; %激光的偏转角：θ
    d1 = D_LasCam * sind(90 + theta) ./ sind(15 - theta + alpha); %水平截面上 物体上激光到镜头的距离：d1
    % ————以镜头为原点O，以光轴为z轴建立空间直角坐标系————
    Z = d1 .* cosd(alpha); Z(im_max<50) = 0; %摄像头光轴为z轴
    X = d1 .* sind(alpha); X(im_max<50) = 0;
    Y = y' .* Z /l_; Y(im_max<50) = 0; %【注意y要转置】
    ZZ(:,ii) = Z;	XX(:,ii) = X;	YY(:,ii) = Y;
    ii = ii + 1;
end

% ————创建点云数据————
pointsLocation = [XX(:) ZZ(:) YY(:)]; %为了符合人观察习惯，将y、z对调
ptCloud = pointCloud(pointsLocation);
%{
ptCloud.Color = uint8( zeros( height*column ,3) ); %——上色——
ptCloud.Color(:,1) = 255;
ptCloud.Color(:,2) = 255;
ptCloud.Color(:,3) = 0;
%}
toc; %————————————————————————————————————
cd(ori_folder) %返回原文件夹

figure; pcshow(ptCloud)
pcwrite(ptCloud,[folder,'.ply']);
% ————不用点云显示【不过plot3不能使3轴等比例显示】————
% figure; plot3(XX, ZZ, YY,'k.','MarkerSize',1) %为了符合人观察习惯，将y、z对调


