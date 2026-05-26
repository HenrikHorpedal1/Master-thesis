$pdflatex = 'pdflatex -shell-escape -interaction=nonstopmode %O %S';
$pdf_mode = 1;
$out_dir  = 'build';
$aux_dir  = 'build';

# Extra files to remove on latexmk -C (full clean)
push @generated_exts, 'synctex.gz', 'run.xml', 'bbl';

# Remove minted cache on any clean (-c or -C)
END {
    if ($cleanup_mode >= 2) {   # only on -C (full clean), not -c (small clean)
        system('rm -rf _minted-main/');
    }
}
