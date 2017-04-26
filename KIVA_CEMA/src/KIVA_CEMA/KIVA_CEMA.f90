!============================================================================
! copyright (c) 2017 Zhen Lu <albert.lz07@gmail.com>
! A program to do CEMA for KIVA data
!============================================================================
program KIVA_CEMA
    use chem_dat
    implicit none

    integer       :: lur, luw
    logical       :: exists
    character(16) :: filename

    namelist /cema/ filename

    lur = 20
    luw = 21

    ! check parameters for cema analysis
    inquire ( file = 'cema.nml', exist= exists )
    if ( exists ) then
        open ( lur, file = 'cema.nml', position = 'rewind', action = 'read' )
        read ( lur, nml = cema )
        close ( lur )
    end if

    ! check the KIVA data file
    inquire ( file = filename, exist = exists )
    if ( .not. exists ) stop 'KIVA data file does not exist'
    open ( lur, file = filename, position = 'rewind', action = 'read' )

    open ( luw, file='KIVA_CEMA.op', status='replace', position = 'rewind', action='write')

    call chem_ckin

    ! read in KIVA 
    call KIVA_read(lur,luw)

    call KIVA_eigen

    call KIVA_output(lur,luw)

    close ( lur )
    close ( luw )

    stop
end program KIVA_CEMA
