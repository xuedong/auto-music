classdef Midi

	methods (Static)

		function seq_to_file(s, f)
			% Writes the sequence [s] to the midi file [f].
			
			s_l = size(s,2); % sequence length
			% Get start and stop times
			n_start = zeros(1, s_l); % start times
			n_stop = zeros(1, s_l); % stop times
			d = 0;
			for i=1:s_l
				n_start(1,i) = d;
				d = d+s(2,i);
				n_stop(1,i) = d;
			end

			% Remove silences
			keep = (s(1,:)~=0);
			keep
			notes = s(1,:);
			notes = notes(keep); % keep only non-zero values !
			n_start = n_start(keep);
			n_stop = n_stop(keep);

			%[notes; n_start; n_stop]
			sz_playing = size(notes,2);

			% Create file
			M = zeros(sz_playing, 6);
			
			M(:,1) = 1;         % all in track 1
			M(:,2) = 1;         % all in channel 1
			M(:,3) = notes';    % notes pitches
			M(:,4) = 120*ones(sz_playing, 1);
			M(:,5) = n_start';	% start times
			M(:,6) = n_stop';		% stop times
			
			M
			fprintf('Creating matrix.\n');
			midi_new = matrix2midi(M);
			midi_new
			midi_new.track
			midi_new.track.messages


[y,Fs] = midi2audio(midi_new);    

%% listen in matlab:
soundsc(y, Fs);
			fprintf('Writing to file.\n');
			%writemidi(midi_new, 'aaa.mid');

		end
		
		function play(s)
			% Plays the sequence [s] using timidity player.
			
			Midi.seq_to_file(s, '.tmp-mid-file.mid');
			%Midi.play_from_file('.tmp-mid-file.mid');
		end
		
		function play_from_file(f)
			% Plays the midi file [f] using timidity player.
		
			system(['timidity ' f]);
		end

	end % methods (Static)

end
