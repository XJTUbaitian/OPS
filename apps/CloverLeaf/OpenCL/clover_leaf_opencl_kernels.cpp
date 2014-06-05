//
// auto-generated by op2.py on 2014-05-12 15:16
//

//header
#include "stdlib.h"
#include "stdio.h"
#include "ops_lib_cpp.h"
#include "ops_opencl_rt_support.h"
//global constants
extern double g_small;
extern double g_big;
extern double dtc_safe;
extern double dtu_safe;
extern double dtv_safe;
extern double dtdiv_safe;
extern field_type field;
extern grid_type grid;
extern state_type *states;
extern int number_of_states;
extern int g_circ;
extern int g_point;
extern int g_rect;
extern double dt;


  extern ops_opencl_core OPS_opencl_core;

  #define MAX_SOURCE_SIZE (2*0x1000000)
  
  void buildOpenCLKernels() {
    static bool isbuilt = false;
  
    if(!isbuilt) {
      clSafeCall( clUnloadCompiler() );
  
      OPS_opencl_core.n_kernels = 2;
      OPS_opencl_core.kernel = (cl_kernel*) malloc(2*sizeof(cl_kernel));  
      
      cl_int ret;
      char* source_filename[2] = {
          "./OpenCL/viscosity_kernel.cl",
          "./OpenCL/accelerate_kernel.cl"
      };
  
      // Load the kernel source code into the array source_str
      FILE *fid;
      char *source_str[2];
      size_t source_size[2];
  
      for(int i=0; i<2; i++) {
        fid = fopen(source_filename[i], "r");
        if (!fid) {
          fprintf(stderr, "Can't open the kernel source file!\n");
          exit(1);
        }
        
        source_str[i] = (char*)malloc(MAX_SOURCE_SIZE);
        source_size[i] = fread(source_str[i], 1, MAX_SOURCE_SIZE, fid);
        if(source_size[i] != MAX_SOURCE_SIZE) {
          if (ferror(fid)) {
            printf ("Error while reading kernel source file %s\n", source_filename[i]);
            exit(-1);
          }
          if (feof(fid))
            printf ("Kernel source file %s succesfuly read.\n", source_filename[i]);
            //printf("%s\n",source_str[i]);
        }
        fclose(fid);
      }
      
      printf(" compiling sources \n");
  
        // Create a program from the source
        OPS_opencl_core.program = clCreateProgramWithSource(OPS_opencl_core.context, 2, (const char **) &source_str, (const size_t *) &source_size, &ret);
        clSafeCall( ret );
  
        // Build the program
        char buildOpts[255];
        sprintf(buildOpts,"-cl-mad-enable -DOPS_WARPSIZE=%d", 32);
        ret = clBuildProgram(OPS_opencl_core.program, 1, &OPS_opencl_core.device_id, buildOpts, NULL, NULL);
  
        if(ret != CL_SUCCESS) {
          char* build_log;
          size_t log_size;
          clSafeCall( clGetProgramBuildInfo(OPS_opencl_core.program, OPS_opencl_core.device_id, CL_PROGRAM_BUILD_LOG, 0, NULL, &log_size) );
          build_log = (char*) malloc(log_size+1);
          clSafeCall( clGetProgramBuildInfo(OPS_opencl_core.program, OPS_opencl_core.device_id, CL_PROGRAM_BUILD_LOG, log_size, build_log, NULL) );
          build_log[log_size] = '\0';
          fprintf(stderr, "=============== OpenCL Program Build Info ================\n\n%s", build_log);
          fprintf(stderr, "\n========================================================= \n");
          free(build_log);
          exit(EXIT_FAILURE);
        }
        printf(" compiling done\n");
  
      // Create the OpenCL kernel
      OPS_opencl_core.kernel[0] = clCreateKernel(OPS_opencl_core.program, "ops_viscosity_kernel", &ret);
      clSafeCall( ret );
      OPS_opencl_core.kernel[1] = clCreateKernel(OPS_opencl_core.program, "ops_accelerate_kernel", &ret);
      clSafeCall( ret );
            
      isbuilt = true;
    }
    
  }
  
//this needs to be a platform specific copy symbol to device function
void ops_decl_const_char( int dim, char const * type, int typeSize, char * data, char const * name )
{
  (void)dim;
  (void)type;
  (void)typeSize;
  (void)data;
  (void)name;
}

  
//user kernel files
#include "viscosity_kernel_opencl_kernel.cpp"
#include "accelerate_kernel_opencl_kernel.cpp"
