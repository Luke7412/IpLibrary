[IP Library](../../doc.md) > Identifier


# Identifier

This module helps identify a build by providing project meta data.


## Parmeters

| Name | Default | Description |
|------|---------|-------------|
| NAME            | "TEST"  | The name of the build. Max 16 characters
| MAJOR_VERSION   | 1       | The major version of the build
| MINOR_VERSION   | 0       | The minor version of the build


## Registers

| Address<br/>Offset  | Register<br/>Name | Access<br/>Type | Description |
|---------------------|-------------------|-----------------|-------------|
| 0x04 - 0x10   | Name      | R   | 16 ascii characters forming a name 
| 0x14          | Version   | R   | [31:16]: Maor Version<br/>[15:0]: Minor Version