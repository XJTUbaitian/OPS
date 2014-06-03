//
// auto-generated by ops.py on 2014-06-03 13:36
//


// host stub function
void ops_par_loop_calc_dt_kernel_get(char const *name, ops_block Block, int dim, int* range,
 ops_arg arg0, ops_arg arg1, ops_arg arg2, ops_arg arg3) {

  buildOpenCLKernels();
  ops_arg args[4] = { arg0, arg1, arg2, arg3};

  sub_block_list sb = OPS_sub_block_list[Block->index];
  //compute localy allocated range for the sub-block
  int start_add[2];
  int end_add[2];
  for ( int n=0; n<2; n++ ){
    start_add[n] = sb->istart[n];end_add[n] = sb->iend[n]+1;
    if (start_add[n] >= range[2*n]) {
      start_add[n] = 0;
    }
    else {
      start_add[n] = range[2*n] - start_add[n];
    }
    if (end_add[n] >= range[2*n+1]) {
      end_add[n] = range[2*n+1] - sb->istart[n];
    }
    else {
      end_add[n] = sb->sizes[n];
    }
  }


  int x_size = end_add[0]-start_add[0];
  int y_size = end_add[1]-start_add[1];

  int xdim0 = args[0].dat->block_size[0]*args[0].dat->dim;
  int xdim1 = args[1].dat->block_size[0]*args[1].dat->dim;


  //Timing
  double t1,t2,c1,c2;
  ops_timing_realloc(72,"calc_dt_kernel_get");
  ops_timers_core(&c1,&t1);

  //set up OpenCL thread blocks
  size_t globalWorkSize[3] = {((x_size-1)/OPS_block_size_x+ 1)*OPS_block_size_x, ((y_size-1)/OPS_block_size_y + 1)*OPS_block_size_y, 1};
  size_t localWorkSize[3] =  {OPS_block_size_x,OPS_block_size_y,1};


  double *arg2h = (double *)arg2.data;
  double *arg3h = (double *)arg3.data;
  int nblocks = ((x_size-1)/OPS_block_size_x+ 1)*((y_size-1)/OPS_block_size_y + 1);
  int maxblocks = nblocks;
  int reduct_bytes = 0;

  reduct_bytes += ROUND_UP(maxblocks*1*sizeof(double)*64);
  reduct_bytes += ROUND_UP(maxblocks*1*sizeof(double)*64);

  reallocReductArrays(reduct_bytes);
  reduct_bytes = 0;

  int r_bytes2 = reduct_bytes/sizeof(double);
  arg2.data = OPS_reduct_h + reduct_bytes;
  arg2.data_d = OPS_reduct_d;// + reduct_bytes;
  for (int b=0; b<maxblocks; b++)
  for (int d=0; d<1; d++) ((double *)arg2.data)[d+b*1] = ZERO_double;
  reduct_bytes += ROUND_UP(maxblocks*1*sizeof(double));

  int r_bytes3 = reduct_bytes/sizeof(double);
  arg3.data = OPS_reduct_h + reduct_bytes;
  arg3.data_d = OPS_reduct_d;// + reduct_bytes;
  for (int b=0; b<maxblocks; b++)
  for (int d=0; d<1; d++) ((double *)arg3.data)[d+b*1] = ZERO_double;
  reduct_bytes += ROUND_UP(maxblocks*1*sizeof(double));


  mvReductArraysToDevice(reduct_bytes);
  int dat0 = args[0].dat->size;
  int dat1 = args[1].dat->size;

  //set up initial pointers
  int base0 = dat0 * 1 * 
  (start_add[0] * args[0].stencil->stride[0] - args[0].dat->offset[0]);
  base0 = base0  + dat0 * args[0].dat->block_size[0] * 
  (start_add[1] * args[0].stencil->stride[1] - args[0].dat->offset[1]);
  base0 = base0/dat0;

  //set up initial pointers
  int base1 = dat1 * 1 * 
  (start_add[0] * args[1].stencil->stride[0] - args[1].dat->offset[0]);
  base1 = base1  + dat1 * args[1].dat->block_size[0] * 
  (start_add[1] * args[1].stencil->stride[1] - args[1].dat->offset[1]);
  base1 = base1/dat1;


  ops_H_D_exchanges_cuda(args, 4);

  int nthread = OPS_block_size_x*OPS_block_size_y;


  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[72], 0, sizeof(cl_mem), (void*) &arg0.data_d ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[72], 1, sizeof(cl_mem), (void*) &arg1.data_d ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[72], 2, sizeof(cl_mem), (void*) &arg2.data_d ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[72], 3, nthread*sizeof(double), NULL));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[72], 4, sizeof(cl_int), (void*) &r_bytes2 ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[72], 5, sizeof(cl_mem), (void*) &arg3.data_d ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[72], 6, nthread*sizeof(double), NULL));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[72], 7, sizeof(cl_int), (void*) &r_bytes3 ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[72], 8, sizeof(cl_int), (void*) &xdim0 ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[72], 9, sizeof(cl_int), (void*) &xdim1 ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[72], 10, sizeof(cl_int), (void*) &base0 ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[72], 11, sizeof(cl_int), (void*) &base1 ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[72], 12, sizeof(cl_int), (void*) &x_size ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[72], 13, sizeof(cl_int), (void*) &y_size ));

  //call/enque opencl kernel wrapper function
  clSafeCall( clEnqueueNDRangeKernel(OPS_opencl_core.command_queue, OPS_opencl_core.kernel[72], 3, NULL, globalWorkSize, localWorkSize, 0, NULL, NULL) );
  clSafeCall( clFinish(OPS_opencl_core.command_queue) );

  mvReductArraysToHost(reduct_bytes);
  for ( int b=0; b<maxblocks; b++ ){
    for ( int d=0; d<1; d++ ){
      arg2h[d] = arg2h[d] + ((double *)arg2.data)[d+b*1];
    }
  }
  arg2.data = (char *)arg2h;

  for ( int b=0; b<maxblocks; b++ ){
    for ( int d=0; d<1; d++ ){
      arg3h[d] = arg3h[d] + ((double *)arg3.data)[d+b*1];
    }
  }
  arg3.data = (char *)arg3h;

  ops_set_dirtybit_cuda(args, 4);
  ops_H_D_exchanges(args, 4);

  //Update kernel record
  ops_timers_core(&c2,&t2);
  OPS_kernels[72].count++;
  OPS_kernels[72].time += t2-t1;
  OPS_kernels[72].transfer += ops_compute_transfer(dim, range, &arg0);
  OPS_kernels[72].transfer += ops_compute_transfer(dim, range, &arg1);
}
