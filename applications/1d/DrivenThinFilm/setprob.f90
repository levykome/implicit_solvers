subroutine setprob

    implicit none

    integer :: newton_max_iter, newton_verbosity
    double precision :: newton_reduction_factor, newton_tolerance
    common /newton_config/ newton_max_iter, newton_reduction_factor,  &
        newton_tolerance, newton_verbosity

    double precision :: cg_tolerance
    integer :: cg_verbosity
    common /cg_config/ cg_tolerance, cg_verbosity

    double precision :: h_left, h_right
    common /boundary_config/ h_left, h_right

    double precision :: gamma
    common /physics_config/ gamma

    character*12 fname
    integer :: iunit


    iunit = 7
    fname = 'setprob.data'

    call opendatafile(iunit, fname)

    read(7, *) newton_max_iter
    read(7, *) newton_reduction_factor
    read(7, *) newton_tolerance
    read(7, *) newton_verbosity

    read(7, *) cg_tolerance
    read(7, *) cg_verbosity

    read(7, *) h_left
    read(7, *) h_right

    read(7, *) gamma
    
end subroutine setprob
