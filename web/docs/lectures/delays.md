# Delays, Filters, and Related Effects

## Delays in Faust

* A one-sample delay in Faust can be expressed with [the `'` primitive](https://faustdoc.grame.fr/manual/syntax/#time-expression). Thus:

```
process = _';
```

adds a one-sample delay to the input signal.

* The difference equation corresponding to this operation is: \(x(n) = x(n-1)\).
* This primitive can be chained. Thus:

```
process = _''';
```

adds a three-sample delay to the input signal.

* The corresponding difference equation is: \(x(n) = x(n-3)\).
* An arbitrary number of delay samples can be specified with [the `@` primitive](https://faustdoc.grame.fr/manual/syntax/#time-expression_1). Thus:

```
process = @(5);
```

adds a five-sample delay to the input signal.

* The corresponding difference equation is: \(x(n) = x(n-5)\).
* A duration in seconds (\(t_{s}\) can be converted into a number of samples (\(t_{n}\) with: \(t_{n} = t_{s}fs\).
* A "dynamic" integer delay can be specified using [`de.delay`](https://faustlibraries.grame.fr/libs/delays/#dedelay):

<p>
<faust-editor>
<!--
maxDel = 1024;
del = hslider("delay",1,1,1023,1);
process = de.delay(maxDel,del);
-->
</faust-editor>
</p>

where `maxDel` is the maximum delay length and `del` is the delay length (an integer).

* A "dynamic" fractional delay can be specified using [`de.fdelay`](https://faustlibraries.grame.fr/libs/delays/#defdelay):

<p>
<faust-editor>
<!--
maxDel = 1024;
del = hslider("delay",1,1,1023,0.01);
process = de.fdelay(maxDel,del);
-->
</faust-editor>
</p>

where `maxDel` is the maximum delay length and `del` is the delay length (which may be fractional).

## Doppler Effect

* Dynamically changing the length of a delay transposes the pitch of the sound it processes. This is known as the [Doppler effect](https://fr.wikipedia.org/wiki/Effet_Doppler).
* A delay can also be expressed as a distance (assuming that the speed of sound in air is \(c = 340 m/s\). To convert a distance in meters to a number of samples, use: \(d_{s} = d_{m}fs/c\), where $\(d_{s}\) is the distance in samples, \(d_{m}\) is the distance in meters, and \(c\) is the speed of sound in air.
* A Faust implementation of the Doppler effect could be:

<p>
<faust-editor>
<!--
import("stdfaust.lib");
doppler(distance,freq) = de.fdelay4(100000,d*osc+1)
with{
  d = distance*ma.SR/340;
  osc = os.osc(freq)*0.5+0.5;
};
d = hslider("distance",340,0.1,600,0.01); // in meters 
f = hslider("frequency",0.1,0.01,2,0.01);
process = doppler(d,f);	
-->
</faust-editor>
</p>

## Nonrecursive "One-Zero" Filters (FIR)

* The "simplest" filter consists in adding a signal to a version delayed by one sample: $\(y(n) = b_{0}x(n)+b_{1}x(n-1)\).
* This is called a "[one-zero filter](https://ccrma.stanford.edu/~jos/fp/One_Zero.html)" because its transfer function has no denominator. It belongs to the FIR (Finite Impulse Response) filter family.
* The sign of \(b_{1}\) determines the filter type: low-pass if \(b_{1}\) is positive, high-pass if \(b_{1}\) is negative.
* It can be implemented simply in Faust:

<p>
<faust-editor>
<!--
import("stdfaust.lib");
oneZero(b1) = _ <: _,_'*b1 :> _;
zero = hslider("zero",0,-1,1,0.01) : si.smoo;
process = oneZero(zero);
-->
</faust-editor>
</p>

## Feedforward Comb Filter

* The [feedforward comb filter](https://ccrma.stanford.edu/~jos/pasp/Feedforward_Comb_Filters.html) is similar to the one-zero filter, except that it uses a delay longer than one sample:

<p>
<faust-editor>
<!--
import("stdfaust.lib");
ffComb(del,ff) = _ <: _,de.delay(128,del)*ff :> _;
d = hslider("delay",1,1,127,1);
f = hslider("feedForward",1,0,1,0.01) : si.smoo;
process = ffComb(d,f);
-->
</faust-editor>
</p>

* The frequency response of this filter resembles a "comb," hence its name.

## Flanger

* [Flanging](https://en.wikipedia.org/wiki/Flanging) is one of the most classic effects in the electric guitarist's toolbox.
* It consists in modulating the delay of a comb filter with an oscillator:

<p>
<faust-editor>
<!--
import("stdfaust.lib");
ffComb(del,ff) = _ <: _,de.delay(128,del)*ff :> _;
flanger(freq,depth,ff) = ffComb(del,ff)
with{
  del = os.osc(freq)*0.5 + 0.5 : +(1) : *(depth);
};
freq = hslider("freq",1,0.1,50,0.01) : si.smoo;
depth = hslider("depth",1,0,100,0.01) : si.smoo;
ff = hslider("feedForward",1,0,1,0.01) : si.smoo;
process = no.noise : flanger(freq,depth,ff);
-->
</faust-editor>
</p>

## Exporting a Faust Program as a Plug-in With JUCE

* Install [JUCE](https://juce.com/).
* Install Visual Studio on Windows or Xcode on macOS.
* Ensure that the "Global Paths" (`File/Global Paths`) are configured correctly in the [Projucer](https://juce.com/download/).
* Choose the `Juce/plug-in` export target in the Faust IDE.
* Open the generated project with the Projucer.
* Go to "Modules" in the left-hand menu, click the small cog at the bottom next to "+," then click "Enable/disable global paths for modules."
* Go to `File/Save Project`.
* Select the exporter corresponding to your platform, then open the project in Visual Studio, Xcode, or the Makefiles.
* Compile the project.

## Assignment

* This assignment must be sent to Romain by email **before ??? (9:00 am)**.

### Plug-in

* The goal is to create a plug-in with Faust for your preferred platform. It may take the form of a VST, Audio Unit, Max, Pure Data, or CSOUND object, etc. The only requirement is to produce an object that can be used in another environment.
* The real objective is for it to fit into your own computer-music/RIM practice.
* Experiment with the synthesis techniques studied in Sessions 1, 2, and 3, and implement mappings that allow them to be controlled in subtle ways.
* Be creative and have fun!
* Try to create a tool that others can use: package it as clearly as possible (e.g., README, installation procedure, etc.).
* When your plug-in is ready, make a short demonstration video (cell phones are fine).
* Post it online (e.g., YouTube).
* Send the video link and the Faust code for your instrument to Romain.

### Final Project

* Prepare three final-project ideas that you will present in class on ???.

<script src="https://cdn.jsdelivr.net/npm/@grame/faust-web-component@0.6.1/dist/faust-web-component.js"></script>
