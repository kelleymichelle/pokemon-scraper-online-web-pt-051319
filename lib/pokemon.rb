require 'pry'
class Pokemon
  attr_accessor :name, :type, :db, :hp
  attr_reader :id

  def initialize(id:, name:, type:, db:)
    @id = id
    @name = name
    @type = type
    @db = db
    @hp = 60
    # binding.pry
  end

  def self.save(name, type, db)
    sql = <<-SQL
      INSERT INTO pokemon (name, type)
      VALUES (?, ?)
    SQL
    db.execute(sql, name, type)
    @id = db.execute("SELECT last_insert_rowid() FROM pokemon")[0][0]
  end

  def self.new_from_db(arg, db)
    id = arg[0]
    name = arg[1]
    type = arg[2]
    pokemon = Pokemon.new(id: id, name: name, type: type, db: db)
    pokemon
  end  
  
  def self.find(num, db)
    sql = <<-SQL
      SELECT *
      FROM pokemon
      WHERE id = ?
      LIMIT 1
    SQL
    db.execute(sql, num).map do |row|
      self.new_from_db(row, db)
    end.first    
  end

  def alter_hp(health, db)
    self.hp = health
    sql = <<-SQL
      UPDATE pokemon
      SET hp = ?
      WHERE id = ?
    SQL
    db.execute(sql, health, self.id)  

  end  

end
