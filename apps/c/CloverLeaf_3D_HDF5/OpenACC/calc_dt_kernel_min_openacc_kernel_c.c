//
// auto-generated by ops.py
//
#include "./OpenACC/clover_leaf_common.h"

#define OPS_GPU

int xdim0_calc_dt_kernel_min;
int ydim0_calc_dt_kernel_min;

#undef OPS_ACC0

#define OPS_ACC0(x, y, z)                                                      \
  (x + xdim0_calc_dt_kernel_min * (y) +                                        \
   xdim0_calc_dt_kernel_min * ydim0_calc_dt_kernel_min * (z))

// user function
inline void calc_dt_kernel_min(const double *dt_min, double *dt_min_val) {
  *dt_min_val = MIN(*dt_min_val, dt_min[OPS_ACC0(0, 0, 0)]);
}

#undef OPS_ACC0

void calc_dt_kernel_min_c_wrapper(double *p_a0, double *p_a1, int x_size,
                                  int y_size, int z_size) {
  double p_a1_0 = p_a1[0];
#ifdef OPS_GPU
#pragma acc parallel deviceptr(p_a0) reduction(min : p_a1_0)
#pragma acc loop reduction(min : p_a1_0)
#endif
  for (int n_z = 0; n_z < z_size; n_z++) {
#ifdef OPS_GPU
#pragma acc loop reduction(min : p_a1_0)
#endif
    for (int n_y = 0; n_y < y_size; n_y++) {
#ifdef OPS_GPU
#pragma acc loop reduction(min : p_a1_0)
#endif
      for (int n_x = 0; n_x < x_size; n_x++) {
        calc_dt_kernel_min(
            p_a0 + n_x * 1 * 1 + n_y * xdim0_calc_dt_kernel_min * 1 * 1 +
                n_z * xdim0_calc_dt_kernel_min * ydim0_calc_dt_kernel_min * 1,
            &p_a1_0);
      }
    }
  }
  p_a1[0] = p_a1_0;
}