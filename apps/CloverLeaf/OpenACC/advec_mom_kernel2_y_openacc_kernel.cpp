//
// auto-generated by ops.py on 2014-08-08 12:31
//

#include "./OpenACC/clover_leaf_common.h"

#define OPS_GPU

extern int xdim0_advec_mom_kernel2_y;
extern int xdim1_advec_mom_kernel2_y;
extern int xdim2_advec_mom_kernel2_y;
extern int xdim3_advec_mom_kernel2_y;

#ifdef __cplusplus
extern "C" {
#endif
void advec_mom_kernel2_y_c_wrapper(
  double *p_a0,
  double *p_a1,
  double *p_a2,
  double *p_a3,
  int x_size, int y_size);

#ifdef __cplusplus
}
#endif

// host stub function
void ops_par_loop_advec_mom_kernel2_y(char const *name, ops_block Block, int dim, int* range,
 ops_arg arg0, ops_arg arg1, ops_arg arg2, ops_arg arg3) {

  ops_arg args[4] = { arg0, arg1, arg2, arg3};

  //compute localy allocated range for the sub-block
  int start[2];
  int end[2];
  #ifdef OPS_MPI
  sub_block_list sb = OPS_sub_block_list[block->index];
  for ( int n=0; n<2; n++ ){
    start[n] = sb->decomp_disp[n];end[n] = sb->decomp_disp[n]+sb->decomp_size[n];
    if (start[n] >= range[2*n]) {
      start[n] = 0;
    }
    else {
      start[n] = range[2*n] - start[n];
    }
    if (end[n] >= range[2*n+1]) {
      end[n] = range[2*n+1] - sb->decomp_disp[n];
    }
    else {
      end[n] = sb->decomp_size[n];
    }
  }
  #else //OPS_MPI
  for ( int n=0; n<2; n++ ){
    start[n] = range[2*n];end[n] = range[2*n+1];
  }
  #endif //OPS_MPI

  int x_size = MAX(0,end[0]-start[0]);
  int y_size = MAX(0,end[1]-start[1]);



  //Timing
  double t1,t2,c1,c2;
  ops_timing_realloc(26,"advec_mom_kernel2_y");
  ops_timers_core(&c2,&t2);

  if (OPS_kernels[26].count == 0) {
    xdim0_advec_mom_kernel2_y = args[0].dat->size[0]*args[0].dat->dim;
    xdim1_advec_mom_kernel2_y = args[1].dat->size[0]*args[1].dat->dim;
    xdim2_advec_mom_kernel2_y = args[2].dat->size[0]*args[2].dat->dim;
    xdim3_advec_mom_kernel2_y = args[3].dat->size[0]*args[3].dat->dim;
  }

  int dat0 = args[0].dat->elem_size;
  int dat1 = args[1].dat->elem_size;
  int dat2 = args[2].dat->elem_size;
  int dat3 = args[3].dat->elem_size;


  //set up initial pointers
  int base0 = dat0 * 1 * 
    (start[0] * args[0].stencil->stride[0] - args[0].dat->base[0] - args[0].dat->d_m[0]);
  base0 = base0+ dat0 *
    args[0].dat->size[0] *
    (start[1] * args[0].stencil->stride[1] - args[0].dat->base[1] - args[0].dat->d_m[1]);
  #ifdef OPS_GPU
  double *p_a0 = (double *)((char *)args[0].data_d + base0);
  #else
  double *p_a0 = (double *)((char *)args[0].data + base0);
  #endif

  int base1 = dat1 * 1 * 
    (start[0] * args[1].stencil->stride[0] - args[1].dat->base[0] - args[1].dat->d_m[0]);
  base1 = base1+ dat1 *
    args[1].dat->size[0] *
    (start[1] * args[1].stencil->stride[1] - args[1].dat->base[1] - args[1].dat->d_m[1]);
  #ifdef OPS_GPU
  double *p_a1 = (double *)((char *)args[1].data_d + base1);
  #else
  double *p_a1 = (double *)((char *)args[1].data + base1);
  #endif

  int base2 = dat2 * 1 * 
    (start[0] * args[2].stencil->stride[0] - args[2].dat->base[0] - args[2].dat->d_m[0]);
  base2 = base2+ dat2 *
    args[2].dat->size[0] *
    (start[1] * args[2].stencil->stride[1] - args[2].dat->base[1] - args[2].dat->d_m[1]);
  #ifdef OPS_GPU
  double *p_a2 = (double *)((char *)args[2].data_d + base2);
  #else
  double *p_a2 = (double *)((char *)args[2].data + base2);
  #endif

  int base3 = dat3 * 1 * 
    (start[0] * args[3].stencil->stride[0] - args[3].dat->base[0] - args[3].dat->d_m[0]);
  base3 = base3+ dat3 *
    args[3].dat->size[0] *
    (start[1] * args[3].stencil->stride[1] - args[3].dat->base[1] - args[3].dat->d_m[1]);
  #ifdef OPS_GPU
  double *p_a3 = (double *)((char *)args[3].data_d + base3);
  #else
  double *p_a3 = (double *)((char *)args[3].data + base3);
  #endif


  #ifdef OPS_GPU
  ops_H_D_exchanges_device(args, 4);
  #else
  ops_H_D_exchanges_host(args, 4);
  #endif
  ops_halo_exchanges(args,4,range);

  ops_timers_core(&c1,&t1);
  OPS_kernels[26].mpi_time += t1-t2;

  advec_mom_kernel2_y_c_wrapper(
    p_a0,
    p_a1,
    p_a2,
    p_a3,
    x_size, y_size);

  ops_timers_core(&c2,&t2);
  OPS_kernels[26].time += t2-t1;
  #ifdef OPS_GPU
  ops_set_dirtybit_device(args, 4);
  #else
  ops_set_dirtybit_host(args, 4);
  #endif
  ops_set_halo_dirtybit3(&args[0],range);

  //Update kernel record
  OPS_kernels[26].count++;
  OPS_kernels[26].transfer += ops_compute_transfer(dim, range, &arg0);
  OPS_kernels[26].transfer += ops_compute_transfer(dim, range, &arg1);
  OPS_kernels[26].transfer += ops_compute_transfer(dim, range, &arg2);
  OPS_kernels[26].transfer += ops_compute_transfer(dim, range, &arg3);
}
