# Signals in Faust, Amplitude Modulation, and Subtractive Synthesis

## Faust Targets

* An overview of Faust targets is provided in the language documentation: <https://faustdoc.grame.fr/manual/tools/#faust2-tools>.
* Most of them are available through the “Export” function (truck icon) in the [online editor](https://faustide.grame.fr).

## Signal Algebra in Faust

* Faust's diagram composition operators are described in detail in the corresponding section of the language documentation: <https://faustdoc.grame.fr/manual/syntax/#diagram-expressions>.
* You are advised to read the entire “Diagram Expressions” section.

## Panning

* A panner controlling the amount of signal sent to two separate channels can be implemented quite simply in Faust:

```
import("stdfaust.lib");
panner(p) = _ <: *(1-p),*(p);
pan = hslider("pan",0,0,1,0.01) : si.smoo;
process = panner(pan);
```

* If clicks occur, the signal produced by a user-interface element can be smoothed using `si.smoo`.

## Auto Pan

* The `panner` function from the previous step can be reused to implement an “auto pan” effect by controlling the `pan` parameter with a low-frequency oscillator (LFO):

```
import("stdfaust.lib");
panner(p) = _ <: *(1-p),*(p);
autoPan(freq,depth) = panner(p) 
with{
  p = 0.5 + os.osc(freq)*0.25*depth;
};
d = hslider("depth",0,0,1,0.01) : si.smoo;
f = hslider("freq",1,0.01,10,0.01) : si.smoo;
process = autoPan(f,d);
```

## Ring Modulation (Amplitude Modulation)

* [Ring modulation](https://en.wikipedia.org/wiki/Ring_modulation) consists in modulating the amplitude of a signal with an oscillator.

```
import("stdfaust.lib");
ringMod(freq,depth) = *(1-mod)
with{
  mod = (os.osc(freq)*0.5 + 0.5)*depth;
};
d = hslider("depth",0,0,1,0.01) : si.smoo;
f = hslider("freq",100,0.01,5000,0.01) : si.smoo;
process = ringMod(f,d);
```

* When ring modulation is applied to a sinusoid, sidebands appear with the following distribution: <https://ccrma.stanford.edu/~jos/st/Example_AM_Spectra.html>

## Subtractive Synthesis

* The most common/standard filters in Faust are:
    * [`fi.resonlp`](https://faustlibraries.grame.fr/libs/filters/#firesonlp): resonant low-pass
    * [`fi.resonbp`](https://faustlibraries.grame.fr/libs/filters/#firesonbp): resonant band-pass
    * [`fi.resonhp`](https://faustlibraries.grame.fr/libs/filters/#firesonhp): resonant high-pass
    * [`fi.lowpass`](https://faustlibraries.grame.fr/libs/filters/#filowpass): Butterworth low-pass
    * [`fi.highpass`](https://faustlibraries.grame.fr/libs/filters/#filowpass): Butterworth high-pass
* Subtractive synthesis consists in filtering a spectrally rich sound to “sculpt” its spectrum.
* This type of synthesis can easily be implemented in Faust:

```
import("stdfaust.lib");
subSynth(freq,ctFreq) = os.sawtooth(freq) : fi.lowpass(3,ctFreq);
f = hslider("freq",400,50,5000,0.01);
cf = hslider("ctFreq",5000,50,10000,0.01) : si.smoo;
gain = hslider("gain",1,0,1,0.01);
gate = button("gate");
envelope = en.adsr(0.1,0.01,0.8,0.1,gate)*gain;
process = subSynth(f,cf*(0.5+envelope*0.5))*envelope;
effect = dm.zita_light;
```

* Resonant filters behave more aggressively depending on their *Q* value:

```
import("stdfaust.lib");
subSynth(freq,ctFreq,q) = os.sawtooth(freq) : fi.resonlp(ctFreq,q,1);
f = hslider("freq",400,50,5000,0.01);
cf = hslider("ctFreq",5000,50,10000,0.01) : si.smoo;
q = hslider("q",5,1,20,0.01) : si.smoo;
gain = hslider("gain",1,0,1,0.01);
gate = button("gate");
envelope = en.adsr(0.1,0.01,0.8,0.1,gate)*gain;
process = subSynth(f,cf*(0.5+envelope*0.5),q)*envelope;
effect = dm.zita_light;
```

* Resonant filters can also be used to synthesize sound:

```
import("stdfaust.lib");
impFreq = hslider("impFreq",7,1,20,0.01) : si.smoo;
q = hslider("q",20,1,30,0.01) : si.smoo;
freq = hslider("freq",440,50,5000,0.01);
gain = hslider("gain",1,0,1,0.01);
gate = button("gate");
process = os.lf_imptrain(impFreq) : fi.resonlp(freq,q,1)*gain*gate*4;
effect = dm.zita_light;		
```

## Assignment: Object Generated With Faust

* This assignment must be sent to me by email **before 04/12/2025 (9:00 a.m.)** at: romain_POINT_michon_AT_inria_POINT_fr.
* The goal is to use the Faust online IDE's Export function to produce an “object” of your choice: a smartphone application, web application, plug-in, etc.
* Experiment with the synthesis techniques studied in Sessions 1 and 2, and implement mappings that allow them to be controlled in subtle ways.
* Put yourself in the shoes of a “digital instrument maker” and build a meaningful instrument or “sound toy.”
* Be creative and have fun!
* Feel free to go beyond what is required and challenge yourself! :)
* When your instrument is ready, make a short demonstration video (cell phones are fine).
* Post the video online (e.g., YouTube).
* Send me the video link and the Faust code for your instrument: romain_POINT_michon_AT_inria_POINT_fr.
