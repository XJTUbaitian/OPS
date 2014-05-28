
# Open source copyright declaration based on BSD open source template:
# http://www.opensource.org/licenses/bsd-license.php
#
# This file is part of the OPS distribution.
#
# Copyright (c) 2013, Mike Giles and others. Please see the AUTHORS file in
# the main source directory for a full list of copyright holders.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
# The name of Mike Giles may not be used to endorse or promote products
# derived from this software without specific prior written permission.
# THIS SOFTWARE IS PROVIDED BY Mike Giles ''AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL Mike Giles BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

"""
OPS OpenCL code generator

This routine is called by ops.py which parses the input files

It produces a file xxx_opencl_kernel.cpp and a XX_kernel.cl for each kernel,
plus a master kernel file

"""

import re
import datetime
import os

def comm(line):
  global file_text, FORTRAN, CPP
  global depth
  prefix = ' '*depth
  if len(line) == 0:
    file_text +='\n'
  else:
    file_text +=prefix+'//'+line+'\n'

def code(text):
  global file_text, g_m
  global depth
  prefix = ''
  if len(text) != 0:
    prefix = ' '*depth

  file_text += prefix+text+'\n'

def FOR(i,start,finish):
  global file_text
  global depth
  code('for ( int '+i+'='+start+'; '+i+'<'+finish+'; '+i+'++ ){')
  depth += 2

def FOR2(i,start,finish,increment):
  global file_text
  global depth
  code('for ( int '+i+'='+start+'; '+i+'<'+finish+'; '+i+'+='+increment+' ){')
  depth += 2

def WHILE(line):
  global file_text
  global depth
  code('while ( '+ line+ ' ){')
  depth += 2

def ENDWHILE():
  global file_text
  global depth
  depth -= 2
  code('}')

def ENDFOR():
  global file_text
  global depth
  depth -= 2
  code('}')

def IF(line):
  global file_text
  global depth
  code('if ('+ line + ') {')
  depth += 2

def ELSEIF(line):
  global file_text
  global depth
  code('else if ('+ line + ') {')
  depth += 2

def ELSE():
  global file_text
  global depth
  code('else {')
  depth += 2

def ENDIF():
  global file_text
  global depth
  depth -= 2
  code('}')

def mult(text, i, n):
  text = text + '1'
  for nn in range (0, i):
    text = text + '* args['+str(n)+'].dat->block_size['+str(nn)+']'

  return text

def para_parse(text, j, op_b, cl_b):
    """Parsing code block, i.e. text to find the correct closing brace"""

    depth = 0
    loc2 = j

    while 1:
      if text[loc2] == op_b:
            depth = depth + 1

      elif text[loc2] == cl_b:
            depth = depth - 1
            if depth == 0:
                return loc2
      loc2 = loc2 + 1

def comment_remover(text):
    """Remove comments from text"""

    def replacer(match):
        s = match.group(0)
        if s.startswith('/'):
            return ''
        else:
            return s
    pattern = re.compile(
        r'//.*?$|/\*.*?\*/|\'(?:\\.|[^\\\'])*\'|"(?:\\.|[^\\"])*"',
        re.DOTALL | re.MULTILINE
    )
    return re.sub(pattern, replacer, text)


def remove_triling_w_space(text):
  line_start = 0
  line = ""
  line_end = 0
  striped_test = ''
  count = 0
  while 1:
    line_end =  text.find("\n",line_start+1)
    line = text[line_start:line_end]
    line = line.rstrip()
    striped_test = striped_test + line +'\n'
    line_start = line_end + 1
    line = ""
    if line_end < 0:
      return striped_test

def arg_parse(text, j):
    """Parsing arguments in op_par_loop to find the correct closing brace"""

    depth = 0
    loc2 = j
    while 1:
        if text[loc2] == '(':
            depth = depth + 1

        elif text[loc2] == ')':
            depth = depth - 1
            if depth == 0:
                return loc2
        loc2 = loc2 + 1

def find_consts(text, consts):
  found_consts = []
  #i = 0
  for cn in range(0,len(consts)):
    #print consts[cn]['name'][1:-1]
    pattern = consts[cn]['name'][1:-1]
    #if re.search(consts[cn]['name'][1:-1], text):
    if re.search('\\b'+pattern+'\\b', text):
      print "found " + consts[cn]['name'][1:-1]
      found_consts.append(cn)
      #i = i + 1
  #if i > 0:
  #  return found_consts
  #else:
  #  return []
  return found_consts
  

