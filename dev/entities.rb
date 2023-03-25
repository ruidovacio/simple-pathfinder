class Entidad
  def initialize
    @posx
    @posy
    @id
  end

  def id?
    return @id
  end

  def posx?
    return @posx
  end

  def posy?
    return @posy
  end
end

class Muro < Entidad
  def initialize(posy, posx)
    @posy = posy
    @posx = posx
    @id = "▫"
  end
end

class Vacio < Entidad
  def initialize(posy, posx)
    @posy = posy
    @posx = posx
    @id = " "
  end
end

class Origen < Entidad
  def initialize(posy, posx)
    @posy = posy
    @posx = posx
    @id = "x".colorize(:red)
  end
end

class Path < Entidad
  def initialize(posy, posx, id)
    @posy = posy
    @posx = posx
    @id = id
  end
end

class Destino < Entidad
  def initialize(posy, posx)
    @posy = posy
    @posx = posx
    @id = "o".colorize(:green)
  end

  def calcular_path!(destinoposy, destinoposx, mundo)
    pathfinding(destinoposy, destinoposx, mundo)
  end
end
