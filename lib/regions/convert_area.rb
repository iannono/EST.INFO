area = File.open("area.txt", "r:GBK:UTF-8")
new_area = File.open("new_area.txt", "w:UTF-8")

area.each_line do |line|
  if /市/ =~ line
    new_area.write(line.gsub("市", ""))
  end 
end
