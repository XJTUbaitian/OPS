/*
* Open source copyright declaration based on BSD open source template:
* http://www.opensource.org/licenses/bsd-license.php
*
* This file is part of the OPS distribution.
*
* Copyright (c) 2013, Mike Giles and others. Please see the AUTHORS file in
* the main source directory for a full list of copyright holders.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
* * Redistributions of source code must retain the above copyright
* notice, this list of conditions and the following disclaimer.
* * Redistributions in binary form must reproduce the above copyright
* notice, this list of conditions and the following disclaimer in the
* documentation and/or other materials provided with the distribution.
* * The name of Mike Giles may not be used to endorse or promote products
* derived from this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY Mike Giles ''AS IS'' AND ANY
* EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL Mike Giles BE LIABLE FOR ANY
* DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
* (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
* LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
* ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
* (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/** @brief Some utility functions for the OPS
  * @author Gihan Mudalige, Istvan Reguly
  * @details Some utility functions for the OPS
  */


#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <limits.h>

#include <ops_util.h>

/*******************************************************************************
* Wrapper for malloc from www.gnu.org/
*******************************************************************************/

void* xmalloc (size_t size)
{
  if(size == 0) return (void *)NULL;

  register void *value = malloc (size);
  if (value == 0) printf("Virtual memory exhausted at malloc\n");
  return value;
}

/*******************************************************************************
* Wrapper for realloc from www.gnu.org/
*******************************************************************************/

void* xrealloc (void *ptr, size_t size)
{
  if(size == 0)
  {
    free(ptr);
    return (void *)NULL;
  }

  register void *value = realloc (ptr, size);
  if (value == 0) printf ("Virtual memory exhausted at realloc\n");
  return value;
}

/*******************************************************************************
* Return the index of the min value in an array
*******************************************************************************/

int min(int array[], int size)
{
  int min = INT_MAX;
  int index = -1;
  for(int i=0; i<size; i++)
  {
    if(array[i]<min)
    {
      index = i;
      min = array[i];
    }
  }
  return index;
}

/*******************************************************************************
* Binary search an array for a given value
*******************************************************************************/

int binary_search(int a[], int value, int low, int high)
{
  if (high < low)
    return -1; // not found

  int mid = low + (high - low) / 2;
  if (a[mid] > value)
    return binary_search(a, value, low, mid-1);
  else if (a[mid] < value)
    return binary_search(a, value, mid+1, high);
  else
    return mid; // found
}

/*******************************************************************************
* Linear search an array for a given value
*******************************************************************************/

int linear_search(int a[], int value, int low, int high)
{
  for(int i = low; i<=high; i++)
  {
    if (a[i] == value) return i;
  }
  return -1;
}

/*******************************************************************************
* Quicksort an array
*******************************************************************************/

void quickSort(int arr[], int left, int right)
{
  int i = left;
  int j = right;
  int tmp;
  int pivot = arr[(left + right) / 2];

  // partition
  while (i <= j) {
    while (arr[i] < pivot)i++;
    while (arr[j] > pivot)j--;
    if (i <= j) {
      tmp = arr[i];
      arr[i] = arr[j];
      arr[j] = tmp;
      i++; j--;
    }
  };
  // recursion
  if (left < j)
    quickSort(arr, left, j);
  if (i < right)
    quickSort(arr, i, right);
}

/*******************************************************************************
* Remove duplicates in an array
*******************************************************************************/

int removeDups(int a[], int array_size)
{
  int i, j;
  j = 0;
  // Remove the duplicates ...
  for (i = 1; i < array_size; i++)
  {
    if (a[i] != a[j])
    {
      j++;
      a[j] = a[i]; // Move it to the front
    }
  }
  // The new array size..
  array_size = (j + 1);
  return array_size;
}

/*******************************************************************************
* Check if a file exists
*******************************************************************************/
int file_exist (char const *filename)
{
  struct stat   buffer;
  return (stat (filename, &buffer) == 0);
}

