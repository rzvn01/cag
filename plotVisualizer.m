function h = plotVisualizer(A,x,y,ax,varargin)
%varargin{1} = radius, varargin{2} = nNodes, varargin{3} = switcher

% Plot the graph in the subplot
g = graph(A,'OmitSelfLoops');
h = plot(ax,g,'XData',x,'YData',y,'LineWidth',1);
h.NodeLabel = {};
h.EdgeColor = 'k';
h.MarkerSize = 3;

%Node color according to number of neighbours
colorSaver = jet;
% colorSaver(1:end,:,:) = colorSaver(end:-1:1,:,:); %upside down, better hot = more neighs
neighCounter = sum(A);
% step = round(64/max(neighCounter));
% ind = 1:step(1):63;
ind = round(linspace(1,63,length(neighCounter)));
MColor = colorSaver(ind(neighCounter+1),:);
h.NodeColor = MColor;

%Create Colormap
colormap(colorSaver);
str = sprintf('%d',length(neighCounter));
c.Label.String = 'Number of Neighbours';

axis equal
axis([ 0 1 0 1])
xticklabels('')
yticklabels('')
if length(varargin) == 3 
    %varargin{1} = radius, varargin{2} = nNodes, varargin{3} = switcher
    if varargin{3} ~= 0
    hold on
    viscircles([x,y],repmat(varargin{1},varargin{2},1),'LineWidth',1,'Color', [0.5 0.5 0.5]);
    hold off
    end
end
end
