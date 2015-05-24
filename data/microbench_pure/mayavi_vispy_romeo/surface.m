figure('doublebuffer','on')

[X,Y] = meshgrid(-2:.009:2, -2:.009:2); 
i = 5;
X = X.*i;
Y = Y.*i;
R = sqrt(X.^2 + Y.^2);
Z = sin(R) ./ R;

sh = surf(X,Y,Z, 'FaceColor','interp','FaceLighting','gouraud', 'LineStyle', 'none'); % surface plot of the first surface
