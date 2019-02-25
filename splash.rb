pixels = []
File.open(ARGV[0]).each do |line|
  if line =~ /"([ .]{128})"/
    pixels << $1.split(//).map { |c| c == ' ' ? '0' : 'f' }
  end
end

puts "mem[0:16384] <= 'h#{pixels.join};"
