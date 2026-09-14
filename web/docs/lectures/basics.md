# Basics

## Resources

* [Faust](https://faust.grame.fr) online editor: <https://faustide.grame.fr>
* Faust documentation: <https://faustdoc.grame.fr>
* Faust signal-processing library documentation: <https://faustlibraries.grame.fr>
* Additional information on sampling theory (in French) can be found here: <https://inria-emeraude.github.io/ujm-acoustique/lectures/son-numerique/>
* Additional information on sampling theory (in English) can be found here: <https://inria-emeraude.github.io/son-ens/lectures/audio-dsp/>

## Key Points

* To run the program, press the "Run" button.
* Code for a sine-wave oscillator with a fixed frequency:

<p>
<faust-editor>
<!--
import("stdfaust.lib");
process = os.osc(440);
-->
</faust-editor>
</p>

* Note that `import("stdfaust.lib");` is required in order to call `os.osc`.
* Code for an oscillator with a dynamic frequency:

<p>
<faust-editor>
<!--
import("stdfaust.lib");
freq = hslider("freq",440,50,1000,0.01);
process = os.osc(freq);
-->
</faust-editor>
</p>

* The waveform produced by this program can be viewed by clicking "Plot First Samples" and opening the “Plot” tab:

<img src="../../res/sine.jpg" width="100%" class="mx-auto d-block">

* The list of samples (values) produced by the program can be viewed by clicking "oscilloscope" in the upper-left corner of the waveform window until the “data” view appears:

<img src="../../res/sine_data.jpg" width="100%" class="mx-auto d-block">

* A digital signal (a list of values) such as the one in the previous figure can be denoted mathematically as \(x(n)\).
* These values are sent directly by the computer to the sound card/audio interface, whose role is to "transform" them into an analog signal.
* The sampling rate is the number of values (samples) per second. It is denoted mathematically by \(f_s\).
* The highest frequency that can be sampled is called the Nyquist frequency and is equal to \(f_s/2\).
* The standard range of a digital signal is -1.0 to +1.0. If sample values exceed this range, the resulting sound will be clipped.
* The line:

```
process = os.osc(freq);
```

from the previous code can be changed to generate other waveforms:

```
process = os.triangle(freq); // triangle wave
process = os.square(freq); // square wave
process = os.sawtooth(freq); // sawtooth wave
process = no.noise; // white noise
```

* Each waveform produces a different sound and has specific [harmonic content](https://fr.wikipedia.org/wiki/Harmonique_(musique)), which can be viewed with the spectroscope in the editor's right-hand window:

<img src="../../res/spectro.jpg" width="100%" class="mx-auto d-block">

* Adding signals is equivalent to mixing them:

```
process = os.sawtooth(500) + os.triangle(400);
```

* Here, a sawtooth wave and a triangle wave are mixed.
* Subtracting signals is equivalent to mixing them with a phase inversion:

```
process = os.sawtooth(500) - os.triangle(400);
```

* When signals are added, the resulting signal may clip (yes, yes, 1 + 1 = 2...).
* Multiplying or dividing a signal by a constant changes its gain:

```
process = os.sawtooth(500)*0.5;
```

* Defining the `freq`, `gain`, and `gate` parameters in Faust code allows it to be controlled with a polyphonic MIDI keyboard:

<p>
<faust-editor>
<!--
import("stdfaust.lib");
freq = hslider("freq",440,50,1000,0.01);
gain = hslider("gain",1,0,1,0.01);
gate = button("gate");
process = os.sawtooth(freq)*gain*gate;
-->
</faust-editor>
</p>

* For this to work in the [web editor](https://faustide.grame.fr), "Activate MIDI polyphonic mode" must be enabled.

## Assignment

* This assignment must be submitted using this form: <https://forms.gle/5ZC8pv3Xpu3TacL7A> **before 23/09/2026 (9 am)**.
* Fill out the form only once. You will **not** receive a confirmation email.
* You are not alone! Feel free to email your questions if you get stuck.

### Problem 1: Adding Two Signals (3 Points)

The first four samples of signals \(x_0(n)\) and \(x_1(n)\) are defined as:

\(x_0(n) = \{0.432,0.547,-0.892,-0.795\}\)

\(x_1(n) = \{-0.544,-0.341,-0.690,0.211\}\)

Let \(y(n) = x_0(n) + x_1(n)\).

**Calculate the values of the first four samples of \(y(n)\).**

### Problem 2: Changing the Gain of a Signal (2 Points)

The first four samples of signal \(x(n)\) are defined as:

\(x(n) = \{0.432,0.547,-0.892,-0.795\}\) (so \(x(n) = x_0(n)\): yes, yes, I am a little lazy too... ;) )

We want to reduce the gain of \(x(n)\) by half, so we define:

$$
y(n) = \frac{x(n)}{2}
$$

**Calculate the values of the first four samples of \(y(n)\).**

### Problem 3: Sampling Rate (1 Point)

Signal \(x(n)\) has a sampling rate of \(f_s=96KHz\). **What is the Nyquist frequency of this signal?**

### Project (14 Points)

* Design a musical instrument in Faust that can be controlled in the online editor with a MIDI keyboard or computer keyboard.
* The instrument must contain at least two sound generators (e.g., an oscillator or white noise).
* Be creative and feel free to try connecting things together. For example, one oscillator could control another:

```
import("stdfaust.lib");
process = os.sawtooth(440 + os.osc(10)*100);
```

* Think about how your instrument could fit into your own musical practice.
* When the instrument is ready, make a short demonstration video (cell phones are fine). It may simply document the instrument, show you jamming with your new favorite instrument, etc.—the choice is yours.
* Post the video online (e.g., YouTube).
* Send the video link and the Faust code for your instrument to Romain.
* Most importantly, have fun!

<script src="https://cdn.jsdelivr.net/npm/@grame/faust-web-component@0.6.1/dist/faust-web-component.js"></script>
