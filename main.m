
clear ; 
close all ;

audioState =-1;
selectionString =[];
player=[];
fs=44100;

lowFreqGain =0;
highFreqGain =0 ;
leqState =0;
heqState=0;

mp3_player(audioState,selectionString,player, ...
    fs,lowFreqGain,highFreqGain,leqState,heqState)