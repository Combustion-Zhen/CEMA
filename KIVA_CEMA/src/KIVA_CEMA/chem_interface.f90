!============================================================================
! copyright (c) 2017 Zhen Lu <albert.lz07@gmail.com>
! chemkin interface
!============================================================================
module chem_dat
    implicit none
    integer, parameter         :: k_dp = kind(1.d0)
    integer                    :: liwk, lcwk, lrwk, ne, ns, nr, nfit
    integer, allocatable       :: iwk(:)
    character(16), allocatable :: cwk(:)
    real(k_dp), allocatable    :: rwk(:)
end module chem_dat

subroutine chem_ckin
    use chem_dat
    implicit none

    integer :: luck, luout, iflag, v(8)
    logical :: exists

    luck  = 11
    luout = 12

    ! chem.bin file
    inquire(file='chem.bin',exist=exists)
    if ( .not. exists ) stop 'chem.bin file not found'

    open(luck,file='chem.bin',form='unformatted',                  &
        err=100,action='read',position='rewind')

    open(luout,file='chem.op',status='replace',action='write')
    write(luout,*) ''
    write(luout,*) '===== Chemistry Interface Initialization ====='
    write(luout,*) ''
    call date_and_time( values = v )
    write(luout,200) v(2),v(3),v(1),v(5),v(6),v(7)

    iflag = 0
    call cklen(luck, luout, liwk, lrwk, lcwk, iflag)
    if(iflag .ne. 0) stop 'Error in cklen'

    allocate(iwk(liwk))
    allocate(rwk(lrwk))
    allocate(cwk(lcwk))

    call ckinit(liwk,lrwk,lcwk,luck,luout,iwk,rwk,cwk,iflag)
    if(iflag .ne. 0) stop 'Error in ckinit'

    call ckindx(iwk, rwk, ne, ns, nr, nfit)

    close(luck)
    write(luout,*) '===== Initialization Complete ====='
    close(luout)
    
    return

100 stop 'error opening chem.bin'
200 format('Date (MM/DD/YEAR): ',i2,'/',i2,'/',i4,                 &
    ' Time: ',i2,':',i2,':',i2,'.')

end subroutine chem_ckin
