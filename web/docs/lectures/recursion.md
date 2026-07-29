# Recursion, IIR Filters, Echo, and Physical Modeling

## Recursion in Faust

* Recursion in Faust can be expressed with [recursive composition `~`](https://faustdoc.grame.fr/manual/syntax/#recursive-composition).
* The equation \(y(n) = x(n) + y(n-1)\) can be implemented in Faust as follows:

<p>
<faust-editor>
<!--
process = +~_;
-->
</faust-editor>
</p>

* The expression on the left of the operator corresponds to the signal traveling from left to right in the block diagram, and the expression on the right to the signal traveling from right to left.
* This type of construction can be used to implement counters:

<p>
<faust-editor>
<!--
process = _~+(1) : -(1);
-->
</faust-editor>
</p>

This produces the signal: \(y(n) = 0,1,2,3,4,...\)

* `~` automatically introduces a one-sample delay in the recursive signal. This is necessary because the equation \(y(n) = x(n) + y(n)\) cannot be solved, since the value of \(y(n)\) cannot be known in advance.

## Sine-Wave Oscillator

* The following tutorial, <https://faustdoc.grame.fr/tutorials/basic-osc/>, shows how a sine-wave oscillator can be implemented from scratch in Faust.

## One-Pole Filter

* The [one-pole filter](https://ccrma.stanford.edu/~jos/fp/One_Pole.html) is the simplest type of recursive filter (IIR: Infinite Impulse Response). Its difference equation is: \(y(n) = x(n) - a_{1}y(n-1)\).
* \(a_{1}\) is the filter pole and can have a value between -1 (low-pass) and 1 (high-pass). In practice, \(a_{1}\) can never reach -1 or 1, as this would make the filter unstable.
* This filter can be implemented simply in Faust:

<p>
<faust-editor>
<!--
import("stdfaust.lib");
onePole(a1) = +~*(a1);
pole = hslider("pole",0,-1,1,0.01);
process = no.noise : onePole(pole);
-->
</faust-editor>
</p>

* Note that Faust's [`si.smooth`](https://faustlibraries.grame.fr/libs/signals/#sismooth) function is based on a normalized version of this filter:

```
smooth(s) = *(1.0 - s) : + ~ *(s);
```

## Feedback Comb Filter

* Adding a longer delay to the previous filter turns it into a [feedback comb filter](https://ccrma.stanford.edu/~jos/pasp/Feedback_Comb_Filters.html):

<p>
<faust-editor>
<!--
import("stdfaust.lib");
fdbComb(del,a1) = +~de.delay(1024,del)*(a1);
d = hslider("delay",0,0,1023,1);
pole = hslider("pole",0,-1,1,0.01);
process = no.noise : fdbComb(d,pole);
-->
</faust-editor>
</p>

* This filter behaves similarly to the feedforward comb filter studied in [the previous lecture](delays.md), except that its "lobes" have a much more aggressive effect.
* Note that the flanger from [the previous lecture](delays.md) can be reimplemented using this feedback comb filter.

## Echo

* Increasing the delay duration of the feedback comb filter from the previous section turns it into an echo:

<p>
<faust-editor>
<!--
import("stdfaust.lib");
echo(duration,feedback) = +~de.delay(50000,del)*(feedback)
with{
  del = duration*ma.SR;
};
instrument(repeat) = ba.pulsen(1,n) <: pm.djembe(50+rand*50,0.5,0.5,1)
with{
  n = repeat*ma.SR;
  rand(trig) = no.noise : ba.sAndH(trig : ba.impulsify);
};
d = hslider("duration",0.25,0,1,0.01);
f = hslider("feedback",0.5,0,1,0.01);
process = instrument(0.25) : echo(d,f);
-->
</faust-editor>
</p>

* A duration in seconds (\(d_{s}\) can be converted into a duration in samples (\(d_{n}\) using the sampling rate (\(fs\) with the following formula: \(d_{n} = d_{s}fs\).

## A Simple Physical Model: Karplus–Strong

* [Karplus–Strong](https://ccrma.stanford.edu/~jos/pasp/Karplus_Strong_Algorithm.html) is a primitive and simplified form of [digital-waveguide](https://ccrma.stanford.edu/~jos/pasp/Digital_Waveguide_Models.html) string physical modeling.
* The string is implemented with a delay (the longer the delay, the longer the string).
* Reflections at its ends are produced by the feedback loop.
* Dispersion at the ends is implemented with a low-pass filter, simulating the disappearance of high frequencies before low frequencies.
* One possible implementation of Karplus–Strong in Faust is:

<p>
<faust-editor>
<!--
import("stdfaust.lib");
ks(freq,damp) = +~(de.fdelay4(1024,del) : dispersion)
with{
  del = ma.SR/freq;
  dispersion = _ <: _,_' :> /(2) : *(1-damp) ;
};
f = hslider("freq",300,50,2000,0.01);
d = hslider("damping",0.01,0,1,0.01);
gate = button("gate");
process = gate : ba.impulsify : ks(f,d);
-->
</faust-editor>
</p>

* Note the use of a fractional delay to ensure that the string is in tune.

<script src="https://cdn.jsdelivr.net/npm/@grame/faust-web-component@0.6.1/dist/faust-web-component.js"></script>
