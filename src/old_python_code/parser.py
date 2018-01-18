#!/usr/bin/env python

import sys
import re

BASE_TIME = {'r':4.0, 'b':2.0, 'n':1.0, 'c':0.5, 's':0.25, 'f':0.125, 'u':0.0625}
MULTIPLIERS = {'p': 1.5, 'm':1.25, 'l':1.75, 't': 2/3}

def parse(path):
    def rewrite_note(note_string):
        pitch_s = re.findall(r'\d+', note_string)
        pitch = int(pitch_s[0]) # Get pitch 
        duration_s = re.findall(r'\D', note_string)
        duration = BASE_TIME[duration_s[0]] # Get note type
        if len(duration_s)>1: # Get possible modifiers
            duration = duration*MULTIPLIERS[duration_s[1]]
        return (pitch,duration)
    with open(path, 'r') as f:
        seq = f.readline()
        l = seq.split()
        l = [rewrite_note(n) for n in l]
        return l

def parse_imp(path):
    print(path)
    def reeq(n):
        (p,d) = n
        return (p+64,d)
    seq = parse(path)
    return [reeq(n) for n in seq]
