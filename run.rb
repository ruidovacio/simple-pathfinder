require "colorize"
require_relative "pathfinding.rb"
require_relative "entities.rb"
require_relative "parser.rb"

class Mundo
  def initialize
    @mapa = parse
    # [
    #   #0, 1, 2, 3, 4, 5, 6, 7, 8, 9, A, B, C, D, E
    #   [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], #0
    #   [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], #1
    #   [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], #2
    #   [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], #3
    #   [1, 0, 0, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 1], #4
    #   [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], #5
    #   [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], #6
    #   [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], #7
    #   [1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1], #8
    #   [1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], #9
    #   [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], #A
    #   [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], #B
    #   [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], #C
    #   [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1], #D
    #   [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1], #E
    # ]
    @universo = []
  end

  def matrix?
    @mapa
  end

  def mapa? #print del mapa
    print "    "
    @mapa[0].each_with_index do |w, wi|
      print wi.to_s(32) + " "
    end
    puts "\n\n"
    @mapa.each_with_index do |y, yi|
      print yi.to_s(32) + "   "
      y.each_with_index do |x, xi|
        print @mapa[yi][xi].to_s + " "
      end
      puts "\n"
    end
    puts "\n\n"
  end

  def update
    #Cargar grilla vacia
    @mapa.each_with_index do |y, yi|
      y.each_with_index do |x, xi|
        @mapa[yi][xi] = "‧"
      end
    end
    #Primero cargar los paths para no sobreescribir los otros elementos
    @universo.each do |el|
      if el.class.name == "Path"
        nuevoy = el.posy?
        nuevox = el.posx?
        sprite = el.id?
        @mapa[nuevoy][nuevox] = sprite
      end
    end
    @universo.each do |el|
      if el.class.name != "Path"
        nuevoy = el.posy?
        nuevox = el.posx?
        sprite = el.id?
        @mapa[nuevoy][nuevox] = sprite
      end
    end
  end

  def universo!(agregar)
    @universo.append(agregar)
  end

  def universo? #totalidad de objetos contenidos en el mundo
    @universo
  end

  def universo_borrar(elemento)
    @universo.delete(elemento)
  end
end

#Iniciar mundo
mundo = Mundo.new

origeny = 0
origenx = 0

mundo.matrix?.each_with_index do |el, e|
  el.each_with_index do |fl, f|
    if el[f] == 3
      origeny = e
      origenx = f
    end
  end
end

destinoy = 0
destinox = 0

mundo.matrix?.each_with_index do |el, e|
  el.each_with_index do |fl, f|
    if el[f] == 4
      destinoy = e
      destinox = f
    end
  end
end

#Extraer muros y crear un objeto para cada uno
mundo.matrix?.each_with_index do |y, yi|
  y.each_with_index do |x, xi|
    if mundo.matrix?[yi][xi] == 1
      mundo.universo!(Muro.new(yi, xi)) #los muros
    end
    if mundo.matrix?[yi][xi] == 2
      mundo.universo!(Vacio.new(yi, xi)) #los vacios
    end
  end
end

origen = Origen.new(origeny, origenx)
mundo.universo!(origen)

destino = Destino.new(destinoy, destinox)
mundo.universo!(destino)

mundo.update
mundo.mapa?
destino.calcular_path!(origen.posy?, origen.posx?, mundo)

puts "Origen: ".colorize(:red) + "x:" + origen.posx?.to_s + " y:" + origen.posy?.to_s
puts "Destino: ".colorize(:green) + "x:" + destino.posx?.to_s + " y:" + destino.posy?.to_s
