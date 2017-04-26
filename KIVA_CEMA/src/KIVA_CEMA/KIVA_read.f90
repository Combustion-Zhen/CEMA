!============================================================================
! copyright (c) 2017 Zhen Lu <albert.lz07@gmail.com>
! data from KIVA output
!============================================================================
subroutine KIVA_read(lur, luw)
    use kiva_dat
    use chem_dat, only: ns
    implicit none

    integer, intent(in)             :: lur, luw

    character(len=len_line)         :: buffer
    character(len=16)               :: tag
    integer                         :: iostatus

    iostatus=0

    do while (iostatus==0)
      read(lur,'(a)',iostat=iostatus) buffer

      if (iostatus<0) then
          write(*,*) 'reach the end of the file'
          exit
      endif

      write(luw,'(a)') buffer

      buffer=trim(adjustl(buffer))

      call KIVA_parser(buffer,tag)

      ! find the keyword "cells"
      if(tag=='cells') then
          read(buffer(len_trim(tag)+1:),'(I20)') ncells
          ! allocate data space
          allocate(pressure(ncells))
          allocate(temperature(ncells))
          allocate(Y(ncells,ns))
          ! initialization
          pressure    = 100000.d0
          temperature = 300.d0
          Y           = 0.d0
      endif

      ! read compositions
      if(tag=='variable') then
          call KIVA_read_var(lur)
          exit
      endif

    enddo

    return
end subroutine KIVA_read

subroutine KIVA_read_var(lur)
    use chem_dat
    use kiva_dat
    implicit none

    integer, intent(in)                     :: lur

    character(len=len_line)                 :: buffer
    character(len=16)                       :: tag, symb(ns)
    integer                                 :: ispe
    logical                                 :: kerr

    call cksyms(cwk, 6, symb, kerr)

    do
      read(lur,'(a)') buffer 
      buffer=trim(adjustl(buffer))

      call KIVA_parser(buffer,tag)

      select case (tag)
      case ('endvars')
          exit
      case ('pressure')
          call KIVA_read_comp(lur, ncells, pressure)
      case ('temp')
          call KIVA_read_comp(lur, ncells, temperature)
      case default
          ! check species
          call ckcomp(tag, symb, ns, ispe)
          if(ispe.gt.0.and.ispe.le.ns) then
              call KIVA_read_comp(lur, ncells, Y(:,ispe))
          endif
      end select

    enddo

    return
end subroutine KIVA_read_var

subroutine KIVA_read_comp(lur, ncells, comp)
    implicit none

    integer, parameter                      :: k_dp = kind(1.d0)
    integer, intent(in)                     :: lur, ncells
    real(k_dp), intent(out)                 :: comp(ncells)

    integer                                 :: i, num_line

    num_line = ncells/10
    
    comp = 0.d0
    do i = 1, num_line
      read(lur,*) comp(1+(i-1)*10:i*10)
    enddo
    if(mod(ncells,10).ne.0) read(lur,*) comp(1+num_line*10:ncells)

    return
end subroutine KIVA_read_comp

subroutine KIVA_parser(buffer,tag)
    use kiva_dat, only: len_line
    implicit none

    character(len=len_line), intent(in)     :: buffer
    character(len=16), intent(out)          :: tag

    integer                                 :: tag_pos

    tag_pos=1
    if(len(buffer).ne.0)then
        do while(buffer(tag_pos:tag_pos).ne.' ')
          tag_pos = tag_pos+1
        enddo
    endif

    read(buffer(1:tag_pos),'(a)') tag

    return
end subroutine KIVA_parser
