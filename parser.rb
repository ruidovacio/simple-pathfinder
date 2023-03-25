def parse
  counter = 0
  condition = 0
  File.open("grid.txt", "r") do |file|
    condition = file.each_line.count
  end

  gridmap = []

  File.open("grid.txt", "r") do |file|
    while counter < condition
      linea = file.readline()
      row = []
      for i in 0...linea.size - 1
        parser = "\n"
        if linea[i] == "*"
          parser = 1
        elsif linea[i] == " "
          parser = 0
        elsif linea[i] == "2"
          parser = 2
        elsif linea[i] == "3"
          parser = 3
        elsif linea[i] == "4"
          parser = 4
        end
        row.append(parser)
      end
      row.reject! { |el| el == "\n" }
      gridmap.append(row)
      counter += 1
    end
  end

  for el in gridmap
    puts el.to_s
  end

  return gridmap
end
