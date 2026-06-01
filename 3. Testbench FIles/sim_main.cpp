#include<iostream>
#include<memory>
#include"Vtop.h"
#include"verilated.h"
#include"verilated_vcd_c.h"
#include "verilated_cov.h"

int main(int argc, char** argv){
    std::unique_ptr<VerilatedContext> contextp {new VerilatedContext};
    Vtop* top = new Vtop{contextp.get()};

    contextp->commandArgs(argc, argv);

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("waveform.vcd");

    if(contextp->randSeed() == 0)
        contextp->randSeed(time(NULL));

    std::cout << "--------------------------------------------" << std::endl;
    std::cout << "  SIMULATION STARTING WITH SEED: " << contextp->randSeed() << std::endl;
    std::cout << "--------------------------------------------" << std::endl;
    
    while (!contextp->gotFinish() && contextp->time() < 1000)
    {

        if(contextp->time() % 5 == 0){
            top->clk = !top->clk;
        }

        top->eval();

        contextp->timeInc(1);

        tfp->dump(contextp->time());
        
    }
    
    tfp->close();

    Verilated::mkdir("logs");
    VerilatedCov::write("logs/coverage.dat");
    
    delete top;
    return 0;
}