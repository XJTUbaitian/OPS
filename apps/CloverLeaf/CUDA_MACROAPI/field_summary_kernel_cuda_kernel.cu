//
// auto-generated by ops.py on 2013-11-19 16:38
//

__constant__ int xdim0_field_summary_kernel;
__constant__ int xdim1_field_summary_kernel;
__constant__ int xdim2_field_summary_kernel;
__constant__ int xdim3_field_summary_kernel;
__constant__ int xdim4_field_summary_kernel;
__constant__ int xdim5_field_summary_kernel;

#define OPS_ACC0(x,y) (x+xdim0_field_summary_kernel*(y))
#define OPS_ACC1(x,y) (x+xdim1_field_summary_kernel*(y))
#define OPS_ACC2(x,y) (x+xdim2_field_summary_kernel*(y))
#define OPS_ACC3(x,y) (x+xdim3_field_summary_kernel*(y))
#define OPS_ACC4(x,y) (x+xdim4_field_summary_kernel*(y))
#define OPS_ACC5(x,y) (x+xdim5_field_summary_kernel*(y))

//user function
__device__

inline void field_summary_kernel( const double *volume, const double *density0,
                     const double *energy0, const double *pressure,
                     const double *xvel0,
                     const double *yvel0,
                     double *vol,
                     double *mass,
                     double *ie,
                     double *ke,
                     double *press) {

  double vsqrd, cell_vol, cell_mass;

  //xvel0, 0,0, 1,0, 0,1, 1,1
  //yvel0, 0,0, 1,0, 0,1, 1,1

  vsqrd = 0.0;
  vsqrd = vsqrd + 0.25 * ( xvel0[OPS_ACC4(0,0)] * xvel0[OPS_ACC4(0,0)] + yvel0[OPS_ACC5(0,0)] * yvel0[OPS_ACC5(0,0)]);
  vsqrd = vsqrd + 0.25 * ( xvel0[OPS_ACC4(1,0)] * xvel0[OPS_ACC4(1,0)] + yvel0[OPS_ACC5(1,0)] * yvel0[OPS_ACC5(1,0)]);
  vsqrd = vsqrd + 0.25 * ( xvel0[OPS_ACC4(0,1)] * xvel0[OPS_ACC4(0,1)] + yvel0[OPS_ACC5(0,1)] * yvel0[OPS_ACC5(0,1)]);
  vsqrd = vsqrd + 0.25 * ( xvel0[OPS_ACC4(1,1)] * xvel0[OPS_ACC4(1,1)] + yvel0[OPS_ACC5(1,1)] * yvel0[OPS_ACC5(1,1)]);


  cell_vol = volume[OPS_ACC0(0,0)];
  cell_mass = cell_vol * density0[OPS_ACC1(0,0)];
  *vol = *vol + cell_vol;
  *mass = *mass + cell_mass;
  *ie = *ie + cell_mass * energy0[OPS_ACC2(0,0)];
  *ke = *ke + cell_mass * 0.5 * vsqrd;
  *press = *press + cell_vol * pressure[OPS_ACC3(0,0)];

}

#undef OPS_ACC0
#undef OPS_ACC1
#undef OPS_ACC2
#undef OPS_ACC3
#undef OPS_ACC4
#undef OPS_ACC5


__global__ void ops_field_summary_kernel(
const double* __restrict arg0,
const double* __restrict arg1,
const double* __restrict arg2,
const double* __restrict arg3,
const double* __restrict arg4,
const double* __restrict arg5,
double* __restrict arg6,
double* __restrict arg7,
double* __restrict arg8,
double* __restrict arg9,
double* __restrict arg10,
int size0,
int size1 ){

  double arg6_l[1];
  double arg7_l[1];
  double arg8_l[1];
  double arg9_l[1];
  double arg10_l[1];
  for (int d=0; d<1; d++) arg6_l[d] = ZERO_double;
  for (int d=0; d<1; d++) arg7_l[d] = ZERO_double;
  for (int d=0; d<1; d++) arg8_l[d] = ZERO_double;
  for (int d=0; d<1; d++) arg9_l[d] = ZERO_double;
  for (int d=0; d<1; d++) arg10_l[d] = ZERO_double;

  int idx_y = blockDim.y * blockIdx.y + threadIdx.y;
  int idx_x = blockDim.x * blockIdx.x + threadIdx.x;

  arg0 += idx_x * 1 + idx_y * 1 * xdim0_field_summary_kernel;
  arg1 += idx_x * 1 + idx_y * 1 * xdim1_field_summary_kernel;
  arg2 += idx_x * 1 + idx_y * 1 * xdim2_field_summary_kernel;
  arg3 += idx_x * 1 + idx_y * 1 * xdim3_field_summary_kernel;
  arg4 += idx_x * 1 + idx_y * 1 * xdim4_field_summary_kernel;
  arg5 += idx_x * 1 + idx_y * 1 * xdim5_field_summary_kernel;

  if (idx_x < size0 && idx_y < size1) {
    field_summary_kernel(arg0, arg1, arg2, arg3,
                   arg4, arg5, arg6_l, arg7_l, arg8_l,
                   arg9_l, arg10_l);
  }
  for (int d=0; d<1; d++)
    ops_reduction<OPS_INC>(&arg6[d+blockIdx.x + blockIdx.y*gridDim.x],arg6_l[d]);
  for (int d=0; d<1; d++)
    ops_reduction<OPS_INC>(&arg7[d+blockIdx.x + blockIdx.y*gridDim.x],arg7_l[d]);
  for (int d=0; d<1; d++)
    ops_reduction<OPS_INC>(&arg8[d+blockIdx.x + blockIdx.y*gridDim.x],arg8_l[d]);
  for (int d=0; d<1; d++)
    ops_reduction<OPS_INC>(&arg9[d+blockIdx.x + blockIdx.y*gridDim.x],arg9_l[d]);
  for (int d=0; d<1; d++)
    ops_reduction<OPS_INC>(&arg10[d+blockIdx.x + blockIdx.y*gridDim.x],arg10_l[d]);

}

