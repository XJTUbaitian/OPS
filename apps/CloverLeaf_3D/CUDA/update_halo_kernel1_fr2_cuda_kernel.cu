//
// auto-generated by ops.py
//
__constant__ int xdim0_update_halo_kernel1_fr2;
__constant__ int ydim0_update_halo_kernel1_fr2;
__constant__ int xdim1_update_halo_kernel1_fr2;
__constant__ int ydim1_update_halo_kernel1_fr2;
__constant__ int xdim2_update_halo_kernel1_fr2;
__constant__ int ydim2_update_halo_kernel1_fr2;
__constant__ int xdim3_update_halo_kernel1_fr2;
__constant__ int ydim3_update_halo_kernel1_fr2;
__constant__ int xdim4_update_halo_kernel1_fr2;
__constant__ int ydim4_update_halo_kernel1_fr2;
__constant__ int xdim5_update_halo_kernel1_fr2;
__constant__ int ydim5_update_halo_kernel1_fr2;
__constant__ int xdim6_update_halo_kernel1_fr2;
__constant__ int ydim6_update_halo_kernel1_fr2;

#define OPS_ACC0(x,y,z) (x+xdim0_update_halo_kernel1_fr2*(y)+xdim0_update_halo_kernel1_fr2*ydim0_update_halo_kernel1_fr2*(z))
#define OPS_ACC1(x,y,z) (x+xdim1_update_halo_kernel1_fr2*(y)+xdim1_update_halo_kernel1_fr2*ydim1_update_halo_kernel1_fr2*(z))
#define OPS_ACC2(x,y,z) (x+xdim2_update_halo_kernel1_fr2*(y)+xdim2_update_halo_kernel1_fr2*ydim2_update_halo_kernel1_fr2*(z))
#define OPS_ACC3(x,y,z) (x+xdim3_update_halo_kernel1_fr2*(y)+xdim3_update_halo_kernel1_fr2*ydim3_update_halo_kernel1_fr2*(z))
#define OPS_ACC4(x,y,z) (x+xdim4_update_halo_kernel1_fr2*(y)+xdim4_update_halo_kernel1_fr2*ydim4_update_halo_kernel1_fr2*(z))
#define OPS_ACC5(x,y,z) (x+xdim5_update_halo_kernel1_fr2*(y)+xdim5_update_halo_kernel1_fr2*ydim5_update_halo_kernel1_fr2*(z))
#define OPS_ACC6(x,y,z) (x+xdim6_update_halo_kernel1_fr2*(y)+xdim6_update_halo_kernel1_fr2*ydim6_update_halo_kernel1_fr2*(z))

//user function
__device__

inline void update_halo_kernel1_fr2(double *density0, double *density1,
                          double *energy0, double *energy1,
                          double *pressure, double *viscosity,
                          double *soundspeed , const int* fields) {
  if(fields[FIELD_DENSITY0] == 1) density0[OPS_ACC0(0,0,0)] = density0[OPS_ACC0(0,0,-3)];
  if(fields[FIELD_DENSITY1] == 1) density1[OPS_ACC1(0,0,0)] = density1[OPS_ACC1(0,0,-3)];
  if(fields[FIELD_ENERGY0] == 1) energy0[OPS_ACC2(0,0,0)] = energy0[OPS_ACC2(0,0,-3)];
  if(fields[FIELD_ENERGY1] == 1) energy1[OPS_ACC3(0,0,0)] = energy1[OPS_ACC3(0,0,-3)];
  if(fields[FIELD_PRESSURE] == 1) pressure[OPS_ACC4(0,0,0)] = pressure[OPS_ACC4(0,0,-3)];
  if(fields[FIELD_VISCOSITY] == 1) viscosity[OPS_ACC5(0,0,0)] = viscosity[OPS_ACC5(0,0,-3)];
  if(fields[FIELD_SOUNDSPEED] == 1) soundspeed[OPS_ACC6(0,0,0)] = soundspeed[OPS_ACC6(0,0,-3)];

}



#undef OPS_ACC0
#undef OPS_ACC1
#undef OPS_ACC2
#undef OPS_ACC3
#undef OPS_ACC4
#undef OPS_ACC5
#undef OPS_ACC6


