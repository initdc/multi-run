TEMP_DIR = "temp_bin"

def save_binary(file, url)
  return if system("test -x #{file}")

  `wget -O #{file} #{url}`
  if system("test -f #{file}")
    `chmod +x #{file}`
  end
end

def get_bins(dir)
  cmd = "ls -1 #{dir}/*"
  IO.popen(cmd) do |r|
    lines = r.readlines
    return nil if lines.empty?

    bins = []
    for line in lines
      bin = line.delete_suffix("\n")
      bins.push bin
    end
    return bins
  end
end

def run_results(files)
  return nil if files.nil?

  results = {}
  files.each do |file|
    cmd = "./#{file}"
    result = system(cmd)
    results[file.to_sym] = result
  end
  return results
end

PROJECTS_REL = %W[
  https://github.com/initdc/golang-project-workflow/releases/download/v0.0.3/demo-v0.0.3-linux-riscv64
  https://github.com/initdc/rust-project-workflow/releases/download/v0.1.0-test/riscv64gc-unknown-linux-gnu
  https://github.com/initdc/zig-project-workflow/releases/download/v0.0.1/riscv64-linux-gnu
  https://github.com/initdc/zig-project-workflow/releases/download/v0.0.1/riscv64-linux-musl
  https://github.com/initdc/c-project-workflow/releases/download/v0.0.1-gcc/riscv64-linux-gnu-gcc
  https://github.com/initdc/c-project-workflow/releases/download/v0.0.1/riscv64-linux-musl
  https://github.com/initdc/dlang-project-workflow/releases/download/v0.0.1/riscv64-linux-gnu-gdc
  https://github.com/initdc/nim-project-workflow/releases/download/v0.0.1/riscv64-linux-gnu-gcc
]

if __FILE__ == $0
  `mkdir -p #{TEMP_DIR}`

  PROJECTS_REL.each do |url|
    token = url
    tk_array = token.delete_prefix("https://github.com/initdc/").split("/")
    proj = tk_array.first.split("-").first
    orig = tk_array.last

    file = "#{TEMP_DIR}/#{proj}_#{orig}"

    url = url.gsub("https://github.com", "https://gh-rep.ubtu.net")
    save_binary(file, url)
  end

  bins = get_bins TEMP_DIR
  pp run_results bins
end
