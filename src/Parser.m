function [pitch, duration] = Parser(path)
    file = fopen(path);
    note_string = fgetl(file);
    fclose(file);

    NOTE = {'r', 'b', 'n', 'c', 's', 'f', 'u'};
    DURATION1 = [4.0, 2.0, 1.0, 0.5, 0.25, 0.125, 0.0625];
    BASE_TIME = containers.Map(NOTE, DURATION1);

    EXTRA = {'p', 'm', 'l', 't'};
    DURATION2 = [1.5, 1.25, 1.75, 2/3];
    MULTIPLIER = containers.Map(EXTRA, DURATION2);
    
    notes = strsplit(strtrim(note_string));
    len = length(notes);
    pitch = zeros(1, len);
    duration = zeros(1, len);

    %disp(path)
    for i = 1:len
        pitch_s = regexp(notes(i), '((-)?\d*|S)', 'match');
        if strcmp(pitch_s{1}, 'S')
        	pitch(i) = 100; % Just convention. Beware, 99 is for silences.
        else
            %disp(pitch_s{1})
        	pitch(i) = str2num(cell2mat(pitch_s{1}));
        end
        duration_s = regexp(notes(i), '[a-z]', 'match');
        duration(i) = BASE_TIME(cell2mat(duration_s{1}(1)));
        if length(duration_s{1}) > 1
            duration(i) = duration(i) * MULTIPLIER(cell2mat(duration_s{1}(2)));
        end
    end
	%notes
	%[pitch;duration]
    

	%fprintf(strcat(path,'\n'))
    %fprintf('Pitch: %d > %d, Duration: %.2f > %.2f . \n', min(pitch), max(pitch), min(duration), max(duration))
    %disp(unique(pitch))
    %disp(unique(duration))
end