__global__ void ops_update_halo_kernel1_fr2(
double* __restrict arg0,
double* __restrict arg1,
double* __restrict arg2,
double* __restrict arg3,
double* __restrict arg4,
double* __restrict arg5,
double* __restrict arg6,
const int* __restrict arg7,
int size0,
int size1,
int size2 ){


  int idx_z = blockDim.z * blockIdx.z + threadIdx.z;
  int idx_y = blockDim.y * blockIdx.y + threadIdx.y;
  int idx_x = blockDim.x * blockIdx.x + threadIdx.x;

  arg0 += idx_x * 1 + idx_y * 1 * xdim0_update_halo_kernel1_fr2 + idx_z * 1 * xdim0_update_halo_kernel1_fr2 * ydim0_update_halo_kernel1_fr2;
  arg1 += idx_x * 1 + idx_y * 1 * xdim1_update_halo_kernel1_fr2 + idx_z * 1 * xdim1_update_halo_kernel1_fr2 * ydim1_update_halo_kernel1_fr2;
  arg2 += idx_x * 1 + idx_y * 1 * xdim2_update_halo_kernel1_fr2 + idx_z * 1 * xdim2_update_halo_kernel1_fr2 * ydim2_update_halo_kernel1_fr2;
  arg3 += idx_x * 1 + idx_y * 1 * xdim3_update_halo_kernel1_fr2 + idx_z * 1 * xdim3_update_halo_kernel1_fr2 * ydim3_update_halo_kernel1_fr2;
  arg4 += idx_x * 1 + idx_y * 1 * xdim4_update_halo_kernel1_fr2 + idx_z * 1 * xdim4_update_halo_kernel1_fr2 * ydim4_update_halo_kernel1_fr2;
  arg5 += idx_x * 1 + idx_y * 1 * xdim5_update_halo_kernel1_fr2 + idx_z * 1 * xdim5_update_halo_kernel1_fr2 * ydim5_update_halo_kernel1_fr2;
  arg6 += idx_x * 1 + idx_y * 1 * xdim6_update_halo_kernel1_fr2 + idx_z * 1 * xdim6_update_halo_kernel1_fr2 * ydim6_update_halo_kernel1_fr2;

  if (idx_x < size0 && idx_y < size1 && idx_z < size2) {
    update_halo_kernel1_fr2(arg0, arg1, arg2, arg3,
                   arg4, arg5, arg6, arg7);
  }

}