def parse_signature(text2):
  text2 = text2.replace('const','')
  text2 = text2.replace('int','__global int')
  text2 = text2.replace('float','__global float')
  text2 = text2.replace('double','__global double')
  return text2
  

def ops_gen_mpi_opencl(master, date, consts, kernels):

  global dims, stens
  global g_m, file_text, depth

  OPS_ID   = 1;  OPS_GBL   = 2;  OPS_MAP = 3;

  OPS_READ = 1;  OPS_WRITE = 2;  OPS_RW  = 3;
  OPS_INC  = 4;  OPS_MAX   = 5;  OPS_MIN = 6;

  accsstring = ['OPS_READ','OPS_WRITE','OPS_RW','OPS_INC','OPS_MAX','OPS_MIN' ]

  NDIM = 2 #the dimension of the application is hardcoded here .. need to get this dynamically

##########################################################################
#  create new kernel files **_kernel.cl
##########################################################################

  kernel_name_list = []
  kernel_list_text = ''
  kernel_list__build_text = ''
  indent = 10*' '
  for nk in range(0,len(kernels)):
    if kernels[nk]['name'] not in kernel_name_list :
      kernel_name_list.append(kernels[nk]['name'])
      
  for nk in range (0,len(kernels)):
    arg_typ  = kernels[nk]['arg_type']
    name  = kernels[nk]['name']
    nargs = kernels[nk]['nargs']
    dim   = kernels[nk]['dim']
    dims  = kernels[nk]['dims']
    stens = kernels[nk]['stens']
    var   = kernels[nk]['var']
    accs  = kernels[nk]['accs']
    typs  = kernels[nk]['typs']

    #parse stencil to locate strided access
    stride = [1] * nargs * 2

    for n in range (0, nargs):
      if str(stens[n]).find('STRID2D_X') > 0:
        stride[2*n+1] = 0
      elif str(stens[n]).find('STRID2D_Y') > 0:
        stride[2*n] = 0


    reduction = 0
    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_gbl' and accs[n] <> OPS_READ:
        reduction = 1



##########################################################################
#  start with opencl kernel function
##########################################################################

    g_m = 0;
    file_text = ''
    depth = 0
    n_per_line = 4

    i = name.find('kernel')
    name2 = name[0:i-1]
        
    code('#include "user_types.h"')
    #generate MACROS
    comm('')
    code('#ifndef MIN')
    code('#define MIN(a,b) ((a<b) ? (a) : (b))')
    code('#endif')
    code('#ifndef MAX')
    code('#define MAX(a,b) ((a>b) ? (a) : (b))')
    code('#endif')
    code('#ifndef SIGN')
    code('#define SIGN(a,b) ((b<0.0) ? (a*(-1)) : (a))')
    code('#endif')
    code('')
    code('#pragma OPENCL EXTENSION cl_khr_fp64:enable')
    code('')
    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_dat':
        code('#define OPS_ACC'+str(n)+'(x,y) (x+xdim'+str(n)+'_'+name+'*(y))')
    code('')    
    
    code('')
    comm('user function')
    fid = open(name2+'_kernel.h', 'r')
    text = fid.read()
    fid.close()
    text = comment_remover(text)

    text = remove_triling_w_space(text)

    i = text.find(name)
    if(i < 0):
      print "\n********"
      print "Error: cannot locate user kernel function: "+name+" - Aborting code generation"
      exit(2)

    i = text[0:i].rfind('\n') #reverse find
    #find function signature
    loc = arg_parse(text, i + 1)
    sig = text[i:loc]+','   
    sig = parse_signature(sig)
    
    #find body of function
    j2 = text[loc+1:].find('{')
    k2 = para_parse(text, loc+j2, '{', '}')
    
    body = text[loc+1:k2+2] # body of function
    
    found_consts = find_consts(body,consts)
    #print found_consts
    
    code(sig) # function signature
    depth = depth +2
    for c in range(0, len(found_consts)):
      code(consts[found_consts[c]]['type'][1:-1]+' '+consts[found_consts[c]]['name'][1:-1]+',')
    text = ''
    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_dat':
        text = text + 'int xdim'+str(n)+'_'+name
      elif arg_typ[n] == 'ops_arg_gbl':
        text = text[0:-2]
      if n < nargs-1:
        text = text + ',\n'
      elif n == nargs-1:
        text = text + ')\n'
    code(text)
                   
    depth =depth-1        
    code(body)
    code('')
    code('')
    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_dat':
        code('#undef OPS_ACC'+str(n))
    code('')
    code('')
    

