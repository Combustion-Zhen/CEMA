!============================================================================
! copyright (c) 2017 Zhen Lu <albert.lz07@gmail.com>
! A program to do CEMA for KIVA data
! 
! In the present version, the real part of the eigenvalue for the chemical
! explosive mode, lambda_e, with EI are ouput.
!
! INPUT:
!   MM          number of elements
!   II          number of reactions
!   KK          number of species
!   LIWRK       length of the integer workspace for chemkin
!   LRWRK       length of the real workspace for chemkin
!   ICKWRK      integer workspace for chemkin
!   RCKWEK      real workspace for chemkin
!   P           pressure
!   T           temperature
!   Y           mass fraction
! OUTOUT:
!   LAMBDA_E    eigenvalue of the chemical explosive mode
!   EI          explosion index
!
! The CEMA subroutine can deal with either constant pressure or constant volume
! system, with different composition variables such as {Y, T}, {Y, h}, {Y, u}
!
! Options for CEMA are given through the first two input character variables,
! they are SYS_CONST and COMP_EVAR
!   SYS_CONST
!       'P' for constant pressure system
!       'V' for constant volume system
!   COMP_EVAR
!       'T' for {Y, T}
!       'E' for {Y, h} or {Y, u}, depends on SYS_CONST
!       'S' for {Y, h^s} or {Y, u^s}, depends on SYS_CONST
!
!============================================================================
subroutine KIVA_eigen
    use chem_dat
    use kiva_dat
    implicit none

    integer                     :: icell
    real(k_dp)                  :: ei(ns+1)

    ! allocate the data space
    allocate( lambda_e(ncells) )

    do icell = 1, ncells
      call CEMA('V','E',ne,nr,ns,liwk,lrwk,iwk,rwk,pressure(icell),            &
                    temperature(icell),Y(icell,:),lambda_e(icell),ei)
    enddo

    return
end subroutine KIVA_eigen
