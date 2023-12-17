[IP Library](../../doc.md) > VGA


# VGA

This module converts a AXI4-video-stream into a VGA stream with a configurable timing.

:warning: Input video stream must match the resolution configured in the VGA module.


## Implemented default configs

| Config Index | Resolution | Frame Rate [FPS] | AClk Frequency [MHz] |
|--------------|------------|------------------|----------------------|
| 0            | 640x350    | 70               | 25.175               |
| 1            | 640x400    | 60               | 25.175               |
| 2            | 640x480    | 60               | 25.175               |
| 3            | 800x600    | 60               | 40.000               |
| 4            | 1024x768   | 60               | 65.000               |
| 5            | 1280x1024  | 60               | 108.000              |


## Paramters

| Name | Default | Description |
|------|---------|-------------|
| DEFAULT_CONFIG  | 3 | The default configuration loaded after reset.


## Interfaces

| Name  | Type |     | Description |
|-------|------|-----|-------------|
| vga   | VGA         | master | 
| pix   | AXI4-Stream | slave  | Video stream to embed in vga timing.
| ctrl  | AXI4-Lite   | slave  |


# Ports

| Name  | Direction | Description |
|-------|-----------|-------------|
| aclk    | in  | AXI Clock. Also used to for VGA timing
| aresetn | in  | AXI Reset. This signal is active-Low
