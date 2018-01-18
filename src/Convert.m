classdef Convert

	methods (Static)

		%function res = to_p_seq(s)
			%% Converts a sequence ((2,length)-array) to a "p1 p2…" string of pitches only.
			%res =  sprintf('%d ', s(1,:));
		%end

		%function res = to_d_seq(s)
			%% Converts a sequence ((2,length)-array) to a "d1 d2…" string of durations only.
			%res =  sprintf('%d %.2f ', s(2,:));
		%end

		%function res = to_pd_seq(s)
			%% Converts a sequence ((2,length)-array) to a "p1 d1 p2 d2…" string.
			%res =  sprintf('%d %.2f ', s);
        %end

    	function [ sequence, data ] = transform_to_symbol_sequence(pitch, duration, seq_type, data) 
      		sequence = zeros(1,length(pitch)) ;
      		if nargin < 4 || isempty(data)
        		data = {} ;
        		data.actual_key_duration = 1 ;
        		data.key_to_duration = containers.Map('KeyType', 'int32', 'ValueType', 'double') ;
        		data.duration_to_key = containers.Map('KeyType', 'double', 'ValueType', 'int32') ;
        		data.actual_key_pitch = 1 ;
        		data.key_to_pitch = containers.Map('KeyType', 'int32', 'ValueType', 'double') ;
        		data.pitch_to_key = containers.Map('KeyType', 'double', 'ValueType', 'int32') ;
        		data.actual_key_value = 1 ;
				data.key_to_value = containers.Map('KeyType', 'int32', 'ValueType', 'any') ;
        		data.value_to_key = containers.Map('KeyType', 'char', 'ValueType', 'int32') ;
      		end
      		for i = 1:length(pitch)
      			if strcmp(seq_type,'duration') || strcmp(seq_type,'product') || strcmp(seq_type,'sum')
        			if ~ data.duration_to_key.isKey(duration(i))
          				data.duration_to_key(duration(i)) = data.actual_key_duration ;
          				data.key_to_duration(data.actual_key_duration) = duration(i) ;
          				data.actual_key_duration = data.actual_key_duration + 1 ;
        			end
        		end
        		if strcmp(seq_type,'pitch') || strcmp(seq_type,'product') || strcmp(seq_type,'sum')
        			if ~ data.pitch_to_key.isKey(pitch(i))
          				data.pitch_to_key(pitch(i)) = data.actual_key_pitch ;
          				data.key_to_pitch(data.actual_key_pitch) = pitch(i) ;
          				data.actual_key_pitch = data.actual_key_pitch + 1 ;
        			end
        		end
        		if strcmp(seq_type,'product') || strcmp(seq_type,'sum')
					value = [data.pitch_to_key(pitch(i)), data.duration_to_key(duration(i))];
					value_str = Utils.hash(value);
        			if ~data.value_to_key.isKey(value_str)
          				key = data.actual_key_value ;
						data.key_to_value(data.actual_key_value) = value ;
          				data.value_to_key(value_str) = key;
          				data.actual_key_value = data.actual_key_value + 1 ;
          			else
						key = data.value_to_key(value_str);
        			end
        			sequence(i) = key ;
        			data.size_alphabet = data.actual_key_value-1;
        		elseif strcmp(seq_type,'duration')
        			sequence(i) = data.actual_key_duration-1 ;
        			data.size_alphabet = data.actual_key_duration-1;
        		elseif strcmp(seq_type,'pitch')
        			sequence(i) = data.actual_key_pitch-1 ;
        			data.size_alphabet = data.actual_key_pitch-1;
        		else
        			error('Unknown seq_type.');
        		end
            end
            %sequence
    	end

        function [ pitch, data ] = product_sequence_to_pitch_sequence(sequence, data)
              pitch = zeros(1, length(sequence)) ;
              for i = 1:length(sequence)
                e = data.key_to_value(sequence(i)) ;
                pitch(i) = e(1) ;
              end
        end

        function [ duration, data ] = product_sequence_to_duration_sequence(sequence, data)
              duration = zeros(1, length(sequence)) ;
              for i = 1:length(sequence)
                e = data.key_to_value(sequence(i)) ;
                duration(i) = e(2) ;
              end
        end
        
        function [ sum_sequence, data ] = product_sequence_to_sum_sequence(sequence, data)
              sum_sequence = zeros(1, 2*length(sequence)) ;
              pitch_len = length(data.key_to_pitch.keys) ;
              for i = 1:length(sequence)
                e = data.key_to_value(sequence(i)) ;
                d = e(2) ;
                p = e(1) ;
                sum_sequence(2*i-1)=p ;
                sum_sequence(2*i)= d + pitch_len ;                
              end
        end

        function [sequence_alphabet] = use_alphabet(sequence, alphabet)
              sequence_alphabet = alphabet(sequence) ;
        end

	end

end
