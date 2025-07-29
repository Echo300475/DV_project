//***************************************************************************************************************
// Author: Van Le
// vanleatwork@yahoo.com
// Phone: VN: 0396221156, US: 5125841843
//***************************************************************************************************************
class apb_monitor #(type PKT = uvm_sequence_item) extends uvm_monitor;

  `uvm_component_param_utils(apb_monitor #(PKT))
  
  string   my_name;
  
  virtual interface apb_if       vif;
 
  uvm_analysis_port #(PKT)  ref_port;

  function new(string name, uvm_component parent);
    super.new(name,parent);
    my_name = name;
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ref_port = new($psprintf("%s_ref_port",my_name),this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
     
    //
    // Getting the interface handle
    //
    if( !uvm_config_db #(virtual apb_if)::get(this,"","APB_VIF",vif) ) begin
      `uvm_error(my_name, "Could not retrieve virtual apb_if");
    end
     
  endfunction
  
  function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
  endfunction
   
  task monitoring;
    PKT     ref_pkt;
    integer ref_pkt_cnt;
    
    ref_pkt_cnt = 0;
    forever @(posedge vif.clk) begin
      ref_pkt = PKT::type_id::create($psprintf("ref_pkt_id_%d",ref_pkt_cnt));
      if (vif.rst==0) begin
				ref_pkt.to_reset = 0;
			end else begin
				ref_pkt.to_reset = 1;
      end
      ref_port.write(ref_pkt);
      ref_pkt_cnt++;
    end
    
  endtask
   
  task run_phase(uvm_phase phase);
    monitoring();
  endtask
   
endclass
