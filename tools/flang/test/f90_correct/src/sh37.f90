! Copyright (c) 2004, NVIDIA CORPORATION.  All rights reserved.
!
! Licensed under the Apache License, Version 2.0 (the "License");
! you may not use this file except in compliance with the License.
! You may obtain a copy of the License at
!
!     http://www.apache.org/licenses/LICENSE-2.0
!
! Unless required by applicable law or agreed to in writing, software
! distributed under the License is distributed on an "AS IS" BASIS,
! WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
! See the License for the specific language governing permissions and
! limitations under the License.
!
! test EOSHIFT and CSHIFT
! one dimension out of two
	program p
	 implicit none
	 integer, parameter :: N=5, M=6
	 integer, dimension(N,M) :: src
	 integer, dimension(N,M) :: eopc,eopv,cpc,cpv
	 integer, dimension(N,M) :: eomc,eomv,cmc,cmv
	 integer, dimension(N,M) :: eopcres,eopvres,cpcres,cpvres
	 integer, dimension(N,M) :: eomcres,eomvres,cmcres,cmvres
	 integer :: i,j,k
        data eopcres/&
        &   7,   8,   9,  10,   0,&
        &  12,  13,  14,  15,   0,&
        &  17,  18,  19,  20,   0,&
        &  22,  23,  24,  25,   0,&
        &  27,  28,  29,  30,   0,&
        &   0,   0,   0,   0,   0/
        data eopvres/&
        &   7,   8,   9,  10,   0,&
        &  12,  13,  14,  15,   0,&
        &  17,  18,  19,  20,   0,&
        &  22,  23,  24,  25,   0,&
        &  27,  28,  29,  30,   0,&
        &   0,   0,   0,   0,   0/
        data eomcres/&
        &   0,   0,   0,   0,   0,&
        &   2,   3,   4,   5,   0,&
        &   7,   8,   9,  10,   0,&
        &  12,  13,  14,  15,   0,&
        &  17,  18,  19,  20,   0,&
        &  22,  23,  24,  25,   0/
        data eomvres/&
        &   0,   0,   0,   0,   0,&
        &   2,   3,   4,   5,   0,&
        &   7,   8,   9,  10,   0,&
        &  12,  13,  14,  15,   0,&
        &  17,  18,  19,  20,   0,&
        &  22,  23,  24,  25,   0/
        data  cpcres/&
        &   7,   8,   9,  10,   0,&
        &  12,  13,  14,  15,   0,&
        &  17,  18,  19,  20,   0,&
        &  22,  23,  24,  25,   0,&
        &  27,  28,  29,  30,   0,&
        &   2,   3,   4,   5,   0/
        data  cpvres/&
        &   7,   8,   9,  10,   0,&
        &  12,  13,  14,  15,   0,&
        &  17,  18,  19,  20,   0,&
        &  22,  23,  24,  25,   0,&
        &  27,  28,  29,  30,   0,&
        &   2,   3,   4,   5,   0/
        data  cmcres/&
        &  27,  28,  29,  30,   0,&
        &   2,   3,   4,   5,   0,&
        &   7,   8,   9,  10,   0,&
        &  12,  13,  14,  15,   0,&
        &  17,  18,  19,  20,   0,&
        &  22,  23,  24,  25,   0/
        data  cmvres/&
        &  27,  28,  29,  30,   0,&
        &   2,   3,   4,   5,   0,&
        &   7,   8,   9,  10,   0,&
        &  12,  13,  14,  15,   0,&
        &  17,  18,  19,  20,   0,&
        &  22,  23,  24,  25,   0/
	 logical,parameter :: doprint = .false.
	 eopc = -10	! fill in with garbage
	 eopv = -10
	 eomc = -10
	 eomv = -10
	 cpc = -10
	 cpv = -10
	 cmc = -10
	 cmv = -10
	 call sub(j,k)	! j is positive, k is negative
	 src=reshape((/(i,i=1,N*M)/),(/N,M/))	! initialize
	 eopc=eoshift(eoshift(src,j,dim=1), 1, dim=2)	! eoshift, positive, constant
	 eopv=eoshift(eoshift(src,j,dim=1), j, dim=2)	! eoshift, positive, variable
	 eomc=eoshift(eoshift(src,j,dim=1),-1, dim=2)	! eoshift, negative, constant
	 eomv=eoshift(eoshift(src,j,dim=1), k, dim=2)	! eoshift, negative, variable
	  cpc= cshift(eoshift(src,j,dim=1), 1, dim=2)	!  cshift, positive, constant
	  cpv= cshift(eoshift(src,j,dim=1), j, dim=2)	!  cshift, positive, variable
	  cmc= cshift(eoshift(src,j,dim=1),-1, dim=2)	!  cshift, negative, constant
	  cmv= cshift(eoshift(src,j,dim=1), k, dim=2)	!  cshift, negative, variable
	 if( doprint )then
	  print 10, ' src',src
	  print 10, 'eopc',eopc
	  print 10, 'eopv',eopv
	  print 10, 'eomc',eomc
	  print 10, 'eomv',eomv
	  print 10, ' cpc', cpc
	  print 10, ' cpv', cpv
	  print 10, ' cmc', cmc
	  print 10, ' cmv', cmv
10	  format('        data ',a,'res/&'/'        &',5(5(i4,','),'&'/'        &'),&
		& 4(i4,','),i4,'/')
	 else
	  call check(eopc,eopcres,N*M)
	  call check(eopv,eopvres,N*M)
	  call check(eomc,eomcres,N*M)
	  call check(eomv,eomvres,N*M)
	  call check(cpc,cpcres,N*M)
	  call check(cpv,cpvres,N*M)
	  call check(cmc,cmcres,N*M)
	  call check(cmv,cmvres,N*M)
	 endif
	end
	subroutine sub(j,k)
	 j = 1
	 k = -1
	end
