 function plotSpectrogram(ax1,y, fs)
      

        % Compute the spectrogram
        window  = hamming(512);
        noverlap = 256;
        [S,F,T,P] = spectrogram(y,window,noverlap,512,fs);

        % Plot the spectrogram
        imagesc(T,F,10*log10(P));

        colorbar;
        xlabel('Time (seconds)',Color=[0.76 , 0.11, 0.76],FontSize=15);
        ylabel('Frequency (Hz)',Color=[0.76 , 0.11, 0.76],FontSize=15);
        title('Spectrogram of Audio Signal',Color=[0.76 , 0.11, 0.76],FontSize=15);
        set(ax1, 'Position', [0.65,0.55,0.25,0.25]);
        set(ax1,'YDir','normal');
    end