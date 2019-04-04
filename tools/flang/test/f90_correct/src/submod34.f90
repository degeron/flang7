!
! Copyright (c) 2018, NVIDIA CORPORATION.  All rights reserved.
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

! This test checks for proper handling of module name conflicts
! aliasing can be used to prevent name conflicts (x from mod2 called x2)
! name conflicts are ignored if not referenced (y from mod and mod2)
! ONLY can be used to avoid including conflicting names (z from mod)
module mod_submod34
    integer x, y, z
interface
    module subroutine set_z(foo)
        integer, intent (in) :: foo
    end subroutine
end interface
end module mod_submod34

module mod2_submod34
    integer, x, y, z, a, b, c
end module mod2_submod34

submodule (mod_submod34) submod_submod34
    integer a, b, c
contains
    module procedure set_z
        c = foo
        z = 2 * c
!        print *, "c is ", c, " and z is ", z 
    end procedure set_z
end submodule submod_submod34

program prog
    use mod_submod34, ONLY : x, y, set_z
    use mod2_submod34,  x2 => x
    implicit none
    a = 1
    b = 2
    c = a + b 
    z = 2 * c
    x = 4
    x2 = 42
    call set_z(5)
    if  ( z .EQ. 6 )  then
        print *, " PASS "
    else
       print *, "FAILED. z should be 6, is ", z
    end if
    if (x2 .GT. x ) then
        print *, "PASSED"
    else
        print *, "TEST FAILED. x2 (", x2, ") should be greater than x (", x, ")"
    end if
end program prog
