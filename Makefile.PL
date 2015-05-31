
# Makefile.PL for PDL::Ops module.

# Use this as a template for the Makefile.PL for
# any external PDL module.

use PDL::Core::Dev;
use ExtUtils::MakeMaker;

PDL::Core::Dev->import();
$package = ["linear_solve.pd",Solve,PDL::Lib::Linear::Solve];
%hash = pdlpp_stdargs($package);
#$hash{OBJECT} .= ' additional_Ccode$(OBJ_EXT) ';
#$hash{clean}->{FILES} .= ' todelete_Ccode$(OBJ_EXT) ';
$hash{'VERSION_FROM'} = 'linear_solve.pd';

if ($ExtUtils::MakeMaker::VERSION >= 6.48)
{
    $hash{META_MERGE} =
    {
        "meta-spec" => { version => 2 },

        resources => {
            repository => {
                type => 'git',
                url => 'git@github.com:shlomif/perl-PDL-Lib-Linear-Solve.git',
                web => 'https://github.com/shlomif/perl-PDL-Lib-Linear-Solve',
            },

        },
    };
}

WriteMakefile(%hash);

sub MY::postamble { pdlpp_postamble($package); }

