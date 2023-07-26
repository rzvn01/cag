function mp3_player(audioState,selectionString,player,fs,lowFreqGain,highFreqGain,leqState,heqState)

SoundVolume(1);
% Create a figure window
f = figure('Name', 'MP3 Player','Position',[100 100 1500 900] ,'Color', [0.65,0.65,0.65],Resize='off',NumberTitle='off');

% Create an axes object
ax = axes(f, 'Position', [0.3,0.55,0.25,0.25]);
axis equal
colorbar;
waveformaxes= axes(f, 'Position', [0.3,0.086,0.25,0.22]);
xlabel('Time (s)',Color=[ 0.76 , 0.11, 0.76 ],FontSize=14);
ylabel('Amplitude',Color=[ 0.76 , 0.11, 0.76 ],FontSize=14);
title(waveformaxes,'Waveform of the audio signal',Color=[ 0.76 , 0.11, 0.76 ],FontSize=14);
colorbar;
playAxes = axes(f, 'Position', [0.65,0.086,0.25,0.25]); % adjust the position of the axes
ax1 = axes(f,'Position', [0.65,0.55,0.25,0.25]);

doc=uimenu(f,"Text",'Documentation');
pdfMenu = uimenu(doc,"Text",'PDF');
pdfCallback = @(hObject,eventdata) open('documentation.pdf');
set(pdfMenu,'Callback',pdfCallback);
colorbar;
xlabel('Time (seconds)',Color=[0.76 , 0.11, 0.76],FontSize=15);
ylabel('Frequency (Hz)',Color=[0.76 , 0.11, 0.76],FontSize=15);
title('Spectrogram of Audio Signal',Color=[0.76 , 0.11, 0.76],FontSize=15);

% Create a listbox
listbox = uicontrol(f, 'Style', 'listbox', 'Position', [120,320,300,410]);

uicontrol(f, 'Style', 'text', 'String', 'Playlist:', 'Position', [120,740,80,20],'BackgroundColor',[0.65,0.65,0.65],'ForegroundColor','[ 0.76 , 0.11, 0.76 ] ',FontSize=12 );

% Add some items to the listbox
% Get a list of all MP3 files in the folder
mp3Files = dir('*.mp3');
%
% Create a cell array of file names
items = {mp3Files.name};

% Set the listbox strings to the file names
set(listbox, 'String', items);


uicontrol(f, 'Style', 'text', 'Position', [264,770,1033,78], 'String', 'MP3 Player GUI !','ForegroundColor','[ 0.76 , 0.11, 0.76 ] ','BackgroundColor',[0.65,0.65,0.65],FontSize=32);

elapsedTimeTextbox = uicontrol(f, 'Style', 'text', 'Position', [471,440,341,20], 'String', 'Elapsed time : -/- seconds .','ForegroundColor','[ 0.76 , 0.11, 0.76 ] ','BackgroundColor',[0.65,0.65,0.65],FontSize=12);

songTextbox = uicontrol(f, 'Style', 'edit', 'Position', [440,740,380,20], 'String', 'Currently nothing playing !','BackgroundColor',[0.65,0.65,0.65],'ForegroundColor','[ 0.76 , 0.11, 0.76 ] ',FontSize=12);

% Create a play button
playButton = uicontrol(f, 'Style', 'pushbutton', 'String', 'Play','BackgroundColor','[ 0.76 , 0.11, 0.76 ] ' ,'Position', [450,360,50,20], 'Callback', @playButtonCallback,Enable='off');

% Create a pause button
pauseButton = uicontrol(f, 'Style', 'pushbutton', 'String', 'Pause/Resume', 'BackgroundColor','[ 0.76 , 0.11, 0.76 ] ' ,'Position', [520,360,80,20], 'Callback', @pauseButtonCallback,Enable='off');

% Create a stop button
stopButton = uicontrol(f, 'Style', 'pushbutton', 'String', 'Stop','BackgroundColor','[ 0.76 , 0.11, 0.76 ] ' , 'Position' ,[615,360,50,20], 'Callback', @stopButtonCallback,Enable='off');

