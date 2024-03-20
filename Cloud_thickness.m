clearvars; close all;
file = 'TCDC_201001.nc';
c = ncread(file,'cc');
[nx, ny, nz, nt] = size(c)
file1 = 'HGT_201001.nc';
h = ncread(file1,'z');
file2 = 'CT_201001.nc';
hgt = ncread(file2,'t2m');
%% Calculate
thickness = zeros(nx,ny,nt);
threshold = 1; % Percent
for t = 1:nt
for x = 1:nx
for y = 1:ny
    base = 0; top = 0;
    for z=nz:-1:8
        if (c(x,y,z,t) >= threshold)
            base = z; break
        end
    end
    if base ~= 0
        for z=base-1:-1:7
            if (c(x,y,z,t) < threshold)
                top = z+1; break
            end
        end
        if top ~= 0
            thickness(x,y,t)=h(x,y,top,t)-h(x,y,base,t);
        end
    end
end
end
end
ncwrite(file2,'t2m',thickness);
