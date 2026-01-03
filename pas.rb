#!/usr/bin/env ruby

# pas: Ruby script
#   Simplified pacman command for MSys2/MinGW on Windows
#     Help:
#       $ ruby pas.rb -h

# License MIT by dinau 2015/12

# Ruby 3.4.8

require 'open3'

class Pas
  def initialize
    @msystemInfoTbl = {
      "MINGW64" => {
        prefix: "mingw-w64-x86_64-",
        group: "mingw64",
      },
      "MINGW32" => {
        prefix: "mingw-w64-i686-",
        group: "mingw32",
      },
      "UCRT64" => {
        prefix: "mingw-w64-ucrt-x86_64-",
        group: "ucrt64",
      },
      "CLANG64" => {
        prefix: "mingw-w64-clang-x86_64-",
        group: "clang64",
      },
      "CLANGARM64" => {
        prefix: "mingw-w64-clang-aarch64-",
        group: "clangarm64",
      },
    }
    @cmdTbl = {
      "-a"  => {cmd: "-Sl",  arg: false},
      "-c"  => {cmd: "-Scc", arg: false},
      "-i"  => {cmd: "-S",   arg: true},
      "-ii" => {cmd: "-Si",  arg: true},
      "-r"  => {cmd: "-Rc",  arg: true},
    }

    msystemInfo = @msystemInfoTbl[ENV['MSYSTEM']]
    if msystemInfo == nil
      msystemInfo = @msystemInfoTbl["UCRT64"] # Set defalut
    end

    @group = msystemInfo[:group]
    @prefix = msystemInfo[:prefix]

    echo_colored("[", newline: false)
    echo_colored("#{@group.upcase}", :cyan, newline: false)
    echo_colored("] / Pas by Ruby #{RUBY_VERSION}")

    @cmd = ""
    if ARGV.length == 0  # Only update DB
      @cmd = "pacman -Syu"
      puts @cmd
      exit system(@cmd) ? 0 : 1
    end
    main()
  end

  def searchWords(argsArry, line)
    fAllMatch = true
    pkgName = line.split(@prefix)[1].split(' ')[0]
    argsArry.each do |arg|
      if pkgName.downcase =~ /#{arg.downcase}/
        # Nothing to do
      else
        fAllMatch = false
        break
      end
    end
    return fAllMatch
  end

  def echo_colored(str, color = :white, newline: true)
    color_codes = {
      white:  "\e[1;37m",
      green:  "\e[1;32m",
      yellow: "\e[1;33m",
      cyan:   "\e[0;36m",
      reset:  "\e[0m"
    }
    print color_codes[color] || color_codes[:white]
    if newline
      puts str
    else
      print str
    end
    print color_codes[:reset]
  end

  def convCaseSensitive(str)
    return str.gsub("sdl","SDL").gsub("sdl2","SDL2").gsub("SDL3","sdl3")
  end

  def main()
    arg1 = ARGV[0]
    argv = ARGV

    if arg1 == "-h" or arg1 == "/h" or arg1 == "/?" or arg1 == "--help"
      puts "Usage:"
      puts "  Update db and packages   : \"pas\"                 -> pacman -Syu"
      puts "  Search WORDs             : \"pas WORD1 WORD2 ...\" -> pacman -Sl | grep -i WORD1 | grep -i WORD2 | ..."
      puts "  Install package          : \"pas -i  WORDs\"       -> pacman -S  mingw-w64-(kind)-x86_64-{WORD1,WORD2,..}"
      puts "  Show package info        : \"pas -ii WORDs\"       -> pacman -Si mingw-w64-(kind)-x86_64-{WORD1,WORD2,..}"
      puts "  Uninstall package        : \"pas -r  WORDs\"       -> pacman -Rc mingw-w64-(kind)-x86_64-{WORD1,WORD2,..}"
      puts "  Clean downloded packages : \"pas -c\"              -> pacman -Scc"
      puts "  Help                     : \"pas -h\"              -> /h, /?, --help are acceptable"
      exit 0
    else
      @cmdInfo =  @cmdTbl[arg1]
      if @cmdInfo == nil
        @cmd = "pacman -Sl" # Get all packages list cmd
      else
        argv.delete_at(0)
        @cmd = "pacman " + @cmdInfo[:cmd]
        if argv.length > 0 and @cmdInfo[:arg]
          @cmd += " #{@prefix}{#{convCaseSensitive(argv.join(","))}}"
          puts @cmd
          exit system(@cmd) ? 0 : 1
        elsif argv.length == 0 and not @cmdInfo[:arg]
          puts @cmd
          exit system(@cmd) ? 0 : 1
        else
          puts "Error!: Argument error"
          exit 1
        end
      end
    end
    # Convert case sensitivity
    args = convCaseSensitive(argv.join(","))

    seq_out = []
    all_list, * = Open3.capture3(@cmd) # Get all packages list
    all_list.split("\n").each do |line|
      if line =~ /^#{@group}/
        if searchWords(argv, line)
          seq_out << line unless seq_out.include?(line)
        end
      end
    end
    if seq_out.length == 0
      puts "Not found package [ #{argv.join(",").gsub("\"","")} ]"
      exit 0
    end
    #  Output colored
    seq_out.each do |line|
      ary = line.split(' ')
      full_name = ary[1]
      ver = ary[2]

      pkg_name = full_name.split(@prefix)[1]
      if ary.length == 3  # In case [Unsinstalled]
        echo_colored(@prefix, :white, newline: false)
        echo_colored(pkg_name, :green, newline: false)
        echo_colored(" #{ver}", :white)
      else  # In case [Installed]
        inst = ary[3]
        echo_colored(@prefix, :white, newline: false)
        echo_colored(pkg_name, :green, newline: false)
        echo_colored(" #{ver}", :white, newline: false)
        echo_colored(" #{inst}", :yellow)
      end
    end
  end
end

Pas.new