% Create a shuffle button
uicontrol(f, 'Style', 'pushbutton', 'String', 'Shuffle','BackgroundColor','[ 0.76 , 0.11, 0.76 ] ' , 'Position', [685,360,50,20], 'Callback', @shuffleButtonCallback,Enable='on');

% Create a repeat button
uicontrol(f, 'Style', 'togglebutton', 'String', 'Repeat','BackgroundColor','[ 0.76 , 0.11, 0.76 ] ' , 'Position', [755,360,50,20], 'Callback', @repeatButtonCallback,Enable='on');

%Create a close button
uicontrol(f, 'Style', 'pushbutton', 'String', 'Close','BackgroundColor','[ 0.76 , 0.11, 0.76 ] ' , 'Position', [1380,20,100,35], 'Callback', @closeButtonCallback);

%Create a random button
uicontrol(f, 'Style', 'pushbutton', 'String', 'Help','BackgroundColor','[ 0.76 , 0.11, 0.76 ] ' ,'Position', [1250,20,100,35],'Callback', @rollCallback);

% Create a time slider
timeSlider = uicontrol(f, 'Style', 'slider', 'Min', 0, 'Max', 100, 'Value', 0, 'Position', [440,410,380,20],'Callback', @timeSliderCallback,Enable='off');

% Create a button for muting the audio
uicontrol('Style','pushbutton','String','Mute Volume','BackgroundColor','[ 0.76 , 0.11, 0.76 ] ','Position',[1000,360,100,20],'Callback',@muteCallback);

% Create a button for setting the audio to maximum volume
uicontrol('Style','pushbutton','String','Max Volume','BackgroundColor','[ 0.76 , 0.11, 0.76 ] ','Position',[1200,360,100,20],'Callback',@maxVolumeCallback);

uicontrol('Style','text','Position',[1280,380,120,20],'String',' Speed ','BackgroundColor',[0.65 0.65 0.65],FontSize=11,ForegroundColor=[0.76 , 0.11, 0.76]);

uicontrol('Style','popup','String',{'0.25','0.5','0.75','1','1.25','1.5','1.75','2'},'BackgroundColor','[ 0.76 , 0.11, 0.76 ]','Position',[1320,360,56,20], 'Callback',@changeSpeed);


uicontrol('Style','text','Position',[1090,380,120,20],'String',' Custom Volume ','BackgroundColor',[0.65 0.65 0.65],FontSize=11,ForegroundColor=[0.76 , 0.11, 0.76]);

uicontrol('Style','popup','String',{'0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'},'Position',[1120,360,55,20],'BackgroundColor','[ 0.76 , 0.11, 0.76 ]','Callback',@volumeCallback);

uicontrol(f, 'Style', 'text', 'String', 'Low Freq','ForegroundColor','[ 0.76 , 0.11, 0.76 ] ', 'Position', [100,244,70 ,20],BackgroundColor=[0.65 0.65 0.65],FontSize=13);
uicontrol(f, 'Style', 'text', 'String', 'High Freq','ForegroundColor','[ 0.76 , 0.11, 0.76 ] ', 'Position', [170, 244, 90, 20],BackgroundColor=[0.65 0.65 0.65],FontSize=13);
lowFreqSlider = uicontrol(f, 'Style', 'slider', 'Min',-12, 'Max', 12,'Value',0,'BackgroundColor','[ 0.5 , 0.5, 0.5 ] ','Position', [125,93,30,144],'SliderStep',[0.1 0.1],'Callback',@lowfreqSliderCallback);

highFreqSlider = uicontrol(f, 'Style', 'slider', 'Min',-12, 'Max', 12,'Value',0,'BackgroundColor','[ 0.5 , 0.5, 0.5 ] ','Position', [195,93,30,144],'SliderStep',[0.1 0.1],'Callback',@highfreqSliderCallback);

lowFreqTextbox = uicontrol(f, 'Style', 'text','BackgroundColor','[ 0.65 , 0.65, 0.65 ] ','ForegroundColor','[ 0.76 , 0.11, 0.76 ] ', 'Position', [125, 63, 30, 20], 'String', '0',FontSize=12);

