class Region 
  def initialize
    @@regions ||= generate_regions
  end 

  def regions
    @@regions
  end

  def filter(content)
    @@regions.each do |region| 
      return region if content.include?(region)
    end
    nil
  end

  private
  def generate_regions
    region_file = File.open("./lib/regions/areas.txt")
    regions = []
    region_file.each_line do |line|
      regions.push(line.strip.to_s)
    end 
    regions
  end
end
