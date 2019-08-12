#!/bin/bash

sbatch -t 6:00:00 -p high 05a_get_fst.sh ALAME NFMFA
sbatch -t 6:00:00 -p high 05a_get_fst.sh ALAME NFA
sbatch -t 6:00:00 -p high 05a_get_fst.sh ALAME MFA
sbatch -t 6:00:00 -p high 05a_get_fst.sh ALAME RUBIC
sbatch -t 6:00:00 -p high 05a_get_fst.sh NFMFA NFA
sbatch -t 6:00:00 -p high 05a_get_fst.sh NFMFA MFA
sbatch -t 6:00:00 -p high 05a_get_fst.sh NFMFA RUBIC
sbatch -t 6:00:00 -p high 05a_get_fst.sh NFA MFA
sbatch -t 6:00:00 -p high 05a_get_fst.sh NFA RUBIC
sbatch -t 6:00:00 -p high 05a_get_fst.sh MFA RUBIC
sbatch -t 6:00:00 -p high 05a_get_fst.sh ALAME_ac ALAME_ah
sbatch -t 6:00:00 -p high 05a_get_fst.sh MFA_gc MFA_sg
sbatch -t 6:00:00 -p high 05a_get_fst.sh MFA_gc MFA_tc
sbatch -t 6:00:00 -p high 05a_get_fst.sh MFA_sg MFA_tc
sbatch -t 6:00:00 -p high 05a_get_fst.sh MFA_sg RUBIC
sbatch -t 6:00:00 -p high 05a_get_fst.sh MFA_gc RUBIC
sbatch -t 6:00:00 -p high 05a_get_fst.sh MFA_tc RUBIC
sbatch -t 6:00:00 -p high 05a_get_fst.sh MFA_sg NFMFA
sbatch -t 6:00:00 -p high 05a_get_fst.sh MFA_gc NFMFA
sbatch -t 6:00:00 -p high 05a_get_fst.sh MFA_tc NFMFA
sbatch -t 6:00:00 -p high 05a_get_fst.sh RUBIC NFA_rr
sbatch -t 6:00:00 -p high 05a_get_fst.sh NFMFA NFA_rr
sbatch -t 6:00:00 -p high 05a_get_fst.sh MFA_sg NFA_rr
sbatch -t 6:00:00 -p high 05a_get_fst.sh MFA_gc NFA_rr
sbatch -t 6:00:00 -p high 05a_get_fst.sh MFA_tc NFA_rr
