#!/usr/bin/perl -w -I./blib/lib/ -I./blib/arch/

use strict;

use PDL;
use PDL::Lib::Linear::Solve;

sub eye
{
    my $n = shift;
    my $pdl = zeroes($n,$n);
    ++($pdl->diagonal(0,1));
    return $pdl;
}

# my $a = pdl([3,4,5]);
# print PDL::Lib::Mylib::sumover2($a), "\n";

my ($coeffs, $values);
# my $coeffs = pdl([0,0,2], [1, 1,3],[0,1,9]);
# my $values = pdl([1], [5],[7]);

$coeffs = pdl([1, 1],[0, 1]);
$values = eye(2);

$coeffs = pdl([0,0,2], [1, 1,3],[0,1,9]);
$values = eye(3);

$coeffs = pdl([[1,1,1],[0,1,1],[1,1,0]]);
$values = eye(3);

$coeffs = pdl([[1,1,1],[1,1,0],[2,2,0]]);
$values = eye(3);

$coeffs = pdl([[1,0,1],[0,1,0],[0,0,1]]);
$values = pdl([
         [[1,2,3],[4,5,6],[7,8,9]],
         [[10,20,30],[40,50,60],[70,80,90]],
         [[100,200,300],[400,500,600],[700,800,900]]
         ]);

my ($out_coeffs, $out_values) = linear_solve($coeffs, $values);
print "\$coeffs = ", $coeffs, "\n";
print "\$out_coeffs = ", $out_coeffs, "\n";
print "\$out_values = ", $out_values, "\n";
print "c*inv(c) = ", $coeffs x $out_values, "\n";


