%% ----------------------------------------------------------------------------------------------------------------
% GetThresholdValues - Gets the threshold values for the different colors
function [hThresholdLow, hThresholdHigh, sThresholdLow, sThresholdHigh, ... 
        vThresholdLow, vThresholdHigh]  = GetThresholds(color)

    % Hue, saturation, value thresholds
    switch color
        case '1'
			% Yellow
			hThresholdLow = 0.1;
			hThresholdHigh = 0.18;
			sThresholdLow = 0.4;
			sThresholdHigh = 1;
			vThresholdLow = 0.4;
			vThresholdHigh = 1;
		case '2'
			% Green
			hThresholdLow = 0.19;
			hThresholdHigh = 0.41;
			sThresholdLow = 0.3;
			sThresholdHigh = 1;
			vThresholdLow = 0.1;
			vThresholdHigh = 1;
		case '3'
			% Red.
			hThresholdLow = -350/360;
			hThresholdHigh = 17/360;
			sThresholdLow = 0.40;
			sThresholdHigh = 1;
			vThresholdLow = 0.35;
			vThresholdHigh = 1.0;
        case '4'
			% Purple
			hThresholdLow = 0.70;   
			hThresholdHigh = 0.96;
			sThresholdLow = 0.1;
			sThresholdHigh = 1;
			vThresholdLow = 0.1;
			vThresholdHigh = 1;
        case '5'
			% blue
			hThresholdLow = 0.58;
			hThresholdHigh = 0.68;
			sThresholdLow = 0.25;
			sThresholdHigh = 1;
			vThresholdLow = 0.25;
			vThresholdHigh = 1;
        otherwise  
            warndlg('Invalid color');            
    end
end