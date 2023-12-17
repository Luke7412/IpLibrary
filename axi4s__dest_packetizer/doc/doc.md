[IP Library](../../doc.md) > Dest Packetizer


# Dest Packetizer

This module consists of 2 sub modules:

- Dest Insert: Inserts TID into AXI4-Stream data packets.
- Dest Extract: Extracts TId from incomming AXI4-Stream data frames.


## Block Diagram

![block diagram](figs/bd.svg)


## Interfaces

| Name  | Type |        | Description |
|-------|------|--------|-------------|
| rx_frame  | AXI4-Stream | target    |
| rx_packet | AXI4-Stream | initiator |
| tx_frame  | AXI4-Stream | initiator |
| tx_packet | AXI4-Stream | target    |


## Ports

| Name  | Direction | Description |
|-------|-----------|-------------|
| aclk    | in  | AXI Clock.
| aresetn | in  | AXI Reset. This signal is active-Low

