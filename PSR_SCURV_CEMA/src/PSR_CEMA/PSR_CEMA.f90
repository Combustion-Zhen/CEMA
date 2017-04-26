!============================================================================
! copyright (c) 2017 Zhen Lu <albert.lz07@gmail.com>
! A program to do CEMA for KIVA data
!============================================================================
program PSR_CEMA
    use chem_dat
    implicit none

    integer       :: lur, luw, iostats, nreac
    logical       :: exists
    character(16) :: filename

    real(k_dp)    :: omega, p, temp, h, lambda_e
    real(k_dp), allocatable :: Y(:), ei(:)

    lur = 20
    luw = 21

    call chem_ckin

    inquire(file='psr.out',exist=exists)
    if(.not.exists) stop 'psr.out required as input'
    open(lur,file='psr.out',position='rewind',action='read')
    open ( luw, file='PSR_CEMA.op', status='replace',                 &
           position = 'rewind', action='write')
    
    allocate( Y(ns) )
    allocate( ei(ns+1) )

    p = 1013250.d0

    do
      read(lur,200,iostat=iostats) omega, temp, Y, h
      if( iostats < 0 ) exit
      call CEMA('P','E',ne,nr,ns,liwk,lrwk,iwk,rwk,p,temp,Y,lambda_e,ei)
      write(luw,200) omega, lambda_e
    enddo

    deallocate( Y )
    deallocate( ei )

    close ( lur )
    close ( luw )

    stop
200 format(200E15.7)
end program PSR_CEMA
