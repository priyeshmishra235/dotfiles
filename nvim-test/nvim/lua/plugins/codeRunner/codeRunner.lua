return {
  -- All run commands allow restart. So, for example, if you use a command that does not have hot reload, you can call a command again and it will close the previous one and start again.
  --
  -- :RunCode: Runs based on file type, first checking if belongs to project, then if filetype mapping exists
  -- :RunCode <A_key_here>: Execute command from its key in current directory.
  -- :RunFile <mode>: Run the current file (optionally you can select an opening mode).
  -- :RunProject <mode>: Run the current project(If you are in a project otherwise you will not do anything,).
  -- :RunClose: Close runner(Doesn't work in better_term mode, use native plugin options)
  -- :CRFiletype - Open json with supported files(Use only if you configured with json files).
  -- :CRProjects - Open json with list of projects(Use only if you configured with json files).
  -- :CrStopHr - Stop Hot Reload(Use only if hot_reload is true, experimental feature).
  'CRAG666/code_runner.nvim',
  config = function()
    require('code_runner').setup {
      filetype = {
        c = {
          'cd $dir &&',
          'gcc $fileName -o $fileNameWithoutExt &&',
          './$fileNameWithoutExt',
        },
        cpp = {
          'cd $dir &&',
          'g++ $fileName -o $fileNameWithoutExt &&',
          './$fileNameWithoutExt',
        },
        java = {
          'cd $dir &&',
          'javac $fileName &&',
          'java $fileNameWithoutExt',
        },
        javascript = 'node $fileName',
        typescript = 'deno run $fileName',
        python = 'python3 -u $fileName',
        php = 'php $fileName',
        ruby = 'ruby $fileName',
        go = 'go run $fileName',
        lua = 'lua $fileName',
        perl = 'perl $fileName',
        r = 'Rscript $fileName',
        swift = 'swift $fileName',
        kotlin = {
          'cd $dir &&',
          'kotlinc $fileName -include-runtime -d $fileNameWithoutExt.jar &&',
          'java -jar $fileNameWithoutExt.jar',
        },
        rust = {
          'cd $dir &&',
          'rustc $fileName &&',
          './$fileNameWithoutExt',
        },
        haskell = 'runhaskell $fileName',
        dart = 'dart $fileName',
        scala = 'scala $fileName',
        shellscript = 'bash $fileName',
        powershell = 'pwsh -File $fileName',
        fsharp = 'dotnet fsi $fileName',
        csharp = {
          'cd $dir &&',
          'mcs $fileName &&',
          'mono $fileNameWithoutExt.exe',
        },
        vbscript = 'cscript //Nologo $fileName',
        clojure = 'clojure $fileName',
        groovy = 'groovy $fileName',
        julia = 'julia $fileName',
        elixir = 'elixir $fileName',
        erlang = 'escript $fileName',
        nim = 'nim compile --run $fileName',
        d = {
          'cd $dir &&',
          'dmd $fileName &&',
          './$fileNameWithoutExt',
        },
        lisp = 'sbcl --script $fileName',
        objectivec = {
          'cd $dir &&',
          'gcc $fileName -o $fileNameWithoutExt -lobjc &&',
          './$fileNameWithoutExt',
        },
        fortran = {
          'cd $dir &&',
          'gfortran $fileName -o $fileNameWithoutExt &&',
          './$fileNameWithoutExt',
        },
        matlab = 'matlab -batch $fileName',
        rscript = 'Rscript $fileName',
        tcl = 'tclsh $fileName',
        vb = {
          'cd $dir &&',
          'vbc /nologo $fileName &&',
          'mono $fileNameWithoutExt.exe',
        },
        zig = {
          'cd $dir &&',
          'zig build-exe $fileName &&',
          './$fileNameWithoutExt',
        },
        pascal = {
          'cd $dir &&',
          'fpc $fileName &&',
          './$fileNameWithoutExt',
        },
        ocaml = 'ocaml $fileName',
        racket = 'racket $fileName',
        scheme = 'scheme --script $fileName',
        vlang = {
          'cd $dir &&',
          'v $fileName &&',
          './$fileNameWithoutExt',
        },
        crystal = {
          'cd $dir &&',
          'crystal build $fileName -o $fileNameWithoutExt &&',
          './$fileNameWithoutExt',
        },
        haxe = {
          'cd $dir &&',
          'haxe -main $fileNameWithoutExt -neko $fileNameWithoutExt.n &&',
          'neko $fileNameWithoutExt.n',
        },
        awk = 'awk -f $fileName',
        sed = 'sed -f $fileName',
        makefile = 'make -f $fileName',
        cmake = {
          'cd $dir &&',
          'cmake . &&',
          'make &&',
          './$fileNameWithoutExt',
        },
        dockerfile = {
          'cd $dir &&',
          'docker build -t $fileNameWithoutExt . &&',
          'docker run $fileNameWithoutExt',
        },
        tex = 'pdflatex $fileName',
        markdown = 'pandoc $fileName -o $fileNameWithoutExt.html',
        yaml = 'python3 -c "import yaml, sys; print(yaml.safe_load(sys.stdin.read()))" < $fileName',
        json = 'python3 -m json.tool $fileName',
        xml = 'xmllint --format $fileName',
        csv = 'column -s, -t < $fileName | less -#2 -N -S',
        tsv = "column -s$'\t' -t < $fileName | less -#2 -N -S",
        html = 'open $fileName',
        css = 'open $fileName',
        less = 'lessc $fileName $fileNameWithoutExt.css',
        scss = 'sass $fileName $fileNameWithoutExt.css',
        sass = 'sass $fileName $fileNameWithoutExt.css',
        coffee = 'coffee $fileName',
        livescript = 'lsc $fileName',
        typescriptreact = 'ts-node $fileName',
        javascriptreact = 'node $fileName',
        vue = 'vue-cli-service serve $fileName',
        svelte = 'svelte $fileName',
        elm = 'elm make $fileName --output=$fileNameWithoutExt.html',
        purescript = 'purs compile $fileName',
        reason = 'bsb -make-world -w',
        rescript = 'rescript build -with-deps',
        fennel = 'fennel $fileName',
        moonscript = 'moonc $fileName',
        qsharp = 'dotnet run $fileName',
        wolfram = 'wolframscript -file $fileName',
        apl = 'apl -f $fileName',
        forth = 'gforth $fileName',
        prolog = 'swipl -s $fileName',
        mercury = 'mmc --make $fileNameWithoutExt && ./$fileNameWithoutExt',
        idris = 'idris $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt',
        agda = 'agda $fileName',
        coq = 'coqc $fileName',
        lean = 'lean $fileName',
        verilog = 'iverilog -o $fileNameWithoutExt $fileName && vvp $fileNameWithoutExt',
        vhdl = 'ghdl -a $fileName && ghdl -e $fileNameWithoutExt && ghdl -r $fileNameWithoutExt',
      },
    }

    -- Keymaps
    local opts = { noremap = true, silent = false }
    vim.keymap.set('n', '<leader>rr', ':RunCode<CR>', opts)
    vim.keymap.set('n', '<leader>rf', ':RunFile<CR>', opts)
    vim.keymap.set('n', '<leader>rft', ':RunFile tab<CR>', opts)
    vim.keymap.set('n', '<leader>rp', ':RunProject<CR>', opts)
    vim.keymap.set('n', '<leader>rc', ':RunClose<CR>', opts)
    vim.keymap.set('n', '<leader>crf', ':CRFiletype<CR>', opts)
    vim.keymap.set('n', '<leader>crp', ':CRProjects<CR>', opts)
  end,
}
