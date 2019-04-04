** Copyright (c) 1989, NVIDIA CORPORATION.  All rights reserved.
**
** Licensed under the Apache License, Version 2.0 (the "License");
** you may not use this file except in compliance with the License.
** You may obtain a copy of the License at
**
**     http://www.apache.org/licenses/LICENSE-2.0
**
** Unless required by applicable law or agreed to in writing, software
** distributed under the License is distributed on an "AS IS" BASIS,
** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
** See the License for the specific language governing permissions and
** limitations under the License.

*   Miscellaneous software pipelining bugs

	program test
	parameter (NUM=20)
	common result(NUM), expect(NUM)
	doubleprecision result, expect
	doubleprecision x(10),y(10)

	do 1 i = 1,10
	    call noswpipe
	    x(i) = 1d0*i
	    y(i) = 3d0*i
1	continue

	call f06fpt(10,x,-1,y,-1,(0.0d0),(-1.0d0))

	j = 1
	do 2 i = 1,10
	    call noswpipe
	    result(j) = x(i)
	    result(j+1) = y(i)
	    j = j + 2
c	    print *,x(i),y(i)
2	continue

	data expect/
     +  -3.0, -1.0, -6.0, -2.0, -9.0, -3.0, -12.0, -4.0, -15.0, -5.0,
     +  -18.0, -6.0, -21.0, -7.0, -24.0, -8.0, -27.0, -9.0,
     +  -30.0, -10.0
     +  /
	call checkd(result, expect, NUM)
	end

	subroutine noswpipe
	end

      SUBROUTINE f06fpt( N, X, INCX, Y, INCY, C, S )
      DOUBLE PRECISION   C, S
      INTEGER            INCX, INCY, N
      DOUBLE PRECISION   X( * ), Y( * )
      DOUBLE PRECISION   ONE         , ZERO
      PARAMETER        ( ONE = 1.0D+0, ZERO = 0.0D+0 )
      DOUBLE PRECISION   TEMP1
      INTEGER            I, IX, IY
      IF( N.GT.0 )THEN
         IF( S.NE.ZERO )THEN
                     IY = 1 - ( N - 1 )*INCY
                     IX = 1 - ( N - 1 )*INCX
                     DO 60, I = 1, N
                        TEMP1   = -X( IX )
                        X( IX ) = -Y( IY )
                        Y( IY ) =  TEMP1
                        IX      =  IX      + INCX
                        IY      =  IY      + INCY
   60                CONTINUE
         END IF
      END IF
      RETURN
      END
