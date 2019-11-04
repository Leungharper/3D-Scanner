% 2019.11.3————3D扫描函数【彩色、平滑、插值】————OK
function [ ptCloud,CalTime ] = fun_build3D( folder , interval , l_ , color_FLAG , interp_FLAG , smooth_FLAG ) % l_是焦距
if ~exist('interval', 'var') || isempty(interval)
    interval = 4;
end
if ~exist('l_', 'var') || isempty(l_)
    l_ = (290-246) * 400/50; %像距/焦距：l' 【这里要修正，具体数值未确定】
end
if ~exist('color_FLAG', 'var') || isempty(color_FLAG) % color_FLAG 参数为空，或者不以变量的形式存在
    color_FLAG = 1;
end
if ~exist('interp_FLAG', 'var') || isempty(interp_FLAG)
	interp_FLAG = 0;
end
if ~exist('smooth_FLAG', 'var') || isempty(smooth_FLAG)
    smooth_FLAG = 0;
end

tic; %————————计时开始————————

ori_folder = pwd;
%{
————摄像头焦距测量_原始数据（5cm）————
距离    20cm       30cm       40cm
像素差  322-176    316-220    316-245
        322-176    316-220    316-246
        322-176    316-119    316-246
———————————————————
%}
% l_ = (290-246) * 400/50; %像距/焦距：l' 【这里要修正，具体数值未确定】
D_LasCam = 79; %激光出射口（laser）与摄像头镜头（camera）的距离：D

cd(folder)
im_no = imread('NoLaser.png');
[height,width,~] = size(im_no); %【不用的变量用~代替】
column = length(3:4:255);
XX = zeros(height,column); YY = XX; ZZ = XX;
RED = uint8(XX); GREEN = RED; BLUE = RED;

y = height/2 - (1:height); %得到落在物体上激光线的y坐标：y
ii = 1;
for i = 3:interval:255
    im0 = imread([num2str(i), '.png']);
    im_minus = im0 - im_no;
    im_minus_gray = rgb2gray(im_minus);
    [im_max,im_I] = max(im_minus_gray,[],2);
    im_I(im_max<50) = 1;
    
    x = width/2 - im_I; %得到落在物体上激光线的x坐标：x
    alpha = atand(x / l_); %物体上激光线与摄像头光轴的夹角：α
    %【DA模块接收3～255，输入4.45V～-4.55V；振镜10V对应20°，激光偏转40°//这里可能也不准】
    theta = (-4.55-4.45) / (255-3) * (i- 252/2) * 38/10; %激光的偏转角：θ
    d1 = D_LasCam * sind(90 + theta) ./ sind(15 - theta + alpha); %水平截面上 物体上激光到镜头的距离：d1
    % ————以镜头为原点O，以光轴为z轴建立空间直角坐标系————
    Z = d1 .* cosd(alpha); Z(im_max<50) = 0; %摄像头光轴为z轴
    X = d1 .* sind(alpha); X(im_max<50) = 0;
    Y = y' .* Z /l_; Y(im_max<50) = 0; %【注意y要转置】
    ZZ(:,ii) = Z;	XX(:,ii) = X;	YY(:,ii) = Y;
    % ————上色————
    for j = 1 : height
        RED(j,ii) = im_no(j,im_I(j),1);
        GREEN(j,ii) = im_no(j,im_I(j),2);
        BLUE(j,ii) = im_no(j,im_I(j),3);
    end
    ii = ii + 1;
end
ZZ(ZZ < 0) = 0;
ZZ_MAX = max(ZZ(:));
ZZ(ZZ == 0) = 1.25 * ZZ_MAX;
if smooth_FLAG == 1 % ————平滑————
    h = fspecial('gaussian',7,2);
    ZZ = imfilter(ZZ,h);
end

if interp_FLAG == 1 % ——插值——
    max_x = max(XX(:)); min_x = min(XX(:));  d_x = max_x - min_x;
    max_y = max(YY(:)); min_y = min(YY(:));  d_y = max_y - min_y;
    [XX1,YY1] = meshgrid( min_x+d_x/10 : d_x/500 : max_x-d_x/10  ,  min_y+d_y/10 : d_y/500 : max_y-d_y/10 );
    % [XX1,YY1] = meshgrid( min_x : 0.2 : max_x  ,  min_y : 0.2 : max_y );
    ZZ1 = griddata(XX,YY,ZZ, XX1,YY1);
    if color_FLAG == 1 % ————重新上色（插值）————
        RED1   = griddata(XX,YY,double(RED),   XX1,YY1);    RED1 = uint8(RED1);
        GREEN1 = griddata(XX,YY,double(GREEN), XX1,YY1);    GREEN1 = uint8(GREEN1);
        BLUE1  = griddata(XX,YY,double(BLUE),  XX1,YY1);    BLUE1 = uint8(BLUE1);
            [height,column,~] = size(XX1); %覆盖原尺寸，下面重新上色用到
            XX = XX1; YY = YY1; ZZ=ZZ1; %覆盖原数据
            RED = RED1; GREEN = GREEN1; BLUE=BLUE1; %覆盖原数据
    end
end

% ————创建点云数据————
pointsLocation = [XX(:) ZZ(:) YY(:)]; %为了符合人观察习惯，将y、z对调
ptCloud = pointCloud(pointsLocation);
if color_FLAG == 1 % ——上色——
    ptCloud.Color = uint8( zeros( height*column ,3) );
    ptCloud.Color(:,1) = RED(:);
    ptCloud.Color(:,2) = GREEN(:);
    ptCloud.Color(:,3) = BLUE(:);
end %}

pcwrite(ptCloud,[folder,'.ply']);

cd(ori_folder) %返回原文件夹

CalTime = toc; %————————计时结束————————



