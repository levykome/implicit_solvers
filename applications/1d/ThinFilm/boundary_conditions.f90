subroutine apply_homogeneous_bcs(q)

! Apply the relevant homogeneous boundary condition operator.

    implicit none

    integer :: mx, mbc, meqn
    double precision :: x_lower, dx
    common /claw_config/ mx, mbc, x_lower, dx, meqn
    double precision, dimension(1-mbc:mx+mbc, meqn), intent(inout) :: q
    double precision, dimension(4) :: zeros

    character(len=2), dimension(2, 10) :: bc_options
    common /bc_config/ bc_options

    zeros = 0.d0
    call fill_2_ghost_cells(bc_options(1, 1), zeros, bc_options(2, 1), zeros, q(:, 1))

end subroutine apply_homogeneous_bcs


subroutine apply_bcs(t, q)

! Fill ghost cells with appropriate boundary values.

    implicit none

    integer :: mx, mbc, meqn
    double precision :: x_lower, dx
    common /claw_config/ mx, mbc, x_lower, dx, meqn

    character(len=2), dimension(2, 10) :: bc_options
    common /bc_config/ bc_options

    double precision, dimension(4, 0:3) :: stencils
    common /stencil_config/ stencils

    double precision, intent(in) :: t
    double precision, dimension(1-mbc:mx+mbc, meqn), intent(inout) :: q

    double precision, dimension(2) :: lower_values, upper_values

    call set_implicit_boundary_data(t, lower_values, upper_values)
    call fill_2_ghost_cells(bc_options(1, 1), lower_values, bc_options(2, 1), upper_values, q(:, 1))

end subroutine apply_bcs


subroutine set_implicit_boundary_data(t, lower_values, upper_values)

    implicit none

    integer :: mx, mbc, meqn
    double precision :: x_lower, dx
    common /claw_config/ mx, mbc, x_lower, dx, meqn

    character(len=2), dimension(2, 10) :: bc_options
    common /bc_config/ bc_options

    double precision, dimension(4, 0:3) :: stencils
    common /stencil_config/ stencils

    double precision, intent(in) :: t
    double precision, dimension(2), intent(out) :: lower_values, upper_values

    double precision, external :: true_solution
    double precision, dimension(-1:2) :: cellwise_lower_values, cellwise_upper_values
    integer :: i, order


    call get_true_solution_by_index_range(-1, 2, t, cellwise_lower_values)
    call get_true_solution_by_index_range(mx-1, mx+2, t, cellwise_upper_values)

    do i = 1, 2
        read(bc_options(1, 1)(i:i), '(I1)') order
        lower_values(i) = dot_product(stencils(:, order), cellwise_lower_values) / dx**order
    end do
    do i = 1, 2
        read(bc_options(2, 1)(i:i), '(I1)') order
        upper_values(i) = dot_product(stencils(:, order), cellwise_upper_values) / dx**order
    end do

end subroutine set_implicit_boundary_data