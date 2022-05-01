# Hello world!

**Very early stage. Sketches, documentation, large experiment still to come.**

In this repository, our minimal Hello World example is
living off our approach to orchestrate workload in OT.

A Fischertechnik simulation model is used as the starting
point (https://www.fischertechnik.de/de-de/produkte/simulieren/simulationsmodelle/50464-sim-transportband-24v).

This is controlled via Python and driven from left to right
and then from right to left.

If the workpiece on the line passes the light barrier, the
line is stopped and the direction is changed after 5 seconds.

## Demonstrator

<p align="center">
  <img src="https://raw.githubusercontent.com/sdm4fzi/hello-world/main/images/hardware-1.png" />
</p>

## Usage

Execute the following commands on ``plc1``:

```
sudo podman pull ghcr.io/sdm4fzi/hello-world:latest
sudo podman run --privileged -it ghcr.io/sdm4fzi/hello-world:latest
```

## Build pipeline
