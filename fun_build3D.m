% 2019.11.3��������3Dɨ�躯������ɫ��ƽ������ֵ����������OK
function [ ptCloud,CalTime ] = fun_build3D( folder , interval , l_ , color_FLAG , interp_FLAG , smooth_FLAG ) % l_�ǽ���
if ~exist('interval', 'var') || isempty(interval)
    interval = 4;
end
if ~exist('l_', 'var') || isempty(l_)
    l_ = (290-246) * 400/50; %���/���ࣺl' ������Ҫ������������ֵδȷ����
end
if ~exist('color_FLAG', 'var') || isempty(color_FLAG) % color_FLAG ����Ϊ�գ����߲��Ա�������ʽ����
    color_FLAG = 1;
end
if ~exist('interp_FLAG', 'var') || isempty(interp_FLAG)
	interp_FLAG = 0;
end
if ~exist('smooth_FLAG', 'var') || isempty(smooth_FLAG)
    smooth_FLAG = 0;
end

tic; %������������������ʱ��ʼ����������������

ori_folder = pwd;
%{
������������ͷ�������_ԭʼ���ݣ�5cm����������
����    20cm       30cm       40cm
���ز�  322-176    316-220    316-245
        322-176    316-220    316-246
        322-176    316-119    316-246
��������������������������������������
%}
% l_ = (290-246) * 400/50; %���/���ࣺl' ������Ҫ������������ֵδȷ����
D_LasCam = 79; %�������ڣ�laser��������ͷ��ͷ��camera���ľ��룺D

cd(folder)
im_no = imread('NoLaser.png');
[height,width,~] = size(im_no); %�����õı�����~���桿
column = length(3:4:255);
XX = zeros(height,column); YY = XX; ZZ = XX;
RED = uint8(XX); GREEN = RED; BLUE = RED;

y = height/2 - (1:height); %�õ����������ϼ����ߵ�y���꣺y
ii = 1;
for i = 3:interval:255
    im0 = imread([num2str(i), '.png']);
    im_minus = im0 - im_no;
    im_minus_gray = rgb2gray(im_minus);
    [im_max,im_I] = max(im_minus_gray,[],2);
    im_I(im_max<50) = 1;
    
    x = width/2 - im_I; %�õ����������ϼ����ߵ�x���꣺x
    alpha = atand(x / l_); %�����ϼ�����������ͷ����ļнǣ���
    %��DAģ�����3��255������4.45V��-4.55V����10V��Ӧ20�㣬����ƫת40��//�������Ҳ��׼��
    theta = (-4.55-4.45) / (255-3) * (i- 252/2) * 38/10; %�����ƫת�ǣ���
    d1 = D_LasCam * sind(90 + theta) ./ sind(15 - theta + alpha); %ˮƽ������ �����ϼ��⵽��ͷ�ľ��룺d1
    % ���������Ծ�ͷΪԭ��O���Թ���Ϊz�Ὠ���ռ�ֱ������ϵ��������
    Z = d1 .* cosd(alpha); Z(im_max<50) = 0; %����ͷ����Ϊz��
    X = d1 .* sind(alpha); X(im_max<50) = 0;
    Y = y' .* Z /l_; Y(im_max<50) = 0; %��ע��yҪת�á�
    ZZ(:,ii) = Z;	XX(:,ii) = X;	YY(:,ii) = Y;
    % ����������ɫ��������
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
if smooth_FLAG == 1 % ��������ƽ����������
    h = fspecial('gaussian',7,2);
    ZZ = imfilter(ZZ,h);
end

if interp_FLAG == 1 % ������ֵ����
    max_x = max(XX(:)); min_x = min(XX(:));  d_x = max_x - min_x;
    max_y = max(YY(:)); min_y = min(YY(:));  d_y = max_y - min_y;
    [XX1,YY1] = meshgrid( min_x+d_x/10 : d_x/500 : max_x-d_x/10  ,  min_y+d_y/10 : d_y/500 : max_y-d_y/10 );
    % [XX1,YY1] = meshgrid( min_x : 0.2 : max_x  ,  min_y : 0.2 : max_y );
    ZZ1 = griddata(XX,YY,ZZ, XX1,YY1);
    if color_FLAG == 1 % ��������������ɫ����ֵ����������
        RED1   = griddata(XX,YY,double(RED),   XX1,YY1);    RED1 = uint8(RED1);
        GREEN1 = griddata(XX,YY,double(GREEN), XX1,YY1);    GREEN1 = uint8(GREEN1);
        BLUE1  = griddata(XX,YY,double(BLUE),  XX1,YY1);    BLUE1 = uint8(BLUE1);
            [height,column,~] = size(XX1); %����ԭ�ߴ磬����������ɫ�õ�
            XX = XX1; YY = YY1; ZZ=ZZ1; %����ԭ����
            RED = RED1; GREEN = GREEN1; BLUE=BLUE1; %����ԭ����
    end
end

% �������������������ݡ�������
pointsLocation = [XX(:) ZZ(:) YY(:)]; %Ϊ�˷����˹۲�ϰ�ߣ���y��z�Ե�
ptCloud = pointCloud(pointsLocation);
if color_FLAG == 1 % ������ɫ����
    ptCloud.Color = uint8( zeros( height*column ,3) );
    ptCloud.Color(:,1) = RED(:);
    ptCloud.Color(:,2) = GREEN(:);
    ptCloud.Color(:,3) = BLUE(:);
end %}

pcwrite(ptCloud,[folder,'.ply']);

cd(ori_folder) %����ԭ�ļ���

CalTime = toc; %������������������ʱ��������������������



