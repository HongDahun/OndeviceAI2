# OndeviceAI2 — HDL Practice

Verilog/SystemVerilog 학습 과정에서 진행한 실습성 프로젝트 모음. 각 폴더가 독립된 실습 하나에 대응한다. 정식 완료보고서·검증 결과까지 갖춘 프로젝트는 별도 저장소로 분리해뒀다 — 아래 목록의 `→` 표시 참고.

| 폴더 | 내용 |
|---|---|
| `dedicated_cpu_counter/` | 전용(Dedicated) CPU로 구현한 카운터 |
| `dedicated_cpu_sum_0to10/` | 전용 CPU로 구현한 0~10 누적합 연산 |
| `general_purpose_cpu/` | 범용(General-Purpose) CPU 구조 설계 실습 |
| `rv32i_practice/` | RISC-V RV32I 단일 사이클 CPU 초기 실습 → 정식 버전: [rv32i-single-cycle](https://github.com/HongDahun/rv32i-single-cycle) |
| `spi_watch_practice/` | SPI Master-Slave + Watch 연동 초기 실습 → 정식 버전: [spi-master-slave-uvm-verification](https://github.com/HongDahun/spi-master-slave-uvm-verification) |
| `spi_uvm_practice/` | SPI UVM 검증 환경(Agent/Driver/Monitor/Scoreboard/Coverage) 구축 실습 |
| `ram_uvm_practice/` | RAM UVM 검증 환경 구축 실습 |

## 기술 스택

Verilog, SystemVerilog, UVM, Xilinx Vivado