##########################################################################
#  generate opencl kernel wrapper function
##########################################################################
    code('__kernel void ops_'+name+'(')
    #currently the read only vars have not been generated differently
    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_dat'and accs[n] == OPS_READ:
        code('__global '+(str(typs[n]).replace('"','')).strip()+'* arg'+str(n)+',')
      elif arg_typ[n] == 'ops_arg_dat'and (accs[n] == OPS_WRITE or accs[n] == OPS_RW or accs[n] == OPS_INC) :
        code('__global '+(str(typs[n]).replace('"','')).strip()+'* arg'+str(n)+',')
      elif arg_typ[n] == 'ops_arg_gbl':
        if accs[n] == OPS_READ:
          code('__global '+(str(typs[n]).replace('"','')).strip()+'* arg'+str(n)+',')
        else:
          code('__global '+(str(typs[n]).replace('"','')).strip()+'* arg'+str(n)+',')
    
    for c in range(0, len(found_consts)):
      #print "CONSTANT "+consts[found_consts[c]]['type'][1:-1]
      if consts[found_consts[c]]['type'][1:-1]=='int' or consts[found_consts[c]]['type'][1:-1]=='double' or consts[found_consts[c]]['type'][1:-1]=='float':
        code(consts[found_consts[c]]['type'][1:-1]+' *'+consts[found_consts[c]]['name'][1:-1]+',')      
      else:
        code('__constant struct '+consts[found_consts[c]]['type'][1:-1]+' *'+consts[found_consts[c]]['name'][1:-1]+',')        
      
    for n in range (0, nargs):
      code('int xdim'+str(n)+'_'+name+',')
    for n in range (0, nargs):
      code('const int base'+str(n)+',')

    code('int size0,')
    code('int size1 ){')
    depth = depth + 2

    #local variable to hold reductions on GPU
    code('')
    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_gbl' and accs[n] != OPS_READ:
        code((str(typs[n]).replace('"','')).strip()+' arg'+str(n)+'_l['+str(dims[n])+'];')

    # set local variables to 0 if OPS_INC, INF if OPS_MIN, -INF
    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_gbl' and accs[n] == OPS_INC:
        code('for (int d=0; d<'+str(dims[n])+'; d++) arg'+str(n)+'_l[d] = ZERO_'+(str(typs[n]).replace('"','')).strip()+';')
      if arg_typ[n] == 'ops_arg_gbl' and accs[n] == OPS_MIN:
        code('for (int d=0; d<'+str(dims[n])+'; d++) arg'+str(n)+'_l[d] = INFINITY_'+(str(typs[n]).replace('"','')).strip()+';')
      if arg_typ[n] == 'ops_arg_gbl' and accs[n] == OPS_MAX:
        code('for (int d=0; d<'+str(dims[n])+'; d++) arg'+str(n)+'_l[d] = -INFINITY_'+(str(typs[n]).replace('"','')).strip()+';')


    code('')
    code('int idx_y = get_global_id(1);')
    code('int idx_x = get_global_id(0);')
    code('')


    indent = (len(name2)+depth+8)*' '
    n_per_line = 5
    IF('idx_x < size0 && idx_y < size1')
    text = name+'('
    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_dat':
        text = text +'&arg'+str(n)+'[base'+str(n)+' + idx_x * '+str(stride[2*n])+' + idx_y * '+str(stride[2*n+1])+' * xdim'+str(n)+'_'+kernel_name_list[nk]+']'
      elif arg_typ[n] == 'ops_arg_gbl' and accs[n] == OPS_READ:
        text = text +'arg'+str(n)
      elif arg_typ[n] == 'ops_arg_gbl' and accs[n] != OPS_READ:
        text = text +'arg'+str(n)+'_l'
      text = text+',\n  '+indent
      
    
    for c in range(0, len(found_consts)):
      text = text + '*'+consts[found_consts[c]]['name'][1:-1]+','
    code(text)
    
    text = (len(name2)+depth+3)*' '
    for n in range (0, nargs):
     text = text + 'xdim'+str(n)+'_'+name
     if n <> nargs-1:
       text = text+',\n  '+indent
     else:
       text = text +');'
    
    code(text)  
      
    ENDIF()

    #reduction accross blocks
    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_gbl' and accs[n] == OPS_INC:
        code('arg'+str(n)+'[get_group_id(0)*1*64] += arg'+str(n)+'_l[0];')
        #code('for (int d=0; d<'+str(dims[n])+'; d++)')
        #code('  ops_reduction<OPS_INC>(&arg'+str(n)+'[d+blockIdx.x + blockIdx.y*gridDim.x],arg'+str(n)+'_l[d]);')
      if arg_typ[n] == 'ops_arg_gbl' and accs[n] == OPS_MIN:
        code('arg'+str(n)+'[get_group_id(0)*1*64] += arg'+str(n)+'_l[0];')
        #code('for (int d=0; d<'+str(dims[n])+'; d++)')
        #code('  ops_reduction<OPS_MIN>(&arg'+str(n)+'[d+blockIdx.x + blockIdx.y*gridDim.x],arg'+str(n)+'_l[d]);')
      if arg_typ[n] == 'ops_arg_gbl' and accs[n] == OPS_MAX:
        code('arg'+str(n)+'[get_group_id(0)*1*64] += arg'+str(n)+'_l[0];')
        #code('for (int d=0; d<'+str(dims[n])+'; d++)')
        #code('  ops_reduction<OPS_MAX>(&arg'+str(n)+'[d+blockIdx.x + blockIdx.y*gridDim.x],arg'+str(n)+'_l[d]);')


    code('')
    depth = depth - 2
    code('}')
         
    
    if not os.path.exists('./OpenCL'):
      os.makedirs('./OpenCL')
    fid = open('./OpenCL/'+kernel_name_list[nk]+'.cl','w')
    date = datetime.datetime.now()
    fid.write('//\n// auto-generated by ops.py on '+date.strftime("%Y-%m-%d %H:%M")+'\n//\n\n')
    fid.write(file_text)
    fid.close()
    
    
