%Plot Figure 3

%Simulation parameters
side_pixels=64;
num_units=15;

%Save the 40 images into a database
num_image=40;
extended_image_base=SaveExtendedImageBase();

%Extract mean grey level from 20000 samples.
meangrey=MeanGreyLevel(side_pixels, extended_image_base, num_image);

%Learn weights
weights=LearningProcess(num_units,side_pixels,extended_image_base,num_image,meangrey);

%Plot principal components
finalimage=zeros(64*3,64*5);
for horiz=1:5
    for vert=1:3
        PC=zeros(64,64);
        for I=1:64
            PC(:,I)=weights((vert-1)*5+horiz,(I-1)*64+1:I*64);
        end
        %Rescale each PC.
        PC=(PC-min(min(PC)))/(max(max(PC))-min(min(PC)));
        %Fill in final image with PC.
        finalimage((vert-1)*64+1:vert*64,(horiz-1)*64+1:horiz*64)=PC;
    end
end

imshow(finalimage)
set(gca,'visible','off')
set(gca,'xtick',[])
saveas(gcf,'Figure3.png')