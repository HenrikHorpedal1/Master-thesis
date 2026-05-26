use Cwd;

# Overleaf compiles inside /compile/...; everything else is a local machine.
my $is_overleaf = (getcwd() =~ m{^/compile});

$pdf_mode = 1;

if ($is_overleaf) {
    # Plain pdflatex — no shell wrapper, no custom output dir (Overleaf serves
    # the PDF from the project root and cannot execute ./texrun.sh).
    $pdflatex = 'pdflatex -shell-escape -interaction=nonstopmode %O %S';
} else {
    # texrun.sh validates/removes a corrupted aux before each pdflatex run,
    # preventing "File ended while scanning use of \@writefile" when VimTeX
    # kills the process mid-write on rapid saves.
    $pdflatex = './texrun.sh -shell-escape -interaction=nonstopmode %O %S';
    $out_dir  = 'build';
    $aux_dir  = 'build';
}

# Extra files to remove on latexmk -C (full clean)
push @generated_exts, 'synctex.gz', 'run.xml', 'bbl';

# Remove minted cache on full clean (-C) only
END {
    if ($cleanup_mode >= 2) {
        system('rm -rf build/_minted-main/');
    }
}
