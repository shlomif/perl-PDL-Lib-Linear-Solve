#!/usr/bin/perl -w

use strict;

use constant NUM_LINEAR_SOLVE_TESTS => 4;
use constant NUM_INV_TESTS => 5;
use Test::More tests => (1+NUM_LINEAR_SOLVE_TESTS+NUM_INV_TESTS);

use PDL;

BEGIN
{
    use_ok('PDL::Lib::Linear::Solve');
}

sub eye
{
    my $n = shift;
    my $pdl = zeroes($n,$n);
    $pdl->diagonal(0,1)++;
    return $pdl;
}

sub tapprox {
    my($a,$b) = @_;
    my $c = abs($a-$b);
    my $d = max($c);
    $d < 0.01;
}

my @linear_solve_tests =
(
    {
        'in_c' => [[1,1],[0,1]],
        'in_v' => [[5],[2]],
        'out_c' => eye(2),
        'out_v' => [[3],[2]],
    },
    {
        'in_c' => [[1,1,1],[0,1,1],[1,1,0]],
        'in_v' => eye(3),
        'out_c' => eye(3),
        'out_v' => [[1,-1,0],[-1,1,1],[1,0,-1]],
    },
    {
        # This is a singular matrix.
        'in_c' => [[1,1,1],[1,1,0],[2,2,0]],
        'in_v' => eye(3),
        'out_c' => [[1,1,1],[0,0,-1],[0,0,-2]],
        'out_v' => [[1,0,0],[-1,1,0],[-2,0,1]],
    },
    {
        # Test the identity.
        'in_c' => eye(2),
        'in_v' => eye(2),
        'out_c' => eye(2),
        'out_v' => eye(2),
    },
);

if (scalar(@linear_solve_tests) != NUM_LINEAR_SOLVE_TESTS)
{
    die "Incorrect number of linear solve tests!";
}

foreach my $t (@linear_solve_tests)
{
    my @out_array = linear_solve(map { pdl($_) } @$t{'in_c','in_v'});
    ok(tapprox($out_array[0], pdl($t->{'out_c'})) &&
       tapprox($out_array[1], pdl($t->{'out_v'})));
}

my @inv_tests =
(
    {
        'in_mat' => [[1,0],[0,1]],
    },
    {
        'in_mat' => [[0,1],[1,0]],
    },
    {
        'in_mat' => [[1,1],[1,0]],
    },
    {
        'in_mat' => [[1,1,1],[1,0,0],[0,2,0]],
    },
    {
        'in_mat' => [[1,2,3],[4,5,6],[-100,2,100]],
    },    
);

if (scalar(@inv_tests) != NUM_INV_TESTS)
{
    die "Incorrect number of inv tests!";
}

foreach my $t (@inv_tests)
{
    my $mat = pdl($t->{'in_mat'});
    my @dims = dims($mat);
    if ((scalar(@dims) != 2) || ($dims[0] != $dims[1]))
    {
        die "Incorrect input for inv:\n$mat\n";
    }
    my $result = myinv($mat);
    ok(tapprox($mat x $result, eye($dims[0])));
}

