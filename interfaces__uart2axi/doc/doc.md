[IP Library](../../doc.md) > uart2axi


# UART 2 AXI

This module translates a UART stream to AXI4 transactions.


## Block Diagram

![address map](figs/bd.svg)


## Paramters

| Name | Default | Description |
|------|---------|-------------|
| ACLK_FREQUENCY  | 200000000 | The frequency for the reference AClk
| BAUD_RATE       | 9600      | UART baud rate used for synthesis
| BAUD_RATE_SIM   | 50000000  | UART baud rate used for simulation (used to reduce simulation time)
| START_BYTE      | 'h7D      | Byte used to indicate start of packet
| STOP_BYTE       | 'h7E      | Byte used to indicate end of packet
| ESCAPE_BYTE     | 'h7F      | byte used to escape data bytes in packet


## Interfaces

| Name  | Type |        | Description |
|-------|------|--------|-------------|
| uart  | UART | slave  |
| m_axi | AXI4 | master |


## Ports

| Name  | Direction | Description |
|-------|-----------|-------------|
| aclk    | in  | AXI Clock. Used to sample UART signals
| aresetn | in  | AXI Reset. This signal is active-Low

