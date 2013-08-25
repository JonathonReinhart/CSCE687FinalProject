import sys
import wave
import struct
import itertools
from pylab import *

'''
    ### Reading

    # Open the wave file
    inwav = wave.open(infilename, 'r')
    
    # Get its params
    (nchannels, sampwidth, framerate, nframes, comptype, compname) = inwav.getparams()
    
    # Read and unpack frames
    # This will correctly format the data (be it 8, 16, 32 bit data),
    # and return a tuple of channel data.
    # For a mono recording, it would return (monodata)
    # For a stereo recording, it would return (lchannel, rchannel)
    channel_data = wav_unpack(inwav)
    
    
    
    ### Writing
    # Automatically determines how many channels you give it
    
    wav_save('temp.wav', framerate, sampwidth, *channel_data)
    
    # or
    
    lchannel = channel_data[0]
    rchannel = channel_data[1]
    wav_save('temp.wav', framerate, sampwidth, lchannel, rchannel)

'''


# http://stackoverflow.com/a/1751478/119527        
def _chunks(l, n):
    return ( l[i:i+n] for i in xrange(0, len(l), n) )
    
# Inspired by http://stackoverflow.com/questions/7946798   
def _interleave(*args):
    return [each_val for each_tuple in zip(*args) for each_val in each_tuple]    
    
        
# Convert each pair of bytes into a signed 16-bit value        
def _str_to_s16_array(s): 
    return (struct.unpack('<h', x)[0] for x in _chunks(s, 2))
    
# Convert each byte into a signed 8-bit value    
def _str_to_s8_array(s):
    return (struct.unpack('<b', x)[0] for x in s)

def s16_array_to_str(ar):
    return ''.join(struct.pack('<h', x) for x in ar)
    
def s8_array_to_str(ar):
    return ''.join(struct.pack('<b', x) for x in ar)
    


###############################################################################
# Unpack WAV byte stream into channel data
    

# 16-bit stereo data looks like:
# LL0 RR0 LL1 RR1 ...
def _unpack_stereo_16(data):
    samps = _str_to_s16_array(data)

    #return (itertools.islice(samps, 0, None, 2), itertools.islice(samps, 1, None, 2))
    samps = list(samps)
    return (samps[0::2], samps[1::2])
    
# 16-bit mono data looks like:
# MM0 MM1 MM2 ...
def _unpack_mono_16(data):
    return (list(_str_to_s16_array(data)), )
    
# 8-bit stereo data looks like:
# L0 R0 L1 R1
def _unpack_stereo_8(data):
    samps = _str_to_s8_array(data)
    
    #return (itertools.islice(samps, 0, None, 2), itertools.islice(samps, 1, None, 2))
    samps = list(samps)
    return (samps[0::2], samps[1::2])
    
# 8-bit mono data looks like:
# M0 M1 M2 ...
def _unpack_mono_8(data):
    return (list(_str_to_s8_array(data)), )
    
def wav_unpack(wav, n=None):
    (nchannels, sampwidth, framerate, nframes, comptype, compname) = wav.getparams()
    
    if n == None: n = nframes   # get all
    
    data = wav.readframes(n)
    
    sel = (nchannels,sampwidth*8)
    if sel == (1, 8):  return _unpack_mono_8(data)
    if sel == (2, 8):  return _unpack_stereo_8(data)
    if sel == (1, 16): return _unpack_mono_16(data)
    if sel == (2, 16): return _unpack_stereo_16(data)
    raise Exception('Unsupported format: {0} channels, {1}-bit samples'.format(*sel))

    
###############################################################################
# Pack channel data into WAV byte stream

def _pack_mono_8(mchan):
    return s8_array_to_str(mchan) 
    
def _pack_stereo_8(lchan, rchan):
    interleaved = _interleave(lchan, rchan)
    return s8_array_to_str(interleaved)

def _pack_mono_16(mchan):
    return s16_array_to_str(mchan) 
    
def _pack_stereo_16(lchan, rchan):
    interleaved = _interleave(lchan, rchan)
    return s16_array_to_str(interleaved)
    
    
def wav_save(filename, samprate, sampwidth, *channels):
    
    nchannels = len(channels)
    sel = (nchannels,sampwidth*8)
    if   sel == (1, 8):  data = _pack_mono_8(*channels)
    elif sel == (2, 8):  data = _pack_stereo_8(*channels)
    elif sel == (1, 16): data = _pack_mono_16(*channels)
    elif sel == (2, 16): data = _pack_stereo_16(*channels)
    else:
        raise Exception('Unsupported format: {0} channels, {1}-bit samples'.format(*sel))
    
    wav = wave.open(filename, 'wb')
    wav.setparams((nchannels, sampwidth, samprate, 0, 'NONE', 'noncompressed'))
    wav.writeframes(data)
    wav.close()
    


###############################################################################

def main(args):
    if len(args) < 1:
        print 'Usage: xxx.py infile.wav'
        return 1
        
    infilename = args[0]
    inwav = wave.open(infilename, 'r')
    (nchannels, sampwidth, framerate, nframes, comptype, compname) = inwav.getparams()
    
    print 'Read {0}'.format(infilename)
    print '  Channels:       {0}'.format(nchannels)
    print '  Sample Width:   {0} bits'.format(sampwidth*8)
    print '  Sampling Freq:  {0} Hz'.format(framerate)
    print '  # of Frames:    {0} ({1} sec)'.format(nframes, nframes/float(framerate))
    
    Tmax = 6.0
    N = int(framerate*Tmax)
    data = wav_unpack(inwav, N)
    t = linspace(0.0, Tmax, N)
    
    print 'data:', type(data)
    print 'data[0]:', type(data[0])
    
    
    if nchannels == 1:
        figure()
        plot(t, data[0])
        
    elif nchannels == 2:
        fig = figure()
        ax = fig.add_subplot(2,1,1)
        ax.set_title('Left channel')
        ax.plot(t, data[0])
        
        ax = fig.add_subplot(2,1,2)
        ax.set_title('Right channel')
        ax.plot(t, data[1])
        
    else:
        print 'Cannot show plot with {0} channels.'.format(nchannels)
    
    show()
    
    
    #wav_save('temp.wav', framerate, sampwidth, *data)
    lchannel = data[0]
    rchannel = data[1]
    wav_save('temp.wav', framerate, sampwidth, lchannel, rchannel)
    
    return 0
    

if __name__ == '__main__':
    sys.exit(main(sys.argv[1:]))