// host stub function
void ops_par_loop_field_summary_kernel(char const *name, int dim, int* range,
 ops_arg arg0, ops_arg arg1, ops_arg arg2, ops_arg arg3,
 ops_arg arg4, ops_arg arg5, ops_arg arg6, ops_arg arg7, ops_arg arg8,
 ops_arg arg9, ops_arg arg10) {

  ops_arg args[11] = { arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10};


  int x_size = range[1]-range[0];
  int y_size = range[3]-range[2];

  int xdim0 = args[0].dat->block_size[0];
  int xdim1 = args[1].dat->block_size[0];
  int xdim2 = args[2].dat->block_size[0];
  int xdim3 = args[3].dat->block_size[0];
  int xdim4 = args[4].dat->block_size[0];
  int xdim5 = args[5].dat->block_size[0];

  ops_timing_realloc(4);
  if (OPS_kernels[4].count == 0) {
    cudaMemcpyToSymbol( xdim0_field_summary_kernel, &xdim0, sizeof(int) );
    cudaMemcpyToSymbol( xdim1_field_summary_kernel, &xdim1, sizeof(int) );
    cudaMemcpyToSymbol( xdim2_field_summary_kernel, &xdim2, sizeof(int) );
    cudaMemcpyToSymbol( xdim3_field_summary_kernel, &xdim3, sizeof(int) );
    cudaMemcpyToSymbol( xdim4_field_summary_kernel, &xdim4, sizeof(int) );
    cudaMemcpyToSymbol( xdim5_field_summary_kernel, &xdim5, sizeof(int) );
  }


  double *arg6h = (double *)arg6.data;
  double *arg7h = (double *)arg7.data;
  double *arg8h = (double *)arg8.data;
  double *arg9h = (double *)arg9.data;
  double *arg10h = (double *)arg10.data;

  dim3 grid( (x_size-1)/OPS_block_size_x+ 1, (y_size-1)/OPS_block_size_y + 1, 1);
  dim3 block(OPS_block_size_x,OPS_block_size_y,1);

  int nblocks = ((x_size-1)/OPS_block_size_x+ 1)*((y_size-1)/OPS_block_size_y + 1);
  int maxblocks = nblocks;
  int reduct_bytes = 0;
  int reduct_size = 0;

  reduct_bytes += ROUND_UP(maxblocks*1*sizeof(double));
  reduct_size = MAX(reduct_size,sizeof(double)*1);
  reduct_bytes += ROUND_UP(maxblocks*1*sizeof(double));
  reduct_size = MAX(reduct_size,sizeof(double)*1);
  reduct_bytes += ROUND_UP(maxblocks*1*sizeof(double));
  reduct_size = MAX(reduct_size,sizeof(double)*1);
  reduct_bytes += ROUND_UP(maxblocks*1*sizeof(double));
  reduct_size = MAX(reduct_size,sizeof(double)*1);
  reduct_bytes += ROUND_UP(maxblocks*1*sizeof(double));
  reduct_size = MAX(reduct_size,sizeof(double)*1);

  reallocReductArrays(reduct_bytes);
  reduct_bytes = 0;

  arg6.data = OPS_reduct_h + reduct_bytes;
  arg6.data_d = OPS_reduct_d + reduct_bytes;
  for (int b=0; b<maxblocks; b++)
  for (int d=0; d<1; d++) ((double *)arg6.data)[d+b*1] = ZERO_double;
  reduct_bytes += ROUND_UP(maxblocks*1*sizeof(double));

  arg7.data = OPS_reduct_h + reduct_bytes;
  arg7.data_d = OPS_reduct_d + reduct_bytes;
  for (int b=0; b<maxblocks; b++)
  for (int d=0; d<1; d++) ((double *)arg7.data)[d+b*1] = ZERO_double;
  reduct_bytes += ROUND_UP(maxblocks*1*sizeof(double));

  arg8.data = OPS_reduct_h + reduct_bytes;
  arg8.data_d = OPS_reduct_d + reduct_bytes;
  for (int b=0; b<maxblocks; b++)
  for (int d=0; d<1; d++) ((double *)arg8.data)[d+b*1] = ZERO_double;
  reduct_bytes += ROUND_UP(maxblocks*1*sizeof(double));

  arg9.data = OPS_reduct_h + reduct_bytes;
  arg9.data_d = OPS_reduct_d + reduct_bytes;
  for (int b=0; b<maxblocks; b++)
  for (int d=0; d<1; d++) ((double *)arg9.data)[d+b*1] = ZERO_double;
  reduct_bytes += ROUND_UP(maxblocks*1*sizeof(double));

  arg10.data = OPS_reduct_h + reduct_bytes;
  arg10.data_d = OPS_reduct_d + reduct_bytes;
  for (int b=0; b<maxblocks; b++)
  for (int d=0; d<1; d++) ((double *)arg10.data)[d+b*1] = ZERO_double;
  reduct_bytes += ROUND_UP(maxblocks*1*sizeof(double));


  mvReductArraysToDevice(reduct_bytes);

  char *p_a[11];


  //set up initial pointers
  p_a[0] = &args[0].data_d[
  + args[0].dat->size * args[0].dat->block_size[0] * ( range[2] * 1 - args[0].dat->offset[1] )
  + args[0].dat->size * ( range[0] * 1 - args[0].dat->offset[0] ) ];

  p_a[1] = &args[1].data_d[
  + args[1].dat->size * args[1].dat->block_size[0] * ( range[2] * 1 - args[1].dat->offset[1] )
  + args[1].dat->size * ( range[0] * 1 - args[1].dat->offset[0] ) ];

  p_a[2] = &args[2].data_d[
  + args[2].dat->size * args[2].dat->block_size[0] * ( range[2] * 1 - args[2].dat->offset[1] )
  + args[2].dat->size * ( range[0] * 1 - args[2].dat->offset[0] ) ];

  p_a[3] = &args[3].data_d[
  + args[3].dat->size * args[3].dat->block_size[0] * ( range[2] * 1 - args[3].dat->offset[1] )
  + args[3].dat->size * ( range[0] * 1 - args[3].dat->offset[0] ) ];

  p_a[4] = &args[4].data_d[
  + args[4].dat->size * args[4].dat->block_size[0] * ( range[2] * 1 - args[4].dat->offset[1] )
  + args[4].dat->size * ( range[0] * 1 - args[4].dat->offset[0] ) ];

  p_a[5] = &args[5].data_d[
  + args[5].dat->size * args[5].dat->block_size[0] * ( range[2] * 1 - args[5].dat->offset[1] )
  + args[5].dat->size * ( range[0] * 1 - args[5].dat->offset[0] ) ];


  ops_halo_exchanges_cuda(args, 11);

  int nshared = 0;
  int nthread = OPS_block_size_x*OPS_block_size_y;

  nshared = MAX(nshared,sizeof(double)*1);
  nshared = MAX(nshared,sizeof(double)*1);
  nshared = MAX(nshared,sizeof(double)*1);
  nshared = MAX(nshared,sizeof(double)*1);
  nshared = MAX(nshared,sizeof(double)*1);

  nshared = MAX(nshared*nthread,reduct_size*nthread);

  //call kernel wrapper function, passing in pointers to data
  ops_field_summary_kernel<<<grid, block, nshared >>> (  (double *)p_a[0], (double *)p_a[1],
           (double *)p_a[2], (double *)p_a[3],
           (double *)p_a[4], (double *)p_a[5],
           (double *)arg6.data_d, (double *)arg7.data_d,
           (double *)arg8.data_d, (double *)arg9.data_d,
           (double *)arg10.data_d,x_size, y_size);

  mvReductArraysToHost(reduct_bytes);
  for ( int b=0; b<maxblocks; b++ ){
    for ( int d=0; d<1; d++ ){
      arg6h[d] = arg6h[d] + ((double *)arg6.data)[d+b*1];
    }
  }
  arg6.data = (char *)arg6h;

  for ( int b=0; b<maxblocks; b++ ){
    for ( int d=0; d<1; d++ ){
      arg7h[d] = arg7h[d] + ((double *)arg7.data)[d+b*1];
    }
  }
  arg7.data = (char *)arg7h;

  for ( int b=0; b<maxblocks; b++ ){
    for ( int d=0; d<1; d++ ){
      arg8h[d] = arg8h[d] + ((double *)arg8.data)[d+b*1];
    }
  }
  arg8.data = (char *)arg8h;

  for ( int b=0; b<maxblocks; b++ ){
    for ( int d=0; d<1; d++ ){
      arg9h[d] = arg9h[d] + ((double *)arg9.data)[d+b*1];
    }
  }
  arg9.data = (char *)arg9h;

  for ( int b=0; b<maxblocks; b++ ){
    for ( int d=0; d<1; d++ ){
      arg10h[d] = arg10h[d] + ((double *)arg10.data)[d+b*1];
    }
  }
  arg10.data = (char *)arg10h;

  ops_set_dirtybit_cuda(args, 11);
  OPS_kernels[4].count++;
}