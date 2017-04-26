!============================================================================
! copyright (c) 2017 Zhen Lu <albert.lz07@gmail.com>
! data from KIVA output
!============================================================================
subroutine KIVA_output(lur, luw)
    use kiva_dat
    implicit none

    integer, intent(in)             :: lur, luw

    character(len=len_line)         :: buffer
    integer                         :: iostatus

    ! write the CEMA results
    ! lambda_e real part
    write(luw,'(a)') 'lambda_e     0'
    call KIVA_write_comp(luw, ncells, lambda_e)

    ! write the remaining data in KIVA file
    write(luw,'(a)') 'endvars'
    do while (iostatus==0)
      read(lur,'(a)',iostat=iostatus) buffer 
      if(iostatus<0) exit
      write(luw,'(a)') buffer
    enddo

    return
end subroutine KIVA_output

subroutine KIVA_write_comp(luw, ncells, comp)
    implicit none

    integer, parameter      :: k_dp = kind(1.d0)
    integer, intent(in)     :: luw, ncells
    real(k_dp), intent(in)  :: comp(ncells)

    integer                 :: i, num_line

    num_line = ncells/10

    do i = 1, num_line
      write(luw,100) comp(1+(i-1)*10:i*10)
    enddo
    if(mod(ncells,10).ne.0) write(luw,100) comp(1+num_line*10:ncells)

    return
100 format(1X, 10E16.8)
end subroutine KIVA_write_comp
