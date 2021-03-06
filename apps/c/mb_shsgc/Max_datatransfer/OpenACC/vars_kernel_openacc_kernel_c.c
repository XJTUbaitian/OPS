//
// auto-generated by ops.py
//
#include "./OpenACC/shsgc_common.h"

#define OPS_GPU

int xdim0_vars_kernel;
int xdim1_vars_kernel;
int xdim2_vars_kernel;
int xdim3_vars_kernel;
int xdim4_vars_kernel;

#undef OPS_ACC_MD0
#undef OPS_ACC_MD1
#undef OPS_ACC_MD2
#undef OPS_ACC_MD3
#undef OPS_ACC_MD4

#define OPS_ACC_MD0(d, x) ((x)*3 + (d))
#define OPS_ACC_MD1(d, x) ((x)*3 + (d))
#define OPS_ACC_MD2(d, x) ((x)*3 + (d))
#define OPS_ACC_MD3(d, x) ((x)*3 + (d))
#define OPS_ACC_MD4(d, x) ((x)*3 + (d))
// user function
inline void vars_kernel(const double *alam, const double *al, const double *gt,
                        double *cmp, double *cf) {
  double anu, aaa, ga, qf, ww;
  for (int m = 0; m < 3; m++) {
    anu = alam[OPS_ACC_MD0(m, 0)];
    aaa = al[OPS_ACC_MD1(m, 0)];
    ga = aaa * (gt[OPS_ACC_MD2(m, 1)] - gt[OPS_ACC_MD2(m, 0)]) /
         (pow(aaa, 2.0) + del2);
    qf = sqrt(con + pow(anu, 2.0));
    cmp[OPS_ACC_MD3(m, 0)] = 0.50 * qf;
    ww = anu + cmp[OPS_ACC_MD3(m, 0)] * ga;
    qf = sqrt(con + pow(ww, 2.0));
    cf[OPS_ACC_MD4(m, 0)] = qf;
  }
}

#undef OPS_ACC_MD0
#undef OPS_ACC_MD1
#undef OPS_ACC_MD2
#undef OPS_ACC_MD3
#undef OPS_ACC_MD4

void vars_kernel_c_wrapper(double *p_a0, double *p_a1, double *p_a2,
                           double *p_a3, double *p_a4, int x_size) {
#ifdef OPS_GPU
#pragma acc parallel deviceptr(p_a0, p_a1, p_a2, p_a3, p_a4)
#pragma acc loop
#endif
  for (int n_x = 0; n_x < x_size; n_x++) {
    vars_kernel(p_a0 + n_x * 1 * 3, p_a1 + n_x * 1 * 3, p_a2 + n_x * 1 * 3,
                p_a3 + n_x * 1 * 3, p_a4 + n_x * 1 * 3);
  }
}
