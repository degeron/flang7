!** Copyright (c) 1989, NVIDIA CORPORATION.  All rights reserved.
!**
!** Licensed under the Apache License, Version 2.0 (the "License");
!** you may not use this file except in compliance with the License.
!** You may obtain a copy of the License at
!**
!**     http://www.apache.org/licenses/LICENSE-2.0
!**
!** Unless required by applicable law or agreed to in writing, software
!** distributed under the License is distributed on an "AS IS" BASIS,
!** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
!** See the License for the specific language governing permissions and
!** limitations under the License.

!* Tests for runtime library MATMUL routines

program p
  
  parameter(NbrTests=2112)
  parameter(o_extent=2)
  parameter(n_extent=6)
  parameter(m_extent=4)
  parameter(k_extent=8)
  
  real*4, dimension(n_extent,m_extent) :: arr1
  real*4, dimension(m_extent,k_extent) :: arr2
  real*4, dimension(n_extent,k_extent) :: arr3
  real*4, dimension(n_extent,m_extent,o_extent) :: arr4
  real*4, dimension(n_extent,o_extent,m_extent) :: arr5
  real*4, dimension(o_extent,n_extent,m_extent) :: arr6
  
  real*4, dimension(o_extent,m_extent,k_extent) :: arr7
  real*4, dimension(m_extent,o_extent,k_extent) :: arr8
  real*4, dimension(m_extent,k_extent,o_extent) :: arr9
  
  real*4, dimension(n_extent,k_extent,o_extent) :: arr10
  real*4, dimension(n_extent,o_extent,k_extent) :: arr11
  real*4, dimension(o_extent,n_extent,k_extent) :: arr12
  
  real*4, dimension(2:n_extent+1,m_extent) :: arr13
  real*4, dimension(2:m_extent+1,k_extent) :: arr14
  real*4, dimension(2:n_extent+1,k_extent) :: arr15
  real*4, dimension(n_extent,2:m_extent+1) :: arr16
  real*4, dimension(m_extent,2:k_extent+1) :: arr17
  real*4, dimension(n_extent,2:k_extent+1) :: arr18
  real*4, dimension(n_extent,k_extent) :: arr19
  
  REAL*4 :: expect(NbrTests) 
  REAL*4 :: results(NbrTests)
  
  integer:: i,j
  
  data arr1 /0,1,2,3,4,5,6,7,8,9,10,11,			&
             12,13,14,15,16,17,18,19,20,22,22,23/
  data arr2 /0,1,2,3,4,5,6,7,8,9,10,11,			&
             12,13,14,15,16,17,18,19,20,21,22,23,		&
             24,25,26,27,28,29,30,31/
  data arr3 /0,1,2,3,4,5,6,7,8,9,10,11, 			&
             12,13,14,15,16,17,18,19,20,21,22,23,		&
             24,25,26,27,28,29,30,31,32,33,34,35,		&
             36,37,38,39,40,41,42,43,44,45,46,47/
  data arr4 /0,1,2,3,4,5,6,7,8,9,10,11, 			&
             12,13,14,15,16,17,18,19,20,21,22,23,		&
             24,25,26,27,28,29,30,31,32,33,34,35,		&
             36,37,38,39,40,41,42,43,44,45,46,47/
  data arr5 /0,1,2,3,4,5,6,7,8,9,10,11, 			&
             12,13,14,15,16,17,18,19,20,21,22,23,		&
             24,25,26,27,28,29,30,31,32,33,34,35,		&
             36,37,38,39,40,41,42,43,44,45,46,47/
  data arr6 /0,1,2,3,4,5,6,7,8,9,10,11, 			&
             12,13,14,15,16,17,18,19,20,21,22,23,		&
             24,25,26,27,28,29,30,31,32,33,34,35,		&
             36,37,38,39,40,41,42,43,44,45,46,47/
  data arr7 /0,1,2,3,4,5,6,7,8,9,10,11, 			&
             12,13,14,15,16,17,18,19,20,21,22,23,		&
             24,25,26,27,28,29,30,31,32,33,34,35,		&
             36,37,38,39,40,41,42,43,44,45,46,47,		&
             48,49,50,51,52,53,54,55,56,57,58,59,		&
             60,61,62,63/
  data arr8 /0,1,2,3,4,5,6,7,8,9,10,11, 			&
             12,13,14,15,16,17,18,19,20,21,22,23,		&
             24,25,26,27,28,29,30,31,32,33,34,35,		&
             36,37,38,39,40,41,42,43,44,45,46,47,		&
             48,49,50,51,52,53,54,55,56,57,58,59,		&
             60,61,62,63/
  data arr9 /0,1,2,3,4,5,6,7,8,9,10,11, 			&
             12,13,14,15,16,17,18,19,20,21,22,23,		&
             24,25,26,27,28,29,30,31,32,33,34,35,		&
             36,37,38,39,40,41,42,43,44,45,46,47,		&
             48,49,50,51,52,53,54,55,56,57,58,59,		&
             60,61,62,63/
  data arr10 /0,1,2,3,4,5,6,7,8,9,10,11,	 		&
             12,13,14,15,16,17,18,19,20,21,22,23,		&
             24,25,26,27,28,29,30,31,32,33,34,35,		&
             36,37,38,39,40,41,42,43,44,45,46,47,		&
             48,49,50,51,52,53,54,55,56,57,58,59,		&
             60,61,62,63,64,65,66,67,68,69,70,71,		&
             72,73,74,75,76,77,78,79,80,81,82,83,		&
             84,85,86,87,88,89,90,91,92,93,94,95/
  data arr11 /0,1,2,3,4,5,6,7,8,9,10,11,	 		&
             12,13,14,15,16,17,18,19,20,21,22,23,		&
             24,25,26,27,28,29,30,31,32,33,34,35,		&
             36,37,38,39,40,41,42,43,44,45,46,47,		&
             48,49,50,51,52,53,54,55,56,57,58,59,		&
             60,61,62,63,64,65,66,67,68,69,70,71,		&
             72,73,74,75,76,77,78,79,80,81,82,83,		&
             84,85,86,87,88,89,90,91,92,93,94,95/
  data arr12 /0,1,2,3,4,5,6,7,8,9,10,11,	 		&
             12,13,14,15,16,17,18,19,20,21,22,23,		&
             24,25,26,27,28,29,30,31,32,33,34,35,		&
             36,37,38,39,40,41,42,43,44,45,46,47,		&
             48,49,50,51,52,53,54,55,56,57,58,59,		&
             60,61,62,63,64,65,66,67,68,69,70,71,		&
             72,73,74,75,76,77,78,79,80,81,82,83,		&
             84,85,86,87,88,89,90,91,92,93,94,95/
  data arr13 /0,1,2,3,4,5,6,7,8,9,10,11,                        &
             12,13,14,15,16,17,18,19,20,22,22,23/
  data arr14 /0,1,2,3,4,5,6,7,8,9,10,11,                        &
             12,13,14,15,16,17,18,19,20,21,22,23,               &
             24,25,26,27,28,29,30,31/
  data arr15 /0,1,2,3,4,5,6,7,8,9,10,11,                        &
             12,13,14,15,16,17,18,19,20,21,22,23,               &
             24,25,26,27,28,29,30,31,32,33,34,35,               &
             36,37,38,39,40,41,42,43,44,45,46,47/
  data arr16 /0,1,2,3,4,5,6,7,8,9,10,11,                        &
             12,13,14,15,16,17,18,19,20,22,22,23/
  data arr17 /0,1,2,3,4,5,6,7,8,9,10,11,                        &
             12,13,14,15,16,17,18,19,20,21,22,23,               &
             24,25,26,27,28,29,30,31/
  data arr18 /0,1,2,3,4,5,6,7,8,9,10,11,                        &
             12,13,14,15,16,17,18,19,20,21,22,23,               &
             24,25,26,27,28,29,30,31,32,33,34,35,               &
             36,37,38,39,40,41,42,43,44,45,46,47/

  data expect /  &
  ! test 1-48
      84.0, 90.0, 96.0, 105.0, 108.0, 114.0, 228.0, 250.0, 272.0, &
      301.0, 316.0, 338.0, 372.0, 410.0, 448.0, 497.0, 524.0, 562.0, &
      516.0, 570.0, 624.0, 693.0, 732.0, 786.0, 660.0, 730.0, 800.0, &
      889.0, 940.0, 1010.0, 804.0, 890.0, 976.0, 1085.0, 1148.0, 1234.0, &
      948.0, 1050.0, 1152.0, 1281.0, 1356.0, 1458.0, 1092.0, 1210.0, 1328.0, &
      1477.0, 1564.0, 1682.0, &
  ! test 49-96
      0.0, 90.0, 96.0, 105.0, 108.0, 114.0, 0.0, 250.0, 272.0, &
      301.0, 316.0, 338.0, 0.0, 410.0, 448.0, 497.0, 524.0, 562.0, &
      0.0, 570.0, 624.0, 693.0, 732.0, 786.0, 0.0, 730.0, 800.0, &
      889.0, 940.0, 1010.0, 0.0, 890.0, 976.0, 1085.0, 1148.0, 1234.0, &
      0.0, 1050.0, 1152.0, 1281.0, 1356.0, 1458.0, 0.0, 1210.0, 1328.0, &
      1477.0, 1564.0, 1682.0, &
  ! test 97-144
      84.0, 90.0, 96.0, 105.0, 108.0, 0.0, 228.0, 250.0, 272.0, &
      301.0, 316.0, 0.0, 372.0, 410.0, 448.0, 497.0, 524.0, 0.0, &
      516.0, 570.0, 624.0, 693.0, 732.0, 0.0, 660.0, 730.0, 800.0, &
      889.0, 940.0, 0.0, 804.0, 890.0, 976.0, 1085.0, 1148.0, 0.0, &
      948.0, 1050.0, 1152.0, 1281.0, 1356.0, 0.0, 1092.0, 1210.0, 1328.0, &
      1477.0, 1564.0, 0.0, &
  ! test 145-192
      84.0, 90.0, 96.0, 105.0, 108.0, 114.0, 228.0, 246.0, 264.0, &
      289.0, 300.0, 318.0, 372.0, 402.0, 432.0, 473.0, 492.0, 522.0, &
      516.0, 558.0, 600.0, 657.0, 684.0, 726.0, 660.0, 714.0, 768.0, &
      841.0, 876.0, 930.0, 804.0, 870.0, 936.0, 1025.0, 1068.0, 1134.0, &
      948.0, 1026.0, 1104.0, 1209.0, 1260.0, 1338.0, 1092.0, 1182.0, 1272.0, &
      1393.0, 1452.0, 1542.0, &
  ! test 193-240
      84.0, 90.0, 96.0, 105.0, 108.0, 114.0, 228.0, 246.0, 264.0, &
      289.0, 300.0, 318.0, 372.0, 402.0, 432.0, 473.0, 492.0, 522.0, &
      516.0, 558.0, 600.0, 657.0, 684.0, 726.0, 660.0, 714.0, 768.0, &
      841.0, 876.0, 930.0, 804.0, 870.0, 936.0, 1025.0, 1068.0, 1134.0, &
      948.0, 1026.0, 1104.0, 1209.0, 1260.0, 1338.0, 1092.0, 1182.0, 1272.0, &
      1393.0, 1452.0, 1542.0, &
  ! test 241-288
      30.0, 33.0, 36.0, 39.0, 42.0, 45.0, 102.0, 117.0, 132.0, &
      147.0, 162.0, 177.0, 174.0, 201.0, 228.0, 255.0, 282.0, 309.0, &
      246.0, 285.0, 324.0, 363.0, 402.0, 441.0, 318.0, 369.0, 420.0, &
      471.0, 522.0, 573.0, 390.0, 453.0, 516.0, 579.0, 642.0, 705.0, &
      462.0, 537.0, 612.0, 687.0, 762.0, 837.0, 534.0, 621.0, 708.0, &
      795.0, 882.0, 969.0, &
  !test 289-336
      30.0, 33.0, 36.0, 0.0, 0.0, 0.0, 102.0, 117.0, 132.0, &
      0.0, 0.0, 0.0, 174.0, 201.0, 228.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, &
  ! test 337-384
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 246.0, 264.0, &
      289.0, 0.0, 0.0, 0.0, 402.0, 432.0, 473.0, 0.0, 0.0, &
      0.0, 558.0, 600.0, 657.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, &
  ! test 385-432
      30.0, 33.0, 36.0, 39.0, 42.0, 45.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 174.0, 201.0, 228.0, 255.0, 282.0, 309.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 318.0, 369.0, 420.0, &
      471.0, 522.0, 573.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      462.0, 537.0, 612.0, 687.0, 762.0, 837.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, &
  ! test 433-480
      48.0, 0.0, 54.0, 0.0, 60.0, 0.0, 192.0, 0.0, 222.0, &
      0.0, 252.0, 0.0, 336.0, 0.0, 390.0, 0.0, 444.0, 0.0, &
      480.0, 0.0, 558.0, 0.0, 636.0, 0.0, 624.0, 0.0, 726.0, &
      0.0, 828.0, 0.0, 768.0, 0.0, 894.0, 0.0, 1020.0, 0.0, &
      912.0, 0.0, 1062.0, 0.0, 1212.0, 0.0, 1056.0, 0.0, 1230.0, &
      0.0, 1404.0, 0.0, &
  ! test 481-528
      30.0, 0.0, 36.0, 0.0, 42.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 174.0, 0.0, 228.0, 0.0, 282.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 318.0, 0.0, 420.0, &
      0.0, 522.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      462.0, 0.0, 612.0, 0.0, 762.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, &
  ! test 529-576
      48.0, 0.0, 54.0, 0.0, 60.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 336.0, 0.0, 390.0, 0.0, 444.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 624.0, 0.0, 726.0, &
      0.0, 828.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      912.0, 0.0, 1062.0, 0.0, 1212.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, &
  ! test 577-624
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 138.0, 0.0, &
      174.0, 0.0, 210.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 306.0, 0.0, 390.0, 0.0, 474.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 474.0, 0.0, 606.0, 0.0, 738.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 642.0, 0.0, &
      822.0, 0.0, 1002.0, &
  !test 625-672
      0.0, 621.0, 0.0, 795.0, 0.0, 969.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 453.0, 0.0, 579.0, 0.0, 705.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 285.0, 0.0, &
      363.0, 0.0, 441.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 117.0, 0.0, 147.0, 0.0, 177.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, &
  ! test 673-720
      912.0, 0.0, 1062.0, 0.0, 1212.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 624.0, 0.0, 726.0, 0.0, 828.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 336.0, 0.0, 390.0, &
      0.0, 444.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      48.0, 0.0, 54.0, 0.0, 60.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, &
  ! test 721-768
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 138.0, 0.0, &
      174.0, 0.0, 210.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 306.0, 0.0, 390.0, 0.0, 474.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 474.0, 0.0, 606.0, 0.0, 738.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 642.0, 0.0, &
      822.0, 0.0, 1002.0, &
  ! test 767-864
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 492.0, 528.0, &
      564.0, 0.0, 0.0, 0.0, 804.0, 864.0, 924.0, 0.0, 0.0, &
      0.0, 1116.0, 1200.0, 1284.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
  ! test 865-960
      102.0, 105.0, 108.0, 111.0, 114.0, 117.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1542.0, 1593.0, 1644.0, &
      1695.0, 1746.0, 1797.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 2982.0, 3081.0, 3180.0, 3279.0, 3378.0, 3477.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      4422.0, 4569.0, 4716.0, 4863.0, 5010.0, 5157.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
  !test 961-1056
      0.0, 3576.0, 0.0, 0.0, 0.0, 3774.0, 0.0, 0.0, 0.0, &
      3972.0, 0.0, 0.0, 0.0, 4008.0, 0.0, 0.0, 0.0, 4230.0, &
      0.0, 0.0, 0.0, 4452.0, 0.0, 0.0, 0.0, 4440.0, 0.0, &
      0.0, 0.0, 4686.0, 0.0, 0.0, 0.0, 4932.0, 0.0, 0.0, &
      0.0, 4872.0, 0.0, 0.0, 0.0, 5142.0, 0.0, 0.0, 0.0, &
      5412.0, 0.0, 0.0, 0.0, 5304.0, 0.0, 0.0, 0.0, 5598.0, &
      0.0, 0.0, 0.0, 5892.0, 0.0, 0.0, 0.0, 5736.0, 0.0, &
      0.0, 0.0, 6054.0, 0.0, 0.0, 0.0, 6372.0, 0.0, 0.0, &
      0.0, 6168.0, 0.0, 0.0, 0.0, 6510.0, 0.0, 0.0, 0.0, &
      6852.0, 0.0, 0.0, 0.0, 6600.0, 0.0, 0.0, 0.0, 6966.0, &
      0.0, 0.0, 0.0, 7332.0, 0.0, 0.0, &
  ! test 1057-1152
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 294.0, 0.0, 324.0, 0.0, 354.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1158.0, 0.0, 1284.0, &
      0.0, 1410.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      2022.0, 0.0, 2244.0, 0.0, 2466.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 2886.0, 0.0, 3204.0, 0.0, 3522.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
  !test 1153-1248
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 96.0, 0.0, 102.0, &
      0.0, 108.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 672.0, 0.0, 726.0, 0.0, 780.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      1248.0, 0.0, 1350.0, 0.0, 1452.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1824.0, 0.0, 1974.0, &
      0.0, 2124.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
  ! test 1249-1344
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 789.0, 0.0, 0.0, 0.0, &
      867.0, 0.0, 0.0, 0.0, 945.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 1701.0, 0.0, 0.0, 0.0, 1875.0, 0.0, 0.0, &
      0.0, 2049.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2613.0, &
      0.0, 0.0, 0.0, 2883.0, 0.0, 0.0, 0.0, 3153.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 3525.0, 0.0, 0.0, 0.0, &
      3891.0, 0.0, 0.0, 0.0, 4257.0, 0.0, &
  !test 1355-1440
      0.0, 2769.0, 0.0, 3501.0, 0.0, 4233.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 2409.0, 0.0, 3045.0, 0.0, 3681.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2049.0, 0.0, &
      2589.0, 0.0, 3129.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 1689.0, 0.0, 2133.0, 0.0, 2577.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
  !test 1441-1536
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3720.0, 0.0, 4332.0, &
      0.0, 4944.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 2568.0, 0.0, 2988.0, 0.0, 3408.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      1416.0, 0.0, 1644.0, 0.0, 1872.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 264.0, 0.0, 300.0, &
      0.0, 336.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
  !test 1537-1632
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 474.0, 0.0, 0.0, &
      0.0, 594.0, 0.0, 0.0, 0.0, 714.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 1194.0, 0.0, 0.0, 0.0, 1506.0, 0.0, &
      0.0, 0.0, 1818.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      1914.0, 0.0, 0.0, 0.0, 2418.0, 0.0, 0.0, 0.0, 2922.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2634.0, 0.0, 0.0, &
      0.0, 3330.0, 0.0, 0.0, 0.0, 4026.0, &

      84.0, 90.0, 96.0, 105.0, 108.0, 114.0, 228.0, 250.0, 272.0, &
      301.0, 316.0, 338.0, 372.0, 410.0, 448.0, 497.0, 524.0, 562.0, &
      516.0, 570.0, 624.0, 693.0, 732.0, 786.0, 660.0, 730.0, 800.0, &
      889.0, 940.0, 1010.0, 804.0, 890.0, 976.0, 1085.0, 1148.0, 1234.0, &
      948.0, 1050.0, 1152.0, 1281.0, 1356.0, 1458.0, 1092.0, 1210.0, 1328.0, &
      1477.0, 1564.0, 1682.0, &

  ! test 1681-1728
      84.0, 90.0, 96.0, 105.0, 108.0, 114.0, 228.0, 250.0, 272.0, &
      301.0, 316.0, 338.0, 372.0, 410.0, 448.0, 497.0, 524.0, 562.0, &
      516.0, 570.0, 624.0, 693.0, 732.0, 786.0, 660.0, 730.0, 800.0, &
      889.0, 940.0, 1010.0, 804.0, 890.0, 976.0, 1085.0, 1148.0, 1234.0, &
      948.0, 1050.0, 1152.0, 1281.0, 1356.0, 1458.0, 1092.0, 1210.0, 1328.0, &
      1477.0, 1564.0, 1682.0, &

  ! test 1729-1776
      84.0, 90.0, 96.0, 105.0, 108.0, 0.0, 228.0, 250.0, 272.0, &
      301.0, 316.0, 0.0, 372.0, 410.0, 448.0, 497.0, 524.0, 0.0, &
      516.0, 570.0, 624.0, 693.0, 732.0, 0.0, 660.0, 730.0, 800.0, &
      889.0, 940.0, 0.0, 804.0, 890.0, 976.0, 1085.0, 1148.0, 0.0, &
      948.0, 1050.0, 1152.0, 1281.0, 1356.0, 0.0, 1092.0, 1210.0, 1328.0, &
      1477.0, 1564.0, 0.0, &

  ! test 1777-1824
      84.0, 90.0, 96.0, 105.0, 108.0, 114.0, 228.0, 246.0, 264.0, &
      289.0, 300.0, 318.0, 372.0, 402.0, 432.0, 473.0, 492.0, 522.0, &
      516.0, 558.0, 600.0, 657.0, 684.0, 726.0, 660.0, 714.0, 768.0, &
      841.0, 876.0, 930.0, 804.0, 870.0, 936.0, 1025.0, 1068.0, 1134.0, &
      948.0, 1026.0, 1104.0, 1209.0, 1260.0, 1338.0, 1092.0, 1182.0, 1272.0, &
      1393.0, 1452.0, 1542.0, &
  ! test 1825-1872
      84.0, 90.0, 96.0, 105.0, 108.0, 114.0, 228.0, 246.0, 264.0, &
      289.0, 300.0, 318.0, 372.0, 402.0, 432.0, 473.0, 492.0, 522.0, &
      516.0, 558.0, 600.0, 657.0, 684.0, 726.0, 660.0, 714.0, 768.0, &
      841.0, 876.0, 930.0, 804.0, 870.0, 936.0, 1025.0, 1068.0, 1134.0, &
      948.0, 1026.0, 1104.0, 1209.0, 1260.0, 1338.0, 1092.0, 1182.0, 1272.0, &
      1393.0, 1452.0, 1542.0, &
  ! test 1873-1920
      30.0, 33.0, 36.0, 39.0, 42.0, 45.0, 102.0, 117.0, 132.0, &
      147.0, 162.0, 177.0, 174.0, 201.0, 228.0, 255.0, 282.0, 309.0, &
      246.0, 285.0, 324.0, 363.0, 402.0, 441.0, 318.0, 369.0, 420.0, &
      471.0, 522.0, 573.0, 390.0, 453.0, 516.0, 579.0, 642.0, 705.0, &
      462.0, 537.0, 612.0, 687.0, 762.0, 837.0, 534.0, 621.0, 708.0, &
      795.0, 882.0, 969.0, &
  !test 1921-1968
      30.0, 33.0, 36.0, 0.0, 0.0, 0.0, 102.0, 117.0, 132.0, &
      0.0, 0.0, 0.0, 174.0, 201.0, 228.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, &
  ! test 1969-2016
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 246.0, 264.0, &
      289.0, 0.0, 0.0, 0.0, 402.0, 432.0, 473.0, 0.0, 0.0, &
      0.0, 558.0, 600.0, 657.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, &
  ! test 2017-2064
      30.0, 33.0, 36.0, 39.0, 42.0, 45.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, 174.0, 201.0, 228.0, 255.0, 282.0, 309.0, &
      0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 318.0, 369.0, 420.0, &
      471.0, 522.0, 573.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, &
      462.0, 537.0, 612.0, 687.0, 762.0, 837.0, 0.0, 0.0, 0.0, &
      0.0, 0.0, 0.0, &
  ! test 2065-2112
      48.0, 0.0, 54.0, 0.0, 60.0, 0.0, 192.0, 0.0, 222.0, &
      0.0, 252.0, 0.0, 336.0, 0.0, 390.0, 0.0, 444.0, 0.0, &
      480.0, 0.0, 558.0, 0.0, 636.0, 0.0, 624.0, 0.0, 726.0, &
      0.0, 828.0, 0.0, 768.0, 0.0, 894.0, 0.0, 1020.0, 0.0, &
      912.0, 0.0, 1062.0, 0.0, 1212.0, 0.0, 1056.0, 0.0, 1230.0, &
      0.0, 1404.0, 0.0 /

  
  !test 1-48
  arr3=0
  arr3 = matmul(arr1,arr2)
  call assign_result(1,48,arr3,results)
  ! print *,"**** arr3 = matmul(arr1,arr2) ***"
  ! print *,arr3
  
  ! test 49-96
  arr3=0
  arr3(2:n_extent,:) = matmul(arr1(2:n_extent,:),arr2)
  call assign_result(49,96,arr3,results)
  ! print *,"**** arr3(2:n_extent,:) = matmul(arr1(2:n_extent,:),arr2) ***"
  ! print *,arr3
  
  ! test 97-144
  arr3=0
  arr3(1:n_extent-1,:) = matmul(arr1(1:n_extent-1,:),arr2)
  call assign_result(97,144,arr3,results)
  ! print *,"**** arr3(1:n_extent-1,:) = matmul(arr1(1:n_extent-1,:),arr2) ***"
  ! print *,arr3
  
  ! test 145-192
  arr3=0
  arr3 = matmul(arr1(:,2:m_extent),arr2(2:m_extent,:))
  call assign_result(145,192,arr3,results)
  ! print *,"**** arr3 = matmul(arr1(:,2:m_extent),arr2(2:m_extent,:)) ***"
  ! print *,arr3
  
  ! test 193-240
  arr3=0
  arr3 = matmul(arr1(:,2:m_extent),arr2(2:m_extent,:))
  call assign_result(193,240,arr3,results)
  ! print *,"**** arr3 = matmul(arr1(:,2:m_extent),arr2(2:m_extent,:)) ***"
  ! print *,arr3
  
  ! test 241-288
  arr3=0
  arr3 = matmul(arr1(:,1:m_extent-1),arr2(1:m_extent-1,:))
  call assign_result(241,288,arr3,results)
  ! print *,"**** arr3 = matmul(arr1(:,1:m_extent-1),arr2(1:m_extent-1,:)) ***"
  ! print *,arr3
  
  !test 289-336
  arr3=0
  arr3(1:3,1:3) = matmul(arr1(1:3,1:3),arr2(1:3,1:3))
  call assign_result(289,336,arr3,results)
  ! print *,"**** arr3(1:3,1:3) = matmul(arr1(1:3,1:3),arr2(1:3,1:3)) ***"
  ! print *,arr3
  
  ! test 337-384
  arr3=0
  arr3(2:4,2:4) = matmul(arr1(2:4,2:4),arr2(2:4,2:4))
  call assign_result(337,384,arr3,results)
  ! print *,"**** arr3(2:4,2:4) = matmul(arr1(2:4,2:4),arr2(2:4,2:4)) ***"
  ! print *,arr3
  
  ! test 385-432
  arr3=0
  arr3(:,1:k_extent:2) = matmul(arr1(:,1:m_extent-1),arr2(1:m_extent-1,1:k_extent:2))
  call assign_result(385,432,arr3,results)
  ! print *,"**** arr3(:,1:k_extent:2) = matmul(arr1(:,1:m_extent-1),arr2(1:m_extent-1,1:k_extent:2)) ***"
  ! print *,arr3
  
  ! test 433-480
  arr3=0
  arr3(1:n_extent:2,:) = matmul(arr1(1:n_extent:2,2:m_extent),arr2(1:m_extent-1,:))
  call assign_result(433,480,arr3,results)
  ! print *,"**** arr3(1:n_extent:2,:) = matmul(arr1(1:n_extent:2,2:m_extent),arr2(1:m_extent-1,:)) ***"
  ! print *,arr3
  
  ! test 481-528
  arr3=0
  arr3(1:n_extent:2,1:k_extent:2) = matmul(arr1(1:n_extent:2,1:m_extent-1),      &
                                           arr2(1:m_extent-1,1:k_extent:2))
  call assign_result(481,528,arr3,results)
  ! print *,"**** arr3(1:n_extent:2,1:k_extent:2) = matmul(arr1(1:n_extent:2,1:m_extent-1),arr2(1:m_extent-1,1:k_extent:2)) ***"
  ! print *,arr3
  
  ! test 529-576
  arr3=0
  arr3(1:n_extent-1:2,1:k_extent-1:2) = matmul(arr1(1:n_extent-1:2,2:m_extent),	&
                                               arr2(1:m_extent-1,1:k_extent:2))
  call assign_result(529,576,arr3,results)
  ! print *,"**** arr3(1:n_extent-1:2,1:k_extent-1:2) = matmul(arr1(1:n_extent-1:2,2:m_extent),arr2(1:m_extent-1,1:k_extent:2))***"
  ! print *,arr3
  
  ! test 577-624
  arr3=0
  arr3(2:n_extent:2,2:k_extent:2) = matmul(arr1(2:n_extent:2,1:m_extent-1),	&
                                               arr2(2:m_extent,2:k_extent:2))
  call assign_result(577,624,arr3,results)
  ! print *,"**** arr3(2:n_extent:2,2:k_extent:2) = matmul(arr1(2:n_extent:2,1:m_extent-1),arr2(2:m_extent,2:k_extent:2)) ***"
  ! print *,arr3
  
  !test 625-672
  arr3=0
  arr3(n_extent:1:-2,1:k_extent:2) = matmul(arr1(n_extent:1:-2,1:m_extent-1),      &
                                           arr2(1:m_extent-1,k_extent:1:-2))
  call assign_result(625,672,arr3,results)
  ! print *,"**** arr3(n_extent:1:-2,1:k_extent:2) = matmul(arr1(n_extent:1:-2,1:m_extent-1), arr2(1:m_extent-1,k_extent:1:-2)) ***"
  ! print *,arr3
  
  ! test 673-720
  arr3=0
  arr3(1:n_extent-1:2,k_extent-1:1:-2) = matmul(arr1(1:n_extent-1:2,m_extent:2:-1),	&
                                               arr2(m_extent-1:1:-1,1:k_extent:2))
  call assign_result(673,720,arr3,results)
  ! print *,"**** arr3(1:n_extent-1:2,k_extent-1:1:-2) = matmul(arr1(1:n_extent-1:2,m_extent:2:-1),arr2(m_extent-1:1:-1,1:k_extent:2)) ***"
  ! print *,arr3
  
  ! test 721-768
  arr3=0
  arr3(n_extent:2:-2,k_extent:2:-2) = matmul(arr1(n_extent:2:-2,m_extent-1:1:-1),	&
                                               arr2(m_extent:2:-1,k_extent:2:-2))
  call assign_result(721,768,arr3,results)
  ! print *,"**** arr3(n_extent:2:-2,k_extent:2:-2) = matmul(arr1(n_extent:2:-2,m_extent-1:1:-1),arr2(m_extent:2:-1,k_extent:2:-2)) ***"
  ! print *,arr3
  
  ! test 769-864
  arr10=0
  arr10(2:4,2:4:1) = matmul(arr4(2:4,2:4,1),arr7(1,2:4,2:4))
  call assign_result(769,864,arr10,results)
  ! print *,"**** arr10(2:4,2:4:1) = matmul(arr4(2:4,2:4,1),arr7(1,2:4,2:4)) ***"
  ! print *,arr10
  
  ! test 865-960
  arr11=0
  arr11(:,1,1:k_extent:2) = matmul(arr4(:,1:m_extent-1,2),arr8(1:m_extent-1,1,1:k_extent:2))
  call assign_result(865,960,arr11,results)
  ! print *,"**** arr11(:,1,1:k_extent:2) = matmul(arr4(:,1:m_extent-1,2),arr8(1:m_extent-1,1,1:k_extent:2)) ***"
  ! print *,arr11
  
  !test 961-1056
  arr12=0
  arr12(2,1:n_extent:2,:) = matmul(arr4(1:n_extent:2,2:m_extent,2),arr9(1:m_extent-1,:,2))
  call assign_result(961,1056,arr12,results)
  ! print *,"**** arr12(2,1:n_extent:2,:) = matmul(arr4(1:n_extent:2,2:m_extent,2),arr9(1:m_extent-1,:,2)) ***"
  ! print *,arr12
  
  ! test 1057-1152
  arr10=0
  arr10(1:n_extent:2,1:k_extent:2,2) = matmul(arr5(1:n_extent:2,2,1:m_extent-1),      &
                                           arr8(1:m_extent-1,2,1:k_extent:2))
  call assign_result(1057,1152,arr10,results)
  ! print *,"**** arr10(1:n_extent:2,1:k_extent:2,2) = matmul(arr5(1:n_extent:2,2,1:m_extent-1), arr8(1:m_extent-1,2,1:k_extent:2)) ***"
  ! print *,arr10
  
  !test 1153-1248
  arr11=0
  arr11(1:n_extent-1:2,2,1:k_extent-1:2) = matmul(arr5(1:n_extent-1:2,1,2:m_extent),	&
                                               arr9(1:m_extent-1,1:k_extent:2,1))
  call assign_result(1153,1248,arr11,results)
  ! print *,"**** arr11(1:n_extent-1:2,2,1:k_extent-1:2) = matmul(arr5(1:n_extent-1:2,1,2:m_extent),arr9(1:m_extent-1,1:k_extent:2,1)) ***"
  ! print *,arr11
  
  ! test 1249-1344
  arr12=0
  arr12(1,2:n_extent:2,2:k_extent:2) = matmul(arr5(2:n_extent:2,2,1:m_extent-1),	&
                                               arr7(2,2:m_extent,2:k_extent:2))
  call assign_result(1249,1344,arr12,results)
  ! print *,"**** arr12(1,2:n_extent:2,2:k_extent:2) = matmul(arr5(2:n_extent:2,2,1:m_extent-1), arr7(2,2:m_extent,2:k_extent:2)) ***"
  ! print *,arr12
  
  !test 1345-1440
  arr10=0
  arr10(n_extent:1:-2,1:k_extent:2,1) = matmul(arr6(2,n_extent:1:-2,1:m_extent-1),      &
                                           arr9(1:m_extent-1,k_extent:1:-2,2))
  call assign_result(1345,1440,arr10,results)
  ! print *,"**** arr10(n_extent:1:-2,1:k_extent:2,1) = matmul(arr6(2,n_extent:1:-2,1:m_extent-1),arr9(1:m_extent-1,k_extent:1:-2,2)) ***"
  ! print *,arr10
  
  !test 1441-1536
  arr11=0
  arr11(1:n_extent-1:2,2,k_extent-1:1:-2) = matmul(arr6(1,1:n_extent-1:2,m_extent:2:-1),	&
                                               arr7(2,m_extent-1:1:-1,1:k_extent:2))
  call assign_result(1441,1536,arr11,results)
  ! print *,"**** arr11(1:n_extent-1:2,2,k_extent-1:1:-2) = matmul(arr6(1,1:n_extent-1:2,m_extent:2:-1),arr7(2,m_extent-1:1:-1,1:k_extent:2)) ***"
  ! print *,arr11
  
  !test 1537-1632
  arr12=0
  arr12(2,n_extent:2:-2,k_extent:2:-2) = matmul(arr6(2,n_extent:2:-2,m_extent-1:1:-1),	&
                                               arr8(m_extent:2:-1,1,k_extent:2:-2))
  call assign_result(1537,1632,arr12,results)
  ! print *,"**** arr12(2,n_extent:2:-2,k_extent:2:-2) = matmul(arr6(2,n_extent:2:-2,m_extent-1:1:-1),arr8(m_extent:2:-1,1,k_extent:2:-2)) ***"
  ! print *,arr12

  arr19 = 0

  ! test 1633-1680
  arr15=0
  arr15 =  arr19 + matmul(arr13,arr14)
  call assign_result(1633,1680,arr15,results)
  ! print *,arr15


  ! test 1681-1728
  arr18=0
  arr18 = arr19 +  matmul(arr16,arr17)
  call assign_result(1681,1728,arr18,results)
  ! print *,arr15

   ! test 1729-1776
  arr15=0
  arr15(2:n_extent,:) = matmul(arr13(2:n_extent,:),arr14)
  call assign_result(1729,1776,arr15,results)
  ! print *,arr15

  ! test 1777-1824
  arr15=0
  arr15 = arr19 + matmul(arr13(:,2:m_extent),arr14(3:m_extent+1,:))
  call assign_result(1777,1824,arr15,results)
  ! print *,arr15

  ! test 1825-1872
  arr15=0
  arr15 = arr19 + matmul(arr13(:,2:m_extent),arr14(3:m_extent+1,:))
  call assign_result(1825,1872,arr15,results)
  ! print *,arr15

  ! test 1873-1920
  arr15=0
  arr15 = arr19 + matmul(arr13(:,1:m_extent-1),arr14(2:m_extent,:))
  call assign_result(1873,1920,arr15,results)
  !print *,arr15

  !test 1921-1968
  arr15=0
  arr15(2:4,1:3) = arr19(2:4,1:3) + matmul(arr13(2:4,1:3),arr14(2:4,1:3))
  call assign_result(1921,1968,arr15,results)
  ! print *,arr15

  ! test 1969-2016
  arr15=0
  arr15(3:5,2:4) = arr19(3:5,2:4) + matmul(arr13(3:5,2:4),arr14(3:5,2:4))
  call assign_result(1969,2016,arr15,results)
  ! print *,arr15

  ! test 2017-2064
  arr15=0
  arr15(:,1:k_extent:2) = arr19(:,1:k_extent:2) +  &
                         matmul(arr13(:,1:m_extent-1),arr14(2:m_extent,1:k_extent:2))
  call assign_result(2017,2064,arr15,results)
  ! print *,arr15

  ! test 2065-2112
  arr15=0
  arr15(2:n_extent+1:2,:) = arr19(2:n_extent+1:2,:) +   &
                           matmul(arr13(2:n_extent+1:2,2:m_extent),arr14(2:m_extent,:))
  call assign_result(2065,2112,arr15,results)
  ! print *,arr15
  
  call check(results, expect, NbrTests)

end program

subroutine assign_result(s_idx, e_idx , arr, rslt)
  REAL*4, dimension(1:e_idx-s_idx+1) :: arr
  REAL*4, dimension(e_idx) :: rslt
  integer:: s_idx, e_idx

  rslt(s_idx:e_idx) = arr

end subroutine
