% 2019.8.26��������3Dɨ����ԣ����壩��������OK
clc; clear; close all; 
ori_folder = pwd;
folder = '24-Aug-2019-222011';
tic; %������������������������������������������������������������������������
%{
������������ͷ�������_ԭʼ���ݣ�5cm����������
����    20cm       30cm       40cm
���ز�  322-176    316-220    316-245
        322-176    316-220    316-246
        322-176    316-119    316-246
��������������������������������������
%}
l_ = (290-246) * 400/50; %���/���ࣺl' ������Ҫ������������ֵδȷ����
D_LasCam = 79; %�������ڣ�laser��������ͷ��ͷ��camera���ľ��룺D

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
    
    x = width/2 - im_I; %�õ����������ϼ����ߵ�x���꣺x
    y = (1:height) - height/2; %�õ����������ϼ����ߵ�y���꣺y
    alpha = atand(x / l_); %�����ϼ�����������ͷ����ļнǣ���
    %��DAģ�����3��255������4.45V��-4.55V����10V��Ӧ20�㣬����ƫת40��//�������Ҳ��׼��
    theta = (-4.55-4.45) / (255-3) * (i- 252/2) * 38/10; %�����ƫת�ǣ���
    d1 = D_LasCam * sind(90 + theta) ./ sind(15 - theta + alpha); %ˮƽ������ �����ϼ��⵽��ͷ�ľ��룺d1
    % ���������Ծ�ͷΪԭ��O���Թ���Ϊz�Ὠ���ռ�ֱ������ϵ��������
    Z = d1 .* cosd(alpha); Z(im_max<50) = 0; %����ͷ����Ϊz��
    X = d1 .* sind(alpha); X(im_max<50) = 0;
    Y = y' .* Z /l_; Y(im_max<50) = 0; %��ע��yҪת�á�
    ZZ(:,ii) = Z;	XX(:,ii) = X;	YY(:,ii) = Y;
    ii = ii + 1;
end

% �������������������ݡ�������
pointsLocation = [XX(:) ZZ(:) YY(:)]; %Ϊ�˷����˹۲�ϰ�ߣ���y��z�Ե�
ptCloud = pointCloud(pointsLocation);
%{
ptCloud.Color = uint8( zeros( height*column ,3) ); %������ɫ����
ptCloud.Color(:,1) = 255;
ptCloud.Color(:,2) = 255;
ptCloud.Color(:,3) = 0;
%}
toc; %������������������������������������������������������������������������
cd(ori_folder) %����ԭ�ļ���

figure; pcshow(ptCloud)
pcwrite(ptCloud,[folder,'.ply']);
% �����������õ�����ʾ������plot3����ʹ3��ȱ�����ʾ����������
% figure; plot3(XX, ZZ, YY,'k.','MarkerSize',1) %Ϊ�˷����˹۲�ϰ�ߣ���y��z�Ե�


