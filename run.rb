require "colorize"
require_relative "./dev/pathfinding.rb"
require_relative "./dev/entities.rb"
require_relative "./dev/parser.rb"

class Mundo
  def initialize
    @mapa = parse
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
