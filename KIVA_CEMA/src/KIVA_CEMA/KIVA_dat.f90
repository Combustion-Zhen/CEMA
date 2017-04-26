!============================================================================
! copyright (c) 2017 Zhen Lu <albert.lz07@gmail.com>
! data from KIVA output
!============================================================================
module kiva_dat
    implicit none
    integer, parameter          :: DP = kind(1.d0), len_line=200
    integer                     :: ncells
    real(DP), allocatable       :: pressure(:), temperature(:), Y(:,:),       &
                                   lambda_e(:)
end module kiva_dat