##########################################################################
#  generate opencl host stub function
##########################################################################
    g_m = 0;
    file_text = ''
    depth = 0
    code('')
    comm(' host stub function')

    code('void ops_par_loop_'+name+'(char const *name, ops_block Block, int dim, int* range,')
    text = ''
    for n in range (0, nargs):

      text = text +' ops_arg arg'+str(n)
      if nargs <> 1 and n != nargs-1:
        text = text +','
      else:
        text = text +') {'
      if n%n_per_line == 3 and n <> nargs-1:
         text = text +'\n'
    code(text);
    depth = 2

    code('');
    code('buildOpenCLKernels();')
    
    text ='ops_arg args['+str(nargs)+'] = {'
    for n in range (0, nargs):
      text = text +' arg'+str(n)
      if nargs <> 1 and n != nargs-1:
        text = text +','
      else:
        text = text +'};\n'
      if n%n_per_line == 5 and n <> nargs-1:
        text = text +'\n                    '
    code(text);

    code('sub_block_list sb = OPS_sub_block_list[Block->index];')

    comm('compute localy allocated range for the sub-block')

    code('int start_add['+str(NDIM)+'];')
    code('int end_add['+str(NDIM)+'];')


    FOR('n','0',str(NDIM))
    code('start_add[n] = sb->istart[n];end_add[n] = sb->iend[n]+1;')
    IF('start_add[n] >= range[2*n]')
    code('start_add[n] = 0;')
    ENDIF()
    ELSE()
    code('start_add[n] = range[2*n] - start_add[n];')
    ENDIF()

    IF('end_add[n] >= range[2*n+1]')
    code('end_add[n] = range[2*n+1] - sb->istart[n];')
    ENDIF()
    ELSE()
    code('end_add[n] = sb->sizes[n];')
    ENDIF()
    ENDFOR()
    code('')

    code('')
    code('int x_size = end_add[0]-start_add[0];')
    code('int y_size = end_add[1]-start_add[1];')
    code('')

    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_dat':
        code('int xdim'+str(n)+' = args['+str(n)+'].dat->block_size[0]*args['+str(n)+'].dat->dim;')
    code('')

    #timing structs
    code('')
    comm('Timing')
    code('double t1,t2,c1,c2;')
    code('ops_timing_realloc('+str(nk)+',"'+name+'");')
    code('ops_timers_core(&c1,&t1);')
    code('')

    #set up OpenCL grid and thread blocks
    comm('set up OpenCL thread blocks')
    code('size_t globalWorkSize[3] = {((x_size-1)/OPS_block_size_x+ 1)*OPS_block_size_x, ((y_size-1)/OPS_block_size_y + 1)*OPS_block_size_y, 1};')
    code('size_t localWorkSize[3] =  {OPS_block_size_x,OPS_block_size_y,1};')
    code('')
    
    #setup reduction variables
    code('')
    for n in range (0, nargs):
        if arg_typ[n] == 'ops_arg_gbl':
          code(''+(str(typs[n]).replace('"','')).strip()+' *arg'+str(n)+'h = ('+(str(typs[n]).replace('"','')).strip()+' *)arg'+str(n)+'.data;')
    
    GBL_READ = False
    GBL_INC = False
    GBL_MAX = False
    GBL_MIN = False
    GBL_WRITE = False

    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_gbl':
        if accs[n] == OPS_READ:
          GBL_READ = True
        if accs[n] == OPS_INC:
          GBL_INC = True
        if accs[n] == OPS_MAX:
          GBL_MAX = True
        if accs[n] == OPS_MIN:
          GBL_MIN = True
        if accs[n] == OPS_WRITE:
          GBL_WRITE = True

    if GBL_INC == True or GBL_MIN == True or GBL_MAX == True or GBL_WRITE == True:
      code('int nblocks = ((x_size-1)/OPS_block_size_x+ 1)*((y_size-1)/OPS_block_size_y + 1);')
      code('int maxblocks = nblocks;')
      code('int reduct_bytes = 0;')
      code('int reduct_size = 0;')
      code('')

    if GBL_READ == True:
      code('int consts_bytes = 0;')
      code('')

    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_gbl':
        if accs[n] == OPS_READ:
          code('consts_bytes += ROUND_UP('+str(dims[n])+'*sizeof('+(str(typs[n]).replace('"','')).strip()+'));')
        else:
          code('reduct_bytes += ROUND_UP(maxblocks*'+str(dims[n])+'*sizeof('+(str(typs[n]).replace('"','')).strip()+'));')
          code('reduct_size = MAX(reduct_size,sizeof('+(str(typs[n]).replace('"','')).strip()+')*'+str(dims[n])+');')
    code('')

    if GBL_READ == True:
      code('reallocConstArrays(consts_bytes);')
    if GBL_INC == True or GBL_MIN == True or GBL_MAX == True or GBL_WRITE == True:
      code('reallocReductArrays(reduct_bytes);')
      code('reduct_bytes = 0;')
      code('')

    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_gbl' and accs[n] != OPS_READ:
        code('arg'+str(n)+'.data = OPS_reduct_h + reduct_bytes;')
        code('arg'+str(n)+'.data_d = OPS_reduct_d + reduct_bytes;')
        code('for (int b=0; b<maxblocks; b++)')
        if accs[n] == OPS_INC:
          code('for (int d=0; d<'+str(dims[n])+'; d++) (('+(str(typs[n]).replace('"','')).strip()+' *)arg'+str(n)+'.data)[d+b*'+str(dims[n])+'] = ZERO_'+(str(typs[n]).replace('"','')).strip()+';')
        if accs[n] == OPS_MAX:
          code('for (int d=0; d<'+str(dims[n])+'; d++) (('+(str(typs[n]).replace('"','')).strip()+' *)arg'+str(n)+'.data)[d+b*'+str(dims[n])+'] = -INFINITY_'+(str(typs[n]).replace('"','')).strip()+';')
        if accs[n] == OPS_MIN:
          code('for (int d=0; d<'+str(dims[n])+'; d++) (('+(str(typs[n]).replace('"','')).strip()+' *)arg'+str(n)+'.data)[d+b*'+str(dims[n])+'] = INFINITY_'+(str(typs[n]).replace('"','')).strip()+';')
        code('reduct_bytes += ROUND_UP(maxblocks*'+str(dims[n])+'*sizeof('+(str(typs[n]).replace('"','')).strip()+'));')
        code('')

    code('')

    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_gbl':
        if accs[n] == OPS_READ:
          code('consts_bytes = 0;')
          code('arg'+str(n)+'.data = OPS_consts_h + consts_bytes;')
          code('arg'+str(n)+'.data_d = OPS_consts_d + consts_bytes;')
          code('for (int d=0; d<'+str(dims[n])+'; d++) (('+(str(typs[n]).replace('"','')).strip()+' *)arg'+str(n)+'.data)[d] = arg'+str(n)+'h[d];')
          code('consts_bytes += ROUND_UP('+str(dims[n])+'*sizeof(int));')
          code('mvConstArraysToDevice(consts_bytes);')

    if GBL_INC == True or GBL_MIN == True or GBL_MAX == True or GBL_WRITE == True:
      code('mvReductArraysToDevice(reduct_bytes);')


    #set up initial pointers    
    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_dat':
        #code('int off'+str(n)+'_1 = offs['+str(n)+'][0];')
        #code('int off'+str(n)+'_2 = offs['+str(n)+'][1];')
        code('int dat'+str(n)+' = args['+str(n)+'].dat->size;')

    code('')
    code('cl_mem p_a['+str(nargs)+'];')

    comm('')
    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_dat':
        comm('set up initial pointers')

        code('int base'+str(n)+' = dat'+str(n)+' * 1 * ')
        code('(start_add[0] * args['+str(n)+'].stencil->stride[0] - args['+str(n)+'].dat->offset[0]);')
        for d in range (1, NDIM):
          code('base'+str(n)+' = base'+str(n)+'  + dat'+str(n)+' * args['+str(n)+'].dat->block_size['+str(d-1)+'] * ')
          code('(start_add['+str(d)+'] * args['+str(n)+'].stencil->stride['+str(d)+'] - args['+str(n)+'].dat->offset['+str(d)+']);')

        code('base'+str(n)+' = base'+str(n)+'/dat'+str(n)+';')
        code('')


    #for n in range (0, nargs):
    #  if arg_typ[n] == 'ops_arg_dat':
    #    code('p_a['+str(n)+'] = &args['+str(n)+'].data_d[')
    #    code('+ args['+str(n)+'].dat->size * args['+str(n)+'].dat->block_size[0] * ( range[2] * '+str(stride[2*n+1])+' - args['+str(n)+'].dat->offset[1] )')
    #    code('+ args['+str(n)+'].dat->size * ( range[0] * '+str(stride[2*n])+' - args['+str(n)+'].dat->offset[0] ) ];')
    #    code('')


    code('')
    #code('ops_halo_exchanges_cuda(args, '+str(nargs)+');')
    code('ops_H_D_exchanges_cuda(args, '+str(nargs)+');')
    code('')


    #set up shared memory for reduction
    if GBL_INC == True or GBL_MIN == True or GBL_MAX == True or GBL_WRITE == True:
       code('int nshared = 0;')
       code('int nthread = OPS_block_size_x*OPS_block_size_y;')
       code('')
    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_gbl' and accs[n] != OPS_READ:
        code('nshared = MAX(nshared,sizeof('+(str(typs[n]).replace('"','')).strip()+')*'+str(dims[n])+');')
    code('')
    
    if GBL_INC == True or GBL_MIN == True or GBL_MAX == True or GBL_WRITE == True:
      code('nshared = MAX(nshared*nthread,reduct_size*nthread);')
      code('')
    
    #upload gloabal constants to device
    for c in range(0, len(found_consts)):
      const_type = consts[found_consts[c]]['type'][1:-1]
      const_dim = consts[found_consts[c]]['dim']
      code('clSafeCall( clEnqueueWriteBuffer(OPS_opencl_core.command_queue, OPS_opencl_core.constant['+str(found_consts[c])+'], CL_TRUE, 0, sizeof('+const_type+')*'+const_dim+', (void*) &'+consts[found_consts[c]]['name'][1:-1]+', 0, NULL, NULL) );')
      code('clSafeCall( clFlush(OPS_opencl_core.command_queue) );')
    code('')
    
    #set up argements in order to do the kernel call
    nkernel_args = 0
    for n in range (0, nargs):
      code('clSafeCall( clSetKernelArg(OPS_opencl_core.kernel['+str(nk)+'], '+str(nkernel_args)+', sizeof(cl_mem), (void*) &arg'+str(n)+'.data_d ));')
      nkernel_args = nkernel_args+1
      
    for c in range(0, len(found_consts)):
      if consts[found_consts[c]]['type'][1:-1] is 'int' or consts[found_consts[c]]['type'][1:-1] is 'double' or consts[found_consts[c]]['type'][1:-1] is 'float':
        code('clSafeCall( clSetKernelArg(OPS_opencl_core.kernel['+str(nk)+'], '+str(nkernel_args)+', sizeof(cl_mem'+\
             consts[found_consts[c]]['type'][1:-1]+'), (void*) &'+consts[found_consts[c]]['name'][1:-1]+' ));')
      else:
        #code('clSafeCall( clSetKernelArg(OPS_opencl_core.kernel['+str(nk)+'], '+str(nkernel_args)+', sizeof('+\
        #     consts[found_consts[c]]['type'][1:-1]+'), (void*) &'+consts[found_consts[c]]['name'][1:-1]+' ));')
        code('clSafeCall( clSetKernelArg(OPS_opencl_core.kernel['+str(nk)+'], '+str(nkernel_args)+', sizeof(cl_mem), (void*) &OPS_opencl_core.constant['+str(found_consts[c])+']) );')
        
      nkernel_args = nkernel_args+1
      
     
    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_dat':
        code('clSafeCall( clSetKernelArg(OPS_opencl_core.kernel['+str(nk)+'], '+str(nkernel_args)+', sizeof(cl_int), (void*) &xdim'+str(n)+' ));')
        nkernel_args = nkernel_args+1
    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_dat':
        code('clSafeCall( clSetKernelArg(OPS_opencl_core.kernel['+str(nk)+'], '+str(nkernel_args)+', sizeof(cl_int), (void*) &base'+str(n)+' ));')
        nkernel_args = nkernel_args+1
    
    code('clSafeCall( clSetKernelArg(OPS_opencl_core.kernel['+str(nk)+'], '+str(nkernel_args)+', sizeof(cl_int), (void*) &x_size ));')
    nkernel_args = nkernel_args+1
    code('clSafeCall( clSetKernelArg(OPS_opencl_core.kernel['+str(nk)+'], '+str(nkernel_args)+', sizeof(cl_int), (void*) &y_size ));')
    nkernel_args = nkernel_args+1
    
    #kernel call
    code('')
    comm('call/enque opencl kernel wrapper function')
    code('clSafeCall( clEnqueueNDRangeKernel(OPS_opencl_core.command_queue, OPS_opencl_core.kernel['+str(nk)+'], 3, NULL, globalWorkSize, localWorkSize, 0, NULL, NULL) );')
    code('clSafeCall( clFinish(OPS_opencl_core.command_queue) );')
    code('')

    if GBL_INC == True or GBL_MIN == True or GBL_MAX == True or GBL_WRITE == True:
      code('mvReductArraysToHost(reduct_bytes);')

    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_gbl' and accs[n] != OPS_READ:
        FOR('b','0','maxblocks')
        FOR('d','0',str(dims[n]))
        if accs[n] == OPS_INC:
          code('arg'+str(n)+'h[d] = arg'+str(n)+'h[d] + ((double *)arg'+str(n)+'.data)[d+b*'+str(dims[n])+'];')
        elif accs[n] == OPS_MAX:
          code('arg'+str(n)+'h[d] = MAX(arg'+str(n)+'h[d],((double *)arg'+str(n)+'.data)[d+b*'+str(dims[n])+']);')
        elif accs[n] == OPS_MIN:
          code('arg'+str(n)+'h[d] = MIN(arg'+str(n)+'h[d],((double *)arg'+str(n)+'.data)[d+b*'+str(dims[n])+']);')
        ENDFOR()
        ENDFOR()
        code('arg'+str(n)+'.data = (char *)arg'+str(n)+'h;')
        code('')

    code('ops_set_dirtybit_cuda(args, '+str(nargs)+');')
    code('ops_H_D_exchanges(args, '+str(nargs)+');')

    code('')
    comm('Update kernel record')
    code('ops_timers_core(&c2,&t2);')
    code('OPS_kernels['+str(nk)+'].count++;')
    code('OPS_kernels['+str(nk)+'].time += t2-t1;')
    for n in range (0, nargs):
      if arg_typ[n] == 'ops_arg_dat':
        code('OPS_kernels['+str(nk)+'].transfer += ops_compute_transfer(dim, range, &arg'+str(n)+');')
    depth = depth - 2
    code('}')