highFreqTextbox = uicontrol(f, 'Style', 'text', 'BackgroundColor','[ 0.65 , 0.65, 0.65 ] ','ForegroundColor','[ 0.76 , 0.11, 0.76 ] ','Position', [195, 63, 30, 20], 'String', '0',FontSize=12);

equalizeButton = uicontrol(f, 'Style', 'pushbutton', 'String', 'Equalize','BackgroundColor','[ 0.76 , 0.11, 0.76 ] ' ,'Position', [125 ,33,100,20], 'Callback', @equalizeButtonCallback,Enable='off',FontSize=13);

if isempty(items)
    % If the listbox is empty, display an error message and close the figure
    errordlg('The playlist is empty. Please add some songs first.', 'Error', 'modal');
    close(f);
    return;
else
    set(playButton,'Enable','on');
end

    function playButtonCallback(~, ~)
        % Get the selected item from the listbox
        set(pauseButton,'Enable','on');
        set(timeSlider,'Enable','on');
        set(stopButton,'Enable','on');
        selection = get(listbox, 'Value');
        % Get the corresponding string from the list of items
        selectionString = items{selection};
        % Read the audio data from the file
        [y, fs] = audioread(selectionString);
        % Average the left and right channels into a single channel
        y = mean(y, 2);
        % Play the audio data

        plot(waveformaxes,y);
        xlabel('Time (s)',Color=[ 0.76 , 0.11, 0.76 ],FontSize=14);
        ylabel('Amplitude',Color=[ 0.76 , 0.11, 0.76 ],FontSize=14);
        title(waveformaxes,'Waveform of the audio signal',Color=[ 0.76 , 0.11, 0.76 ],FontSize=14);
        player = audioplayer(y, fs);
        play(player);
        % Set the maximum value of the time slider to the length of the song
        % (in seconds)
        set(timeSlider, 'Max', length(y) / fs);
        % Update the time slider as the song plays
        audioState = 1;
        index =0;

        % Call the plotSpectrogram function to plot the spectrogram
        plotSpectrogram(ax1,y, fs);
        axes(playAxes);
        playDisplayRandomPhoto;

        while audioState == 1
            set(songTextbox, 'String', selectionString);
            currentTime = player.CurrentSample / fs;
            set(timeSlider, 'Value', currentTime);
            elapsedTime = floor(player.CurrentSample / fs);
            totalDuration = floor(player.TotalSamples / fs);
            % Convert to strings
            elapsedTimeStr = num2str(elapsedTime);
            totalDurationStr = num2str(totalDuration);
            % Update elapsed time display
            set(elapsedTimeTextbox, 'String', ['Elapsed time : ' elapsedTimeStr '/' totalDurationStr ' seconds .']);
            if index == 20
                pause(0.3);
                visualize(player);
                index=0;
            else
                index=index+1;
            end
            drawnow;
            if player.CurrentSample == player.TotalSamples
                stop(player);
                audioState = 0;
                stopDisplayRandomPhoto;
                set(songTextbox, 'String', "Currently nothing playing ! ");
                set(timeSlider, 'Value', 0);
            end
        end
    end


    function visualize(~)
        axes(ax);
        % Set the parameters for the RGG function
        nodes = randi([50, 100]); % Random integer between 20 and 200
        radius = rand(1) * 0.3 + 0.1; % Random value between 0.1 and 0.7
        x = single(rand(nodes,1));
        y = single(rand(nodes,1));
        A = false(nodes);
        for j = 1:nodes
            x0 = x(j); y0 = y(j);
            distance = sqrt((x - x0).^2 + (y - y0).^2);
            neigh = zeros(nodes,1);
            neigh(distance <= radius) = true;
            A(j,:) = logical(neigh);
            A(j,j) = false;
        end
        switcher = 0;
        % Plot the visualizer
        plotVisualizer(A, x, y, ax,radius, nodes, switcher);

    end

    function pauseButtonCallback(~, ~)
        % Check the current status of the audioplayer object
        if strcmp(player.Running, 'on')
            % Pause the audio playback
            audioState = 0;
            % Pause the audioplayer object
            pause(player);
            axes(playAxes);
            stopDisplayRandomPhoto;
            set(songTextbox, 'String', "Paused !");
        else
            axes(playAxes);
            % Resume the audio playback
            audioState = 1;
            % Resume the audioplayer object
            resume(player);
            playDisplayRandomPhoto;
            index=0;
            while audioState == 1
                set(songTextbox, 'String', selectionString);
                set(timeSlider, 'Value', player.CurrentSample / fs);
                % Update the visualizer
                if index == 20
                    visualize(player);
                    index=0;
                else
                    index=index+1;
                end
                drawnow;
            end
        end
    end

    function stopButtonCallback(~, ~)

        set(pauseButton,'Enable','off');
        % Stop the audio playback and reset the current position to the beginning
        audioState = -1;
        set(songTextbox, 'String', "Currently nothing playing ! ");
        set(timeSlider, 'Value', 0);
        set(elapsedTimeTextbox,'String','Elapsed time : -/- seconds .');
        % Stop the audioplayer object and reset the current position to the beginning
        axes(playAxes);
        stop(player);
        stopDisplayRandomPhoto;
    end

    function shuffleButtonCallback(~, ~)
        % Shuffle the items in the listbox
        items = items(randperm(length(items)));
        set(listbox, 'String', items);
        axes(playAxes);
        shuffleDisplayRandomPhoto;
    end

    function repeatButtonCallback(hObject, ~)
        axes(playAxes);
        % Check the value of the toggle button
        if get(hObject, 'Value') == 1
            % Set listbox selection to current song
            set(listbox, 'Value', get(listbox, 'Value'));
            % Set listbox selection mode to single
            set(listbox, 'Max', 1, 'Min', 1);
        else
            % Set listbox selection mode to multiple
            set(listbox, 'Max', inf, 'Min', 0);
        end
        repeatDisplayRandomPhoto;
    end

    function volumeCallback(hObject, ~)
        volume = hObject.String{hObject.Value};
        volume = str2double(volume);
        SoundVolume(volume);
    end

    function plotSpectrogram(ax1,y, fs)


        % Compute the spectrogram
        window  = hamming(512);
        noverlap = 256;
        [~,F,T,P] = spectrogram(y,window,noverlap,512,fs);

        % Plot the spectrogram
        imagesc(T,F,10*log10(P));

        colorbar;
        xlabel('Time (seconds)',Color=[0.76 , 0.11, 0.76],FontSize=15);
        ylabel('Frequency (Hz)',Color=[0.76 , 0.11, 0.76],FontSize=15);
        title('Spectrogram of Audio Signal',Color=[0.76 , 0.11, 0.76],FontSize=15);
        set(ax1, 'Position', [0.65,0.55,0.25,0.25]);
        set(ax1,'YDir','normal');
    end

    function closeButtonCallback(~, ~)
        % Close the figure window
        close(f);

        % Close any other objects you want to close (e.g. figures, UI objects, etc.)
        close all;
    end
    function muteCallback(~, ~)
        % Close the figure window
        SoundVolume(0);

    end

    function maxVolumeCallback(~, ~)
        % Close the figure window
        SoundVolume(1);
    end

    function rollCallback(~, ~)
        % Open the web link in the default web browse
        web('https://www.youtube.com/watch?v=dQw4w9WgXcQ');

    end

    function playDisplayRandomPhoto
        axes(playAxes);

        % Get a list of all image files in the folder
        imageFiles = dir('play/*.jpg');

        % Choose a random image file
        randomIndex = randi(numel(imageFiles));
        randomImage = imageFiles(randomIndex);

        % Read in the image file
        imageData = imread(fullfile('play', randomImage.name));

        % Display image in plot
        h = image(imageData);
        % Set CDataMapping to 'scaled' to scale data values to colormap
        set(h, 'CDataMapping', 'scaled');
        % Set XData and YData to specify coordinate limits
        set(h, 'XData', [1 size(imageData,2)]);
        set(h, 'YData', [1 size(imageData,1)]);
        % Delete x-axis label
        xlabel('');
        % Delete y-axis label
        ylabel('');
        % Delete x-axis tick marks and labels
        set(gca, 'XTick', []);
        % Delete y-axis tick marks and labels
        set(gca, 'YTick', []);
    end
    function stopDisplayRandomPhoto
        axes(playAxes);

        % Get a list of all image files in the folder
        imageFiles = dir('stop/*.jpg');

        % Choose a random image file
        randomIndex = randi(numel(imageFiles));
        randomImage = imageFiles(randomIndex);

        % Read in the image file
        imageData = imread(fullfile('stop', randomImage.name));

        % Display image in plot
        h = image(imageData);
        % Set CDataMapping to 'scaled' to scale data values to colormap
        set(h, 'CDataMapping', 'scaled');
        % Set XData and YData to specify coordinate limits
        set(h, 'XData', [1 size(imageData,2)]);
        set(h, 'YData', [1 size(imageData,1)]);
        % Delete x-axis label
        xlabel('');
        % Delete y-axis label
        ylabel('');
        % Delete x-axis tick marks and labels
        set(gca, 'XTick', []);
        % Delete y-axis tick marks and labels
        set(gca, 'YTick', []);
    end

    function shuffleDisplayRandomPhoto
        axes(playAxes);

        % Get a list of all image files in the folder
        imageFiles = dir('shuffle/*.jpg');

        % Choose a random image file
        randomIndex = randi(numel(imageFiles));
        randomImage = imageFiles(randomIndex);

        % Read in the image file
        imageData = imread(fullfile('shuffle', randomImage.name));

        % Display image in plot
        h = image(imageData);
        % Set CDataMapping to 'scaled' to scale data values to colormap
        set(h, 'CDataMapping', 'scaled');
        % Set XData and YData to specify coordinate limits
        set(h, 'XData', [1 size(imageData,2)]);
        set(h, 'YData', [1 size(imageData,1)]);
        % Delete x-axis label
        xlabel('');
        % Delete y-axis label
        ylabel('');
        % Delete x-axis tick marks and labels
        set(gca, 'XTick', []);
        % Delete y-axis tick marks and labels
        set(gca, 'YTick', []);

    end

    function repeatDisplayRandomPhoto
        axes(playAxes);

        % Get a list of all image files in the folder
        imageFiles = dir('repeat/*.jpg');

        % Choose a random image file
        randomIndex = randi(numel(imageFiles));
        randomImage = imageFiles(randomIndex);

        % Read in the image file
        imageData = imread(fullfile('repeat', randomImage.name));

        % Display image in plot
        h = image(imageData);
        % Set CDataMapping to 'scaled' to scale data values to colormap
        set(h, 'CDataMapping', 'scaled');
        % Set XData and YData to specify coordinate limits
        set(h, 'XData', [1 size(imageData,2)]);
        set(h, 'YData', [1 size(imageData,1)]);
        % Delete x-axis label
        xlabel('');
        % Delete y-axis label
        ylabel('');
        % Delete x-axis tick marks and labels
        set(gca, 'XTick', []);
        % Delete y-axis tick marks and labels
        set(gca, 'YTick', []);
    end
    function timeSliderCallback(source, ~)
        % Get the current value of the time slider
        value = get(source, 'Value');

        % Stop the audio player
        stop(player);

        % Set the audio player to play from the new position to the end
        play(player, floor(value)*fs);
        playDisplayRandomPhoto;

        audioState =1;
        index=0;

        while audioState == 1
            set(songTextbox, 'String', selectionString);
            set(timeSlider, 'Value', player.CurrentSample / fs);
            elapsedTime = floor(player.CurrentSample / fs);
            totalDuration = floor(player.TotalSamples / fs);
            elapsedTimeStr = num2str(elapsedTime);
            totalDurationStr = num2str(totalDuration);
            set(elapsedTimeTextbox, 'String', ['Elapsed time : ' elapsedTimeStr '/' totalDurationStr ' seconds .']);
            if index == 20
                visualize(player);
                index=0;
            else
                index=index+1;
            end
            drawnow;
            if player.CurrentSample == player.TotalSamples
                stop(player);
                audioState = 0;
                stopDisplayRandomPhoto;
                set(songTextbox, 'String', "Currently nothing playing ! ");
                set(timeSlider, 'Value', 0);

            end
        end

    end

    function changeSpeed(source, ~)

        selection = get(listbox, 'Value');
        selectionString = items{selection};

        [y, fs] = audioread(selectionString);
        speed = source.String{source.Value};
        speed = str2double(speed);
        fs_mod = fs * speed;
        player = audioplayer(y, fs_mod);
        play(player);

        set(pauseButton,'Enable','on');
        set(timeSlider,'Enable','on');
        set(timeSlider,'Enable','on');
        set(stopButton,'Enable','on');

        playDisplayRandomPhoto;

        audioState =1;
        index=0;
        axes(playAxes);

        while audioState == 1

            set(songTextbox, 'String', selectionString);
            set(timeSlider, 'Value', player.CurrentSample / fs_mod);

            elapsedTime = floor(player.CurrentSample / fs_mod);
            totalDuration = floor(player.TotalSamples / fs_mod);
            elapsedTimeStr = num2str(elapsedTime);
            totalDurationStr = num2str(totalDuration);
            set(elapsedTimeTextbox, 'String', ['Elapsed time : ' elapsedTimeStr '/' totalDurationStr ' seconds .']);

            if index == 20
                visualize(player);
                index=0;
            else
                index=index+1;
            end
            drawnow;
            if player.CurrentSample == player.TotalSamples
                stop(player);
                audioState = 0;
                stopDisplayRandomPhoto;
                set(songTextbox, 'String', "Currently nothing playing ! ");
                set(timeSlider, 'Value', 0);

            end
        end
    end

    function lowfreqSliderCallback(~,~)
        value = get(lowFreqSlider,'Value');
        value = round(value ,2 );

        lowFreqGain = value ;
        set(lowFreqTextbox,'String',lowFreqGain);
        leqState = leqState+1 ;

        if(leqState>=1&&heqState>=1)
            set(equalizeButton,'Enable','on');

        end
    end



    function highfreqSliderCallback(~,~)
        value = get(highFreqSlider,'Value');
        value = round(value ,2 );

        highFreqGain = value ;
        set(highFreqTextbox,'String',highFreqGain);
        heqState = heqState+1 ;

        if(leqState>=1&&heqState>=1)
            set(equalizeButton,'Enable','on');

        end
    end

    function equalizeButtonCallback(~, ~)

        set(pauseButton,'Enable','on');
        set(timeSlider,'Enable','on');
        set(stopButton,'Enable','on');

        selection = get(listbox, 'Value');
        selectionString = items{selection};
        [audio,fs] = audioread(selectionString);

        audio(:,1) = audio(:,1) * lowFreqGain;
        audio(:,2) = audio(:,2) * highFreqGain;

        player = audioplayer(audio,fs);

        plot(waveformaxes,audio);

        xlabel('Time (s)',Color=[ 0.76 , 0.11, 0.76 ],FontSize=14);
        ylabel('Amplitude',Color=[ 0.76 , 0.11, 0.76 ],FontSize=14);

        title(waveformaxes,'Waveform of the audio signal',Color=[ 0.76 , 0.11, 0.76 ],FontSize=14);

        play(player);

        set(songTextbox,'String',['Currently playing: ', selectionString]);
        set(playButton,'Enable','off');

        axes(playAxes);

        playDisplayRandomPhoto;

        audioState =1;
        index=0;

        while audioState == 1
            set(songTextbox, 'String', selectionString);
            set(timeSlider, 'Value', player.CurrentSample / fs);
            elapsedTime = floor(player.CurrentSample / fs);
            totalDuration = floor(player.TotalSamples / fs);
            elapsedTimeStr = num2str(elapsedTime);
            totalDurationStr = num2str(totalDuration);
            set(elapsedTimeTextbox, 'String', ['Elapsed time : ' elapsedTimeStr '/' totalDurationStr ' seconds .']);

            if index == 20
                visualize(player);
                index=0;
            else
                index=index+1;
            end

            drawnow;

            if player.CurrentSample == player.TotalSamples
                stop(player);
                audioState = 0;
                stopDisplayRandomPhoto;
                set(songTextbox, 'String', "Currently nothing playing ! ");
                set(timeSlider, 'Value', 0);

            end
        end
    end

end