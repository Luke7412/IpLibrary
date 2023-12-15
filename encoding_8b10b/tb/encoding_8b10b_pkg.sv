

package encoding_8b10b_pkg;


  typedef struct {
    string name;
    logic [7:0] data_8b;
    logic [9:0] data_10b_n;
    logic [9:0] data_10b_p;
    logic disp_flip;
    logic is_k;
  } t_8b10b_entry;


  t_8b10b_entry entries [256] = '{
    '{"D00.0", 8'b00000000, 10'b0101011001, 10'b1010100110, 0, 0},
    '{"D00.1", 8'b00100000, 10'b1100111001, 10'b1000100110, 1, 0},
    '{"D00.2", 8'b01000000, 10'b1101011001, 10'b1001000110, 1, 0},
    '{"D00.3", 8'b01100000, 10'b1110011001, 10'b0001100110, 0, 0},
    '{"D00.4", 8'b10000000, 10'b0110011001, 10'b1001100110, 0, 0},
    '{"D00.5", 8'b10100000, 10'b0110111001, 10'b0010100110, 1, 0},
    '{"D00.6", 8'b11000000, 10'b0111011001, 10'b0011000110, 0, 0},
    '{"D00.7", 8'b11100000, 10'b1100011001, 10'b0011100110, 0, 0},
    '{"D01.0", 8'b00000001, 10'b0101001110, 10'b1010110001, 0, 0},
    '{"D01.1", 8'b00100001, 10'b1100101110, 10'b1000110001, 1, 0},
    '{"D01.2", 8'b01000001, 10'b1101001110, 10'b1001010001, 1, 0},
    '{"D01.3", 8'b01100001, 10'b1110001110, 10'b0001110001, 0, 0},
    '{"D01.4", 8'b10000001, 10'b0110001110, 10'b1001110001, 0, 0},
    '{"D01.5", 8'b10100001, 10'b0110101110, 10'b0010110001, 1, 0},
    '{"D01.6", 8'b11000001, 10'b0111001110, 10'b0011010001, 0, 0},
    '{"D01.7", 8'b11100001, 10'b1100001110, 10'b0011110001, 0, 0},
    '{"D02.0", 8'b00000010, 10'b0101001101, 10'b1010110010, 0, 0},
    '{"D02.1", 8'b00100010, 10'b1100101101, 10'b1000110010, 1, 0},
    '{"D02.2", 8'b01000010, 10'b1101001101, 10'b1001010010, 1, 0},
    '{"D02.3", 8'b01100010, 10'b1110001101, 10'b0001110010, 0, 0},
    '{"D02.4", 8'b10000010, 10'b0110001101, 10'b1001110010, 0, 0},
    '{"D02.5", 8'b10100010, 10'b0110101101, 10'b0010110010, 1, 0},
    '{"D02.6", 8'b11000010, 10'b0111001101, 10'b0011010010, 0, 0},
    '{"D02.7", 8'b11100010, 10'b1100001101, 10'b0011110010, 0, 0},
    '{"D03.0", 8'b00000011, 10'b0101000011, 10'b1110100011, 1, 0},
    '{"D03.1", 8'b00100011, 10'b1100100011, 10'b1100100011, 0, 0},
    '{"D03.2", 8'b01000011, 10'b1101000011, 10'b1101000011, 0, 0},
    '{"D03.3", 8'b01100011, 10'b1110000011, 10'b0101100011, 1, 0},
    '{"D03.4", 8'b10000011, 10'b0110000011, 10'b1101100011, 1, 0},
    '{"D03.5", 8'b10100011, 10'b0110100011, 10'b0110100011, 0, 0},
    '{"D03.6", 8'b11000011, 10'b0111000011, 10'b0111000011, 1, 0},
    '{"D03.7", 8'b11100011, 10'b1100000011, 10'b0111100011, 1, 0},
    '{"D04.0", 8'b00000100, 10'b0101001011, 10'b1010110100, 0, 0},
    '{"D04.1", 8'b00100100, 10'b1100101011, 10'b1000110100, 1, 0},
    '{"D04.2", 8'b01000100, 10'b1101001011, 10'b1001010100, 1, 0},
    '{"D04.3", 8'b01100100, 10'b1110001011, 10'b0001110100, 0, 0},
    '{"D04.4", 8'b10000100, 10'b0110001011, 10'b1001110100, 0, 0},
    '{"D04.5", 8'b10100100, 10'b0110101011, 10'b0010110100, 1, 0},
    '{"D04.6", 8'b11000100, 10'b0111001011, 10'b0011010100, 0, 0},
    '{"D04.7", 8'b11100100, 10'b1100001011, 10'b0011110100, 0, 0},
    '{"D05.0", 8'b00000101, 10'b0101000101, 10'b1110100101, 1, 0},
    '{"D05.1", 8'b00100101, 10'b1100100101, 10'b1100100101, 0, 0},
    '{"D05.2", 8'b01000101, 10'b1101000101, 10'b1101000101, 0, 0},
    '{"D05.3", 8'b01100101, 10'b1110000101, 10'b0101100101, 1, 0},
    '{"D05.4", 8'b10000101, 10'b0110000101, 10'b1101100101, 1, 0},
    '{"D05.5", 8'b10100101, 10'b0110100101, 10'b0110100101, 0, 0},
    '{"D05.6", 8'b11000101, 10'b0111000101, 10'b0111000101, 1, 0},
    '{"D05.7", 8'b11100101, 10'b1100000101, 10'b0111100101, 1, 0},
    '{"D06.0", 8'b00000110, 10'b0101000110, 10'b1110100110, 1, 0},
    '{"D06.1", 8'b00100110, 10'b1100100110, 10'b1100100110, 0, 0},
    '{"D06.2", 8'b01000110, 10'b1101000110, 10'b1101000110, 0, 0},
    '{"D06.3", 8'b01100110, 10'b1110000110, 10'b0101100110, 1, 0},
    '{"D06.4", 8'b10000110, 10'b0110000110, 10'b1101100110, 1, 0},
    '{"D06.5", 8'b10100110, 10'b0110100110, 10'b0110100110, 0, 0},
    '{"D06.6", 8'b11000110, 10'b0111000110, 10'b0111000110, 1, 0},
    '{"D06.7", 8'b11100110, 10'b1100000110, 10'b0111100110, 1, 0},
    '{"D07.0", 8'b00000111, 10'b0001000111, 10'b1110111000, 0, 0},
    '{"D07.1", 8'b00100111, 10'b1000100111, 10'b1100111000, 1, 0},
    '{"D07.2", 8'b01000111, 10'b1001000111, 10'b1101011000, 1, 0},
    '{"D07.3", 8'b01100111, 10'b1010000111, 10'b0101111000, 0, 0},
    '{"D07.4", 8'b10000111, 10'b0010000111, 10'b1101111000, 0, 0},
    '{"D07.5", 8'b10100111, 10'b0010100111, 10'b0110111000, 1, 0},
    '{"D07.6", 8'b11000111, 10'b0011000111, 10'b0111011000, 0, 0},
    '{"D07.7", 8'b11100111, 10'b1000000111, 10'b0111111000, 0, 0},
    '{"D08.0", 8'b00001000, 10'b0101000111, 10'b1010111000, 0, 0},
    '{"D08.1", 8'b00101000, 10'b1100100111, 10'b1000111000, 1, 0},
    '{"D08.2", 8'b01001000, 10'b1101000111, 10'b1001011000, 1, 0},
    '{"D08.3", 8'b01101000, 10'b1110000111, 10'b0001111000, 0, 0},
    '{"D08.4", 8'b10001000, 10'b0110000111, 10'b1001111000, 0, 0},
    '{"D08.5", 8'b10101000, 10'b0110100111, 10'b0010111000, 1, 0},
    '{"D08.6", 8'b11001000, 10'b0111000111, 10'b0011011000, 0, 0},
    '{"D08.7", 8'b11101000, 10'b1100000111, 10'b0011111000, 0, 0},
    '{"D09.0", 8'b00001001, 10'b0101001001, 10'b1110101001, 1, 0},
    '{"D09.1", 8'b00101001, 10'b1100101001, 10'b1100101001, 0, 0},
    '{"D09.2", 8'b01001001, 10'b1101001001, 10'b1101001001, 0, 0},
    '{"D09.3", 8'b01101001, 10'b1110001001, 10'b0101101001, 1, 0},
    '{"D09.4", 8'b10001001, 10'b0110001001, 10'b1101101001, 1, 0},
    '{"D09.5", 8'b10101001, 10'b0110101001, 10'b0110101001, 0, 0},
    '{"D09.6", 8'b11001001, 10'b0111001001, 10'b0111001001, 1, 0},
    '{"D09.7", 8'b11101001, 10'b1100001001, 10'b0111101001, 1, 0},
    '{"D10.0", 8'b00001010, 10'b0101001010, 10'b1110101010, 1, 0},
    '{"D10.1", 8'b00101010, 10'b1100101010, 10'b1100101010, 0, 0},
    '{"D10.2", 8'b01001010, 10'b1101001010, 10'b1101001010, 0, 0},
    '{"D10.3", 8'b01101010, 10'b1110001010, 10'b0101101010, 1, 0},
    '{"D10.4", 8'b10001010, 10'b0110001010, 10'b1101101010, 1, 0},
    '{"D10.5", 8'b10101010, 10'b0110101010, 10'b0110101010, 0, 0},
    '{"D10.6", 8'b11001010, 10'b0111001010, 10'b0111001010, 1, 0},
    '{"D10.7", 8'b11101010, 10'b1100001010, 10'b0111101010, 1, 0},
    '{"D11.0", 8'b00001011, 10'b0001001011, 10'b1010101011, 1, 0},
    '{"D11.1", 8'b00101011, 10'b1000101011, 10'b1000101011, 0, 0},
    '{"D11.2", 8'b01001011, 10'b1001001011, 10'b1001001011, 0, 0},
    '{"D11.3", 8'b01101011, 10'b1010001011, 10'b0001101011, 1, 0},
    '{"D11.4", 8'b10001011, 10'b0010001011, 10'b1001101011, 1, 0},
    '{"D11.5", 8'b10101011, 10'b0010101011, 10'b0010101011, 0, 0},
    '{"D11.6", 8'b11001011, 10'b0011001011, 10'b0011001011, 1, 0},
    '{"D11.7", 8'b11101011, 10'b1000001011, 10'b0011101011, 1, 0},
    '{"D12.0", 8'b00001100, 10'b0101001100, 10'b1110101100, 1, 0},
    '{"D12.1", 8'b00101100, 10'b1100101100, 10'b1100101100, 0, 0},
    '{"D12.2", 8'b01001100, 10'b1101001100, 10'b1101001100, 0, 0},
    '{"D12.3", 8'b01101100, 10'b1110001100, 10'b0101101100, 1, 0},
    '{"D12.4", 8'b10001100, 10'b0110001100, 10'b1101101100, 1, 0},
    '{"D12.5", 8'b10101100, 10'b0110101100, 10'b0110101100, 0, 0},
    '{"D12.6", 8'b11001100, 10'b0111001100, 10'b0111001100, 1, 0},
    '{"D12.7", 8'b11101100, 10'b1100001100, 10'b0111101100, 1, 0},
    '{"D13.0", 8'b00001101, 10'b0001001101, 10'b1010101101, 1, 0},
    '{"D13.1", 8'b00101101, 10'b1000101101, 10'b1000101101, 0, 0},
    '{"D13.2", 8'b01001101, 10'b1001001101, 10'b1001001101, 0, 0},
    '{"D13.3", 8'b01101101, 10'b1010001101, 10'b0001101101, 1, 0},
    '{"D13.4", 8'b10001101, 10'b0010001101, 10'b1001101101, 1, 0},
    '{"D13.5", 8'b10101101, 10'b0010101101, 10'b0010101101, 0, 0},
    '{"D13.6", 8'b11001101, 10'b0011001101, 10'b0011001101, 1, 0},
    '{"D13.7", 8'b11101101, 10'b1000001101, 10'b0011101101, 1, 0},
    '{"D14.0", 8'b00001110, 10'b0001001110, 10'b1010101110, 1, 0},
    '{"D14.1", 8'b00101110, 10'b1000101110, 10'b1000101110, 0, 0},
    '{"D14.2", 8'b01001110, 10'b1001001110, 10'b1001001110, 0, 0},
    '{"D14.3", 8'b01101110, 10'b1010001110, 10'b0001101110, 1, 0},
    '{"D14.4", 8'b10001110, 10'b0010001110, 10'b1001101110, 1, 0},
    '{"D14.5", 8'b10101110, 10'b0010101110, 10'b0010101110, 0, 0},
    '{"D14.6", 8'b11001110, 10'b0011001110, 10'b0011001110, 1, 0},
    '{"D14.7", 8'b11101110, 10'b1000001110, 10'b0011101110, 1, 0},
    '{"D15.0", 8'b00001111, 10'b0101011010, 10'b1010100101, 0, 0},
    '{"D15.1", 8'b00101111, 10'b1100111010, 10'b1000100101, 1, 0},
    '{"D15.2", 8'b01001111, 10'b1101011010, 10'b1001000101, 1, 0},
    '{"D15.3", 8'b01101111, 10'b1110011010, 10'b0001100101, 0, 0},
    '{"D15.4", 8'b10001111, 10'b0110011010, 10'b1001100101, 0, 0},
    '{"D15.5", 8'b10101111, 10'b0110111010, 10'b0010100101, 1, 0},
    '{"D15.6", 8'b11001111, 10'b0111011010, 10'b0011000101, 0, 0},
    '{"D15.7", 8'b11101111, 10'b1100011010, 10'b0011100101, 0, 0},
    '{"D16.0", 8'b00010000, 10'b0101010110, 10'b1010101001, 0, 0},
    '{"D16.1", 8'b00110000, 10'b1100110110, 10'b1000101001, 1, 0},
    '{"D16.2", 8'b01010000, 10'b1101010110, 10'b1001001001, 1, 0},
    '{"D16.3", 8'b01110000, 10'b1110010110, 10'b0001101001, 0, 0},
    '{"D16.4", 8'b10010000, 10'b0110010110, 10'b1001101001, 0, 0},
    '{"D16.5", 8'b10110000, 10'b0110110110, 10'b0010101001, 1, 0},
    '{"D16.6", 8'b11010000, 10'b0111010110, 10'b0011001001, 0, 0},
    '{"D16.7", 8'b11110000, 10'b1100010110, 10'b0011101001, 0, 0},
    '{"D17.0", 8'b00010001, 10'b0101010001, 10'b1110110001, 1, 0},
    '{"D17.1", 8'b00110001, 10'b1100110001, 10'b1100110001, 0, 0},
    '{"D17.2", 8'b01010001, 10'b1101010001, 10'b1101010001, 0, 0},
    '{"D17.3", 8'b01110001, 10'b1110010001, 10'b0101110001, 1, 0},
    '{"D17.4", 8'b10010001, 10'b0110010001, 10'b1101110001, 1, 0},
    '{"D17.5", 8'b10110001, 10'b0110110001, 10'b0110110001, 0, 0},
    '{"D17.6", 8'b11010001, 10'b0111010001, 10'b0111010001, 1, 0},
    '{"D17.7", 8'b11110001, 10'b1100010001, 10'b0111110001, 1, 0},
    '{"D18.0", 8'b00010010, 10'b0101010010, 10'b1110110010, 1, 0},
    '{"D18.1", 8'b00110010, 10'b1100110010, 10'b1100110010, 0, 0},
    '{"D18.2", 8'b01010010, 10'b1101010010, 10'b1101010010, 0, 0},
    '{"D18.3", 8'b01110010, 10'b1110010010, 10'b0101110010, 1, 0},
    '{"D18.4", 8'b10010010, 10'b0110010010, 10'b1101110010, 1, 0},
    '{"D18.5", 8'b10110010, 10'b0110110010, 10'b0110110010, 0, 0},
    '{"D18.6", 8'b11010010, 10'b0111010010, 10'b0111010010, 1, 0},
    '{"D18.7", 8'b11110010, 10'b1100010010, 10'b0111110010, 1, 0},
    '{"D19.0", 8'b00010011, 10'b0001010011, 10'b1010110011, 1, 0},
    '{"D19.1", 8'b00110011, 10'b1000110011, 10'b1000110011, 0, 0},
    '{"D19.2", 8'b01010011, 10'b1001010011, 10'b1001010011, 0, 0},
    '{"D19.3", 8'b01110011, 10'b1010010011, 10'b0001110011, 1, 0},
    '{"D19.4", 8'b10010011, 10'b0010010011, 10'b1001110011, 1, 0},
    '{"D19.5", 8'b10110011, 10'b0010110011, 10'b0010110011, 0, 0},
    '{"D19.6", 8'b11010011, 10'b0011010011, 10'b0011010011, 1, 0},
    '{"D19.7", 8'b11110011, 10'b1000010011, 10'b0011110011, 1, 0},
    '{"D20.0", 8'b00010100, 10'b0101010100, 10'b1110110100, 1, 0},
    '{"D20.1", 8'b00110100, 10'b1100110100, 10'b1100110100, 0, 0},
    '{"D20.2", 8'b01010100, 10'b1101010100, 10'b1101010100, 0, 0},
    '{"D20.3", 8'b01110100, 10'b1110010100, 10'b0101110100, 1, 0},
    '{"D20.4", 8'b10010100, 10'b0110010100, 10'b1101110100, 1, 0},
    '{"D20.5", 8'b10110100, 10'b0110110100, 10'b0110110100, 0, 0},
    '{"D20.6", 8'b11010100, 10'b0111010100, 10'b0111010100, 1, 0},
    '{"D20.7", 8'b11110100, 10'b1100010100, 10'b0111110100, 1, 0},
    '{"D21.0", 8'b00010101, 10'b0001010101, 10'b1010110101, 1, 0},
    '{"D21.1", 8'b00110101, 10'b1000110101, 10'b1000110101, 0, 0},
    '{"D21.2", 8'b01010101, 10'b1001010101, 10'b1001010101, 0, 0},
    '{"D21.3", 8'b01110101, 10'b1010010101, 10'b0001110101, 1, 0},
    '{"D21.4", 8'b10010101, 10'b0010010101, 10'b1001110101, 1, 0},
    '{"D21.5", 8'b10110101, 10'b0010110101, 10'b0010110101, 0, 0},
    '{"D21.6", 8'b11010101, 10'b0011010101, 10'b0011010101, 1, 0},
    '{"D21.7", 8'b11110101, 10'b1000010101, 10'b0011110101, 1, 0},
    '{"D22.0", 8'b00010110, 10'b0001010110, 10'b1010110110, 1, 0},
    '{"D22.1", 8'b00110110, 10'b1000110110, 10'b1000110110, 0, 0},
    '{"D22.2", 8'b01010110, 10'b1001010110, 10'b1001010110, 0, 0},
    '{"D22.3", 8'b01110110, 10'b1010010110, 10'b0001110110, 1, 0},
    '{"D22.4", 8'b10010110, 10'b0010010110, 10'b1001110110, 1, 0},
    '{"D22.5", 8'b10110110, 10'b0010110110, 10'b0010110110, 0, 0},
    '{"D22.6", 8'b11010110, 10'b0011010110, 10'b0011010110, 1, 0},
    '{"D22.7", 8'b11110110, 10'b1000010110, 10'b0011110110, 1, 0},
    '{"D23.0", 8'b00010111, 10'b0001010111, 10'b1110101000, 0, 0},
    '{"D23.1", 8'b00110111, 10'b1000110111, 10'b1100101000, 1, 0},
    '{"D23.2", 8'b01010111, 10'b1001010111, 10'b1101001000, 1, 0},
    '{"D23.3", 8'b01110111, 10'b1010010111, 10'b0101101000, 0, 0},
    '{"D23.4", 8'b10010111, 10'b0010010111, 10'b1101101000, 0, 0},
    '{"D23.5", 8'b10110111, 10'b0010110111, 10'b0110101000, 1, 0},
    '{"D23.6", 8'b11010111, 10'b0011010111, 10'b0111001000, 0, 0},
    '{"D23.7", 8'b11110111, 10'b1000010111, 10'b0111101000, 0, 0},
    '{"D24.0", 8'b00011000, 10'b0101010011, 10'b1010101100, 0, 0},
    '{"D24.1", 8'b00111000, 10'b1100110011, 10'b1000101100, 1, 0},
    '{"D24.2", 8'b01011000, 10'b1101010011, 10'b1001001100, 1, 0},
    '{"D24.3", 8'b01111000, 10'b1110010011, 10'b0001101100, 0, 0},
    '{"D24.4", 8'b10011000, 10'b0110010011, 10'b1001101100, 0, 0},
    '{"D24.5", 8'b10111000, 10'b0110110011, 10'b0010101100, 1, 0},
    '{"D24.6", 8'b11011000, 10'b0111010011, 10'b0011001100, 0, 0},
    '{"D24.7", 8'b11111000, 10'b1100010011, 10'b0011101100, 0, 0},
    '{"D25.0", 8'b00011001, 10'b0001011001, 10'b1010111001, 1, 0},
    '{"D25.1", 8'b00111001, 10'b1000111001, 10'b1000111001, 0, 0},
    '{"D25.2", 8'b01011001, 10'b1001011001, 10'b1001011001, 0, 0},
    '{"D25.3", 8'b01111001, 10'b1010011001, 10'b0001111001, 1, 0},
    '{"D25.4", 8'b10011001, 10'b0010011001, 10'b1001111001, 1, 0},
    '{"D25.5", 8'b10111001, 10'b0010111001, 10'b0010111001, 0, 0},
    '{"D25.6", 8'b11011001, 10'b0011011001, 10'b0011011001, 1, 0},
    '{"D25.7", 8'b11111001, 10'b1000011001, 10'b0011111001, 1, 0},
    '{"D26.0", 8'b00011010, 10'b0001011010, 10'b1010111010, 1, 0},
    '{"D26.1", 8'b00111010, 10'b1000111010, 10'b1000111010, 0, 0},
    '{"D26.2", 8'b01011010, 10'b1001011010, 10'b1001011010, 0, 0},
    '{"D26.3", 8'b01111010, 10'b1010011010, 10'b0001111010, 1, 0},
    '{"D26.4", 8'b10011010, 10'b0010011010, 10'b1001111010, 1, 0},
    '{"D26.5", 8'b10111010, 10'b0010111010, 10'b0010111010, 0, 0},
    '{"D26.6", 8'b11011010, 10'b0011011010, 10'b0011011010, 1, 0},
    '{"D26.7", 8'b11111010, 10'b1000011010, 10'b0011111010, 1, 0},
    '{"D27.0", 8'b00011011, 10'b0001011011, 10'b1110100100, 0, 0},
    '{"D27.1", 8'b00111011, 10'b1000111011, 10'b1100100100, 1, 0},
    '{"D27.2", 8'b01011011, 10'b1001011011, 10'b1101000100, 1, 0},
    '{"D27.3", 8'b01111011, 10'b1010011011, 10'b0101100100, 0, 0},
    '{"D27.4", 8'b10011011, 10'b0010011011, 10'b1101100100, 0, 0},
    '{"D27.5", 8'b10111011, 10'b0010111011, 10'b0110100100, 1, 0},
    '{"D27.6", 8'b11011011, 10'b0011011011, 10'b0111000100, 0, 0},
    '{"D27.7", 8'b11111011, 10'b1000011011, 10'b0111100100, 0, 0},
    '{"D28.0", 8'b00011100, 10'b0001011100, 10'b1010111100, 1, 0},
    '{"D28.1", 8'b00111100, 10'b1000111100, 10'b1000111100, 0, 0},
    '{"D28.2", 8'b01011100, 10'b1001011100, 10'b1001011100, 0, 0},
    '{"D28.3", 8'b01111100, 10'b1010011100, 10'b0001111100, 1, 0},
    '{"D28.4", 8'b10011100, 10'b0010011100, 10'b1001111100, 1, 0},
    '{"D28.5", 8'b10111100, 10'b0010111100, 10'b0010111100, 0, 0},
    '{"D28.6", 8'b11011100, 10'b0011011100, 10'b0011011100, 1, 0},
    '{"D28.7", 8'b11111100, 10'b1000011100, 10'b0011111100, 1, 0},
    '{"D29.0", 8'b00011101, 10'b0001011101, 10'b1110100010, 0, 0},
    '{"D29.1", 8'b00111101, 10'b1000111101, 10'b1100100010, 1, 0},
    '{"D29.2", 8'b01011101, 10'b1001011101, 10'b1101000010, 1, 0},
    '{"D29.3", 8'b01111101, 10'b1010011101, 10'b0101100010, 0, 0},
    '{"D29.4", 8'b10011101, 10'b0010011101, 10'b1101100010, 0, 0},
    '{"D29.5", 8'b10111101, 10'b0010111101, 10'b0110100010, 1, 0},
    '{"D29.6", 8'b11011101, 10'b0011011101, 10'b0111000010, 0, 0},
    '{"D29.7", 8'b11111101, 10'b1000011101, 10'b0111100010, 0, 0},
    '{"D30.0", 8'b00011110, 10'b0001011110, 10'b1110100001, 0, 0},
    '{"D30.1", 8'b00111110, 10'b1000111110, 10'b1100100001, 1, 0},
    '{"D30.2", 8'b01011110, 10'b1001011110, 10'b1101000001, 1, 0},
    '{"D30.3", 8'b01111110, 10'b1010011110, 10'b0101100001, 0, 0},
    '{"D30.4", 8'b10011110, 10'b0010011110, 10'b1101100001, 0, 0},
    '{"D30.5", 8'b10111110, 10'b0010111110, 10'b0110100001, 1, 0},
    '{"D30.6", 8'b11011110, 10'b0011011110, 10'b0111000001, 0, 0},
    '{"D30.7", 8'b11111110, 10'b1000011110, 10'b0111100001, 0, 0},
    '{"D31.0", 8'b00011111, 10'b0101010101, 10'b1010101010, 0, 0},
    '{"D31.1", 8'b00111111, 10'b1100110101, 10'b1000101010, 1, 0},
    '{"D31.2", 8'b01011111, 10'b1101010101, 10'b1001001010, 1, 0},
    '{"D31.3", 8'b01111111, 10'b1110010101, 10'b0001101010, 0, 0},
    '{"D31.4", 8'b10011111, 10'b0110010101, 10'b1001101010, 0, 0},
    '{"D31.5", 8'b10111111, 10'b0110110101, 10'b0010101010, 1, 0},
    '{"D31.6", 8'b11011111, 10'b0111010101, 10'b0011001010, 0, 0},
    '{"D31.7", 8'b11111111, 10'b1100010101, 10'b0011101010, 0, 0}
  };




      // ("K28."    8'b00011100, 10'b0011110100, 10'b1100001011, 0, 1),
      // ("K28."    8'b00111100, 10'b0011111001, 10'b1100000110, 1, 1),
      // ("K28."    8'b01011100, 10'b0011110101, 10'b1100001010, 1, 1),
      // ("K28."    8'b01111100, 10'b0011110011, 10'b1100001100, 1, 1),
      // ("K28."    8'b10011100, 10'b0011110010, 10'b1100001101, 0, 1),
      // ("K28."    8'b10111100, 10'b0011111010, 10'b1100000101, 1, 1),
      // ("K28."    8'b11011100, 10'b0011110110, 10'b1100001001, 1, 1),
      // ("K28."    8'b11111100, 10'b0011111000, 10'b1100000111, 0, 1),
      // ("K"    8'b11110111, 10'b1110101000, 10'b0001010111, 0, 1),
      // ("K"    8'b11111011, 10'b1101101000, 10'b0010010111, 0, 1),
      // ("K"    8'b11111101, 10'b1011101000, 10'b0100010111, 0, 1),
      // ("K"    8'b11111110, 10'b0111101000, 10'b1000010111, 0, 1)





endpackage