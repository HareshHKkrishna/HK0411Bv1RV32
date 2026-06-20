module instruction_memory (
    input logic [31:0]pc,
    output logic [31:0]instr
);

logic [31:0]cache[255:0];
always_comb begin
    instr=cache[pc[31:2]];          
end
    
endmodule

/*



### Day 1

IF Stage
PC
Instruction Memory
IF Wrapper
IF/ID Register

~2-3 hours


### Day 2

ID/EX Register
EX Stage
Branch Logic

~3-4 hours


### Day 3

Data Memory
EX/MEM Register
MEM Stage

~2 hours


### Day 4

WB Stage
MEM/WB Register
CPU Top

~3 hours

---

### Day 5
Forwarding Unit
Hazard Unit
Flush Logic
~4-5 hours


### Day 6

CPU Integration Debug

~1 full day

---

# Realistic Estimate

Given your current progress and the fact that:

```text
✓ ALU done
✓ Register File done
✓ Decoder done
✓ ImmGen done
✓ Control Unit done
✓ ALU Control done
✓ ID Wrapper done
✓ ID Verification done
```

I think:

```text
Best case     : 3 days
Realistic     : 5-7 days
Careful + TB  : 7-10 days
```

If your goal is a **good project for interviews**, spend the extra time and finish:

```text
Forwarding
Hazard Detection
Self-checking CPU testbench
Functional coverage
```

Those verification features will impress interviewers more than simply getting the pipeline to run.
*/