##########################################################################
#  output individual kernel file
##########################################################################
    if not os.path.exists('./OpenCL'):
      os.makedirs('./OpenCL')
    fid = open('./OpenCL/'+name+'_opencl_kernel.cpp','w')
    date = datetime.datetime.now()
    fid.write('//\n// auto-generated by ops.py on '+date.strftime("%Y-%m-%d %H:%M")+'\n//\n\n')
    fid.write(file_text)
    fid.close()

# end of main kernel call loop

##########################################################################
#  output one master kernel file
##########################################################################
  depth = 0
  file_text =''
  comm('header')
  code('#include "stdlib.h"')
  code('#include "stdio.h"')
  code('#include "ops_lib_cpp.h"')
  code('#include "ops_opencl_rt_support.h"')
  code('#include "user_types.h"')
  
  comm('global constants')
  for nc in range (0,len(consts)):
    if consts[nc]['dim'].isdigit() and int(consts[nc]['dim'])==1:
      code('extern '+consts[nc]['type'][1:-1]+' '+(str(consts[nc]['name']).replace('"','')).strip()+';')
    else:
      if consts[nc]['dim'].isdigit() and int(consts[nc]['dim']) > 0:
        num = consts[nc]['dim']
        code('extern '+consts[nc]['type'][1:-1]+' '+(str(consts[nc]['name']).replace('"','')).strip()+'['+num+'];')
      else:
        code('extern '+consts[nc]['type'][1:-1]+' *'+(str(consts[nc]['name']).replace('"','')).strip()+';')

  code('')
  
  kernel_name_list = []
  kernel_list_text = ''
  kernel_list__build_text = ''
  indent = 10*' '
  for nk in range(0,len(kernels)):
    if kernels[nk]['name'] not in kernel_name_list :
      kernel_name_list.append(kernels[nk]['name'])
      kernel_list_text = kernel_list_text + '"./OpenCL/'+kernel_name_list[nk]+'.cl"'
      if nk != len(kernels)-1:
        kernel_list_text = kernel_list_text+',\n'+indent
      kernel_list__build_text = kernel_list__build_text + \
      'OPS_opencl_core.kernel['+str(nk)+'] = clCreateKernel(OPS_opencl_core.program, "ops_'+kernel_name_list[nk]+'", &ret);\n      '+\
      'clSafeCall( ret );\n      '  
  

  opencl_build = """
  extern ops_opencl_core OPS_opencl_core;

  #define MAX_SOURCE_SIZE ("""+str(len(kernels))+"""*0x1000000)
  
  void buildOpenCLKernels() {
    static bool isbuilt = false;
  
    if(!isbuilt) {
      clSafeCall( clUnloadCompiler() );
  
      OPS_opencl_core.n_kernels = """+str(len(kernels))+""";
      OPS_opencl_core.kernel = (cl_kernel*) malloc("""+str(len(kernels))+"""*sizeof(cl_kernel));  
      
      cl_int ret;
      char* source_filename["""+str(len(kernels))+"""] = {
          """+kernel_list_text+"""
      };
  
      // Load the kernel source code into the array source_str
      FILE *fid;
      char *source_str["""+str(len(kernels))+"""];
      size_t source_size["""+str(len(kernels))+"""];
  
      for(int i=0; i<"""+str(len(kernels))+"""; i++) {
        fid = fopen(source_filename[i], "r");
        if (!fid) {
          fprintf(stderr, "Can't open the kernel source file!\\n");
          exit(1);
        }
        
        source_str[i] = (char*)malloc(MAX_SOURCE_SIZE);
        source_size[i] = fread(source_str[i], 1, MAX_SOURCE_SIZE, fid);
        if(source_size[i] != MAX_SOURCE_SIZE) {
          if (ferror(fid)) {
            printf ("Error while reading kernel source file %s\\n", source_filename[i]);
            exit(-1);
          }
          if (feof(fid))
            printf ("Kernel source file %s succesfuly read.\\n", source_filename[i]);
            //printf("%s\\n",source_str[i]);
        }
        fclose(fid);
      }
      
      printf(" compiling sources \\n");
  
        // Create a program from the source
        OPS_opencl_core.program = clCreateProgramWithSource(OPS_opencl_core.context, """+str(len(kernels))+""", (const char **) &source_str, (const size_t *) &source_size, &ret);
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
          build_log[log_size] = '\\0';
          fprintf(stderr, "=============== OpenCL Program Build Info ================\\n\\n%s", build_log);
          fprintf(stderr, "\\n========================================================= \\n");
          free(build_log);
          exit(EXIT_FAILURE);
        }
        printf(" compiling done\\n");
  
      // Create the OpenCL kernel
      """+kernel_list__build_text+"""      
      isbuilt = true;
    }
    
  }
  
//this needs to be a platform specific copy symbol to device function
/*void ops_decl_const_char( int dim, char const * type, int typeSize, char * data, char const * name )
{
  (void)dim;
  (void)type;
  (void)typeSize;
  (void)data;
  (void)name;
}*/

  """
  depth = -2
  code(opencl_build)
  
  
  comm('user kernel files')

  for nk in range(0,len(kernel_name_list)):
    code('#include "'+kernel_name_list[nk]+'_opencl_kernel.cpp"')
  
   
  master = master.split('.')[0]
  fid = open('./OpenCL/'+master.split('.')[0]+'_opencl_kernels.cpp','w')
  fid.write('//\n// auto-generated by op2.py on '+date.strftime("%Y-%m-%d %H:%M")+'\n//\n\n')
  fid.write(file_text)
  fid.close()
