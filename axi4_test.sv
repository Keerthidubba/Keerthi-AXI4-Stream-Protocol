import pkg1::*;
class basic_test extends uvm_test;

    `uvm_component_utils(basic_test)

    axi4_env env;
    axi4_master_sanity_sequence master_seq;
    axi4_slave_sanity_sequence  slave_seq;
    int Print_handle;

    function new(string name="basic_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_db#(int)::set(this, "*", "handle", Print_handle);
        env = axi4_env::type_id::create("env", this);
        master_seq = axi4_master_sanity_sequence::type_id::create("master_seq", this);
        slave_seq  = axi4_slave_sanity_sequence::type_id::create("slave_seq", this);
    endfunction

    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      begin
      $display("enetering into seq start of master and slave");
          fork
              begin
                  master_seq.get_print(Print_handle);
                  master_seq.start(env.master_agent.master_seqr);
              end
              begin
                  slave_seq.start(env.slave_agent.slave_seqr);
              end
          join_any
      $display("leaving from seq start of master and slave");
          //disable fork;
      end
      phase.drop_objection(this);
    endtask


endclass : basic_test
