require "colorize"

def pathfinding(charaposy, charaposx, mundo)


  #Funcion que calcula los 4 ejes cardinales
  expandir = ->(cell) {
    [
      { :y => cell[:y] - 1, :x => cell[:x], :counter => cell[:counter] + 1 }, #norte
      { :y => cell[:y], :x => cell[:x] + 1, :counter => cell[:counter] + 1 }, #este
      { :y => cell[:y] + 1, :x => cell[:x], :counter => cell[:counter] + 1 }, #sur
      { :y => cell[:y], :x => cell[:x] - 1, :counter => cell[:counter] + 1 }, #oeste
    ]
  }

  lista = []
  expansion = []
  basecount = 0 #contara la totalidad de tiradas que tome llegar al resultado final
  #punto de inicio = punto a
  initial = [{ :y => charaposy.to_i, :x => charaposx.to_i, :counter => 0 }]
  lista.concat(initial) #concatenar a la lista maestra
  buffer = initial

  #PASO 1: CALCULAR TODOS LOS CAMINOS
  #----------------------------------

  run = true
  while run
    #cleanup para la visualizacion
    for el in mundo.universo?
      if el.class.name == "Path"
        mundo.universo_borrar(el)
      end
    end

    #para cada buffer(tirada anterior) calcular los 4 puntos cardinales
    buffer.each do |el|
      agregar = expandir.call(el)
      expansion.concat(agregar)
    end

    #eliminar repetidos y muros
    expansion.uniq!
    expansion.reject! { |el| mundo.matrix?[el[:y]][el[:x]] == "▫" }

    #buscar repetidos CON LA LISTA MAESTRA
    lista.each_with_index do |el, e|
      expansion.each_with_index do |fl, f|
        if lista[e][:y] == expansion[f][:y] and lista[e][:x] == expansion[f][:x]
          expansion[f] = { :y => 0, :x => 0, :counter => -1 } #asignacion para eliminar
        end
      end
    end

    #eliminar los que tengan contador negativo
    expansion.reject! { |el| el[:counter] == -1 }

    #detectar si se encontro el objetivo
    expansion.each do |el|
      if el[:y] == self.posy? and el[:x] == self.posx?
        run = false
        break
      end
    end

    #almacenar tirada, y concatenar a la master list
    buffer = expansion
    lista.concat(expansion)

    #vaciar para arrancar el siguiente turno
    expansion = []
    basecount += 1
  end

  #PASO 2: ESCOGER EL CAMINO MAS CORTO
  #----------------------------------

  count_path = basecount
  final_path = []
  check_path = { :y => @posy, :x => @posx, :counter => basecount } #encontrar esto, el punto a
  buffer_path = check_path
  while count_path != 0
    #Elije todos los caminos del nivel siguiente
    possible_paths = lista.select { |el| el[:counter] == count_path - 1 }
    possible_paths = possible_paths.shuffle() #variacion cuando hay posibilidades identicas
    manhattan_distances = []
    possible_paths.each do |el|
      vary = el[:y]
      varx = el[:x]
      checky = check_path[:y]
      checkx = check_path[:x]
      #obtener el primer menor valor que aparece en la lista, por eso el shuffle
      manhattan = (vary - checky).abs + (varx - checkx).abs
      manhattan_distances.append(manhattan)
    end
    #carga el buffer del ultimo valor elegido
    buffer_path = check_path

    #carga el de menor valor para agregar a la lista final
    check_path = possible_paths[manhattan_distances.index(manhattan_distances.min)]
    final_path.append(check_path)
    count_path -= 1
  end

  #PASO 3: DISPLAY
  #----------------------------------

  final_path.each do |el|
    # mundo.universo!(Path.new(el[:y], el[:x], (el[:counter].to_s(32))))
    mundo.universo!(Path.new(el[:y], el[:x], "+".colorize(:yellow)))
  end
  # print "Camino: ".colorize(:yellow) + "x:" + el[:x].to_s + " y:" + el[:y].to_s + " distancia:" + el[:counter].to_s + "\n"
  mundo.update
  mundo.mapa?
end
