#!/usr/bin/env python

# Just for testing
import sys
from midiutil.MidiFile import MIDIFile
import subprocess

# Converts sequence [seq] to the midi file [path].
def convert_to_file(seq, path, rel=0):
    degrees  = [60, 62, 64, 65, 67, 69, 71, 72] # MIDI note number
    track    = 0
    channel  = 0
    time     = 0   # In beats
    tempo    = 80  # In BPM
    volume   = 100 # 0-127, as per the MIDI standard

    MyMIDI = MIDIFile(1) # One track, defaults to format 1 (tempo track
                         # automatically created)
    MyMIDI.addTempo(track,time, tempo)
    
    for (p,d) in seq:
        if (p!=0 and p!=99):
            MyMIDI.addNote(track, channel, p, time, d, volume)
        time = time + d

    with open(path, "wb") as output_file:
        MyMIDI.writeFile(output_file)

def play(seq):
    convert_to_file(seq, 'tmp.mid')
    subprocess.call(['timidity', 'tmp.mid'])
