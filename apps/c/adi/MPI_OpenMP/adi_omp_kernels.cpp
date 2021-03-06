//
// auto-generated by ops.py//

// header
#define OPS_3D
#define OPS_ACC_MD_MACROS
#include "ops_lib_cpp.h"
#ifdef OPS_MPI
#include "ops_mpi_core.h"
#endif

// set max number of OMP threads for reductions
#ifndef MAX_REDUCT_THREADS
#define MAX_REDUCT_THREADS 64
#endif
// global constants
extern int nx;
extern int ny;
extern int nz;
extern double lambda;

// user kernel files
#include "init_kernel_omp_kernel.cpp"
#include "preproc_kernel_omp_kernel.cpp"
#include "rms_kernel_omp_kernel.cpp"
