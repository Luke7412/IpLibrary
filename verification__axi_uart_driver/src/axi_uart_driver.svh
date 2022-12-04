

class AxiUartDriver #(
  parameter bit [7:0] START_BYTE  = 'h7D,
  parameter bit [7:0] STOP_BYTE   = 'h7E,
  parameter bit [7:0] ESCAPE_BYTE = 'h7F
);

  localparam bit [2:0] PROT     = '0;
  localparam bit [2:0] SIZE     = 'b010;
  localparam bit [1:0] BURST    = 'b01;
  localparam bit [3:0] CACHE    = '0;
  localparam bit [0:0] LOCK     = '0;
  localparam bit [0:0] ID       = '0;
  localparam int BYTES_PER_BEAT = 2**SIZE;

  typedef bit [7:0] u8;
  typedef u8 t_pkt [$];
  typedef t_pkt t_pkts [$];
  
  UartReceiver    rx;
  UartTransmitter tx;

  //----------------------------------------------------------------------------
  function new(virtual UartIntf vif);
    rx = new(vif);
    tx = new(vif);
  endfunction

  task start();
    rx.start();
    tx.start();
  endtask

  task stop();
    rx.stop();
    tx.stop();
  endtask


  //----------------------------------------------------------------------------
  function t_pkt make_addr_pkt(t_pkt_id pkt_id, int addr, int length);
    t_pkt pkt;
    bit [57:0] vec = {
      ID, LOCK, 8'(length-1), CACHE, BURST, SIZE, PROT, addr, 8'(pkt_id)
    };
    
    for(int i=0; i<8; i++) begin
      pkt.push_back(vec[7:0]);
      vec >>= 8;
    end
    return pkt;
  endfunction


  function t_pkts pack_data(t_pkt_id pkt_id, t_pkt data, int offset);
    t_pkts pkts;
    int nof_beats = (data.size() + offset + BYTES_PER_BEAT-1) / BYTES_PER_BEAT;
    int nof_bytes = nof_beats * BYTES_PER_BEAT;
    int bytes_to_add = nof_bytes - data.size();
    bit valid [] = new[nof_bytes];

    // Realign data
    valid = '{default: '0};
    for(int i=0; i<data.size(); i++)
      valid[offset+i] = '1;

    repeat(offset) 
      data.push_front('0);
    repeat(bytes_to_add-offset) 
      data.push_back('0);

    // Create a packet for each data beat
    for (int i=0; i<nof_beats; i++) begin
      t_pkt     pkt;
      bit [3:0] axi_strb = {<<{valid[i*BYTES_PER_BEAT +: BYTES_PER_BEAT]}};
      bit       axi_last = i==nof_beats-1;

      pkt.push_back(pkt_id);
      for (int j=0; j<BYTES_PER_BEAT; j++)
        pkt.push_back(data[i*BYTES_PER_BEAT+j]);
      pkt.push_back({axi_last, axi_strb});
      pkts.push_back(pkt);
    end
    return pkts;
  endfunction


  function bit[1:0] unpack_write_response(t_pkt pkt);
    u8 val;
    bit [1:0] axi_resp;
    bit axi_id;

    if (pkt.pop_front() != WRITE_RESP)
      $fatal();

    val = pkt.pop_front();
    axi_resp = val[1:0];
    axi_id = val[2:2];
    return axi_resp;
  endfunction

  function t_pkt unpack_read_response(t_pkts pkts);
    t_pkt pkt;
    bit [7:0] val;
    bit [1:0] axi_resp;
    bit axi_id;

    foreach (pkts[i]) begin
      if (pkts[i].pop_front() != READ_RESP) 
        $fatal();

      repeat(4)
        pkt.push_back(pkts[i].pop_front());

      val = pkts[i].pop_front();
      axi_resp = val[1:0];
      axi_id = val[2:2];
    end 
    return pkt;
  endfunction


  //----------------------------------------------------------------------------
  function t_pkt add_escape_chars(t_pkt pkt);
    int idx = 0;

    while (idx < pkt.size()) begin
      if (pkt[idx] inside {START_BYTE, STOP_BYTE, ESCAPE_BYTE}) begin
        pkt.insert(idx, ESCAPE_BYTE);
        idx++;
      end
      idx++;
    end
    return pkt;
  endfunction

  function t_pkt remove_escape_chars(t_pkt pkt);
    int idx = 0;

    while (idx < pkt.size()) begin
      if (pkt[idx] == ESCAPE_BYTE) begin
        pkt.delete(idx);
      end
      idx++;
    end
    return pkt;
  endfunction

  function t_pkt add_framing(t_pkt pkt);
    pkt.push_front(START_BYTE);
    pkt.push_back(STOP_BYTE);
    return pkt;
  endfunction

  function t_pkt remove_framing(t_pkt pkt);
    void'(pkt.pop_front());
    void'(pkt.pop_back());
    return pkt;
  endfunction


  //----------------------------------------------------------------------------
  task send_pkt(input t_pkt pkt);
    pkt = add_escape_chars(pkt);
    pkt = add_framing(pkt);
    tx.send_bytes(pkt, .blocking(0));
  endtask

  task receive_pkt(output t_pkt pkt);
    // fetch_pkt(pkt);
    pkt = remove_framing(pkt);
    pkt = remove_escape_chars(pkt);
  endtask

  task fetch_pkt(output t_pkt pkt);
    u8 resp_byte;
    bit running = 0;
    bit is_escaped = 0;

    forever begin
      rx.fetch_byte(resp_byte);

      if (resp_byte == START_BYTE)
        running = 1;
      if (running)
        pkt.push_back(resp_byte);
      if (resp_byte == STOP_BYTE && !is_escaped)
        break;
      if (running)
        is_escaped = resp_byte == ESCAPE_BYTE;
    end
  endtask


  //----------------------------------------------------------------------------
  task write(int addr, bit [7:0] data []);
    t_pkt pkt;
    t_pkts pkts;
    int offset = addr % BYTES_PER_BEAT;
    int aligned_addr = addr - offset;

    // Send write address packet
    int length = (data.size() + offset + BYTES_PER_BEAT-1) / BYTES_PER_BEAT;
    pkt = make_addr_pkt(.pkt_id(WRITE_ADDR), .addr(aligned_addr), .length(length));
    send_pkt(pkt);

    // Send write data packet
    pkts = pack_data(.pkt_id(WRITE_DATA), .data(data), .offset(offset));
    foreach(pkts[i])
      send_pkt(pkts[i]);

    // Fetch write response packet
    receive_pkt(pkt);
    if(unpack_write_response(pkt) != 0)
      $fatal();

  endtask


  task read(int addr, length, output bit [7:0] data [$]);
    t_pkt pkt;
    t_pkts pkts;
    int offset = addr % BYTES_PER_BEAT;
    int aligned_addr = addr - offset;

    // Send read address packet
    int nof_packets = (length + offset + BYTES_PER_BEAT-1) / BYTES_PER_BEAT;
    pkt = make_addr_pkt(.pkt_id(WRITE_ADDR), .addr(aligned_addr), .length(length));
    send_pkt(pkt);

    // Fetch read response packet
    repeat (nof_packets) begin
      receive_pkt(pkt);
      pkts.push_back(pkt);
    end

    pkt = unpack_read_response(pkts);
    for (int i=0; i<length; i++)
      data.push_back(pkt[offset+i]);

  endtask

endclass