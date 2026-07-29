import("stdfaust.lib");
freq = hslider("freq",440,50,1000,0.01);
process = os.osc(freq);