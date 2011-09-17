Project Description:

In this design, the decoding process of MP3 decoder works as described as follows. Incoming MP3 streams are fed into the input module of the decoder and processed.  If the synchronization word is found and CRC word is successfully checked, the output main data containing scale factors and Huffman code bits are sent to a predefined buffer. Huffman decoder reads data from buffer and decodes them. The decoded scale factors are delivered to requantizer component. The output 576 frequency lines are written to main memory. Using the input scale factors, requantizer descales  the 576 small integer numbers output from Huffman decoder.  Reordering process is applied to reorder the frequency lines including short window blocks. The functionality of the last four components--- antialias, IMDCT, frequency inversion and filter bank is to transform the MP3 from frequency domain to time domain. By merging frequencies using butterfly calculations, antialias reduces the alias effects introduced from the non-ideal bandpass filter used in encoding process.  In IMDCT, 576 frequency lines are divided into 32 subbands with 18 frequency lines in each. Applying multiplications and cosine calculations to each 18 samples depending on four classes of window type, IMDCT generates samples for filter bank component. After the frequencies of the input samples are inverted by frequency inversion, filter bank exploits MCT to translate the aliased signals and filter out the undesired aliasing in translated signals by using windowing. Hence, the signals in frequency domain are converted back to their time domain origins.  A pcm sample file can be produced from filter bank component when the MP3 decoding process is completed.

File Structure:

This folder contains three directories: Huffman, IMDCT and Filterbank, each of them 
includes all the VHDL source codes of the component.

Assumptions in Design:

In this design, it is assumed that a buffer sized as 1024x8 bits provides main data including scale factors and Huffman code bits to Huffman decoder. 
Also, it is assumed that a memory with 1024x8 bits is ready for each component to write or read the output or input 576 frequency lines.

Components:

Huffman:
Under this directory, three vhdl files are provided, with which the functionality of 
Huffman decoder can be fulfilled.

-all_types.vhd
This file contains all the definitions of the types of MP3 data frame.

-huffman_tables.vhd
This file contains all the Huffman tables used in Huffman decoder including 4 constant 
tables and 34 Huffman tables.

-huffman.vhd
This file is the main module of Huffman decoder.The task of this module is to 
transform the incoming bitstream data into scale factors and original frequency lines.

The Huffman decoder is implemented as a finite state machine, in which two different 
decoding processes: scale factor decoding and Huffman decoding are performed.
In scale factor decoding, an individual process is implemented depending on the different 
window type as long, short or mixed window switching. In Huffman decoding, 576 
frequency lines are produced, which are divided into three partitions: big values, count1s 
and zeros.

IMDCT:
Under this directory, seven VHDL files are provided.Inverse Modified Discrete Cosine Transform, IMDCT, produces time samples from frequency lines in cooperation with the synthesis polyphase filter bank.In  this module, all cosine and sine values are converted to 32-bit fix point values.Four components are used by imdct.vhd, corresponding to block type 0,1,2,3.These components  perform inverse modified discrete cosine transform  and windowing calculation. 


-imdct.vhd 
This component is the top level of IMDCT module.In IMDCT, one 18*32 bits array is defined  to store temporary results, and another 576*32 bits array for previous line results. According to different block types, four components are imiplemented to calculate the output results. Each component has 18 input values (one subband), 18 temporary output values which will finally be sent to the memory, and 18 previous line values. The top level invokes these components 32 times to get 576 results. The 576 previous lines are stored in the array to be used in the next frame calculation.


-imdct_gen0.vhd
This component is used to implement the inverse modified discrete cosine transform and windowing calculation based on block type 0.


-imdct_gen1.vhd
This component is used to implement the inverse modified discrete cosine transform and windowing calculation based on block type 1.

-imdct_gen2.vhd
This component is used to implement the inverse modified discrete cosine transform and windowing calculation based on block type 2.

-imdct_gen3.vhd
This component is used to implement the inverse modified discrete cosine transform and windowing calculation based on block type 3.

-mul.vhd
Three functions are defined including 2 32 bit fix point multipliers and 1 32-bit divider.

Filterbank:

Under this directory, three main VHDL files are provided. This module is the final step in the MP3 decoding process. Each time, 32 frequency line values from the IMDCT module are applied to synthesis polyphase filter band and 32 consecutive PCM samples are produced at a time.

It contains the following process steps:
-Matrixing: Discrete cosine transform using fix point multiplier. 64 values are produced and shift into a 1024-bit barrel shifter
-Shifting: Implemented a 1024 entry barrel shifter
-Building a 512 values vector using the values in the shifter
-Windowing by 512 coefficients 
-Calculating 32 samples
-Producing 32 reconstructed PCM samples

-Filterbank.vhd:
This is the main component of this module,in which the primary processing procedures are implemented.

-Filterbank_package.vhd:
Constants, types, tables and functions for Filterbank component are defined.

-Mul.vhd:
Three functions are defined including 2 32 bit fix point multipliers and 1 32 bit divider.