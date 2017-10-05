//
// auto-generated by ops.py
//
#include "./OpenACC/clover_leaf_common.h"

#define OPS_GPU

int xdim0_reset_field_kernel2;
int ydim0_reset_field_kernel2;
int xdim1_reset_field_kernel2;
int ydim1_reset_field_kernel2;
int xdim2_reset_field_kernel2;
int ydim2_reset_field_kernel2;
int xdim3_reset_field_kernel2;
int ydim3_reset_field_kernel2;
int xdim4_reset_field_kernel2;
int ydim4_reset_field_kernel2;
int xdim5_reset_field_kernel2;
int ydim5_reset_field_kernel2;

#undef OPS_ACC0
#undef OPS_ACC1
#undef OPS_ACC2
#undef OPS_ACC3
#undef OPS_ACC4
#undef OPS_ACC5

#define OPS_ACC0(x, y, z)                                                      \
  (x + xdim0_reset_field_kernel2 * (y) +                                       \
   xdim0_reset_field_kernel2 * ydim0_reset_field_kernel2 * (z))
#define OPS_ACC1(x, y, z)                                                      \
  (x + xdim1_reset_field_kernel2 * (y) +                                       \
   xdim1_reset_field_kernel2 * ydim1_reset_field_kernel2 * (z))
#define OPS_ACC2(x, y, z)                                                      \
  (x + xdim2_reset_field_kernel2 * (y) +                                       \
   xdim2_reset_field_kernel2 * ydim2_reset_field_kernel2 * (z))
#define OPS_ACC3(x, y, z)                                                      \
  (x + xdim3_reset_field_kernel2 * (y) +                                       \
   xdim3_reset_field_kernel2 * ydim3_reset_field_kernel2 * (z))
#define OPS_ACC4(x, y, z)                                                      \
  (x + xdim4_reset_field_kernel2 * (y) +                                       \
   xdim4_reset_field_kernel2 * ydim4_reset_field_kernel2 * (z))
#define OPS_ACC5(x, y, z)                                                      \
  (x + xdim5_reset_field_kernel2 * (y) +                                       \
   xdim5_reset_field_kernel2 * ydim5_reset_field_kernel2 * (z))

// user function
inline void reset_field_kernel2(double *xvel0, const double *xvel1,
                                double *yvel0, const double *yvel1,
                                double *zvel0, const double *zvel1) {

  xvel0[OPS_ACC0(0, 0, 0)] = xvel1[OPS_ACC1(0, 0, 0)];
  yvel0[OPS_ACC2(0, 0, 0)] = yvel1[OPS_ACC3(0, 0, 0)];
  zvel0[OPS_ACC4(0, 0, 0)] = zvel1[OPS_ACC5(0, 0, 0)];
}

#undef OPS_ACC0
#undef OPS_ACC1
#undef OPS_ACC2
#undef OPS_ACC3
#undef OPS_ACC4
#undef OPS_ACC5

void reset_field_kernel2_c_wrapper(double *p_a0, double *p_a1, double *p_a2,
                                   double *p_a3, double *p_a4, double *p_a5,
                                   int x_size, int y_size, int z_size) {
#ifdef OPS_GPU
#pragma acc parallel deviceptr(p_a0, p_a1, p_a2, p_a3, p_a4, p_a5)
#pragma acc loop
#endif
  for (int n_z = 0; n_z < z_size; n_z++) {
#ifdef OPS_GPU
#pragma acc loop
#endif
    for (int n_y = 0; n_y < y_size; n_y++) {
#ifdef OPS_GPU
#pragma acc loop
#endif
      for (int n_x = 0; n_x < x_size; n_x++) {
        reset_field_kernel2(
            p_a0 + n_x * 1 * 1 + n_y * xdim0_reset_field_kernel2 * 1 * 1 +
                n_z * xdim0_reset_field_kernel2 * ydim0_reset_field_kernel2 * 1,
            p_a1 + n_x * 1 * 1 + n_y * xdim1_reset_field_kernel2 * 1 * 1 +
                n_z * xdim1_reset_field_kernel2 * ydim1_reset_field_kernel2 * 1,
            p_a2 + n_x * 1 * 1 + n_y * xdim2_reset_field_kernel2 * 1 * 1 +
                n_z * xdim2_reset_field_kernel2 * ydim2_reset_field_kernel2 * 1,
            p_a3 + n_x * 1 * 1 + n_y * xdim3_reset_field_kernel2 * 1 * 1 +
                n_z * xdim3_reset_field_kernel2 * ydim3_reset_field_kernel2 * 1,
            p_a4 + n_x * 1 * 1 + n_y * xdim4_reset_field_kernel2 * 1 * 1 +
                n_z * xdim4_reset_field_kernel2 * ydim4_reset_field_kernel2 * 1,
            p_a5 + n_x * 1 * 1 + n_y * xdim5_reset_field_kernel2 * 1 * 1 +
                n_z * xdim5_reset_field_kernel2 * ydim5_reset_field_kernel2 *
                    1);
      }
    }
  }
}