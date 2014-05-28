//
// auto-generated by ops.py on 2014-05-28 15:13
//


// host stub function
void ops_par_loop_advec_mom_kernel_x2(char const *name, ops_block Block, int dim, int* range,
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
  int xdim2 = args[2].dat->block_size[0]*args[2].dat->dim;
  int xdim3 = args[3].dat->block_size[0]*args[3].dat->dim;


  //Timing
  double t1,t2,c1,c2;
  ops_timing_realloc(12,"advec_mom_kernel_x2");
  ops_timers_core(&c1,&t1);

  //set up OpenCL thread blocks
  size_t globalWorkSize[3] = {((x_size-1)/OPS_block_size_x+ 1)*OPS_block_size_x, ((y_size-1)/OPS_block_size_y + 1)*OPS_block_size_y, 1};
  size_t localWorkSize[3] =  {OPS_block_size_x,OPS_block_size_y,1};




  int dat0 = args[0].dat->size;
  int dat1 = args[1].dat->size;
  int dat2 = args[2].dat->size;
  int dat3 = args[3].dat->size;

  cl_mem p_a[4];

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

  //set up initial pointers
  int base2 = dat2 * 1 * 
  (start_add[0] * args[2].stencil->stride[0] - args[2].dat->offset[0]);
  base2 = base2  + dat2 * args[2].dat->block_size[0] * 
  (start_add[1] * args[2].stencil->stride[1] - args[2].dat->offset[1]);
  base2 = base2/dat2;

  //set up initial pointers
  int base3 = dat3 * 1 * 
  (start_add[0] * args[3].stencil->stride[0] - args[3].dat->offset[0]);
  base3 = base3  + dat3 * args[3].dat->block_size[0] * 
  (start_add[1] * args[3].stencil->stride[1] - args[3].dat->offset[1]);
  base3 = base3/dat3;


  ops_H_D_exchanges_cuda(args, 4);



  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[12], 0, sizeof(cl_mem), (void*) &arg0.data_d ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[12], 1, sizeof(cl_mem), (void*) &arg1.data_d ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[12], 2, sizeof(cl_mem), (void*) &arg2.data_d ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[12], 3, sizeof(cl_mem), (void*) &arg3.data_d ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[12], 4, sizeof(cl_int), (void*) &xdim0 ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[12], 5, sizeof(cl_int), (void*) &xdim1 ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[12], 6, sizeof(cl_int), (void*) &xdim2 ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[12], 7, sizeof(cl_int), (void*) &xdim3 ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[12], 8, sizeof(cl_int), (void*) &base0 ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[12], 9, sizeof(cl_int), (void*) &base1 ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[12], 10, sizeof(cl_int), (void*) &base2 ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[12], 11, sizeof(cl_int), (void*) &base3 ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[12], 12, sizeof(cl_int), (void*) &x_size ));
  clSafeCall( clSetKernelArg(OPS_opencl_core.kernel[12], 13, sizeof(cl_int), (void*) &y_size ));

  //call/enque opencl kernel wrapper function
  clSafeCall( clEnqueueNDRangeKernel(OPS_opencl_core.command_queue, OPS_opencl_core.kernel[12], 3, NULL, globalWorkSize, localWorkSize, 0, NULL, NULL) );
  clSafeCall( clFinish(OPS_opencl_core.command_queue) );

  ops_set_dirtybit_cuda(args, 4);
  ops_H_D_exchanges(args, 4);

  //Update kernel record
  ops_timers_core(&c2,&t2);
  OPS_kernels[12].count++;
  OPS_kernels[12].time += t2-t1;
  OPS_kernels[12].transfer += ops_compute_transfer(dim, range, &arg0);
  OPS_kernels[12].transfer += ops_compute_transfer(dim, range, &arg1);
  OPS_kernels[12].transfer += ops_compute_transfer(dim, range, &arg2);
  OPS_kernels[12].transfer += ops_compute_transfer(dim, range, &arg3);
}