// host stub function
void ops_par_loop_update_halo_kernel1_fr2(char const *name, ops_block block, int dim, int* range,
 ops_arg arg0, ops_arg arg1, ops_arg arg2, ops_arg arg3,
 ops_arg arg4, ops_arg arg5, ops_arg arg6, ops_arg arg7) {

  ops_arg args[8] = { arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7};


  ops_timing_realloc(51,"update_halo_kernel1_fr2");
  OPS_kernels[51].count++;

  //compute locally allocated range for the sub-block
  int start[3];
  int end[3];
  #ifdef OPS_MPI
  sub_block_list sb = OPS_sub_block_list[block->index];
  if (!sb->owned) return;
  for ( int n=0; n<3; n++ ){
    start[n] = sb->decomp_disp[n];end[n] = sb->decomp_disp[n]+sb->decomp_size[n];
    if (start[n] >= range[2*n]) {
      start[n] = 0;
    }
    else {
      start[n] = range[2*n] - start[n];
    }
    if (sb->id_m[n]==MPI_PROC_NULL && range[2*n] < 0) start[n] = range[2*n];
    if (end[n] >= range[2*n+1]) {
      end[n] = range[2*n+1] - sb->decomp_disp[n];
    }
    else {
      end[n] = sb->decomp_size[n];
    }
    if (sb->id_p[n]==MPI_PROC_NULL && (range[2*n+1] > sb->decomp_disp[n]+sb->decomp_size[n]))
      end[n] += (range[2*n+1]-sb->decomp_disp[n]-sb->decomp_size[n]);
  }
  #else //OPS_MPI
  for ( int n=0; n<3; n++ ){
    start[n] = range[2*n];end[n] = range[2*n+1];
  }
  #endif //OPS_MPI

  int x_size = MAX(0,end[0]-start[0]);
  int y_size = MAX(0,end[1]-start[1]);
  int z_size = MAX(0,end[2]-start[2]);

  int xdim0 = args[0].dat->size[0]*args[0].dat->dim;
  int ydim0 = args[0].dat->size[1];
  int xdim1 = args[1].dat->size[0]*args[1].dat->dim;
  int ydim1 = args[1].dat->size[1];
  int xdim2 = args[2].dat->size[0]*args[2].dat->dim;
  int ydim2 = args[2].dat->size[1];
  int xdim3 = args[3].dat->size[0]*args[3].dat->dim;
  int ydim3 = args[3].dat->size[1];
  int xdim4 = args[4].dat->size[0]*args[4].dat->dim;
  int ydim4 = args[4].dat->size[1];
  int xdim5 = args[5].dat->size[0]*args[5].dat->dim;
  int ydim5 = args[5].dat->size[1];
  int xdim6 = args[6].dat->size[0]*args[6].dat->dim;
  int ydim6 = args[6].dat->size[1];


  //Timing
  double t1,t2,c1,c2;
  ops_timers_core(&c2,&t2);

  if (OPS_kernels[51].count == 1) {
    cudaMemcpyToSymbol( xdim0_update_halo_kernel1_fr2, &xdim0, sizeof(int) );
    cudaMemcpyToSymbol( ydim0_update_halo_kernel1_fr2, &ydim0, sizeof(int) );
    cudaMemcpyToSymbol( xdim1_update_halo_kernel1_fr2, &xdim1, sizeof(int) );
    cudaMemcpyToSymbol( ydim1_update_halo_kernel1_fr2, &ydim1, sizeof(int) );
    cudaMemcpyToSymbol( xdim2_update_halo_kernel1_fr2, &xdim2, sizeof(int) );
    cudaMemcpyToSymbol( ydim2_update_halo_kernel1_fr2, &ydim2, sizeof(int) );
    cudaMemcpyToSymbol( xdim3_update_halo_kernel1_fr2, &xdim3, sizeof(int) );
    cudaMemcpyToSymbol( ydim3_update_halo_kernel1_fr2, &ydim3, sizeof(int) );
    cudaMemcpyToSymbol( xdim4_update_halo_kernel1_fr2, &xdim4, sizeof(int) );
    cudaMemcpyToSymbol( ydim4_update_halo_kernel1_fr2, &ydim4, sizeof(int) );
    cudaMemcpyToSymbol( xdim5_update_halo_kernel1_fr2, &xdim5, sizeof(int) );
    cudaMemcpyToSymbol( ydim5_update_halo_kernel1_fr2, &ydim5, sizeof(int) );
    cudaMemcpyToSymbol( xdim6_update_halo_kernel1_fr2, &xdim6, sizeof(int) );
    cudaMemcpyToSymbol( ydim6_update_halo_kernel1_fr2, &ydim6, sizeof(int) );
  }


  int *arg7h = (int *)arg7.data;

  dim3 grid( (x_size-1)/OPS_block_size_x+ 1, (y_size-1)/OPS_block_size_y + 1, z_size);
  dim3 tblock(OPS_block_size_x,OPS_block_size_y,1);

  int consts_bytes = 0;

  consts_bytes += ROUND_UP(NUM_FIELDS*sizeof(int));

  reallocConstArrays(consts_bytes);

  consts_bytes = 0;
  arg7.data = OPS_consts_h + consts_bytes;
  arg7.data_d = OPS_consts_d + consts_bytes;
  for (int d=0; d<NUM_FIELDS; d++) ((int *)arg7.data)[d] = arg7h[d];
  consts_bytes += ROUND_UP(NUM_FIELDS*sizeof(int));
  mvConstArraysToDevice(consts_bytes);
  int dat0 = args[0].dat->elem_size;
  int dat1 = args[1].dat->elem_size;
  int dat2 = args[2].dat->elem_size;
  int dat3 = args[3].dat->elem_size;
  int dat4 = args[4].dat->elem_size;
  int dat5 = args[5].dat->elem_size;
  int dat6 = args[6].dat->elem_size;

  char *p_a[8];

  //set up initial pointers
  int d_m[OPS_MAX_DIM];
  #ifdef OPS_MPI
  for (int d = 0; d < dim; d++) d_m[d] = args[0].dat->d_m[d] + OPS_sub_dat_list[args[0].dat->index]->d_im[d];
  #else //OPS_MPI
  for (int d = 0; d < dim; d++) d_m[d] = args[0].dat->d_m[d];
  #endif //OPS_MPI
  int base0 = dat0 * 1 * 
  (start[0] * args[0].stencil->stride[0] - args[0].dat->base[0] - d_m[0]);
  base0 = base0+ dat0 *
    args[0].dat->size[0] *
    (start[1] * args[0].stencil->stride[1] - args[0].dat->base[1] - d_m[1]);
  base0 = base0+ dat0 *
    args[0].dat->size[0] *
    args[0].dat->size[1] *
    (start[2] * args[0].stencil->stride[2] - args[0].dat->base[2] - d_m[2]);
  p_a[0] = (char *)args[0].data_d + base0;

  #ifdef OPS_MPI
  for (int d = 0; d < dim; d++) d_m[d] = args[1].dat->d_m[d] + OPS_sub_dat_list[args[1].dat->index]->d_im[d];
  #else //OPS_MPI
  for (int d = 0; d < dim; d++) d_m[d] = args[1].dat->d_m[d];
  #endif //OPS_MPI
  int base1 = dat1 * 1 * 
  (start[0] * args[1].stencil->stride[0] - args[1].dat->base[0] - d_m[0]);
  base1 = base1+ dat1 *
    args[1].dat->size[0] *
    (start[1] * args[1].stencil->stride[1] - args[1].dat->base[1] - d_m[1]);
  base1 = base1+ dat1 *
    args[1].dat->size[0] *
    args[1].dat->size[1] *
    (start[2] * args[1].stencil->stride[2] - args[1].dat->base[2] - d_m[2]);
  p_a[1] = (char *)args[1].data_d + base1;

  #ifdef OPS_MPI
  for (int d = 0; d < dim; d++) d_m[d] = args[2].dat->d_m[d] + OPS_sub_dat_list[args[2].dat->index]->d_im[d];
  #else //OPS_MPI
  for (int d = 0; d < dim; d++) d_m[d] = args[2].dat->d_m[d];
  #endif //OPS_MPI
  int base2 = dat2 * 1 * 
  (start[0] * args[2].stencil->stride[0] - args[2].dat->base[0] - d_m[0]);
  base2 = base2+ dat2 *
    args[2].dat->size[0] *
    (start[1] * args[2].stencil->stride[1] - args[2].dat->base[1] - d_m[1]);
  base2 = base2+ dat2 *
    args[2].dat->size[0] *
    args[2].dat->size[1] *
    (start[2] * args[2].stencil->stride[2] - args[2].dat->base[2] - d_m[2]);
  p_a[2] = (char *)args[2].data_d + base2;

  #ifdef OPS_MPI
  for (int d = 0; d < dim; d++) d_m[d] = args[3].dat->d_m[d] + OPS_sub_dat_list[args[3].dat->index]->d_im[d];
  #else //OPS_MPI
  for (int d = 0; d < dim; d++) d_m[d] = args[3].dat->d_m[d];
  #endif //OPS_MPI
  int base3 = dat3 * 1 * 
  (start[0] * args[3].stencil->stride[0] - args[3].dat->base[0] - d_m[0]);
  base3 = base3+ dat3 *
    args[3].dat->size[0] *
    (start[1] * args[3].stencil->stride[1] - args[3].dat->base[1] - d_m[1]);
  base3 = base3+ dat3 *
    args[3].dat->size[0] *
    args[3].dat->size[1] *
    (start[2] * args[3].stencil->stride[2] - args[3].dat->base[2] - d_m[2]);
  p_a[3] = (char *)args[3].data_d + base3;

  #ifdef OPS_MPI
  for (int d = 0; d < dim; d++) d_m[d] = args[4].dat->d_m[d] + OPS_sub_dat_list[args[4].dat->index]->d_im[d];
  #else //OPS_MPI
  for (int d = 0; d < dim; d++) d_m[d] = args[4].dat->d_m[d];
  #endif //OPS_MPI
  int base4 = dat4 * 1 * 
  (start[0] * args[4].stencil->stride[0] - args[4].dat->base[0] - d_m[0]);
  base4 = base4+ dat4 *
    args[4].dat->size[0] *
    (start[1] * args[4].stencil->stride[1] - args[4].dat->base[1] - d_m[1]);
  base4 = base4+ dat4 *
    args[4].dat->size[0] *
    args[4].dat->size[1] *
    (start[2] * args[4].stencil->stride[2] - args[4].dat->base[2] - d_m[2]);
  p_a[4] = (char *)args[4].data_d + base4;

  #ifdef OPS_MPI
  for (int d = 0; d < dim; d++) d_m[d] = args[5].dat->d_m[d] + OPS_sub_dat_list[args[5].dat->index]->d_im[d];
  #else //OPS_MPI
  for (int d = 0; d < dim; d++) d_m[d] = args[5].dat->d_m[d];
  #endif //OPS_MPI
  int base5 = dat5 * 1 * 
  (start[0] * args[5].stencil->stride[0] - args[5].dat->base[0] - d_m[0]);
  base5 = base5+ dat5 *
    args[5].dat->size[0] *
    (start[1] * args[5].stencil->stride[1] - args[5].dat->base[1] - d_m[1]);
  base5 = base5+ dat5 *
    args[5].dat->size[0] *
    args[5].dat->size[1] *
    (start[2] * args[5].stencil->stride[2] - args[5].dat->base[2] - d_m[2]);
  p_a[5] = (char *)args[5].data_d + base5;

  #ifdef OPS_MPI
  for (int d = 0; d < dim; d++) d_m[d] = args[6].dat->d_m[d] + OPS_sub_dat_list[args[6].dat->index]->d_im[d];
  #else //OPS_MPI
  for (int d = 0; d < dim; d++) d_m[d] = args[6].dat->d_m[d];
  #endif //OPS_MPI
  int base6 = dat6 * 1 * 
  (start[0] * args[6].stencil->stride[0] - args[6].dat->base[0] - d_m[0]);
  base6 = base6+ dat6 *
    args[6].dat->size[0] *
    (start[1] * args[6].stencil->stride[1] - args[6].dat->base[1] - d_m[1]);
  base6 = base6+ dat6 *
    args[6].dat->size[0] *
    args[6].dat->size[1] *
    (start[2] * args[6].stencil->stride[2] - args[6].dat->base[2] - d_m[2]);
  p_a[6] = (char *)args[6].data_d + base6;


  ops_H_D_exchanges_device(args, 8);
  ops_halo_exchanges(args,8,range);

  ops_timers_core(&c1,&t1);
  OPS_kernels[51].mpi_time += t1-t2;


  //call kernel wrapper function, passing in pointers to data
  ops_update_halo_kernel1_fr2<<<grid, tblock >>> (  (double *)p_a[0], (double *)p_a[1],
           (double *)p_a[2], (double *)p_a[3],
           (double *)p_a[4], (double *)p_a[5],
           (double *)p_a[6], (int *)arg7.data_d,x_size, y_size, z_size);

  if (OPS_diags>1) {
    cutilSafeCall(cudaDeviceSynchronize());
  }
  ops_timers_core(&c2,&t2);
  OPS_kernels[51].time += t2-t1;
  ops_set_dirtybit_device(args, 8);
  ops_set_halo_dirtybit3(&args[0],range);
  ops_set_halo_dirtybit3(&args[1],range);
  ops_set_halo_dirtybit3(&args[2],range);
  ops_set_halo_dirtybit3(&args[3],range);
  ops_set_halo_dirtybit3(&args[4],range);
  ops_set_halo_dirtybit3(&args[5],range);
  ops_set_halo_dirtybit3(&args[6],range);

  //Update kernel record
  OPS_kernels[51].transfer += ops_compute_transfer(dim, range, &arg0);
  OPS_kernels[51].transfer += ops_compute_transfer(dim, range, &arg1);
  OPS_kernels[51].transfer += ops_compute_transfer(dim, range, &arg2);
  OPS_kernels[51].transfer += ops_compute_transfer(dim, range, &arg3);
  OPS_kernels[51].transfer += ops_compute_transfer(dim, range, &arg4);
  OPS_kernels[51].transfer += ops_compute_transfer(dim, range, &arg5);
  OPS_kernels[51].transfer += ops_compute_transfer(dim, range, &arg6);
}
